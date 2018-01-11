pragma solidity ^0.4.18;

import '../Crowdsale.sol';

contract PurchasePrecondition {

  function evaluate(address beneficiary, uint256 value) public {
    require(isValid(beneficiary, value));
  }

  function isValid(address beneficiary, uint256 value) public returns (bool) {
    Crowdsale crowdsale = Crowdsale(msg.sender);
    return isValid(crowdsale, beneficiary, value);
  }

  function isValid(Crowdsale crowdsale, address beneficiary, uint256 value) public returns (bool);
}
