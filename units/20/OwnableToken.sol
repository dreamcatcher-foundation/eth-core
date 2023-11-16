// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'units/20/Token.sol';
import 'imports/openzeppelin/access/Ownable.sol';

contract PoolToken is Token, Ownable {
    constructor(string memory name, string memory symbol) Token(name, symbol, 0)  Ownable(msg.sender) {
        _transferOwnership(msg.sender);
    }

    function mint(address account, uint amount) onlyOwner() external virtual {
        _mint(account, amount);
    }
}
