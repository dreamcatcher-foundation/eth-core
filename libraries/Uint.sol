// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Uint {

    /// 18 => decimals
    function native(
        uint num, 
        uint8 decimals
    ) 
        internal 
        pure 
        returns 
        (uint) {
            
        return ((num * (10**18) / (10**18)) * (10**decimals)) / (10**18);
    }

    /// decimals => 18
    function normal(
        uint num, 
        uint8 decimals
    ) 
        internal 
        pure 
        returns 
        (uint) {

        return ((num * (10**18) / (10**decimals)) * (10**18)) / (10**18);
    }

    ///

    function secondsLeft(
        uint timestampA, 
        uint timestampB
    ) 
        internal 
        view 
        returns 
        (uint) {

        uint seconds_ = timestampB - timestampA;
        return time() < timestampA ? seconds_ : seconds_ - time();
    }

    function hoursLeft(
        uint timestampA, 
        uint timestampB
    ) 
        internal 
        view 
        returns 
        (uint) {

        return secondsLeft(
            timestampA, 
            timestampB
        ) / 3600;
    }

    function daysLeft(
        uint timestampA, 
        uint timestampB
    ) 
        internal 
        view 
        returns 
        (uint) {

        return hoursLeft(
            timestampA, 
            timestampB
        ) / 24;
    }

    function weeksLeft(
        uint timestampA, 
        uint timestampB
    )
        internal 
        view 
        returns 
        (uint) {

        return daysLeft(
            timestampA,
            timestampB
        ) / 7;
    }

    function monthsLeft(
        uint timestampA,
        uint timestampB
    )
        internal
        view
        returns
        (uint) {

        return weeksLeft(
            timestampA,
            timestampB
        ) / 30;
    }
    
    function yearsLeft(
        uint timestampA,
        uint timestampB
    )
        internal
        view
        returns
        (uint) {

        return monthsLeft(
            timestampA,
            timestampB
        ) / 12;
    }

    ///

    function time() 
    internal 
    view 
    returns 
    (uint) {

        return block.timestamp;
    }
}

