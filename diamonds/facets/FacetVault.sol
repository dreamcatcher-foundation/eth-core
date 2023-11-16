// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/FacetSafe.sol';
import 'diamonds/facets/interfaces/IFacetTokenLink.sol';
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';
import 'diamonds/facets/interfaces/IFacetChainlinkOracle.sol';
import 'libraries/Uint.sol';
import 'units/interfaces/IToken.sol';
import 'libraries/Finance.sol';
import 'diamonds/facets/interfaces/IFacetSafe.sol';

/// basic vault implementation for closed beta
/// it is still rough and needs to work around the EIP4626
/// standard
/// future features will include repayment in asset and
/// full implementation and connection to the
/// dreamcatcher protocol
contract FacetVault is FacetSafe {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Uint for uint;
    using Finance for uint;

    function asset() public view virtual returns (address) {
        /// return the address of USD but this is calculated
        /// based on the tokens value in the oracle
        /// any allowed token may be deposited
        return address(0);
    }

    function totalAssets() public view virtual returns (uint) {
        uint sum;
        uint length = safe().onHand.length();
        for (uint i = 0; i < length; i++) {
            address token = safe().onHand.at(i);
            if (IFacetChainlinkOracle(_self()).hasChainlinkPriceFeed(token)) {
                uint balance = getHoldingsInSafe(token); /// 10**18
                uint price = IFacetChainlinkOracle(_self()).getChainlinkLatestAnswer(token); /// 10**8
                price = price.normal(8); /// chainlink out put always as 10**8
                sum += (price * balance);
            }
            /// if the asset is not registered in the oracle then it will be ignored
        }
        return sum;
    }

    /// token MUST BE 18 DECIMALS
    function totalAssetsPerShare() public view virtual returns (uint) {
        return totalAssets() / IFacetTokenLink(_self()).totalSupply(); /// supply of token is assumed to be 18 decimals
    }

    function convertToShares(address tokenIn, uint amountIn) public view virtual returns (uint) {
        uint8 decimals = IToken(tokenIn).decimals();
        amountIn = amountIn.normal(decimals);
        if (isAllowedIn(tokenIn)) {
            uint price = IFacetChainlinkOracle(_self()).getChainlinkLatestAnswer(tokenIn);
            price = price.normal(8);
            uint valueIn = (price * amountIn);
            uint amountToMint = valueIn.mint(totalAssets(), IFacetTokenLink(_self()).totalSupply());
            return amountToMint; /// returned at 10**18
        } else {
            return 0; /// if it cant find a value in then by default it will assume the asset is zero
        }
    }

    /// assumed to be 10**18 because the pool token MUST BE 18 DECIMALS.
    function convertToAssets(uint amountIn) public view virtual returns (uint) {
        return amountIn.send(totalAssets(), IFacetTokenLink(_self()).totalSupply());
    }

    function maxDeposit(address receiver) public view virtual returns (uint) {
        return 2**256 - 1;
    }

    function previewDeposit(address tokenIn, uint amountIn) public view virtual returns (uint) {
        return convertToShares(tokenIn, amountIn);
    }

    function deposit(address tokenIn, uint amountIn) public nonReentrant() virtual {
        /// converted value to 10**18 to allow math
        _deposit(tokenIn, amountIn);
        IFacetTokenLink(_self()).____mint(_msgSender(), convertToShares(tokenIn, amountIn));
    }

    /// repays in kind
    function withdraw(uint amountIn) public virtual {
        uint valueToSend = convertToAssets(amountIn);
        _onlyCallerHasSufficientBalance(IFacetTokenLink(_self()).getLinkedToken(), amountIn);
        uint portion = (valueToSend * 10000) / totalAssets(); /// get % of total assets
        uint length = safe().onHand.length();
        /// for each holding send the proportion to the reedeamer in kind
        for (uint i = 0; i < length; i++) {
            address tokenOut = safe().onHand.at(i);
            if (tokenOut == address(0)) {
                /// amounts always in 10**18 of the token especially for eth
                uint amount = getHoldingsInSafe(address(0));
                uint amountToSend = (amount / 10000) * portion; /// send portion of eth
                /// when ____withdraw is called by the contract itself
                /// the context changes and the contract itself is allowing
                /// the withdrawal
                IFacetSafe(_self()).____withdraw(_msgSender(), amountToSend);
            } else {
                /// 10**18 is converted to native in withdraw function
                uint amount = getHoldingsInSafe(tokenOut);
                uint amountToSend = (amount / 10000) * portion;
                IFacetSafe(_self()).____withdraw(_msgSender(), tokenOut, amountToSend);
            }
        }
    }
} 
