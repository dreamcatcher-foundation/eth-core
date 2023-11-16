
/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;

library Uint {
    function native(uint num, uint8 decimals) internal pure returns (uint) {
        return ((num * (10**18) / (10**18)) * (10**decimals)) / (10**18);
    }

    function normal(uint num, uint8 decimals) internal pure returns (uint) {
        return ((num * (10**18) / (10**decimals)) * (10**18)) / (10**18);
    }
}





/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.19;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}




/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * ////IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}




/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.19;

////import "../IERC20.sol";

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}




/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

pragma solidity ^0.8.19;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}




/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
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
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';

contract SlotSafe {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 internal constant _SAFE = keccak256('slot.safe');

    struct StorageSafe {
        mapping(address => uint) balances;
        EnumerableSet.AddressSet allowedIn;
        EnumerableSet.AddressSet allowedOut;
        EnumerableSet.AddressSet onHand;
        bool locked;
    }

    function safe() internal pure virtual returns (StorageSafe storage s) {
        bytes32 location = _SAFE;
        assembly {
            s.slot := location
        }
    }
}



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;

interface IFacetSafe {
    event Deposit(address from, address tokenIn, uint amountIn);
    event Withdraw(address to, address tokenOut, uint amountOut);
    event PermissionGrantedTokenIn(address tokenIn);
    event PermissionRevokedTokenIn(address tokenIn);
    event PermissionGrantedTokenOut(address tokenOut);
    event PermissionRevokedTokenOut(address tokenOut);

    function ____allowTokenInToSafe(address token) external;
    function ____forbidTokenInToSafe(address token) external;
    function ____allowTokenOutOfSafe(address token) external;
    function ____forbidTokenOutOfSafe(address token) external;
    function ____withdraw(address to, address tokenOut, uint amountOut) external;
    function ____withdraw(address to, uint amountOut) external;

    ///

    function getHoldingsInSafe(address token) external view returns (uint);
    function getTokensAllowedInToSafe() external view returns (address[] memory);
    function getTokenAllowedInToSafe(uint tokenId) external view returns (address);
    function getTokensAllowedOutFromSafe() external view returns (address[] memory);
    function getTokenAllowedOutFromSafe(uint tokenId) external view returns (address);
    function isAllowedIn(address token) external view returns (bool);
    function isAllowedOut(address token) external view returns (bool);
}



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'libraries/Uint.sol';

library Finance {
    using Uint for uint;

    function mint(uint v, uint b, uint s) internal pure returns (uint) {
        return (v * s) / b;
    }

    function send(uint a, uint b, uint s) internal pure returns (uint) {
        return (a * b) / s;
    }

    function amountOut(uint amountIn, uint priceA, uint priceB) internal pure returns (uint) {
        return (amountIn * priceA) / priceB;
    }
}



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
////import 'imports/openzeppelin/token/ERC20/extensions/IERC20Permit.sol';
////import 'imports/openzeppelin/token/ERC20/IERC20.sol';

interface IToken is IERC20, IERC20Metadata, IERC20Permit {
    function balanceOfAt(address account, uint snapshotId) external view returns (uint);
    function totalSupplyAt(uint snapshotId) external view returns (uint);
    function currentSnapshotId() external view returns (uint);
    function snapshot() external returns (uint);
    function burn(uint amount) external;
    function burnFrom(address account, uint amount) external;
}



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
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
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;

interface IFacetTokenLink {
    event TokenLinkEstablished(address oldToken, address newToken);

    function ____linkToken(address newToken) external;
    function ____mint(address account, uint amount) external;
    function ____burn(address account, uint amount) external;

    ///

    function getLinkedToken() external view returns (address);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
}



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'diamonds/facets/slots/SlotSafe.sol';
////import 'imports/openzeppelin/utils/Context.sol';
////import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';
////import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
////import 'imports/openzeppelin/token/ERC20/IERC20.sol';
////import 'libraries/Uint.sol';

