pragma solidity ^0.4.11;

import "common/SafeMath.sol";
import "common/Ownable.sol";
import "PRAVOToken.sol";

contract PRAVOCrowdSale is Ownable {
  using SafeMath for uint;

  string public constant name = "PRAVO Token ICO";

  PRAVOToken public token;

  uint256 public collected = 0;

  uint256 public tokensSold = 0;

  uint256 public weiRefunded = 0;



  uint constant pravoPrice = 0.003 ether; //token price


  /* to modify before deploy */
  address constant tokenAddress = 0x0;

  address constant beneficiaryFoundation = 0x0;
  address constant beneficiaryDevelopment = 0x0;
  address constant beneficiaryCompany = 0x0;
  address constant beneficiaryBounty = 0x0;
  address constant beneficiaryEth = 0x0;

  uint constant ethUsdRate = 0;

  uint public startStamp = 0;

  /* */

  uint public endStamp = startStamp + 30 days;


  uint constant MIN_INVESTMENT = pravoPrice;
  uint constant MAX_INVESTMENT = 2500000 * pravoPrice;

  uint constant softCapUSD = 500000;  /* half of a million USD */
  uint constant softCap = 500000 / ethUsdRate;  /* num of tokens */

  uint constant maxTokens = 4000000000;  /* 4 billions */
  uint constant hardCap = maxTokens * pravoPrice;



  bool public softCapReached = false;

  bool public crowdsaleFinished = false;

  mapping (address => uint) public deposited;



  event SoftCapReached(uint softCap);

  event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);

  event Refunded(address indexed holder, uint amount);

  modifier icoActive() {
    require(now >= startStamp && now < endStamp);
    _;
  }

  modifier icoEnded() {
    require(now >= endStamp);
    _;
  }

  modifier maxInvestment() {
    require(msg.value <= MAX_INVESTMENT);
    _;
  }

  modifier minInvestment() {
    require(msg.value >= MIN_INVESTMENT);
    _;
  }

  function PRAVOCrowdSale  (
  ) public {
      require(beneficiaryFoundation != 0x0 &&
          beneficiaryDevelopment != 0x0 &&
          beneficiaryCompany != 0x0 &&
          beneficiaryBounty != 0x0 &&
          beneficiaryEth != 0x0 &&
          startStamp != 0x0 &&
          ethUsdRate !=0);
      token = PRAVOToken(tokenAddress);
  }

  function() public payable minInvestment maxInvestment {
    doPurchase();
  }

  function refund() external icoEnded {
    require(softCapReached == false);
    require(deposited[msg.sender] > 0);

    uint to_refund = deposited[msg.sender];

    deposited[msg.sender] = 0;
    msg.sender.transfer(to_refund);

    weiRefunded = weiRefunded.add(to_refund);
    Refunded(msg.sender, to_refund);
  }

  function withdraw() external onlyOwner {
    require(softCapReached);

    beneficiaryEth.transfer(collected);

    token.burn(token.balanceOf(this).sub(tokensSold));

    token.transfer(beneficiaryFoundation, tokensSold.mul(10).div(100));
    token.transfer(beneficiaryDevelopment, tokensSold.mul(26).div(100));
    token.transfer(beneficiaryBounty, tokensSold.mul(4).div(100));
    token.transfer(beneficiaryCompany, token.balanceOf(this));

    crowdsaleFinished = true;
  }

  function calculateBonus(uint tokens) internal constant returns (uint bonus) {
    if (now < startStamp + 1 hours) {
        return tokens.mul(15).div(100);
    }
    if (now < startStamp + 24 hours) {
        return tokens.mul(10).div(100);
    }
    if (now < startStamp + 7 days) {
        return tokens.mul(5).div(100);
    }
    if (now < startStamp + 14 days) {
        return tokens.mul(3).div(100);
    }
    if (now < startStamp + 21 days) {
        return tokens.mul(2).div(100);
    }

    return 0;
  }

  function doPurchase() private icoActive {
    require(!crowdsaleFinished);

    uint tokens = msg.value.div(pravoPrice);

    tokens = tokens.add(calculateBonus(tokens));

    uint newTokensSold = tokensSold.add(tokens);


    require(newTokensSold <= hardCap);

    if (!softCapReached && newTokensSold >= softCap) {
      softCapReached = true;
      SoftCapReached(softCap);
    }

    collected = collected.add(msg.value);

    tokensSold = newTokensSold;

    deposited[msg.sender] = deposited[msg.sender].add(msg.value);

    token.transfer(msg.sender, tokens);
    NewContribution(msg.sender, tokens, msg.value);
  }
}
