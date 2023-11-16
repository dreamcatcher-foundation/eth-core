// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'imports/openzeppelin/token/ERC20/ERC20.sol';
import 'imports/openzeppelin/token/ERC20/extensions/ERC20Burnable.sol';
import 'imports/openzeppelin/token/ERC20/extensions/ERC20Snapshot.sol';
import 'imports/openzeppelin/token/ERC20/extensions/ERC20Permit.sol';

contract Token is ERC20, ERC20Burnable, ERC20Snapshot, ERC20Permit {
    constructor(string memory name, string memory symbol, uint mint) ERC20(name, symbol) ERC20Permit(name) {
        _mint(msg.sender, mint * (10**18));
    }

    function currentSnapshotId() external view virtual returns (uint) {
        return _getCurrentSnapshotId();
    }

    function snapshot() external virtual returns (uint) {
        return _snapshot();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Snapshot) {
        super._beforeTokenTransfer(from, to, amount);
    }
}