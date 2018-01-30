import ether from './helpers/ether';
import EVMRevert from './helpers/EVMRevert';
import latestTime from './helpers/latestTime';
import { advanceBlock } from './helpers/advanceToBlock';
import { duration, increaseTimeTo } from './helpers/increaseTime';

const BigNumber = web3.BigNumber

const WhitelistedCrowdsale = artifacts.require('mocks/WhitelistedCrowdsaleImpl.sol')
const MintableToken = artifacts.require('MintableToken')

contract('WhitelistCrowdsale', function ([_, owner, wallet, beneficiary, sender]) {
  const rate = new BigNumber(1000)

  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    await advanceBlock();
  });

  beforeEach(async function () {
    this.startTime = latestTime() + duration.weeks(1);
    this.endTime = this.startTime + duration.weeks(1);

    this.crowdsale = await WhitelistedCrowdsale.new(this.startTime, this.endTime, rate, wallet, {from: owner})

    this.token = MintableToken.at(await this.crowdsale.token())
  })

  describe('whitelisting', function () {
    const amount = ether(1)

    beforeEach(async function () {
      await increaseTimeTo(this.startTime);
    })

    it('should add address to whitelist', async function () {
      let whitelisted = await this.crowdsale.isWhitelisted(sender)
      whitelisted.should.equal(false)
      await this.crowdsale.addToWhitelist(sender, { from: owner })
      whitelisted = await this.crowdsale.isWhitelisted(sender)
      whitelisted.should.equal(true)
    })

    it('should reject non-whitelisted sender', async function () {
      await this.crowdsale.buyTokens(beneficiary, { value: amount, from: sender }).should.be.rejectedWith(EVMRevert)
    })

    it('should sell to whitelisted address', async function () {
      await this.crowdsale.addToWhitelist(sender, { from: owner })
      await this.crowdsale.buyTokens(beneficiary, { value: amount, from: sender }).should.be.fulfilled
    })
  })
})
