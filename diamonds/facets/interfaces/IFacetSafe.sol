// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFacetSafe {
    event Deposit(address from, address tokenIn, uint amountIn);
    event Withdraw(address to, address tokenOut, uint amountOut);
    event PermissionGrantedTokenIn(address tokenIn);
    event PermissionRevokedTokenIn(address tokenIn);
    event PermissionGrantedTokenOut(address tokenOut);
    event PermissionRevokedTokenOut(address tokenOut);

    function ____allowTokenInToSafe(address token) external;
    function ____forbidTokenInToSafe(address token) external;
    function ____allowTokenOutOfSafe(address token) external;
    function ____forbidTokenOutOfSafe(address token) external;
    function ____withdraw(address to, address tokenOut, uint amountOut) external;
    function ____withdraw(address to, uint amountOut) external;

    ///

    function getHoldingsInSafe(address token) external view returns (uint);
    function getTokensAllowedInToSafe() external view returns (address[] memory);
    function getTokenAllowedInToSafe(uint tokenId) external view returns (address);
    function getTokensAllowedOutFromSafe() external view returns (address[] memory);
    function getTokenAllowedOutFromSafe(uint tokenId) external view returns (address);
    function isAllowedIn(address token) external view returns (bool);
    function isAllowedOut(address token) external view returns (bool);
}