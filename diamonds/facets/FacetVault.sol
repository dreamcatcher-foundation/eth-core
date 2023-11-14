// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/FacetSafe.sol';
import 'diamonds/facets/FacetToken.sol';
import 'diamonds/facets/FacetChainlinkOracle.sol';
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';

interface IFacetValue {
    function totalAssets() external view returns (uint);
    function totalAssetsPerShare() external view returns (uint);
    function convertToShares(address tokenIn, uint amountIn) external view returns (uint);
    function convertToAssets(uint amountIn) external view returns (uint);
    function depositInVault(address account, address tokenIn, uint amountIn) external;
    function withdrawFromVault(address account, uint amountIn) external;
}

/// requires safe, token, and chainlink oracle facets to be implemented
contract FacetVault is FacetSafe, FacetToken, FacetChainlinkOracle {
    using EnumerableSet for EnumerableSet.AddressSet;

    event DepositInVault(address indexed from, address indexed tokenIn, uint indexed amountIn, uint amountOut);
    event WithdrawFromVault(address indexed to, uint indexed amountIn, uint indexed amountOut);

    function totalAssets() public view virtual returns (uint) {
        /// price feeds are all assumed to be in usd
        uint sum;
        uint length = safe().onHand.length();
        address self = address(this);
        for (uint i = 0; i < length; i++) {
            address token_ = safe().onHand.at(i);
            uint decimals_ = IFacetToken(token_).decimals();
            uint balance = IFacetSafe(self).getHoldingsInSafe(token_);
            /// price is 1 of the token so break down the price for each micro unit of the token
            uint price = IFacetChainlinkOracle(self).getChainlinkLatestAnswer(token_) / (10**decimals_);
            sum += (price * balance);
        }
        return sum;
    }

    function totalAssetsPerShare() public view virtual returns (uint) {
        address self = address(this);
        return totalAssets() / IFacetToken(self).totalSupply();
    }

    function convertToShares(address tokenIn, uint amountIn) public view virtual returns (uint) {
        /// if the token is part of the chainlink oracle then return an amount else return 0 because cannot find value of the token
        address self = address(this);
        bool isAllowedIn_ = IFacetSafe(self).isAllowedIn(tokenIn);
        if (isAllowedIn_) {
            uint decimals_ = IFacetToken(tokenIn).decimals();
            uint valueIn = (IFacetChainlinkOracle(self).getChainlinkLatestAnswer(tokenIn) / (10**decimals_)) * amountIn;
            return (valueIn * IFacetToken(self).totalSupply()) / totalAssets();
        } else {
            return 0;
        }
    }

    function convertToAssets(uint amountIn) public view virtual returns (uint) {
        address self = address(this);
        return (amountIn * totalAssets()) / IFacetToken(self).totalSupply();
    }

    function depositInVault(address tokenIn, uint amountIn) nonReentrant() public virtual {
        _depositInVault(tokenIn, amountIn);
    }

    function withdrawFromVault(uint amountIn) nonReentrant() public virtual {
        _withdrawFromVault(amountIn);
    }

    function _onlySelf() internal view virtual override (FacetSafe, FacetToken, FacetChainlinkOracle) {
        super._onlySelf();
    }

    function _depositInVault(address tokenIn, uint amountIn) private {
        uint amountToMint = convertToShares(tokenIn, amountIn);
        address self = address(this);
        /// does not support eth
        require(tokenIn != address(0), 'FacetVault: unsupported');
        require(IFacetToken(tokenIn).balanceOf(_msgSender()) >= amountIn, 'FacetVault: insufficient balance');
        require(amountToMint != 0, 'FacetVault: zero value');
        deposit(tokenIn, amountIn);
        IFacetToken(self).____mint(amountToMint);
        IFacetToken(self).transfer(_msgSender(), amountToMint);
        emit DepositInVault(_msgSender(), tokenIn, amountIn, amountToMint);
    }

    /// repays in kind
    function _withdrawFromVault(uint amountIn) private {
        uint amountToSend = convertToAssets(amountIn);
        address self = address(this);
        require(IFacetToken(self).balanceOf(_msgSender()) >= amountIn, 'FacetVault: insufficient balance');
        require(amountToSend != 0, 'FacetVault: zero value');
        uint portion = (amountToSend * 10000) / totalAssets();
        uint length = safe().onHand.length();
        /// for each holding send the proportional amount in kind
        for (uint i = 0; i < length; i++) {
            address tokenOut = safe().onHand.at(i);
            if (tokenOut == address(0)) {
                /// eth has to be handled specially
                uint balance = IFacetSafe(self).getHoldingsInSafe(address(0));
                uint balanceToSend = (balance / 10000) * portion;
                IFacetSafe(self).____withdraw(_msgSender(), balanceToSend);
            } else {
                uint balance = IFacetSafe(self).getHoldingsInSafe(tokenOut);
                /// divide balance of the token by the portion owned by the contributor
                uint balanceToSend = (balance / 10000) * portion;
                IFacetSafe(self).____withdraw(_msgSender(), tokenOut, balanceToSend);
            }
        }
        /// should be as close to the amount to send as possible
        emit WithdrawFromVault(_msgSender(), amountIn, amountToSend);
    }
}