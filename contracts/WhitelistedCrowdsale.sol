pragma solidity ^0.4.18;

import './Crowdsale.sol';
import './purchase_preconditions/WhitelistedAddress.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * @title WhitelistedCrowdsale
 * @dev Extension of Crowsdale where an owner can whitelist addresses
 * which can buy in crowdsale before it opens to the public
 */
contract WhitelistedCrowdsale is Crowdsale, Ownable {
  using SafeMath for uint256;

  WhitelistedAddress private whitelistedAddress;

  function WhitelistedCrowdsale() public {
    whitelistedAddress = new WhitelistedAddress();
    purchasePreconditions.push(whitelistedAddress);
  }

  function addToWhitelist(address buyer) public onlyOwner {
    whitelistedAddress.add(buyer);
  }

  function isWhitelisted(address buyer) public constant returns (bool) {
    return whitelistedAddress.isWhitelisted(buyer);
  }

}
