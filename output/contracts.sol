pragma solidity ^0.5.0;

contract Identity {
    mapping(address => string) private _names;

    /**
   * Associate short name with the account
   */
    function iAm(string memory shortName) public {
        _names[msg.sender] = shortName;
    }

    /**
   * Function to confirm the address of the current account
   */
    function whereAmI() public view returns (address yourAddress) {
        address myself = msg.sender;
        return myself;
    }

    /**
   *  Confirm the shortName of the current account
   */
    function whoAmI() public view returns (string memory yourName) {
        return (_names[msg.sender]);
    }
}


pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}


pragma solidity ^0.5.0;


/**
 * @dev Implementation of the `IERC20` interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using `_mint`.
 * For a generic mechanism see `ERC20Mintable`.
 *
 * *For a detailed writeup see our guide [How to implement supply
 * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See `IERC20.approve`.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See `IERC20.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See `IERC20.balanceOf`.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See `IERC20.transfer`.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See `IERC20.allowance`.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See `IERC20.approve`.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to `transfer`, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a `Transfer` event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a `Transfer` event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

     /**
     * @dev Destoys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a `Transfer` event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an `Approval` event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See `_burn` and `_approve`.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }
}


pragma solidity ^0.5.0;


/**
 * @dev Extension of `ERC20` that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
contract ERC20Burnable is ERC20 {
    /**
     * @dev Destoys `amount` tokens from the caller.
     *
     * See `ERC20._burn`.
     */
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /**
     * @dev See `ERC20._burnFrom`.
     */
    function burnFrom(address account, uint256 amount) public {
        _burnFrom(account, amount);
    }
}


pragma solidity ^0.5.0;


/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}


pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


pragma solidity ^0.5.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}


pragma solidity ^0.5.0;


contract PauserRole is Ownable {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

    constructor() internal {
        _addPauser(msg.sender);
    }

    modifier onlyPauser() {
        require(isPauser(msg.sender), "onlyPauser");
        _;
    }

    function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }

    function addPauser(address account) public onlyOwner {
        _addPauser(account);
    }

    function removePauser(address account) public onlyOwner {
        _removePauser(account);
    }

    function _addPauser(address account) private {
        require(account != address(0));
        _pausers.add(account);
        emit PauserAdded(account);
    }

    function _removePauser(address account) private {
        require(account != address(0));
        _pausers.remove(account);
        emit PauserRemoved(account);
    }

    //====================================================================================
    //=== Overridden ERC20 functionality
    //====================================================================================

    /**
        Ensure there is no way for the contract to end up with no owner. That sould inadvertently result in
        pauser administration becoming impossible. We override this to allways disallow it.
     */
    function renounceOwnership() public onlyOwner {
        require(false, "forbidden");
    }

    /**
        @dev allows the current owner to transfer control of the contract to a newOwner
        @param newOwner - the address to transfer the ownership to
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _removePauser(msg.sender);
        super.transferOwnership(newOwner);
        _addPauser(newOwner);
    }
}


pragma solidity ^0.5.0;


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is PauserRole {
    /**
     * @dev Emitted when the pause is triggered by a pauser (`account`).
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by a pauser (`account`).
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state. Assigns the Pauser role
     * to the deployer.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}


pragma solidity ^0.5.0;


/**
 * @title Pausable token
 * @dev ERC20 modified with pausable transfers.
 */
contract ERC20Pausable is ERC20, Pausable {
    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
        return super.approve(spender, value);
    }

    function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
        return super.decreaseAllowance(spender, subtractedValue);
    }
}


pragma solidity ^0.5.0;


contract VerifiedAccount is ERC20, Ownable {
    mapping(address => bool) private _isRegistered;

    constructor() internal {
        // the smart contract starts off registering iself, since address is known
        registerAccount();
    }

    event AccountRegistered(address indexed account);

    /// this registers the calling wallet address as a known address. Operations that
    /// transfer responsibility may require the target account to be a registered account
    /// to protect the system from getting into a state where administration or a large amount of funds
    /// can become forever innaccesible
    function registerAccount() public returns (bool ok) {
        _isRegistered[msg.sender] = true;
        emit AccountRegistered(msg.sender);
        return true;
    }

    function isRegistered(address account) public view returns (bool ok) {
        return _isRegistered[account];
    }

    function _accountExists(address account) internal view returns (bool exists) {
        return account == msg.sender || _isRegistered[account];
    }

    modifier onlyExistingAccount(address account) {
        require(_accountExists(account), "account not registered");
        _;
    }

    /// Safe ERC20 methods
    function safeTransfer(address to, uint256 value)
        public
        onlyExistingAccount(to)
        returns (bool ok)
    {
        transfer(to, value);
        return true;
    }

    function safeApprove(address spender, uint256 value)
        public
        onlyExistingAccount(spender)
        returns (bool ok)
    {
        approve(spender, value);
        return true;
    }

    function safeTransferFrom(address from, address to, uint256 value)
        public
        onlyExistingAccount(to)
        returns (bool ok)
    {
        transferFrom(from, to, value);
        return true;
    }

    /// safe ownership transfer
    /// allows the current owner to transfer control of the contract to a newOwner
    function transferOwnership(address newOwner) public onlyExistingAccount(newOwner) onlyOwner {
        super.transferOwnership(newOwner);
    }
}


