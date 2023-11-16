// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Uint {
    function native(uint num, uint8 decimals) internal pure returns (uint) {
        return ((num * (10**18) / (10**18)) * (10**decimals)) / (10**18);
    }

    function normal(uint num, uint8 decimals) internal pure returns (uint) {
        return ((num * (10**18) / (10**decimals)) * (10**18)) / (10**18);
    }
}

