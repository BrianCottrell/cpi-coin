// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Permit.sol";

contract cPUREToken is
    ERC20,
    ERC20Burnable,
    ERC20Detailed,
    Ownable,
    ERC20Permit
{
    constructor(uint256 initialSupply)
        ERC20Detailed("Celo Pure", "cPURE", 18)
        ERC20Permit("Celo Purepp")
    {}
}
