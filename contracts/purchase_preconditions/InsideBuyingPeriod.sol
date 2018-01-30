pragma solidity ^0.4.18;

import './PurchasePrecondition.sol';

contract InsideBuyingPeriod is PurchasePrecondition {

  function isValid(Crowdsale crowdsale, address buyer, address beneficiary, uint256 value) public returns (bool) {
    bool afterStartTime = now >= crowdsale.startTime();
    bool beforeEndTime = now <= crowdsale.endTime();
    return afterStartTime && beforeEndTime;
  }
}
