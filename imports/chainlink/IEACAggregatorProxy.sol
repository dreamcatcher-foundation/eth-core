// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEACAggregatorProxy {
    function latestAnswer() external view returns (uint);
    function latestTimestamp() external view returns (uint);
}