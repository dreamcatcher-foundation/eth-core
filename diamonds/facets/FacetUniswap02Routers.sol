// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/slots/SlotUniswap02Routers.sol';
import 'imports/uniswap/interfaces/IUniswapV2Router02.sol';
import 'diamonds/facets/FacetChainlinkOracle.sol';
import 'imports/openzeppelin/utils/Context.sol';
import 'diamonds/facets/FacetSafe.sol';
import 'diamonds/facets/FacetToken.sol';

/// requires chainlink oracle
contract FacetUniswap02Routers is SlotUniswap02Routers, Context {
    event Swap(address tokenIn, address tokenOut, uint amountIn, uint minAmountOut);

    function ____swapTokens(string memory exchange, address tokenIn, address tokenOut, uint amountIn, address bridgeToken) public virtual {
        address self = address(this);
        address exchange_ = uniswap02Routers().router[exchange];
        _onlySelf();
        require(exchange_ != address(0), 'FacetUniswap02Routers: invalid exchange');
        require(amountIn != 0, 'FacetUniswap02Routers: zero value');
        require(IFacetChainlinkOracle(self).hasChainlinkPriceFeed(tokenIn), 'FacetUniswap02Routers: unassigned token in');
        require(IFacetChainlinkOracle(self).hasChainlinkPriceFeed(tokenOut), 'FacetUniswap02Routers: unassigned token out');
        uint priceA = (IFacetChainlinkOracle(self).getChainlinkLatestAnswer(tokenIn));
        uint priceB = (IFacetChainlinkOracle(self).getChainlinkLatestAnswer(tokenOut));
        uint minAmountOut = ((amountIn / (10**IFacetToken(tokenIn).decimals())) / priceB) * priceA;
        address[] memory path;
        path = new address[](3);
        path[0] = tokenIn;
        path[1] = bridgeToken;
        path[2] = tokenOut;
        IFacetToken(tokenIn).approve(exchange_, amountIn);
        IUniswapV2Router02(exchange_).swapExactTokensForTokens(amountIn, minAmountOut, path, self, block.timestamp);
    }

    function _onlySelf() internal virtual {
        require(_msgSender() == address(this), 'FacetUniswap02Routers: only self');
    }
}