pragma solidity ^0.4.17;

contract ActionChainI {
    enum Stage { Created, Awaiting, Completed }
    uint public link_num;
    Stage public stage;
}

contract ActionChainMonitor {
    enum Stage { Created, Awaiting, Completed }

    mapping (uint => string) LinkName;
    mapping (uint => string) StageName;

    function ActionChainMonitor() public {
        StageName[0] = "Created";
        StageName[1] = "Awaiting";
        StageName[2] = "Completed";

     LinkName[0] = "OCR";
     LinkName[1] = "fields";
     LinkName[2] = "table";
     LinkName[3] = "suitgenerator";
     LinkName[4] = "rosreestr";
    }

    function link_num(address ac) public view returns(uint) {
        return ActionChainI(ac).link_num();
    }

    function link_name(address ac) public view returns(string) {
        return LinkName[link_num(ac)];
    }

    function stage(address ac) public view returns(ActionChainI.Stage) {
        return ActionChainI(ac).stage();
    }

    function stage_name(address ac) public view returns(string) {
        return StageName[uint(stage(ac))];
    }
}
