pragma solidity ^0.8.13;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract PureGovToken is  ERC20, ERC20Burnable {
  //We inherited the DetailedERC20
  uint256 public genesisTime;

  constructor(string memory _name, string memory _symbol) ERC20("Pure Governance Token", "PGT") {
    genesisTime = block.timestamp;
  }

  function mintPure(address senderAddress, uint govTokenCount) public {
      // Convert governance tokens amount to dollars
      uint conversionRate = getGovTokenPerDollar();
      uint256 dollarsSpent = govTokenCount * conversionRate * 10^decs;
      uint256 iud = inflationAdjustedDollars(dollarsSpent);
      
      _mint(senderAddress, iud);
  }

  function inflationAdjustedDollars(uint256 dollarsSpent) private returns (uint256) {
    uint256 currTime = block.timestamp;
    uint256 secsSinceGenesis = currTime - genesisTime;
    uint256 monthsSinceGenesis = secsSinceGenesis / (60 * 60 * 24 * 30);
    uint256 numerator = 98 ** monthsSinceGenesis;
    uint256 denominatorPow = (2 * monthsSinceGenesis) - 18;

    if (denominatorPow < 0) {
        uint256 numeratorPow = -1 * denominatorPow;
        return numerator * 10^numeratorPow * dollarsSpent;
    }
    return (numerator * dollarsSpent) / 10^denominatorPow;
  }
  
        

  function getGovTokenPerDollar() private pure returns (uint) {
      return 5; //TODO test
  }
}