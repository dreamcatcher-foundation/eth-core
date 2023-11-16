// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFacetTokenLink {
    event TokenLinkEstablished(address oldToken, address newToken);

    function ____linkToken(address newToken) external;
    function ____mint(address account, uint amount) external;
    function ____burn(address account, uint amount) external;

    ///

    function getLinkedToken() external view returns (address);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
}