// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import 'imports/openzeppelin/utils/Context.sol';
import 'ERC2335/facets/storage/storageAdmin.sol';

contract facetAdmin is Context, storageAdmin {
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    function getAdmin() public view virtual returns (address) {
        return admin().admin;
    }

    function claim() public virtual {
        require(admin().admin == address(0), 'facetAdmin: admin claimed');
        admin().admin = _msgSender();
        transferAdmin(_msgSender());
    }

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