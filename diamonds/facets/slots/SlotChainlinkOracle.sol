// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SlotChainlinkOracle {
    bytes32 internal constant _CHAINLINK_ORACLE = keccak256('slot.chainlink.oracle');

    struct StorageChainlinkOracle {
        mapping(address => address) chainlinkPriceFeed;
    }

    function chainlinkOracle() internal pure virtual returns (StorageChainlinkOracle storage s) {
        bytes32 location = _CHAINLINK_ORACLE;
        assembly {
            s.slot := location
        }
    }
}