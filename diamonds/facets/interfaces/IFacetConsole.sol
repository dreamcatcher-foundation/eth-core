// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFacetConsole {
    function ____setOperator(address newOperator) external;
    function ____setTimelock(uint newTimelockSeconds) external;

    ///

    function operator() external view returns (address);
    function getCurrentRequestId() external view returns (uint);
    function getRequestTarget(uint requestId) external view returns (address);
    function getRequestArgs(uint requestId) external view returns (bytes memory);
    function getRequestStartTimestamp(uint requestId) external view returns (uint);
    function getRequestDuration(uint requestId) external view returns (uint);
    function requestHasBeenExecuted(uint requestId) external view returns (bool);
    function claim() external;
    function request(address to, bytes memory args) external returns (uint);
    function execute(uint requestId) external returns (bool, bytes memory);
}