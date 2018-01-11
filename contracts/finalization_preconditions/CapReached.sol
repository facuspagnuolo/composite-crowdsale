pragma solidity ^0.4.18;

import './FinalizationPrecondition.sol';

contract CapReached is FinalizationPrecondition {
  uint256 public cap;

  function CapReached(uint256 _cap) public {
    require(_cap > 0);
    cap = _cap;
  }

  function isValid(Crowdsale crowdsale) public returns (bool) {
    return crowdsale.weiRaised() >= cap;
  }
}
