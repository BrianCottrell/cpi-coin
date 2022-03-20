pragma solidity ^0.8.13;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract PureGovToken is ERC20, ERC20Burnable {
  //We inherited the DetailedERC20 
  constructor(string memory _name, string memory _symbol) ERC20("Pure Governance Token", "PGT") {
  	_mint(msg.sender, 10000);
  }

  function convertToPure(uint tokenCount) private returns (bool success) {
      _burn(msg.sender, tokenCount);

      msg.sender.call(abi.encodeWithSignature("mintPure(string,int)", msg.sender, tokenCount));
      return true;
  }
}