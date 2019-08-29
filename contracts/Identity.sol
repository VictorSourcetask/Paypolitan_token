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
