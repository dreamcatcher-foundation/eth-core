// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';

contract storageToken {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 internal constant _TOKEN = keccak256('facet.token');

    struct StorageToken {
        mapping(address => uint) balances;
        mapping(address => mapping(address => uint)) allowances;
        uint totalSupply;
        uint maxSupply;
        string name;
        string symbol;
        uint8 decimals;
        EnumerableSet.AddressSet whitelist;
        EnumerableSet.AddressSet blacklist;
        EnumerableSet.AddressSet holders;
        uint feeTransfer;
        address feeTransferTo;
        bool enabledCapped;
        bool enabledSoulBound;
        bool enabledWhitelist;
        bool enabledBlacklist;
        bool enabledTransferFee;
        bool enabledSnapshot;
        bool enabledBurnable;
        bool enabledFlashMint;
        bool enabledOnlyAdminTransferer;
        uint feeFlashMint;
        address feeFlashMintTo;

        /// This token can be paused by the the admin.
        /// Requires storagePausable and facetPausable.
        bool enabledPausable;
        
        /// Allow the contract to accept an address of a token,
        /// wrap it, and mint these custum tokens. These can then be
        /// unwrapped when they are returned to this contract.
        bool enabledTokenWrapper;
        address wrappableTokenIn;
        uint rate; /// In: 1 > Out: ?

        /// 
        bool enabledFaucet;
    }

    struct StorageTokenAccount {
        uint maxSize;
        uint minSize;
    }

    function token() internal pure virtual returns (StorageToken storage s) {
        bytes32 location = _TOKEN;
        assembly {
            s.slot := location
        }
    }
}