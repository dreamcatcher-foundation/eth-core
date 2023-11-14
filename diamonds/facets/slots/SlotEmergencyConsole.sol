// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';

contract SlotEmergencyConsole {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 internal constant _EMERGENCY_CONSOLE = keccak256('slot.emergency.console');

    struct StorageEmergencyConsole {
        EnumerableSet.AddressSet emergencyOperators;
        EmergencyRequest[] emergencyRequests;
        uint requiredSignaturesInBasisPoints;
        uint delaySeconds;
    }

    struct EmergencyRequest {
        EnumerableSet.AddressSet expectedSigners;
        EnumerableSet.AddressSet signatures;
        address to;
        bytes args;
        uint startTimestamp;
        uint duration;
        uint requiredSignaturesInBasisPoints;
        bool executed;
    }

    function emergencyConsole() internal pure virtual returns (StorageEmergencyConsole storage s) {
        bytes32 location = _EMERGENCY_CONSOLE;
        assembly {
            s.slot := location
        }
    }
}