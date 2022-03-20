pragma solidity ^0.8.13;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract PureGovToken is  ERC20, ERC20Burnable {
  //We inherited the DetailedERC20
  uint256 public genesisTime;

  constructor(string memory _name, string memory _symbol) ERC20("Pure Governance Token", "PGT") public {
    genesisTime = block.timestamp;
  }

  function mintPure(address senderAddress, uint govTokenCount) public {
      // Convert governance tokens amount to dollasr
      uint conversionRate = getGovTokenPerDollar();
      uint256 dollarsSpent = govTokenCount * conversionRate;
      uint256 currTime = block.timestamp;
      uint256 monthsSinceGenesis = (currTime - genesisTime) / (60 * 60 * 24 * 30);    

      uint256 inflationAdjustmentNumerator = 1005 ** monthsSinceGenesis;
      uint256 inflationAdjustmentDenominator = 1000 ** monthsSinceGenesis;

      uint256 inflationAdjustedDollars = dollarsSpent * inflationAdjustmentNumerator;
      inflationAdjustedDollars = inflationAdjustedDollars / inflationAdjustmentDenominator;

      _mint(senderAddress, inflationAdjustedDollars);
  }

  function getGovTokenPerDollar() private returns (uint) {
      return 5; //TODO test
  }
}