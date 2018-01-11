pragma solidity ^0.4.18;

import './FinalizationPrecondition.sol';

contract BuyingPeriodHasEnded is FinalizationPrecondition {

  function isValid(Crowdsale crowdsale) public returns (bool) {
    return now > crowdsale.endTime();
  }
}
