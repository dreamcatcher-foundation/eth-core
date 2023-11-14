// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SlotUniswap02Routers {
    bytes32 internal constant _UNISWAP_02_ROUTERS = keccak256('slot.uniswap.02.routers');

    struct StorageUniswap02Routers {
        mapping(string => address) router;
    }

    function uniswap02Routers() internal pure virtual returns (StorageUniswap02Routers storage s) {
        bytes32 location = _UNISWAP_02_ROUTERS;
        assembly {
            s.slot := location
        }
    }
}