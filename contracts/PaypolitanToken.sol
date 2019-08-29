pragma solidity ^0.5.0;

import "./Identity.sol";
// import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";

contract PaypolitanToken {
    string public name = "Paypolitan Token";
    string public symbol = "PPA";
    string public standard = "Paypolitan Token v1.0";
    uint8 public decimals = 18;

    constructor() public {}

    /// this modifier will be used to disable all ERC20 functionality during the minting process

}
