pragma solidity ^0.8.13;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract PureGovToken is ERC20, ERC20Burnable {
  event Debug(bool s, bytes r); 
  constructor(string memory _name, string memory _symbol) ERC20("Pure Governance Token", "PGT") {
  	
    _mint(msg.sender, 10000 * 10 ** decimals());
  }

  function convertToPure(uint tokenCount) public returns (bool success) {
      uint256 tokensToConvert = tokenCount * 10 ** decimals();
      _burn(msg.sender, tokensToConvert);

      address pureTokenAddr = 0xccAf167ae1C562d67bE3A4624dcF94A15DaD5cca;
      (bool s, bytes memory r) = pureTokenAddr.call(abi.encodeWithSignature("mintPure(address,uint256)", msg.sender, tokensToConvert));
      return true;
  }
}