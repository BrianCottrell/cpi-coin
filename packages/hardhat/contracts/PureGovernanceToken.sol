pragma solidity ^0.8.13;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract PureGovToken is ERC20, ERC20Burnable {
  event Debug(bool s, bytes r);
  
  uint256 public genesisTime;

  constructor(string memory _name, string memory _symbol) ERC20("Pure Governance Token", "PGT") {
    genesisTime = block.timestamp;
    _mint(msg.sender, 10000 * 10 ** decimals());
  }

  function convertToPure(uint tokenCount) public returns (bool success) {
      uint256 tokensToConvert = tokenCount * 10 ** decimals();
      _burn(msg.sender, tokensToConvert);

      address pureTokenAddr = 0xccAf167ae1C562d67bE3A4624dcF94A15DaD5cca;
      (bool s, bytes memory r) = pureTokenAddr.call(abi.encodeWithSignature("mintPure(address,address,uint256)", msg.sender, address(this), tokensToConvert));
      return true;
  }

  function mintGovToken(address senderAddress, uint256 amountToConvert) public {
    uint256 currTime = block.timestamp;
    uint256 secsSinceGenesis = currTime - genesisTime;
    uint256 monthsSinceGenesis = secsSinceGenesis / (60 * 60 * 24 * 12);
    uint256 numerator = 101 ** monthsSinceGenesis;
    uint256 denominatorPow = 2 * monthsSinceGenesis;
    uint256 inflationRate = numerator / (10 ** denominatorPow); 
    uint256 inflatedDollar = amountToConvert * inflationRate;
    uint256 govTokenAmount = inflatedDollar * getGovTokensPerTenDollars();

    _mint(senderAddress, govTokenAmount);
  }

  function getGovTokensPerTenDollars() private returns (uint256) {
    return 5;
  }
}