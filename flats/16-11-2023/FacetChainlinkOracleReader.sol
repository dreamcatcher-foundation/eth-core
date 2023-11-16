
/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetChainlinkOracleReader.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;

interface IEACAggregatorProxy {
    function latestAnswer() external view returns (uint);
    function latestTimestamp() external view returns (uint);
}



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetChainlinkOracleReader.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.19;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}




/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetChainlinkOracleReader.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;

contract SlotChainlinkOracle {
    bytes32 internal constant _CHAINLINK_ORACLE = keccak256('slot.chainlink.oracle');

    struct StorageChainlinkOracle {
        mapping(address => address) chainlinkPriceFeed;
    }

    function chainlinkOracle() internal pure virtual returns (StorageChainlinkOracle storage s) {
        bytes32 location = _CHAINLINK_ORACLE;
        assembly {
            s.slot := location
        }
    }
}



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetChainlinkOracleReader.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
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



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetChainlinkOracleReader.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;

contract SlotChainlinkOracleReader {
    bytes32 internal constant _CHAINLINK_ORACLE_READER = keccak256('slot.chainlink.oracle.reader');

    struct StorageChainlinkOracleReader {
        address readingFrom;
    }

    function chainlinkOracleReader() internal pure virtual returns (StorageChainlinkOracleReader storage s) {
        bytes32 location = _CHAINLINK_ORACLE_READER;
        assembly {
            s.slot := location
        }
    }
}



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetChainlinkOracleReader.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'diamonds/facets/slots/SlotChainlinkOracle.sol';
////import 'imports/openzeppelin/utils/Context.sol';
////import 'imports/chainlink/IEACAggregatorProxy.sol';

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

/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetChainlinkOracleReader.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'diamonds/facets/FacetChainlinkOracle.sol';
////import 'diamonds/facets/slots/SlotChainlinkOracleReader.sol';
////import 'diamonds/facets/interfaces/IFacetChainlinkOracle.sol';

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