pragma solidity ^0.5.0;


/// Grantor Role trait
/// this adds support for a rolw that allows creation of vesting token grants, allocated from the role holder's wallet
/// Owner is not allowed to renounce ownership, lest the contract go without administration.
/// But it is ok for owner to shed initially granted roles by removing role from self

contract GrantorRole is Ownable {
    bool private constant OWNER_UNIFORM_GRANTOR_FLAG = false;

    using Roles for Roles.Role;

    event GrantorAdded(address indexed account);
    event GrantorRemoved(address indexed account);

    Roles.Role private _grantors;
    mapping(address => bool) private _isUniformGrantor;

    constructor() internal {
        _addGrantor(msg.sender, OWNER_UNIFORM_GRANTOR_FLAG);
    }

    modifier onlyGrantor() {
        require(isGrantor(msg.sender), "onlyGrantor");
        _;
    }

    modifier onlyGrantorOrSelf(address account) {
        require(isGrantor(msg.sender) || msg.sender == account, "onlyGrantorOrSelf");
        _;
    }

    function isGrantor(address account) public view returns (bool) {
        return _grantors.has(account);
    }

    function addGrantor(address account, bool isUniformGrantor) public onlyOwner {
        _addGrantor(account, isUniformGrantor);
    }

    function removeGrantor(address account) public onlyOwner {
        _removeGrantor(account);
    }

    function _addGrantor(address account, bool isUniformGrantor) private {
        require(account != address(0));
        _grantors.add(account);
        _isUniformGrantor[account] = isUniformGrantor;
        emit GrantorAdded(account);
    }

    function _removeGrantor(address account) private {
        require(account != address(0));
        _grantors.remove(account);
        emit GrantorRemoved(account);
    }

    function isUniformGrantor(address account) public view returns (bool) {
        return isGrantor(account) && _isUniformGrantor[account];
    }

    modifier onlyUniformGrantor() {
        require(isUniformGrantor(msg.sender), "Only uniform grantor role can do this.");
        _;
    }

    /// overridden ERC20 functionality
    /// ensure there is no way for the contract to end up with no owner
    function renounceOwnership() public onlyOwner {
        require(false, "forbidden");
    }

    /// allows the current owner to transfer control of the contract to a newOwner
    function transferOwnership(address newOwner) public onlyOwner {
        _removeGrantor(msg.sender);
        super.transferOwnership(newOwner);
        _addGrantor(newOwner, OWNER_UNIFORM_GRANTOR_FLAG);
    }
}


pragma solidity ^0.5.0;

interface IERC20Vestable {
    function getInstrinsicVestingSchedule(address grantHolder)
        external
        view
        returns (uint32 cliffDuration, uint32 vestDuration, uint32 vestIntervalDays);

    function grantVestingTokens(
        address beneficiary,
        uint256 totalAmount,
        uint256 vestingAmount,
        uint32 startDay,
        uint32 duration,
        uint32 cliffDuration,
        uint32 interval,
        bool isRevacable
    ) external returns (bool ok);

    function today() external view returns (uint32 dayNumber);

    function vestingForAccountAsOf(address grantHolder, uint32 onDayOrToday)
        external
        view
        returns (
            uint256 amountVested,
            uint256 amountNotVested,
            uint256 amountOfGrant,
            uint32 vestStartDay,
            uint32 cliffDuration,
            uint32 vestDuration,
            uint32 vestIntervalDays,
            bool isActive,
            bool wasRevoked
        );

