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
      // Convert governance tokens amount to dollasr
      uint conversionRate = getGovTokenPerDollar();
      uint256 decs = decimals();
      uint256 dollarsSpent= govTokenCount * conversionRate * 10^decs;
      uint256 iud = inflationAdjustedDollars(dollarsSpent);
      

      _mint(senderAddress, iud);
  }

  function inflationAdjustedDollars(uint256 dollarsSpent) private returns (uint256) {
    uint256 currTime = block.timestamp;
    uint256 daysSinceGenesis = currTime - genesisTime;
    daysSinceGenesis =  daysSinceGenesis / (60 * 60 * 24 * 30);    

    uint256 inflationAdjustmentNumerator = 100004 ** daysSinceGenesis;
    uint256 inflationAdjustmentDenominator = 100000 ** daysSinceGenesis;

    uint256 inflationAdjustedDollars = dollarsSpent * inflationAdjustmentNumerator;
    inflationAdjustedDollars = inflationAdjustedDollars / inflationAdjustmentDenominator;
    return inflationAdjustedDollars;
  }
  
        

  function getGovTokenPerDollar() private pure returns (uint) {
      return 5; //TODO test
  }
}