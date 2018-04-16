pragma solidity ^0.4.11;

import "common/Ownable.sol";
import "PRAVOTokenI.sol";

contract PRAVOToken is Ownable, PRAVOTokenI {
	string public name = "PRAVO token";
	string public symbol = "PRAVO";
	uint public decimals = 18;

  /* This notifies clients about the amount burnt */
  event Burn(address indexed from, uint value);

	function PRAVOToken() public{
    uint INITIAL_SUPPLY = 4000000000;

		balances[msg.sender] = INITIAL_SUPPLY;
	}

  function burn(uint burn_value) onlyOwner public {
    balances[msg.sender] = balances[msg.sender].sub(burn_value);
    Burn(msg.sender, burn_value);
  }
}
