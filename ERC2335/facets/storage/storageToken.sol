// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';
import 'imports/openzeppelin/utils/Arrays.sol';
import 'imports/openzeppelin/utils/Counters.sol';

contract storageToken {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Arrays for uint[];
    using Counters for Counters.Counter;

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
        EnumerableSet.AddressSet minters;
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
        bool enabledForges;
        mapping(address => Snapshots) accountBalanceSnapshots;
        Snapshots totalSupplySnapshots;
        Counters.Counter currentSnapshotId;
    }

    struct Snapshots {
        uint[] ids;
        uint[] values;
    }

    function token() internal pure virtual returns (StorageToken storage s) {
        bytes32 location = _TOKEN;
        assembly {
            s.slot := location
        }
    }
}