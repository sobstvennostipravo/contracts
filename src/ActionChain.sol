pragma solidity ^0.4.17;

import "common/Ownable.sol";
import	"siplib.sol";

interface WorkerI {
    function jobStart(bytes32[] _data) payable public;
    /* function jobDone(bytes32[] _data) public; */
}

contract ActionChain is Ownable/* , WorkerI */ {
    enum Stage { Created, Awaiting, Completed }


    SipLib.Link[] public links;  // or map ?
    uint public link_num;
    event DoneEvent(uint);
    Stage public stage;

    event Debug(string string_part, uint uint_part);

    modifier atStage(Stage _stage) {
        require(stage == _stage);
        _;
    }

    modifier currentWorkerOnly() {
        require(msg.sender == links[link_num].addr);
        _;
    }

    function ActionChain() payable public
    {
        stage = Stage.Created;
        link_num = 0;
    }

    function  setLinks(bytes32[] _links) public onlyOwner
    {
        for (uint i = 0; i < _links.length; i++) {
            links.push(SipLib.linkFromBytes32(_links[i]));
        }
        Debug("setLinks", links.length);
    }


    function supplyInitialData(bytes32[] _data) public
        atStage(Stage.Created)
    {
        Debug("supplyInitialData", 0);

        link_num = 0;
        stage = Stage.Awaiting;

        /* transfer tokens */
        /* via Root? */
        /* transfer */
        /* TokenI */
        WorkerI(links[link_num].addr).jobStart.value(links[link_num].microEtherPrice * 1 szabo)(_data);
    }

    function jobDone(bytes32[] _data) currentWorkerOnly() public
        atStage(Stage.Awaiting)
    {
        DoneEvent(link_num);
        if (link_num >= links.length - 1) {
            stage = Stage.Completed;
            /* return ether & tokens, ? change ownership to user */
        }
        else {
            link_num++;
            WorkerI(links[uint(link_num)].addr).jobStart(_data);
        }
    }
}
