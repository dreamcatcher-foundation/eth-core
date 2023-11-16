// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFacetEmergencyConsole {
    function ____grantRoleEmergencyOperator(address account) external;
    function ____revokeRoleEmergencyOperator(address account) external;
    function ____setEmergencyTimelock(uint newTimelockSeconds) external;
    function ____setEmergencyRequiredSignatures(uint newRequiredSignatures) external;

    ///

    function emergencyOperators() external view returns (address[] memory);
    function emergencyOperator(uint operatorId) external view returns (address);
    function getCurrentEmergencyRequestId() external view returns (uint);
    function getEmergencyRequestTarget(uint requestId) external view returns (address);
    function getEmergencyRequestArgs(uint requestId) external view returns (bytes memory);
    function getEmergencyRequestStartTimestamp(uint requestId) external view returns (uint);
    function getEmergencyRequestDuration(uint requestId) external view returns (uint);
    function getEmergencyRequestExpectedSigners(uint requestId) external view returns (address[] memory);
    function getEmergencySignatures(uint requestId) external view returns (address[] memory);
    function getEmergencySignature(uint requestId, uint signatureId) external view returns (address);
    function getEmergencyRequestRequiredSignatures(uint requestId) external view returns (uint);
    function emergencyRequestHasBeenExecuted(uint requestId) external view returns (bool);
    function emergencyRequest(address to, bytes memory args) external returns (uint);
    function signEmergencyRequest(uint requestId) external;
    function executeEmergencyRequest(uint requestId) external returns (bool, bytes memory);
}