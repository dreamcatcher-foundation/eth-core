// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract storageAdmin {
    bytes32 internal constant _ADMIN = keccak256('facet.admin');

    struct StorageAdmin {
        address admin;
        mapping(string => mapping(address => bool)) isRole;
    }

    function admin() internal pure virtual returns (StorageAdmin storage s) {
        bytes32 location = _ADMIN;
        assembly {
            s.slot := location
        }
    }
}