pragma solidity ^0.4.18;

import './PurchasePrecondition.sol';

contract NonZeroPurchase is PurchasePrecondition {

  function isValid(Crowdsale crowdsale, address beneficiary, uint256 value) public returns (bool) {
    return value > 0;
  }
}
