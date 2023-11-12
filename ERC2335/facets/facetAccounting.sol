// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import 'imports/openzeppelin/utils/Context.sol';
import 'ERC2335/facets/storage/storageAdmin.sol';
import 'ERC2335/facets/storage/storageOracle.sol';
import 'ERC2335/facets/storage/storageSafe.sol';
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import 'ERC2335/facets/storage/storageToken.sol';

interface IEACAggregatorProxy {
    function latestAnswer() external view returns (uint);
    function latestTimestamp() external view returns (uint);
}

contract facetAccounting is Context, storageAdmin, storageOracle, storageSafe, storageToken {
    using EnumerableSet for EnumerableSet.AddressSet;
    
    function totalAssets() public view virtual returns (uint sum) {
        uint length = safe().onHand.length();
        for (uint i = 0; i < length; i++) {
            address token = safe().onHand.at(i);
            uint decimals = IERC20Metadata(token).decimals();
            uint amount = safe().amounts[token];
            if (oracle().tokenToChainlinkPriceFeed[token] != address(0)) {
                /// price given for one full unit of the token, so it is divided to obtain the smallest unit of price
                uint price = IEACAggregatorProxy(oracle().tokenToChainlinkPriceFeed[token]).latestAnswer() / (10**decimals);
                sum += (price * amount);
            } else {
                sum += 0;
            }
        }
    }

    function totalAssetsPerShare() public view virtual returns (uint sum) {
        return totalAssets() / token().totalSupply;
    }
}