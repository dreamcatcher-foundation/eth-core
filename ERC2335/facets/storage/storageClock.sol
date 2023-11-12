// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract storageClock {
    bytes32 internal constant _CLOCK = keccak256('facet.clock');

    struct StorageClock {
        uint preLaunchTimestamp;
        uint launchTimestamp;
        Timer[] timers;
    }

    struct Timer {
        uint startTimestamp;
        uint duration;
    }

    function clock() internal pure virtual returns (StorageClock storage s) {
        bytes32 location = _CLOCK;
        assembly {
            s.slot := location
        }
    }
}