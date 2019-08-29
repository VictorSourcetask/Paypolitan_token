pragma solidity ^0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Roles.sol";

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