    function vestingAsOf(uint32 onDayorToday)
        external
        view
        returns (
            uint256 amountVested,
            uint256 amountNotVested,
            uint256 amountOfGrant,
            uint32 vestStartDay,
            uint32 cliffDuration,
            uint32 vestDuration,
            uint32 vestIntervalDays,
            bool isActive,
            bool wasRevoked
        );

    function revokeGrant(address grandHolder, uint32 onDay) external returns (bool);

    event VestingScheduleCreated(
        address indexed vestingLocation,
        uint32 cliffDuration,
        uint32 indexed duration,
        uint32 interval,
        bool indexed isRevokable
    );

    event VestingTokensGranted(
        address indexed beneficiary,
        uint256 indexed vestingAmount,
        uint32 startDay,
        address vestingLocation,
        address indexed grantor
    );

    event GrantRevoked(address indexed grantHolder, uint32 indexed onDay);
}


pragma solidity ^0.5.7;


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
        uint32 cliffDuration,
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
        return
            grantVestingTokens(
                beneficiary,
                totalAmount,
                vestingAmount,
                startDay,
                duration,
                cliffDuration,
                interval,
                isRevocable
            );
    }

    /// Check vesting

    /**
     *  @dev returns the day number of the current day, in days since the UNIX epoch
     */
    function today() public view returns (uint32 dayNumber) {
        return uint32(block.timestamp / SECONDS_PER_DAY);
    }

    function _effectiveDay(uint32 onDayOrToday) internal view returns (uint32 dayNumber) {
        return onDayOrToday == 0 ? today() : onDayOrToday;
    }

    /**
        @dev Determines the number of tokens that have not vested in the given account

        The math is: not vested amount = vesting amount * (end date - on date) / (end date - start date)

        @param grantHolder = The account to check
        @param onDayOrToday = the day to check for, in days since UNIX epoch.
                              Can pass the special value 0 to indicate today
    */
    function _getNotVestedAmount(address grantHolder, uint32 onDayOrToday)
        internal
        view
        returns (uint256 amountNotVested)
    {
        tokenGrant storage grant = _tokenGrants[grantHolder];
        vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
        uint32 onDay = _effectiveDay(onDayOrToday);

        /// if there's not schedule, or before the vesting cliff, then the full amount is not vested
        if (!grant.isActive || onDay < grant.startDay + vesting.cliffDuration) {
            // none are vested (all are not vested)
            return grant.amount;
        } else if (onDay >= grant.startDay + vesting.duration) {
            // if after end of vesting, then the not vested ammuntis zero (all are vested).
            // all are vested (none are not vested)
            return uint256(0);
        } else {
            // otherwise a fractional amount is vested
            // compute the exact number of vested
            uint32 daysVested = onDay - grant.startDay;
            // adjust result rounding down to take into consideration the interval
            uint32 effectiveDaysVested = (daysVested / vesting.interval) * vesting.interval;

            // compute the fraction vested from schedule using 224.32 fixed pint math for date range ratio.
            // Note: This is safe in 256-bit math because max value of X billion tokens = X*10^27 wei, and
            // typical token amounts can fit into 90 bits. Scalling using a 32 bits value results in only 125
            // amounts many ordrs of magnitude greter than mere billions.
            uint256 vested = grant.amount.mul(effectiveDaysVested).div(vesting.duration);
            return grant.amount.sub(vested);
        }
    }

    /**
        @dev computes the amount of funds in the given account which are available for use as of given day.
        If there's no vesting schedule then 0 tokens are considered to be vested nad this just returns the full account balance

        available amount = total funds - not vested amount

        @param grantHolder the account to check
        @param onDay the day to check for, in days since the UNIX epoch
    */
    function _getAvailableAmount(address grantHolder, uint32 onDay)
        internal
        view
        returns (uint256 amountAvailable)
    {
        uint256 totalTokens = balanceOf(grantHolder);
        uint256 vested = totalTokens.sub(_getNotVestedAmount(grantHolder, onDay));
        return vested;
    }

    function vestingForAccountAsOf(address grantHolder, uint32 onDayOrToday)
        public
        view
        onlyGrantorOrSelf(grantHolder)
        returns (
            uint256 amountVested,
            uint256 amountNotVested,
            uint256 amountOfGrant,
            uint32 vestStartDay,
            uint32 vestDuration,
            uint32 cliffDuration,
            uint32 vestIntervalDays,
            bool isActive,
            bool wasRevoked
        )
    {
        tokenGrant storage grant = _tokenGrants[grantHolder];
        vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
        uint256 notVestedAmount = _getNotVestedAmount(grantHolder, onDayOrToday);
        uint256 grantAmount = grant.amount;

        return (
            grantAmount.sub(notVestedAmount),
            notVestedAmount,
            grantAmount,
            grant.startDay,
            vesting.duration,
            vesting.cliffDuration,
            vesting.interval,
            grant.isActive,
            grant.wasRevoked
        );
    }

    /**
        @dev return all the information about the grant's vesting as of the given day
        for the current account to be called by the account holder

        @param onDayOrToday - the day to check for. Can pass the special value 0 to indicate today
        @return - A touple with the following values
            amountVested - the amount of the vestingAmount that is vested
            amountNotVested - the amount that is vested (equal to vestingAmount - vestedAmount)
            amountOfGrant - the amount of tokens subject to vesting
            vestStartDay - starting day of the grant
            cliffDuration - duration of the cliff
            vestDuration - grant duration in days
            vestIntervalDays - number of days between vesting periods
            isActive - true if the vesting schedule is currently active
            wasRevoked - true id the vesting schedule was revoked
     */
    function vestingAsOf(uint32 onDayOrToday)
        public
        view
        returns (
            uint256 amountVested,
            uint256 amountNotVested,
            uint256 amountOfGrant,
            uint32 vestStartDay,
            uint32 vestDuration,
            uint32 cliffDuration,
            uint32 vestIntervalDays,
            bool isActive,
            bool wasRevoked
        )
    {
        return vestingForAccountAsOf(msg.sender, onDayOrToday);
    }

    /**
        @dev returns true if the account has sufficient funds available to cover the given amount, 
        including consideration for vesting tokens

        @param account - the account to check
        @param amount - the required amount of vested funds
        @param onDay - the day to check for, in days since the UNIX epoch
     */
    function _fundsAreAvailableOn(address account, uint256 amount, uint32 onDay)
        internal
        view
        returns (bool ok)
    {
        return (amount <= _getAvailableAmount(account, onDay));
    }

    /**
        @dev modifier to make a function callable only when the account is sufficiently vested right now

        @param account - account to check
        @param amount - the required amount of vested funds
     */
    modifier onlyIfFundsAvailableNow(address account, uint256 amount) {
        // distingush insufficient overall balance from insufficient vested funds balance in failure msg
        require(
            _fundsAreAvailableOn(account, amount, today()),
            balanceOf(account) < amount ? "insufficient funds" : "insufucient vested funds"
        );
        _;
    }

    //=====================================================================================================
    // === Grant revocation
    //=====================================================================================================

    /**
        @dev if an account has a revocable grant, this forces the grant to end based on computing
        the amount vested up to the given date. All tokens that would no longer vest are returned
        to the account of the original grantor

        @param grantHolder - address to which tokens will be granted
        @param onDay - the day upon which the vesting schedule will be effectively terminated
     */
    function revokeGrant(address grantHolder, uint32 onDay) public onlyGrantor returns (bool ok) {
        tokenGrant storage grant = _tokenGrants[grantHolder];
        vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
        uint256 notVestedAmount;

        // make sure grantor can only revoke from own pool
        require(msg.sender == owner() || msg.sender == grant.grantor, "not allowed");

        // make sure a vesting schedule has previously been set
        require(grant.isActive, "no active vesting schedule");

        // make sure is revocable
        require(vesting.isRevocable, "irrevocable");

        // fail on likely erroneous input
        require(onDay <= grant.startDay + vesting.duration, "no effect");

        // don't let grantor revoke any portion of the vested amount
        require(onDay >= today(), "cannot revoke vested holdings");

        notVestedAmount = _getNotVestedAmount(grantHolder, onDay);

        // use ERC20 _approve()  to forcibly approve grantor to take back non-vested tokens from grantHolder
        _approve(grantHolder, grant.grantor, notVestedAmount);

        // Emits and approval event
        transferFrom(grantHolder, grant.grantor, notVestedAmount);

        // emits a tansfer and approval event
        // kill the grant by updating wasRevoked and isActive
        _tokenGrants[grantHolder].wasRevoked = true;
        _tokenGrants[grantHolder].isActive = false;

        emit GrantRevoked(grantHolder, onDay);
        // emits GrantRevoked event

        return true;
    }

    //======================================================================================================
    //===   Overridden ERC20 functionality
    //======================================================================================================

    /**
        @dev methods transfer() and approve() require an additional available funds check
        to prevent spending held but not-vested tokens. Note that transferFrom() does not have this
        additional check because approved funds come from an already set-aside allowance, not from the wallet.
     */
    function transfer(address to, uint256 value)
        public
        onlyIfFundsAvailableNow(msg.sender, value)
        returns (bool ok)
    {
        return super.transfer(to, value);
    }

    /**
        @dev additional available funds check to prevent spending but not-vested tokens
     */
    function approve(address spender, uint256 value)
        public
        onlyIfFundsAvailableNow(msg.sender, value)
        returns (bool ok)
    {
        return super.approve(spender, value);
    }

}


