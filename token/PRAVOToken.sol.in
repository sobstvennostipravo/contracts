pragma solidity ^0.4.11;

import "token/PRAVOTokenI.sol";


contract PRAVOToken is PRAVOTokenI {
	string public name = "PRAVO token";
	string public symbol = "PRAVO";
	uint public decimals = 18;
  event Debug(string);


	/* function SIP(uint256 _amount) { */
	function PRAVOToken() public{
    uint _amount = 1000000;

		owner = msg.sender;
		mint(owner, _amount);
	}

  function getRate() public returns(uint)  {
      return 42;
  }
}
