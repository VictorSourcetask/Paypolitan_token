pragma solidity ^0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol";
import "./VerifiedAccount.sol";
import "./GrantorRole.sol";
import "./IERC20Vestable.sol";

/**
    @title Contract for grantable ERC20 token vesting schedules
    @notice Adds to an ERC20 support for grantor wallets, ehich are able to grant
    vesting tokens to beneficiary wallets, following per-wallet custom vesting schedules.

    @dev Contract which gives subclass contracts the ability to act as a pool of funds for
    allocating tokens to any number of other addresses. Token grants support the ability
    to vest over time in accordance a predefined vesting schedule. A given wallet can receive
    no more than one token grant.

    Tokens are transferred from the pool to the recipient at the time of grant, but the recipient
    will only be able to transfer tokens out of their wallet after they have vested. Transfers of 
    non vested tokens are prevented.
    
    Two types of token grants are supported:
    - Irrevocable grants, intended for use in cases where vesting tokens have been issued in exchange
    for value, such as with tokens that have been purchased in an IEO
    - Revocable grants, intended for use in cases when vesting tokens have been gifted to the holder,
    such as with employee grants that are given as compensation
 */

contract ERC20Vestable is ERC20, VerifiedAccount, GrantorRole, IERC20Vestable {
    using SafeMath for uint256;

    /// date-related constants for sanity checking dates to reject obvious erroneus input
    /// and conversions from seconds to days and years that are more ore less leap year-aware
    uint32 private constant THOUSAND_YEARS_DAYS = 365243;
    uint32 private constant TEN_YEARS_DAYS = THOUSAND_YEARS_DAYS / 100;
    uint32 private constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint32 private constant JAN_1_2000_SECONDS = 946684800;
    uint32 private constant JAN_1_2000_DAYS = JAN_1_2000_SECONDS / SECONDS_PER_DAY;
    uint32 private constant JAN_1_3000_DAYS = JAN_1_2000_DAYS + THOUSAND_YEARS_DAYS;

    struct vestingSchedule {
        bool isValid; /// true if an entry exists and is valid
        bool isRevocable; /// true if the vesting option is revocable (a gift), false if irrevocable (paid)
        uint32 cliffDuration; /// duration of the cliff, with respect to the start day, in days
        uint32 duration; /// duration of the vesting schedule, with respect to the grant start day, in days
        uint32 interval; /// duration in days of the vesting interval
    }

    struct tokenGrant {
        bool isActive; /// true if this vesting entry is active adn in-effect entry
        bool wasRevoked; /// true if this vesting schedule was revoked
        uint32 startDay; /// start day of the grant, in days since the UNIX epoch
        uint256 amount; /// total number of tokens that vest
        address vestingLocation; /// address of the wallet that is holding the vesting schedule
        address grantor; /// grantor that made the grant
    }

    mapping(address => vestingSchedule) private _vestingSchedules;
    mapping(address => tokenGrant) private _tokenGrants;

    ///=========================================================================
    /// Methods for administratively creating a vesting schedule for an account
    ///=========================================================================
    function _setVestingSchedule(
        address vestingLocation,
        uint32 cliffDuration,
        uint32 duration,
        uint32 interval,
        bool isRevocable
    ) internal returns (bool ok) {
        /// check for a valid vesting schedule given (disallow absurd values to reject likely bad input)
        require(
            duration > 0 && duration <= TEN_YEARS_DAYS && cliffDuration < duration && interval >= 1,
            "invalid vesting schedule"
        );

        /// make sure the duration values are in harmony with inverval (both should be an exact multiple of interval)
        require(
            duration % interval == 0 && cliffDuration % interval == 0,
            "invalid cliff/duration for interval"
        );

        /// create and populate a vesting schedule.
        _vestingSchedules[vestingLocation] = vestingSchedule(
            true, /// idValid
            isRevocable,
            cliffDuration,
            duration,
            interval
        );

        /// emit the event and return success
        emit VestingScheduleCreated(
            vestingLocation,
            cliffDuration,
            duration,
            interval,
            isRevocable
        );

        return true;
    }

    function _hasVestingSchedule(address account) internal view returns (bool ok) {
        return _vestingSchedules[account].isValid;
    }

    /**
    @dev returns all the information about the vesting schedule directly associated with the given
    account. This can be used to double check that a uniform grantor has been set up with a correct
    vesting schedule. Also, recipients of standard (non-uniform) grants can use this.
    This method is only callable by the account holder or a grantor, so this is mainly intended
    for administrative use.

    Holders of uniform grants must use vestingAsOf() to view their vesting schedule, as it is
    stored in the grantor account

    @param grantHolder = The address to do this for.
      the special value 0 to indicate today
    @return  = Atuple with the following values:
      vestDuration = grant duration in days
      cliffDuration = duration of the cliff
      vestIntervalDays = number of days between vesting periods
   */
    function getIntrinsicVestingSchedule(address grantHolder)
        public
        view
        onlyGrantorOrSelf(grantHolder)
        returns (uint32 vestDuration, uint32 cliffDuration, uint32 vestIntervalDays)
    {
        return (
            _vestingSchedules[grantHolder].duration,
            _vestingSchedules[grantHolder].cliffDuration,
            _vestingSchedules[grantHolder].interval
        );
    }

    ///==============================================================================================
    /// Token grants (general purpose)
    /// Methods to be used for administratively creating one-off token grants with vesting schedules
    ///==============================================================================================

    function _grantVestingTokens(
        address beneficiary,
        uint256 totalAmount,
        uint256 vestingAmount,
        uint32 startDay,
        address vestingLocation,
        address grantor
    ) internal returns (bool ok) {
        /// make sure no prior grant is in efect
        require(!_tokenGrants[beneficiary].isActive, "grant already exists");

        /// check for valid vestingAmount
        require(
            vestingAmount <= totalAmount &&
                vestingAmount > 0 &&
                startDay >= JAN_1_2000_DAYS &&
                startDay < JAN_1_3000_DAYS,
            "invalid vesting params"
        );

        /// make sure the vesting schedule we are about to use is valid
        require(_hasVestingSchedule(vestingLocation), "no such vesting schedule");

        /// transfer the total number of tokens from grantor into the account"s holdings
        _transfer(grantor, beneficiary, totalAmount);

        /// Emits a transfer event

        /// create and populate a token grant, referencing vesting schedule
        _tokenGrants[beneficiary] = tokenGrant(
            true, /// isActive
            false, /// wasRevoked
            startDay,
            vestingAmount,
            vestingLocation, /// the wallet address where the vesting schedule is kept
            grantor /// the account that performed the grant (where revoked funds should be sent)
        );

        /// Emit the event and return success
        emit VestingTokensGranted(beneficiary, vestingAmount, startDay, vestingLocation, grantor);
        return true;
    }

    /**
     * @dev Immediately grants tokens to an address, including a portion that will vest over time
     * according to a set vesting schedule. The overall duration and cliff duration of the grant must
     * be an even multiple of the vesting interval.
     *
     * @param beneficiary = Address to which tokens will be granted.
     * @param totalAmount = Total number of tokens to deposit into the account.
     * @param vestingAmount = Out of totalAmount, the number of tokens subject to vesting.
     * @param startDay = Start day of the grant's vesting schedule, in days since the UNIX epoch
     *   (start of day). The startDay may be given as a date in the future or in the past, going as far
     *   back as year 2000.
     * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
     * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
     * @param interval = Number of days between vesting increases.
     * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
     *   be revoked (i.e. tokens were purchased).
     */
    function grantVestingTokens(
        address beneficiary,
        uint256 totalAmount,
        uint256 vestingAmount,
        uint32 startDay,
        uint32 duration,
        uint32 cliffInterval,
        uint32 interval,
        bool isRevocable
    ) public onlyGrantor returns (bool ok) {
        // make sure no prior vesting schedule has been set
        require(!_tokenGrants[beneficiary].isActive, "grant already exists");

        // the vesting schedule id unique to this wallet and so will be stored here
        _setVestingSchedule(beneficiary, cliffDuration, duration, interval, isRevocable);

        // issue grantor tokens to the beneficiary, using beneficiary's own vesting schedule
        _grantVestingTokens(
            beneficiary,
            totalAmount,
            vestingAmount,
            startDay,
            beneficiary,
            msg.sender
        );

        return true;
    }

    /**
     *  @dev this variant only grants tokens if the beneficiary account has previously self-registered
     */
    function safeGrantVestingTokens(
        address beneficiary,
        uint256 totalAmount,
        uint256 vestingAmount,
        uint32 startDay,
        uint32 duration,
        uint32 cliffDuration,
        uint32 interval,
        bool isRevocable
    ) public onlyGrantor onlyExistingAccount(beneficiary) returns (bool ok) {
        return grantVestingTokens(
            beneficiary, totalAmount, vestingAmount, startDay, duration, cliffDuration, interval, isRevocable);
        )
    }

    /// Check vesting

    /**
     *  @dev returns the day number of the current day, in days since the UNIX epoch
     */
    function today() public view returns (uint32 dayNumber) {
        return uint32(block.timestamp / SECONDS_PER_DAY);
    }

    function _effectiveDay(uint onDayOrToday) internal view returns (uint32 dayNumber) {
        return onDayOrToday == 0 ? today() : onDayOrToday;
    }


    /**
        @dev Determines the number of tokens that have not vested in the given account

        The math is: not vested amount = vesting amount * (end date - on date) / (end date - start date)

        @param grantorHolder = The account to check
        @param onDayOrToday = the day to check for, in days since UNIX epoch.
                              Can pass the special value 0 to indicate today
     */
    function _getNotVestedAmount(
        address grantHolder,
        uint32 onDayOrToday
    ) internal view returns (uint256 amountNotVested) {
        tokenGrant storage grant = _tokenGrants[grantHolder];
        vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
        uint32 onDay = _effectiveDay(onDayOrToday);
        
        /// if there's not schedule, or before the vesting cliff, then the full amount is not vested
        if(!grant.isActive || onDay < grant.startDay + vesting.cliffDuration) {
            // none are vested (all are not vested)
            return grant.amount;
        }
        // if after end of vesting, then the not vested ammuntis zero (all are vested).
        else if (onDay >= grant.startDay + vesting.duration) {
            // all are vested (none are not vested)
            return uint256(0);
        }
        // otherwise a fractional amount is vested
        else {
            // compute the exact number of vested
            uint32 daysVested = onDay - grant.startDay;
            // adjust result rounding down to take into consideration the interval
            uint32 effectiveDaysVested = (daysVested / vesting.itnerval) * vesting.interval;

            // compute the fraction vested from schedule using 224.32 fixed pint math for date range ratio.
            // Note: This is safe in 256-bit math because max value of X billion tokens = X*10^27 wei, and
            // typical token amounts can fit into 90 bits. Scalling using a 32 bits value results in only 125
            // amounts many ordrs of magnitude greter than mere billions.
            uint256 vested = grant.amount.mul(effectiveDaysVested).div(vesting.duration);
            return grant.amount.sub(vested);
        }

        function _getAvailableAmount(
            address grantHoler, uint32 onDay
        ) internal view returns (uint256 amountAvailable) {
            uint256 totalTokens = balanceOf(grantHolder);
            uint256 vested = totalTokens.sub(_getNotVestedAmount(grantHolder, onDay));
            return vested;
        }
    }

}
