// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFacetChainlinkOracle {
    event ChainlinkPriceFeedAssigned(address indexed token, address indexed oldPriceFeed, address indexed newPriceFeed);

    function ____assignTokenToChainlinkPriceFeed(address token, address newPriceFeed) external;
    function ____unassignTokenToChainlinkPriceFeed(address token) external;

    ///

    function getChainlinkLatestAnswer(address token) external view returns (uint);
    function getChainlinkLatestTimestamp(address token) external view returns (uint);
    function getChainlinkPriceFeed(address token) external view returns (address);
    function hasChainlinkPriceFeed(address token) external view returns (bool);
}