// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/slots/SlotTokenLink.sol';
import 'imports/openzeppelin/utils/Context.sol';
import 'units/interfaces/IOwnableToken.sol';

contract FacetTokenLink is SlotTokenLink, Context {
    event TokenLinkEstablished(address oldToken, address newToken);

    function ____linkToken(address newToken) external virtual {
        _onlySelf();
        require(_self() == IOwnableToken(newToken).owner(), 'FacetTokenLink: token not owned');
        address oldToken = tokenLink().linkedToken;
        tokenLink().linkedToken = newToken;
        emit TokenLinkEstablished(oldToken, newToken);
    }

    function ____mint(address account, uint amount) external virtual {
        _onlySelf();
        IOwnableToken(tokenLink().linkedToken).mint(account, amount);
    }

    function ____burn(address account, uint amount) external virtual {
        _onlySelf();
        IOwnableToken(tokenLink().linkedToken).burnFrom(account, amount);
    }

    ///

    function getLinkedToken() public view virtual returns (address) {
        return tokenLink().linkedToken;
    }

    function name() public view virtual returns (string memory) {
        return IOwnableToken(tokenLink().linkedToken).name();
    }

    function symbol() public view virtual returns (string memory) {
        return IOwnableToken(tokenLink().linkedToken).symbol();
    }

    function decimals() public view virtual returns (uint8) {
        return IOwnableToken(tokenLink().linkedToken).decimals();
    }

    function totalSupply() public view virtual returns (uint) {
        return IOwnableToken(tokenLink().linkedToken).totalSupply();
    }

    function balanceOf(address account) public view returns (uint) {
        return IOwnableToken(tokenLink().linkedToken).balanceOf(account);
    }

    ///

    function _onlySelf() internal view virtual {
        require(_msgSender() == _self(), 'FacetTokenLink: only self');
    }

    function _self() internal view virtual returns (address) {
        return address(this);
    }
}
