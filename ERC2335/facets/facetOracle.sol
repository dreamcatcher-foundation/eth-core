// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import 'imports/openzeppelin/utils/Context.sol';
import 'ERC2335/facets/storage/storageAdmin.sol';
import 'ERC2335/facets/storage/storageOracle.sol';

interface IEACAggregatorProxy {
    function latestAnswer() external view returns (uint);
    function latestTimestamp() external view returns (uint);
}

contract facetOracle is Context, storageOracle, storageAdmin {
    event TokenChainlinkPriceFeedChanged(address indexed token, address indexed oldPriceFeed, address indexed newPriceFeed);

    function getChainlinkLatestAnswerFor(address token) public view virtual returns (uint) {
        return IEACAggregatorProxy(getChainlinkPriceFeed(token)).latestAnswer();
    }

    function getChainlinkLatestTimestamp(address token) public view virtual returns (uint) {
        return IEACAggregatorProxy(getChainlinkPriceFeed(token)).latestTimestamp();
    }

    function getChainlinkPriceFeed(address token) public view virtual returns (address) {
        address chainlinkPriceFeed = oracle().tokenToChainlinkPriceFeed[token];
        require(chainlinkPriceFeed != address(0), 'facetOracle: unassigned price feed');
        return chainlinkPriceFeed;
    }

    function assignTokenToChainlinkPriceFeed(address token, address newPriceFeed) public virtual {
        require(_msgSender() == admin().admin, 'facetOracle: only admin');
        address oldPriceFeed = oracle().tokenToChainlinkPriceFeed[token];
        oracle().tokenToChainlinkPriceFeed[token] = newPriceFeed;
        emit TokenChainlinkPriceFeedChanged(token, oldPriceFeed, newPriceFeed);
    }

    function assignTokensToChainlinkPriceFeeds(address[] memory tokens, address[] memory newPriceFeeds) public virtual {
        require(_msgSender() == admin().admin, 'facetOracle: only admin');
        require(tokens.length == newPriceFeeds.length, 'facetOracle: mismatch');
        uint length = tokens.length;
        for (uint i = 0; i < length; i++) {
            assignTokenToChainlinkPriceFeed(tokens[i], newPriceFeeds[i]);
        }
    }
}