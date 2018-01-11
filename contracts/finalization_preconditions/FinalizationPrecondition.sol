pragma solidity ^0.4.18;

import '../Crowdsale.sol';

contract FinalizationPrecondition {

  function evaluate() public {
    require(isValid());
  }

  function isValid() public returns (bool) {
    Crowdsale crowdsale = Crowdsale(msg.sender);
    return isValid(crowdsale);
  }

  function isValid(Crowdsale crowdsale) public returns (bool);
}
