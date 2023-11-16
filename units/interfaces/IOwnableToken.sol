// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'units/interfaces/IToken.sol';

interface IOwnableToken is IToken {
    function mint(address account, uint amount) external;
    function owner() external view returns (address);
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
}