pragma solidity ^0.4.17;

contract ActionChainI {
    enum Stage { Created, Awaiting, Completed }
    uint public link_num;
    Stage public stage;
}

contract ActionChainMonitor {
    enum Stage { Created, Awaiting, Completed }

    function link_num(address ac) public view returns(uint) {
        return ActionChainI(ac).link_num();
    }

    function stage(address ac) public view returns(ActionChainI.Stage) {
        return ActionChainI(ac).stage();
    }
}
