// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SlotChainlinkOracleReader {
    bytes32 internal constant _CHAINLINK_ORACLE_READER = keccak256('slot.chainlink.oracle.reader');

    struct StorageChainlinkOracleReader {
        address readingFrom;
    }

    function chainlinkOracleReader() internal pure virtual returns (StorageChainlinkOracleReader storage s) {
        bytes32 location = _CHAINLINK_ORACLE_READER;
        assembly {
            s.slot := location
        }
    }
}