pragma solidity ^0.5.0;


/**
    @title Contract for uniform granting of vesting tokens

    @notice Adds methods for programatic creation for uniform or standard token vesting grants

    @dev this is primarily for use by exchanges and scripted internal employee incentive grant creation
 */
contract UniformTokenGrantor is ERC20Vestable {
    struct restrictions {
        bool isValid;
        uint32 minStartDay; // the smallest value for startDay allowed in grant creation
        uint32 maxStartDay; // the maximum value for startDay allowed in grant creation
        uint32 expirationDay; // the last day this grantor may make grants
    }

    mapping(address => restrictions) private _restrictions;

    //========================================================================================
    //=== Uniform token grant setup
    //=== Methods used by owner to set up uniform grants on restricted grantor
    //========================================================================================

    event GrantorRestrictionsSet(
        address indexed grantor,
        uint32 minStartDay,
        uint32 maxStartDay, //========================================================================================
        uint32 expirationDay
    );

    /**
        @dev lets the ownser set or change specific restrictions. Restrictions must be established
        before the grantor will be allowed to issue grants.

        All the values are expressed as number of days since UNIX epoch. Nothe that the inputs
        are themselevs not very thoroughly restricted. However, this method can be called more than once if
        incorrect values need to be changed, or to extend a grantor's expiration date

        @param grantor - Address which will receive the uniform grantable vesting schedule
        @param minStartDay - the smallest value for startDay allowed in grant creation
        @param maxStartDay - the maximum value for startDay allowed in grant creation
        @param expirationDay - the last day this grantor may make grants
     */
    function setRestrictions(
        address grantor,
        uint32 minStartDay,
        uint32 maxStartDay,
        uint32 expirationDay
    ) public onlyOwner onlyExistingAccount(grantor) returns (bool ok) {
        require(
            isUniformGrantor(grantor) && maxStartDay > minStartDay && expirationDay > today(),
            "invalid params"
        );

        // we allow owner to set or change existing specific restrictions
        _restrictions[grantor] = restrictions(
            true, //isValid
            minStartDay,
            maxStartDay,
            expirationDay
        );

        // emit the event and return success
        emit GrantorRestrictionsSet(grantor, minStartDay, maxStartDay, expirationDay);
        return true;
    }

    /**
     * @dev Lets owner permanently establish a vesting schedule for a restricted grantor to use when
     * creating uniform token grants. Grantee accounts forever refer to the grantor's account to look up
     * vesting, so this method can only be used once per grantor.
     *
     * @param grantor = Address which will receive the uniform grantable vesting schedule.
     * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
     * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
     * @param interval = Number of days between vesting increases.
     * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
     *   be revoked (i.e. tokens were purchased).
     */
    function setGrantorVestingSchedule(
        address grantor,
        uint32 duration,
        uint32 cliffDuration,
        uint32 interval,
        bool isRevocable
    ) public onlyOwner onlyExistingAccount(grantor) returns (bool ok) {
        // only allow doing this to restricted grantor role account
        require(isUniformGrantor(grantor), "uniform grantor only");

        // make sure no prior vesting schedule has been set!
        require(!_hasVestingSchedule(grantor), "schedule already exists");

        // the vesting schedule is unique to this grantor wallet and so will be sored here to be
        // referenced by future grants. Emits VestingScheduleCreated event.
        _setVestingSchedule(grantor, cliffDuration, duration, interval, isRevocable);
        return true;
    }

    //================================================================================================
    //=== Uniform token grants
    //=== Methods t be used by exchanges to use for creating tokens
    //================================================================================================

    function isUniformGrantorWithSchedule(address account) internal view returns (bool ok) {
        // check for grantor that has a uniform vesting schedule already set
        return isUniformGrantor(account) && _hasVestingSchedule(account);
    }

    modifier onlyUniformGrantorWithSchedule(address account) {
        require(isUniformGrantorWithSchedule(account), "grantor account not ready");
        _;
    }

    modifier whenGrantorRestrictionsMet(uint32 startDay) {
        restrictions storage restriction = _restrictions[msg.sender];
        require(restriction.isValid, "set restrictions first");

        require(
            startDay >= restriction.minStartDay && startDay < restriction.maxStartDay,
            "startDay too early"
        );

        require(today() < restriction.expirationDay, "grantor expired");
        _;
    }

    /**
        @dev Immediately grants tokens to an address, including a portion that will vest over time
        according to the uniform vesting schedule already established ni the grantor's account

        @param beneficiary = Address to which tokens will be granted
        @param totalAmount = total number of tokens to deposit into the account
        @param vestingAmount = out of totalAmount, the number of tokens subject to vesting
        @param startDay = start day of the grant's vesting schedule, in days since the UNIX epoch
            (start of day). The startDay may be given as a date in the future or in the past, going as far
            back as year 2000
     */
    function grantUniformVestingTokens(
        address beneficiary,
        uint256 totalAmount,
        uint256 vestingAmount,
        uint32 startDay
    )
        public
        onlyUniformGrantorWithSchedule(msg.sender)
        whenGrantorRestrictionsMet(startDay)
        onlyExistingAccount(beneficiary)
        returns (bool ok)
    {
        // issue grantor tokens to the beneficiary, using beneficiary's own vesting schedule
        // emits VestingTokensGranted event
        return
            _grantVestingTokens(
                beneficiary,
                totalAmount,
                vestingAmount,
                startDay,
                msg.sender,
                msg.sender
            );
    }

    /**
        @dev This variant only grants tokens if the beneficiary account has previously self-registered
     */
    function safeGrantUniformVestingTokens(
        address beneficiary,
        uint256 totalAmount,
        uint256 vestingAmount,
        uint32 startDay
    )
        public
        onlyUniformGrantorWithSchedule(msg.sender)
        whenGrantorRestrictionsMet(startDay)
        onlyExistingAccount(beneficiary)
        returns (bool ok)
    {
        // issue grantor tokens to the beneficiary, using beneficiary's own vesting schedule
        // emits VestingTokensGranted event
        return
            _grantVestingTokens(
                beneficiary,
                totalAmount,
                vestingAmount,
                startDay,
                msg.sender,
                msg.sender
            );
    }
}


