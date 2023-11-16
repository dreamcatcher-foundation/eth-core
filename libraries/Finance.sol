// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'libraries/Uint.sol';

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