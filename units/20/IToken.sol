// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Permit.sol';
import 'imports/openzeppelin/token/ERC20/IERC20.sol';

interface IToken is IERC20, IERC20Metadata, IERC20Permit {
    function balanceOfAt(address account, uint snapshotId) external view returns (uint);
    function totalSupplyAt(uint snapshotId) external view returns (uint);
    function currentSnapshotId() external view returns (uint);
    function snapshot() external returns (uint);
}