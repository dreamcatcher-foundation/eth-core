// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Finance {

    function amountToMint(uint valueIn, uint balance, uint supply, uint8 decimalsA, uint8 decimalsB, uint8 decimalsC) internal pure returns (uint) {
        uint8 dampner = 18;
        require(dampner >= decimalsA, 'LibFinance: dampner < decimalsA');
        require(dampner >= decimalsB, 'LibFinance: dampner < decimalsB');
        require(dampner >= decimalsC, 'LibFinance: dampner < decimalsC');
        valueIn = decimalsToDecimals(valueIn, decimalsA, dampner);
        balance = decimalsToDecimals(balance, decimalsB, dampner);
        supply = decimalDampner(supply, decimalsC, dampner);
        uint result = (valueIn * supply) / balance;
        return result;
    }

    function valueToSend(uint amountIn, uint balance, uint supply, uint8 decimalsA, uint8 decimalsB, uint8 decimalsC) internal pure returns (uint) {
        uint8 dampner = 18;
        require(dampner >= decimalsA, 'LibFinance: dampner < decimalsA');
        require(dampner >= decimalsB, 'LibFinance: dampner < decimalsB');
        require(dampner >= decimalsC, 'LibFinance: dampner < decimalsC');
        amountIn = decimalsToDecimals(amountIn, decimalsA, dampner);
        balance = decimalsToDecimals(balance, decimalsB, dampner);
        supply = decimalsToDecimals(supply, decimalsC, dampner);
        uint result = (amountIn * balance) / supply;
        return result;
    }

    function amountOut(uint amountIn, uint priceA, uint priceB, uint8 decimalsA, uint8 decimalsB, uint8 decimalsC) internal pure returns (uint) {
        uint8 dampner = 18;
        require(dampner >= decimalsA, 'LibFinance: dampner < decimalsA');
        require(dampner >= decimalsB, 'LibFinance: dampner < decimalsB');
        require(dampner >= decimalsC, 'LibFinance: dampner < decimalsC');
        amountIn = decimalsToDecimals(amountIn, decimalsA, dampner);
        priceA = decimalDampner(priceA, decimalsB, dampner);
        priceB = decimalDampner(priceB, decimalsC, dampner);
        uint result = (amountIn * priceA) / priceB;
        return result;
    }

    

    function decimalsToDecimals(uint units, uint decimalsA, uint decimalsB) internal pure returns (uint) {
        uint dampner = 10**18;
        return ((units * dampner / (10**decimalsA)) * (10**decimalsB)) / dampner;
    }
}