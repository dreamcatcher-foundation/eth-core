// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/slots/SlotChainlinkOracle.sol';
import 'imports/openzeppelin/utils/Context.sol';
import 'imports/chainlink/IEACAggregatorProxy.sol';

contract FacetChainlinkOracle is SlotChainlinkOracle, Context {
    event ChainlinkPriceFeedAssigned(address indexed token, address indexed oldPriceFeed, address indexed newPriceFeed);

    function ____assignTokenToChainlinkPriceFeed(address token, address newPriceFeed) public virtual {
        _onlySelf();
        address oldPriceFeed = chainlinkOracle().chainlinkPriceFeed[token];
        chainlinkOracle().chainlinkPriceFeed[token] = newPriceFeed;
        emit ChainlinkPriceFeedAssigned(token, oldPriceFeed, newPriceFeed);
    }

    function ____unassignTokenToChainlinkPriceFeed(address token) public virtual {
        _onlySelf();
        address oldPriceFeed = chainlinkOracle().chainlinkPriceFeed[token];
        chainlinkOracle().chainlinkPriceFeed[token] = address(0);
        emit ChainlinkPriceFeedAssigned(token, oldPriceFeed, address(0));
    }

    ///

    function getChainlinkLatestAnswer(address token) public view virtual returns (uint) {
        if (hasChainlinkPriceFeed(token)) {
            return IEACAggregatorProxy(getChainlinkPriceFeed(token)).latestAnswer();
        } else {
            return 0;
        }
    }

    function getChainlinkLatestTimestamp(address token) public view virtual returns (uint) {
        if (hasChainlinkPriceFeed(token)) {
            return IEACAggregatorProxy(getChainlinkPriceFeed(token)).latestTimestamp();
        } else {
            return 0;
        }
    }

    function getChainlinkPriceFeed(address token) public view virtual returns (address) {
        return chainlinkOracle().chainlinkPriceFeed[token];
    }

    function hasChainlinkPriceFeed(address token) public view virtual returns (bool) {
        return getChainlinkPriceFeed(token) != address(0) ? true : false;
    }

    function _onlySelf() internal view virtual {
        require(_msgSender() == address(this), 'FacetChainlinkOracle: only self');
    }
}