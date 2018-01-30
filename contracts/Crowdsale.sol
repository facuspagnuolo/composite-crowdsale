pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import './purchase_preconditions/NonZeroAddress.sol';
import './purchase_preconditions/NonZeroPurchase.sol';
import './purchase_preconditions/InsideBuyingPeriod.sol';
import './purchase_preconditions/PurchasePrecondition.sol';
import './finalization_preconditions/BuyingPeriodHasEnded.sol';
import './finalization_preconditions/FinalizationPrecondition.sol';

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale {
  using SafeMath for uint256;

  // The token being sold
  MintableToken public token;

  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public startTime;
  uint256 public endTime;

  // address where funds are collected
  address public wallet;

  // how many token units a buyer gets per wei
  uint256 public rate;

  // amount of raised money in wei
  uint256 public weiRaised;

  PurchasePrecondition[] internal purchasePreconditions;
  FinalizationPrecondition[] internal finalizationPreconditions;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
    require(_startTime >= now);
    require(_endTime >= _startTime);
    require(_rate > 0);
    require(_wallet != address(0));

    token = createTokenContract();
    startTime = _startTime;
    endTime = _endTime;
    rate = _rate;
    wallet = _wallet;

    purchasePreconditions.push(new NonZeroAddress());
    purchasePreconditions.push(new NonZeroPurchase());
    purchasePreconditions.push(new InsideBuyingPeriod());
    finalizationPreconditions.push(new BuyingPeriodHasEnded());
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific mintable token.
  function createTokenContract() internal returns (MintableToken) {
    return new MintableToken();
  }


  // fallback function can be used to buy tokens
  function () external payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    uint256 weiAmount = msg.value;
    require(validPurchase(msg.sender, beneficiary, weiAmount));

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    for(uint256 i = 0; i < finalizationPreconditions.length; i++) {
      if(finalizationPreconditions[i].isValid()) return true;
    }
    return false;
  }

  // @return true if the transaction can buy tokens
  function validPurchase(address buyer, address beneficiary, uint256 value) internal view returns (bool) {
    for(uint256 i = 0; i < purchasePreconditions.length; i++) {
      if(!purchasePreconditions[i].isValid(buyer, beneficiary, value)) return false;
    }
    return true;
  }

}
