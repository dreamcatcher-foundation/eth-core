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
        uint wrapperRate;
        address feeTransferTo;
        address wrappableTokenIn;
        bool enabledCapped;
        bool enabledSoulBound;
        bool enabledWhitelist;
        bool enabledBlacklist;
        bool enabledTransferFee;
        bool enabledSnapshot;
        bool enabledBurnable;
        bool enabledAdminMarketMaker;
        bool enabledPausable;
        bool enabledTokenWrapper;
    }

    function token() internal pure virtual returns (StorageToken storage s) {
        bytes32 location = _TOKEN;
        assembly {
            s.slot := location
        }
    }
}