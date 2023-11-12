// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract storageAdmin {

    /**
    * @dev The `_ADMIN` constant serves as an internal identifier for administrative functionalities
    * within the contract. It is a 32-byte constant generated using the Keccak256 hash function on
    * the string 'facet.admin'. This ensures a unique and secure identifier for internal use.
    * 
    * Explanation of components:
    * - `bytes32`: Denotes a 32-byte array, the data type of the constant.
    * - `internal`: Restricts access to the constant within the current and derived contracts.
    * - `constant`: Specifies that the value of `_ADMIN` cannot be changed after assignment.
    * - `_ADMIN`: The name given to the constant, following the convention of starting with an underscore.
    * - `keccak256('facet.admin')`: Utilizes the Keccak256 hash function on the string 'facet.admin'
    *   to create a unique and deterministic 32-byte hash, ensuring a secure and collision-resistant
    *   identifier.
    */
    bytes32 internal constant _ADMIN = keccak256('facet.admin');

    /**
    * @dev The `StorageAdmin` struct represents an administrative entity in the contract's storage.
    * It contains a single field:
    *   - `admin`: An Ethereum address that serves as the administrator associated with this struct.
    * 
    * This struct is designed to manage and organize administrative data within the contract,
    * providing a structured way to store and retrieve information about administrators.
    */
    struct StorageAdmin { address admin; }

    /**
    * @dev Internal pure virtual function `admin` retrieves the `StorageAdmin` struct
    * associated with the contract's administrative functionality.
    * 
    * @return s The `StorageAdmin` struct containing information about the administrator.
    * 
    * Implementation details:
    * - This function is marked as internal to restrict access to internal contract logic.
    * - It is marked as pure because it does not modify the contract state.
    * - The function uses assembly to directly access the storage slot associated with the
    *   `_ADMIN` constant, retrieving the `StorageAdmin` struct.
    */
    function admin() internal pure virtual returns (StorageAdmin storage s) {
        bytes32 location = _ADMIN;
        assembly {
            s.slot := location
        }
    }
}