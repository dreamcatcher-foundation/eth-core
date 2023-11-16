// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFacetChainlinkOracleReader {
    event ChainlinkOracleReadingAddressChanged(address indexed oldReadingAddress, address indexed newReadingAddress);

    function ____setChainlinkOracleReadingAddress(address newReadingAddress) external;

    ///

    function getChainlinkLatestAnswer(address token) external view returns (uint);
    function getChainlinkLatestTimestamp(address token) external view returns (uint);
    function getChainlinkPriceFeed(address token) external view returns (address);
    function hasChainlinkPriceFeed(address token) external view returns (bool);
}