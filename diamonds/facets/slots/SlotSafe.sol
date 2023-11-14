// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';

contract SlotSafe {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 internal constant _SAFE = keccak256('slot.safe');

    struct StorageSafe {
        mapping(address => uint) balances;
        EnumerableSet.AddressSet allowedIn;
        EnumerableSet.AddressSet allowedOut;
        EnumerableSet.AddressSet onHand;
        bool locked;
    }

    function safe() internal pure virtual returns (StorageSafe storage s) {
        bytes32 location = _SAFE;
        assembly {
            s.slot := location
        }
    }
}