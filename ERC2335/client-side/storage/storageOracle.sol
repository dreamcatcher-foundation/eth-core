// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract storageOracle {
    bytes32 internal constant _ORACLE = keccak256('node.oracle');

    struct StOracle {
        mapping(address => address) contractToPriceFeed;
    }

    function oracle() internal pure virtual returns (StOracle storage s) {
        bytes32 location = _ORACLE;
        assembly {
            s.slot := location
        }
    }
}