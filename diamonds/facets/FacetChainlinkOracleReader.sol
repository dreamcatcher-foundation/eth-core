// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/FacetChainlinkOracle.sol';
import 'diamonds/facets/slots/SlotChainlinkOracleReader.sol';
import 'diamonds/facets/interfaces/IFacetChainlinkOracle.sol';

/// to be used instead of of chainlink oracle to read from another address
contract FacetChainlinkOracleReader is SlotChainlinkOracleReader, FacetChainlinkOracle {
    event ChainlinkOracleReadingAddressChanged(address indexed oldReadingAddress, address indexed newReadingAddress);

    function ____setChainlinkOracleReadingAddress(address newReadingAddress) public virtual {
        _onlySelf();
        address oldReadingAddress = chainlinkOracleReader().readingFrom;
        chainlinkOracleReader().readingFrom = newReadingAddress;
        emit ChainlinkOracleReadingAddressChanged(oldReadingAddress, newReadingAddress);
    }

    function ____assignTokenToChainlinkPriceFeed(address token, address newPriceFeed) public virtual override {
        _onlySelf();
        revert('FacetChainlinkOracleReader: disabled');
    }

    function ____unassignTokenToChainlinkPriceFeed(address token) public virtual override {
        _onlySelf();
        revert('FacetChainlinkOracleReader: disabled');
    }

    ///

    function getChainlinkLatestAnswer(address token) public view virtual override returns (uint) {
        return IFacetChainlinkOracle(chainlinkOracleReader().readingFrom).getChainlinkLatestAnswer(token);
    }

    function getChainlinkLatestTimestamp(address token) public view virtual override returns (uint) {
        return IFacetChainlinkOracle(chainlinkOracleReader().readingFrom).getChainlinkLatestTimestamp(token);
    }

    function getChainlinkPriceFeed(address token) public view virtual override returns (address) {
        return IFacetChainlinkOracle(chainlinkOracleReader().readingFrom).getChainlinkPriceFeed(token);
    }

    function hasChainlinkPriceFeed(address token) public view virtual override returns (bool) {
        return IFacetChainlinkOracle(chainlinkOracleReader().readingFrom).hasChainlinkPriceFeed(token);
    }
}