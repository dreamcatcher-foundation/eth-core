// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/slots/SlotEmergencyConsole.sol';
import 'imports/openzeppelin/utils/Context.sol';
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';

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

contract FacetEmergencyConsole is SlotEmergencyConsole, Context {
    using EnumerableSet for EnumerableSet.AddressSet;

    event RoleGrantedEmergencyOperator(address indexed account);
    event RoleRevokedEmergencyOperator(address indexed account);
    event EmergencyTimelockChanged(uint indexed oldTimelockSeconds, uint indexed newTimelockSeconds);
    event EmergencyRequiredSignaturesChanged(uint indexed oldRequiredSignatures, uint indexed newRequiredSignatures);
    event NewEmergencyRequest(uint indexed requestId, address indexed to, bytes indexed args);
    event EmergencyRequestSigned(uint indexed requestId, address indexed signer);
    event EmergencyRequestPassed(uint indexed requestId);

    function ____grantRoleEmergencyOperator(address account) external virtual {
        _onlySelf();
        emergencyConsole().emergencyOperators.add(account);
        emit RoleGrantedEmergencyOperator(account);
    }

    function ____revokeRoleEmergencyOperator(address account) external virtual {
        _onlySelf();
        emergencyConsole().emergencyOperators.remove(account);
        emit RoleRevokedEmergencyOperator(account);
    }

    function ____setEmergencyTimelock(uint newTimelockSeconds) external virtual {
        _onlySelf();
        uint oldTimelockSeconds = emergencyConsole().delaySeconds;
        emergencyConsole().delaySeconds = newTimelockSeconds;
        emit EmergencyTimelockChanged(oldTimelockSeconds, newTimelockSeconds);
    }

    function ____setEmergencyRequiredSignatures(uint newRequiredSignatures) external virtual {
        _onlySelf();
        require(newRequiredSignatures <= 10000, 'FacetEmergencyConsole: cannot be greater than 10000');
        uint oldRequiredSignatures = emergencyConsole().requiredSignaturesInBasisPoints;
        emergencyConsole().requiredSignaturesInBasisPoints = newRequiredSignatures;
        emit EmergencyRequiredSignaturesChanged(oldRequiredSignatures, newRequiredSignatures);
    }

    ///

    function emergencyOperators() public view virtual returns (address[] memory) {
        return emergencyConsole().emergencyOperators.values();
    }

    function emergencyOperator(uint operatorId) public view virtual returns (address) {
        return emergencyConsole().emergencyOperators.at(operatorId);
    }

    function getCurrentEmergencyRequestId() public view virtual returns (uint) {
        return emergencyConsole().emergencyRequests.length - 1;
    }

    function getEmergencyRequestTarget(uint requestId) public view virtual returns (address) {
        return emergencyConsole().emergencyRequests[requestId].to;
    }

    function getEmergencyRequestArgs(uint requestId) public view virtual returns (bytes memory) {
        return emergencyConsole().emergencyRequests[requestId].args;
    }

    function getEmergencyRequestStartTimestamp(uint requestId) public view virtual returns (uint) {
        return emergencyConsole().emergencyRequests[requestId].startTimestamp;
    }

    function getEmergencyRequestDuration(uint requestId) public view virtual returns (uint) {
        return emergencyConsole().emergencyRequests[requestId].duration;
    }

    function getEmergencyRequestExpectedSigners(uint requestId) public view virtual returns (address[] memory) {
        return emergencyConsole().emergencyRequests[requestId].expectedSigners.values();
    }

    function getEmergencyRequestExpectedSigner(uint requestId, uint signerId) public view virtual returns (address) {
        return emergencyConsole().emergencyRequests[requestId].expectedSigners.at(signerId);
    }

    function getEmergencySignatures(uint requestId) public view virtual returns (address[] memory) {
        return emergencyConsole().emergencyRequests[requestId].signatures.values();
    }

    function getEmergencySignature(uint requestId, uint signatureId) public view virtual returns (address) {
        return emergencyConsole().emergencyRequests[requestId].signatures.at(signatureId);
    }

    function getEmergencyRequestRequiredSignatures(uint requestId) public view virtual returns (uint) {
        return emergencyConsole().emergencyRequests[requestId].requiredSignaturesInBasisPoints;
    }

    function emergencyRequestHasBeenExecuted(uint requestId) public view virtual returns (bool) {
        return emergencyConsole().emergencyRequests[requestId].executed;
    }

    function emergencyRequest(address to, bytes memory args) public virtual returns (uint) {
        require(emergencyConsole().emergencyOperators.contains(_msgSender()), 'FacetEmergencyConsole: only emergency operator');
        emergencyConsole().emergencyRequests.push();
        uint newId = emergencyConsole().emergencyRequests.length - 1;
        emergencyConsole().emergencyRequests[newId].to = to;
        emergencyConsole().emergencyRequests[newId].args = args;
        emergencyConsole().emergencyRequests[newId].startTimestamp = block.timestamp;
        emergencyConsole().emergencyRequests[newId].duration = emergencyConsole().delaySeconds;
        emergencyConsole().emergencyRequests[newId].requiredSignaturesInBasisPoints = emergencyConsole().requiredSignaturesInBasisPoints;
        for (uint i = 0; i < emergencyConsole().emergencyOperators.length(); i++) {
            emergencyConsole().emergencyRequests[newId].expectedSigners.add(emergencyConsole().emergencyOperators.at(i));
        }
        emergencyConsole().emergencyRequests[newId].executed = false;
        emit NewEmergencyRequest(newId, to, args);
        return newId;
    }

    function signEmergencyRequest(uint requestId) public virtual {
        require(emergencyConsole().emergencyRequests[requestId].expectedSigners.contains(_msgSender()), 'FacetEmergencyConsole: only expected signers');
        require(!emergencyConsole().emergencyRequests[requestId].signatures.contains(_msgSender()), 'FacetEmergencyConsole: already signed');
        emergencyConsole().emergencyRequests[requestId].signatures.add(_msgSender());
        emit EmergencyRequestSigned(requestId, _msgSender());
    }

    function executeEmergencyRequest(uint requestId) public virtual returns (bool, bytes memory) {
        require(emergencyConsole().emergencyOperators.contains(_msgSender()), 'FacetEmergencyConsole: only emergency operator');
        uint requestEndTimestamp = emergencyConsole().emergencyRequests[requestId].startTimestamp + emergencyConsole().emergencyRequests[requestId].duration;
        require(block.timestamp >= requestEndTimestamp, 'FacetEmergencyConsole: emergency request is timelocked');
        require(!emergencyConsole().emergencyRequests[requestId].executed, 'FacetEmergencyConsole: emergency request already executed');
        bool hasSufficientSignatures = ((emergencyConsole().emergencyRequests[requestId].signatures.length() * 10000) / emergencyConsole().emergencyRequests[requestId].expectedSigners.length()) >= emergencyConsole().requiredSignaturesInBasisPoints;
        require(hasSufficientSignatures, 'FacetEmergencyConsole: insufficient signatures');
        address target = emergencyConsole().emergencyRequests[requestId].to;
        bytes memory args = emergencyConsole().emergencyRequests[requestId].args;
        (bool success, bytes memory response) = target.call(args);
        emergencyConsole().emergencyRequests[requestId].executed = true;
        emit EmergencyRequestPassed(requestId);
        return (success, response);
    }

    function _onlySelf() internal view virtual {
        require(_msgSender() == address(this), 'only self');
    }
}