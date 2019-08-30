pragma solidity ^0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Roles.sol";

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