pragma solidity ^0.5.0;


/**
    @dev An ETC20 implementation of the Paypolitan Token. All tokens are initially pre-assigned to
    the creator, and can later be distributed freely using transfer transferFrom other ERC20 functions
 */
contract PaypolitanToken is
    Identity,
    ERC20,
    ERC20Pausable,
    ERC20Burnable,
    ERC20Detailed,
    UniformTokenGrantor
{
    uint32 public constant VERSION = 1;
    uint8 private constant DECIMALS = 18;
    uint256 private constant TOKEN_WEI = 10**uint256(DECIMALS);

    uint256 private constant INITIAL_WHOLE_TOKENS = uint256(5 * (10**9));
    uint256 private constant INITIAL_SUPPLY = uint256(INITIAL_WHOLE_TOKENS) * uint256(TOKEN_WEI);

    /**
        @dev Constructor that gives msg.sender all of existing tokens
     */
    constructor() public ERC20Detailed("Paypolitan.io PPA token", "PPA", DECIMALS) {
        // this is the only place where we ever mint tokens
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    event DepositReceived(address indexed from, uint256 value);

    /**
        fallback function: collect any ether sent to us (whether we asked for it or not)
     */
    function() external payable {
        // track where unexpected ETH came from so we can follow up later
        emit DepositReceived(msg.sender, msg.value);
    }

    /**
        @dev Allow only owner to burn tokens from the owner's wallet, also decreasing the total supply.
        There is no reason for a token holder to EVER call this method directly. It will be
        used by future Paypolitan contract to implement the PaypolitanToken side of token redemption.
     */
    function burn(uint256 value) public onlyIfFundsAvailableNow(msg.sender, value) {
        // this is the only place where we ever burn tokens
        _burn(msg.sender, value);
    }

    /**
        @dev Allow pauser to kill the contract (which must already be paused), with enough restrictions
        in place to ensure this could not happen by accident very easily.
        ETH is returned to owner wallet.
     */
    function kill() public whenPaused onlyPauser returns (bool itsDeadJim) {
        require(isPauser(msg.sender), "onlyPauser");
        address payable payableOwner = address(uint160(owner()));
        selfdestruct(payableOwner);
        return true;
    }
}


