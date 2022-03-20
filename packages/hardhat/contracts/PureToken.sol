pragma solidity ^0.8.13;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract PureGovToken is  ERC20, ERC20Burnable {
  //We inherited the DetailedERC20
  mapping(address => address) public balances;

  uint256 public genesisTime;

  constructor(string memory _name, string memory _symbol) ERC20("Pure Token", "PTK") {
    genesisTime = block.timestamp;
  }

  function mintPure(address senderAddress, address smartContractAddress, uint256 govTokenCount) public {
      // Convert governance tokens amount to dollars
      balances[senderAddress] = smartContractAddress;
      uint256 conversionRate = (getGovTokenPerDollar() / 10);
      uint256 dollarsSpent = govTokenCount / conversionRate;
      uint256 iad = inflationAdjustedDollars(dollarsSpent);
      _mint(senderAddress, iad);
  }

  function inflationAdjustedDollars(uint256 dollarsSpent) public returns (uint256) {
      uint256 currTime = block.timestamp;
      uint256 secsSinceGenesis = currTime - genesisTime;
      uint256 monthsSinceGenesis = secsSinceGenesis / (60 * 60 * 24 * 12);
      uint256 numerator = 98 ** monthsSinceGenesis;
      uint256 denominatorPow = 2 * monthsSinceGenesis;
      uint256 res = numerator * dollarsSpent / (10 ** denominatorPow);
      return res;
  }

  function convertToGovToken(uint256 amountToConvert) {
    _burn(msg.sender, amountToConvert);
    
    address govTokenAddress = balances[msg.sender];
    (bool s, bytes memory r) = govTokenAddress.call(abi.encodeWithSignature("mintGovToken(address,uint256)", msg.sender, amountToConvert));

  }
  function getGovTokenPerTenDollar() private pure returns (uint256) {
      return 50; //TODO test
  }
}