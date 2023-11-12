// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract storageOracle {
    bytes32 internal constant _ORACLE = keccak256('facet.oracle');

    struct StorageOracle { mapping(address => address) tokenToChainlinkPriceFeed; }

    function oracle() internal pure virtual returns (StorageOracle storage s) {
        bytes32 location = _ORACLE;
        assembly {
            s.slot := location
        }
    }
}