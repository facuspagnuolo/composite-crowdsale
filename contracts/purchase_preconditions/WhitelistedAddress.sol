pragma solidity ^0.4.18;

import './PurchasePrecondition.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract WhitelistedAddress is PurchasePrecondition, Ownable {

  mapping (address => bool) public whitelist;

  function addToWhitelist(address buyer) public onlyOwner {
    require(buyer != address(0));
    whitelist[buyer] = true;
  }

  function isValid(Crowdsale crowdsale, address buyer, address beneficiary, uint256 value) public returns (bool) {
    return isWhitelisted(buyer);
  }

  function add(address buyer) public onlyOwner {
    require(buyer != address(0));
    whitelist[buyer] = true;
  }

  function isWhitelisted(address buyer) public view returns (bool) {
    return whitelist[buyer];
  }
}
