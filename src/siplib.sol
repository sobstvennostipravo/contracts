pragma solidity ^0.4.17;

library SipLib {
    struct Link {
        address addr;    // 20 bytes
        uint32 microEtherPrice; // 4 bytes
        uint32 tokenPrice; // 4 bytes
        uint32 timeout;    // 4 bytes
    }

    function linkFromBytes32(bytes32 data) pure internal
    returns (Link)
    {
        return Link({addr: address((data & 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000) >> (12 * 8)),
                    microEtherPrice: uint32((data & 0xffffffff0000000000000000) >> (8 * 8)),
                    tokenPrice:  uint32((data & 0xffffffff00000000) >> (4 * 8)),
                    timeout:  uint32((data & 0xffffffff))
                    });
    }

    function bytes32FromLink(Link link) pure internal
    returns (bytes32)
    {
        return bytes32(link.addr) << (12 * 8) | bytes32(link.microEtherPrice) << (8 * 8) | bytes32(link.tokenPrice) << (4 * 8) | bytes32(link.timeout);

    }
}
