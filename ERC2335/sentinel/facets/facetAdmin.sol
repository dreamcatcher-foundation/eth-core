// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import 'imports/openzeppelin/utils/Context.sol';
import 'ERC2335/sentinel/storage/storageAdmin.sol';

contract facetAdmin is Context, storageAdmin {

    /**
    * @dev The `AdminTransferred` event is emitted when the contract's administrator is transferred
    * from one address to another.
    * 
    * @param oldAdmin The address of the outgoing administrator.
    * @param newAdmin The address of the incoming administrator.
    */
    event AdminTransferred(address oldAdmin, address newAdmin);

    /**
    * @dev Public view function `getAdmin` retrieves the address of the current administrator.
    * 
    * @return The address of the current administrator.
    * 
    * This function provides external visibility to query and retrieve the address of the
    * current administrator associated with the contract. It utilizes the internal `admin`
    * function to access the `StorageAdmin` struct containing the administrator's address.
    */
    function getAdmin() public view virtual returns (address) {
        return admin().admin;
    }

    /**
    * @dev Public virtual function `claim` allows an address to claim the administrator role.
    * 
    * Requirements:
    * - The current administrator must be the zero address, ensuring the role is unclaimed.
    * 
    * Effects:
    * - Sets the caller's address as the new administrator.
    * - Emits the `AdminTransferred` event to signal the change in administrator.
    * 
    * This function is designed to be called by an address that wishes to take on the
    * administrator role when it is currently unclaimed. It ensures that only one address
    * can claim the administrator role at a time, preventing unauthorized claims.
    */
    function claim() public virtual {
        require(admin().admin == address(0), 'facetAdmin: admin claimed');
        admin().admin = _msgSender();
        transferAdmin(_msgSender());
    }

    /**
    * @dev Public virtual function `transferAdmin` allows the current administrator to transfer
    * the administrative role to a new address.
    * 
    * Requirements:
    * - If the current administrator is not the zero address, only the current administrator
    *   can initiate the transfer.
    * - The new administrator address must not be the zero address.
    * 
    * Effects:
    * - If conditions are met, transfers the administrator role from the current administrator
    *   to the specified new address.
    * - Emits the `AdminTransferred` event to signal the change in administrator.
    */
    function transferAdmin(address newAdmin) public virtual {
        if (admin().admin != address(0)) {
            require(_msgSender() == admin().admin, 'facetAdmin: only admin');
        }
        require(newAdmin != address(0), 'facetAdmin: new admin is the zero address');
        address oldAdmin = admin().admin;
        admin().admin = newAdmin;
        emit AdminTransferred(oldAdmin, newAdmin);
    }
}