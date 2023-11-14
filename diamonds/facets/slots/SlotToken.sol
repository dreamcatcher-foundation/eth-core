// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'imports/openzeppelin/utils/Arrays.sol';
import 'imports/openzeppelin/utils/Counters.sol';

contract SlotToken {
    bytes32 internal constant _TOKEN = keccak256('slot.token');

    struct StorageToken {
        mapping(address => uint) balances;
        mapping(address => mapping(address => uint)) allowances;
        mapping(address => Snapshots) snapshotsOfBalance;
        Snapshots snapshotsOfTotalSupply;
        Counters.Counter currentSnapshotId;
        string name;
        string symbol;
        uint totalSupply;
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