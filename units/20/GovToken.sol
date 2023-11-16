// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import 'imports/openzeppelin/token/ERC20/ERC20.sol';
import 'imports/openzeppelin/token/ERC20/extensions/ERC20Burnable.sol';
import 'imports/openzeppelin/token/ERC20/extensions/ERC20Snapshot.sol';
import 'imports/openzeppelin/token/ERC20/extensions/ERC20Permit.sol';
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Permit.sol';

interface IGovToken is IERC20Metadata, IERC20Permit {
    function balanceOfAt(address account, uint snapshotId) external view returns (uint);
    function totalSupplyAt(uint snapshotId) external view returns (uint);
    function getCurrentSnapshotId() external view returns (uint);
    function snapshot() external returns (uint);
}

contract GovToken is ERC20, ERC20Burnable, ERC20Snapshot, ERC20Permit {
    constructor(string memory name, string memory symbol, uint supply) ERC20(name, symbol) ERC20Permit(name) {
        _mint(msg.sender, supply * (10**18));
    }

    function getCurrentSnapshotId() external view virtual returns (uint) {
        return _getCurrentSnapshotId();
    }

    function snapshot() external virtual returns (uint) {
        return _snapshot();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Snapshot) {
        super._beforeTokenTransfer(from, to, amount);
    }
}