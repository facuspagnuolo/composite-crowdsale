pragma solidity ^0.4.18;

import './PurchasePrecondition.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract CappedPurchase is PurchasePrecondition {
  using SafeMath for uint256;

  uint256 private _cap;

  function CappedPurchase(uint256 cap) public {
    require(cap > 0);
    _cap = cap;
  }

  function cap() public view returns (uint256) {
    return _cap;
  }

  function isValid(Crowdsale crowdsale, address buyer, address beneficiary, uint256 value) public returns (bool) {
    return crowdsale.weiRaised().add(value) <= _cap;
  }
}
