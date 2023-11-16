// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SlotTokenLink {
    bytes32 internal constant _TOKEN_LINK = keccak256('slot.token.link');

    struct StorageTokenLink {
        address linkedToken;
    }

    function tokenLink() internal pure virtual returns (StorageTokenLink storage s) {
        bytes32 location = _TOKEN_LINK;
        assembly {
            s.slot := location
        }
    }
}