/// rework
contract FacetSafe is SlotSafe, Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Uint for uint;

    event Deposit(address from, address tokenIn, uint amountIn);
    event Withdraw(address to, address tokenOut, uint amountOut);
    event PermissionGrantedTokenIn(address tokenIn);
    event PermissionRevokedTokenIn(address tokenIn);
    event PermissionGrantedTokenOut(address tokenOut);
    event PermissionRevokedTokenOut(address tokenOut);

    modifier nonReentrant() {
        require(!safe().locked, 'FacetSafe: reentrant call');
        safe().locked = true;
        _;
        safe().locked = false;
    }

    function ____allowTokenInToSafe(address token) external virtual {
        _onlySelf();
        safe().allowedIn.add(token);
        emit PermissionGrantedTokenIn(token);
    }

    function ____forbidTokenInToSafe(address token) external virtual {
        _onlySelf();
        safe().allowedIn.remove(token);
        emit PermissionRevokedTokenIn(token);
    }

    function ____allowTokenOutOfSafe(address token) external virtual {
        _onlySelf();
        safe().allowedOut.add(token);
        emit PermissionGrantedTokenOut(token);
    }

    function ____forbidTokenOutOfSafe(address token) external virtual {
        _onlySelf();
        safe().allowedOut.remove(token);
        emit PermissionRevokedTokenOut(token);
    }

    function ____withdraw(address to, address tokenOut, uint amountOut) nonReentrant() external virtual {
        _onlySelf();
        _withdraw(to, tokenOut, amountOut);
    }

    function ____withdraw(address to, uint amountOut) nonReentrant() external virtual {
        _onlySelf();
        _withdraw(to, amountOut);
    }

    ///

    function getHoldingsInSafe(address token) public view virtual returns (uint) {
        return safe().balances[token];
    }

    function getTokensAllowedInToSafe() public view virtual returns (address[] memory) {
        return safe().allowedIn.values();
    }

    function getTokenAllowedInToSafe(uint tokenId) public view virtual returns (address) {
        return safe().allowedIn.at(tokenId);
    }

    function getTokensAllowedOutFromSafe() public view virtual returns (address[] memory) {
        return safe().allowedOut.values();
    }

    function getTokenAllowedOutFromSafe(uint tokenId) public view virtual returns (address) {
        return safe().allowedOut.at(tokenId);
    }

    function isAllowedIn(address token) public view virtual returns (bool) {
        return safe().allowedIn.contains(token);
    }

    function isAllowedOut(address token) public view virtual returns (bool) {
        return safe().allowedOut.contains(token);
    }

    function _onlyAllowedIn(address token) internal view virtual {
        require(isAllowedIn(token), 'FacetSafe: token is not allowed in');
    }

    function _onlyAllowedOut(address token) internal view virtual {
        require(isAllowedOut(token), 'FacetSafe: token is not allowed out');
    }

    function _onlyCallerHasSufficientBalance(address token, uint amount) internal view virtual {
        amount = amount.native(IERC20Metadata(token).decimals());
        require(IERC20(token).balanceOf(_msgSender()) >= amount);
    }

    function _onlyCallerHasSufficientBalance(uint amount) internal view virtual {
        require(_msgSender().balance >= amount, 'FacetSafe: insufficient balance');
    }

    function _onlySelfHasSufficientBalance(address token, uint amount) internal view virtual {
        require(safe().balances[token] >= amount, 'FacetSafe: insufficient balance');
    }

    function _onlySelf() internal view virtual {
        require(_msgSender() == _self(), 'FacetSafe: only self');
    }

    function _self() internal view virtual returns (address) {
        return address(this);
    }
    
    /// amountIn always in 10**18
    function _deposit(address tokenIn, uint amountIn) internal virtual {
        IERC20 token = IERC20(tokenIn);
        _onlyAllowedIn(tokenIn);
        _onlyCallerHasSufficientBalance(tokenIn, amountIn);
        token.transferFrom(_msgSender(), _self(), amountIn.native(IERC20Metadata(tokenIn).decimals()));
        safe().balances[tokenIn] += amountIn; /// amount in as 10**18
        safe().onHand.add(tokenIn);
        emit Deposit(_msgSender(), tokenIn, amountIn);
    }

    function _deposit() internal virtual {
        _onlyAllowedIn(address(0));
        _onlyCallerHasSufficientBalance(msg.value);
        safe().balances[address(0)] += msg.value; /// eth always in 10**18 no conversion required
        safe().onHand.add(address(0));
        emit Deposit(_msgSender(), address(0), msg.value);
    }

    /// amount out in 10**18
    function _withdraw(address to, address tokenOut, uint amountOut) internal virtual {
        IERC20 token = IERC20(tokenOut);
        require(tokenOut != address(0), 'FacetSafe: inapropriate method');
        _onlyAllowedOut(tokenOut);
        _onlySelfHasSufficientBalance(tokenOut, amountOut);
        safe().balances[tokenOut] -= amountOut;
        if (safe().balances[tokenOut] == 0) {
            safe().onHand.remove(tokenOut);
        }
        /// must be converted back into native to interact with non native contracts
        token.transfer(to, amountOut.native(IERC20Metadata(address(token)).decimals()));
        emit Withdraw(to, tokenOut, amountOut);
    }

    /// amount out always in 10**18 cause eth is natively 18 decimals
    function _withdraw(address to, uint amountOut) internal virtual {
        _onlyAllowedOut(address(0));
        _onlySelfHasSufficientBalance(address(0), amountOut);
        safe().balances[address(0)] -= amountOut;
        if (safe().balances[address(0)] == 0) {
            safe().onHand.remove(address(0));
        }
        payable(to).transfer(amountOut);
        emit Withdraw(to, address(0), amountOut);
    }
}

/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetVault.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'diamonds/facets/FacetSafe.sol';
////import 'diamonds/facets/interfaces/IFacetTokenLink.sol';
////import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';
////import 'diamonds/facets/interfaces/IFacetChainlinkOracle.sol';
////import 'libraries/Uint.sol';
////import 'units/interfaces/IToken.sol';
////import 'libraries/Finance.sol';
////import 'diamonds/facets/interfaces/IFacetSafe.sol';

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

