pragma solidity ^0.4.18;

import '../Crowdsale.sol';

contract PurchasePrecondition {

  function evaluate(address buyer, address beneficiary, uint256 value) public {
    require(isValid(buyer, beneficiary, value));
  }

  function isValid(address buyer, address beneficiary, uint256 value) public returns (bool) {
    Crowdsale crowdsale = Crowdsale(msg.sender);
    return isValid(crowdsale, buyer, beneficiary, value);
  }

  function isValid(Crowdsale crowdsale, address buyer, address beneficiary, uint256 value) public returns (bool);
}
