pragma solidity ^0.5.0;

import "./Identity.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "./UniformTokenGrantor.sol";

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
