// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract storagePausable {
    bytes32 internal constant _PAUSABLE = keccak256('facet.pausable');

    struct StoragePausable { bool paused; }

    function pausable() internal pure virtual returns (StoragePausable storage s) {
        bytes32 location = _PAUSABLE;
        assembly {
            s.slot := location
        }
    }
}