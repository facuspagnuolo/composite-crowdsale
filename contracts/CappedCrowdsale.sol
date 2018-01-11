pragma solidity ^0.4.18;

import './Crowdsale.sol';
import './purchase_preconditions/CappedPurchase.sol';
import './finalization_preconditions/CapReached.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * @title CappedCrowdsale
 * @dev Extension of Crowdsale with a max amount of funds raised
 */
contract CappedCrowdsale is Crowdsale {
  using SafeMath for uint256;

  uint256 public cap;

  function CappedCrowdsale(uint256 _cap) public {
    require(_cap > 0);
    cap = _cap;

    purchasePreconditions.push(new CappedPurchase(_cap));
    finalizationPreconditions.push(new CapReached(_cap));
  }

}
