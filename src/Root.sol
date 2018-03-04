pragma solidity ^0.4.17;

import "common/Ownable.sol";
import "siplib.sol";
import "token/PRAVOTokenI.sol";

interface FactoryI {
    function jobStart(bytes32[] _data) payable public;
    /* function jobDone(bytes32[] _data) public; */
    function makeAction() payable public returns(address);
}

contract Root is Ownable {
    struct PaymentInfo {
        uint val;
        uint stamp;
    }
    mapping (string => SipLib.Link) factoryMap;
    mapping (address => PaymentInfo) paymentsMap;
    mapping (address => uint256) pendingWithdrawalsMap;
    mapping (address => address) contractsMap; // business? array? timestamp?

    event Debug(string string_part, uint uint_part);

    address public tokenAddress;
    /* address public tokenMagicAddress; */

    function Root() onlyOwner public {
        factoryMap['SOBSTVENNOSTIPRAVO'] = SipLib.Link(
            {addr: 0xf07031A5fA0Cc4792d3c5C805994b59dF1086a92, microEtherPrice: 20000, tokenPrice: 2, timeout: 30000});
    }

    function paymentTimeDelta(address client_address) public constant returns(uint) {
        require (paymentsMap[client_address].val > 0);
        return now - paymentsMap[client_address].stamp;
    }

    function getAddress(address client_address) public constant returns(address) {
        return contractsMap[client_address];
    }

    function makeAction(string fabriqueName, address client_address) public onlyOwner {
        Debug("Top of fabriqueName", 0);
        Debug(fabriqueName, 0);
        var fabrique = factoryMap[fabriqueName];
        Debug("before payment check", 0);
        Debug("", paymentsMap[client_address].val);
        Debug("", fabrique.microEtherPrice);
        /* require (paymentsMap[client_address].val >= fabrique.microEtherPrice); */
        /* enoughTokens(client_address, fabrique.tokenPrice); */
        delete contractsMap[client_address];
        Debug("before makeAction", 0);
        address contract_address = FactoryI(fabrique.addr).makeAction.value(fabrique.microEtherPrice * 10 szabo)();
        Debug("after makeAction", 0);

        if (paymentsMap[client_address].val > fabrique.microEtherPrice) {
            paymentsMap[client_address].val -= fabrique.microEtherPrice;
        }
        else {
            delete paymentsMap[client_address];
        }

        Debug("before transferTokens", 0);
        /* transferTokens(client_address, contract_address, fabrique.tokenPrice); */
        Debug("after transferTokens", 0);

        /* return contract_address; */
        contractsMap[client_address] = contract_address;
    }

    /* function buyTokens(address client_address, uint tokens) private { */

    /*     PRAVOTokenI(tokenAddress).transferFrom(tokenMagicAddress, */
    /*         client_address, tokens); */
    /* } */


    function enoughTokens(address client_address, uint tokenPrice) private view {
        uint currentTokenBalance = PRAVOTokenI(tokenAddress).balanceOf(client_address);


        require (tokenPrice <= currentTokenBalance);
    }


    function transferTokens(address client_address,
        address contract_address, uint tokenPrice) private {
        PRAVOTokenI(tokenAddress).transferFrom(client_address, contract_address, tokenPrice);
    }

    function getPrice(string fabriqueName) public constant returns(uint32, uint32)  {
        return (factoryMap[fabriqueName].microEtherPrice, factoryMap[fabriqueName].tokenPrice);
    }

    function () payable public {
        Debug("a payment received", msg.value);
        paymentsMap[msg.sender].val += (msg.value / 1 szabo);  // to microether
        paymentsMap[msg.sender].stamp = now;
    }


    function withdrawAllow(address client_address) onlyOwner public {
        uint256 weiAmount = paymentsMap[client_address].val;
        require(weiAmount > 0);
        delete paymentsMap[msg.sender];
        pendingWithdrawalsMap[client_address] = weiAmount;
    }


    function withdraw() public {
        uint256 weiAmount = pendingWithdrawalsMap[msg.sender];
        require(weiAmount > 0);

        pendingWithdrawalsMap[msg.sender] = 0;
        msg.sender.transfer(weiAmount);
        /* Withdraw(msg.sender, weiAmount); */
    }

    function setTokenAddress(address addr) onlyOwner public  {
        tokenAddress = addr;
    }

    /* function setTokenMagicAddress(address addr) onlyOwner public  { */
    /*     tokenMagicAddress = addr; */
    /* } */

    function setFactory(string fabriqueName,
        address _addr, uint32 _microEtherPrice, uint32 _tokenPrice, uint32 _timeout) onlyOwner public {
        factoryMap[fabriqueName] = SipLib.Link(
            {addr: _addr, microEtherPrice: _microEtherPrice, tokenPrice: _tokenPrice, timeout: _timeout});
    }

    function delFactory(string fabriqueName) onlyOwner public {
        delete factoryMap[fabriqueName];
    }

    function testFunc(string some) public returns(uint)  {
        Debug("a testFunc called", 0);
        return 42;
    }
}
