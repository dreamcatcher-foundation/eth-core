// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SlotConsole {
    bytes32 internal constant _CONSOLE = keccak256('slot.console');

    struct StorageConsole {
        address operator;
        uint delaySeconds;
        Request[] requests;
    }

    struct Request {
        address to;
        bytes args;
        uint startTimestamp;
        uint duration;
        bool executed;
    }

    function console() internal pure virtual returns (StorageConsole storage s) {
        bytes32 location = _CONSOLE;
        assembly {
            s.slot := location
        }
    }
}