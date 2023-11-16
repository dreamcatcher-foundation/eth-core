
/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetEmergencyConsole.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

pragma solidity ^0.8.19;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}




/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetEmergencyConsole.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.19;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}




/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetEmergencyConsole.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';

contract SlotEmergencyConsole {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 internal constant _EMERGENCY_CONSOLE = keccak256('slot.emergency.console');

    struct StorageEmergencyConsole {
        EnumerableSet.AddressSet emergencyOperators;
        EmergencyRequest[] emergencyRequests;
        uint requiredSignaturesInBasisPoints;
        uint delaySeconds;
    }

    struct EmergencyRequest {
        EnumerableSet.AddressSet expectedSigners;
        EnumerableSet.AddressSet signatures;
        address to;
        bytes args;
        uint startTimestamp;
        uint duration;
        uint requiredSignaturesInBasisPoints;
        bool executed;
    }

    function emergencyConsole() internal pure virtual returns (StorageEmergencyConsole storage s) {
        bytes32 location = _EMERGENCY_CONSOLE;
        assembly {
            s.slot := location
        }
    }
}

/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetEmergencyConsole.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'diamonds/facets/slots/SlotEmergencyConsole.sol';
////import 'imports/openzeppelin/utils/Context.sol';
////import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';

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
