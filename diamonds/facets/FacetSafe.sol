// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/slots/SlotSafe.sol';
import 'imports/openzeppelin/utils/Context.sol';
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import 'imports/openzeppelin/token/ERC20/IERC20.sol';
import 'libraries/Uint.sol';

/// rework
contract FacetSafe is SlotSafe, Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Uint for uint;

    event Deposit(address from, address tokenIn, uint amountIn);
    event Withdraw(address to, address tokenOut, uint amountOut);
    event PermissionGrantedTokenIn(address tokenIn);
    event PermissionRevokedTokenIn(address tokenIn);
    event PermissionGrantedTokenOut(address tokenOut);
    event PermissionRevokedTokenOut(address tokenOut);

    modifier nonReentrant() {
        require(!safe().locked, 'FacetSafe: reentrant call');
        safe().locked = true;
        _;
        safe().locked = false;
    }

    function ____allowTokenInToSafe(address token) external virtual {
        _onlySelf();
        safe().allowedIn.add(token);
        emit PermissionGrantedTokenIn(token);
    }

    function ____forbidTokenInToSafe(address token) external virtual {
        _onlySelf();
        safe().allowedIn.remove(token);
        emit PermissionRevokedTokenIn(token);
    }

    function ____allowTokenOutOfSafe(address token) external virtual {
        _onlySelf();
        safe().allowedOut.add(token);
        emit PermissionGrantedTokenOut(token);
    }

    function ____forbidTokenOutOfSafe(address token) external virtual {
        _onlySelf();
        safe().allowedOut.remove(token);
        emit PermissionRevokedTokenOut(token);
    }

    function ____withdraw(address to, address tokenOut, uint amountOut) nonReentrant() external virtual {
        _onlySelf();
        _withdraw(to, tokenOut, amountOut);
    }

    function ____withdraw(address to, uint amountOut) nonReentrant() external virtual {
        _onlySelf();
        _withdraw(to, amountOut);
    }

    ///

    function getHoldingsInSafe(address token) public view virtual returns (uint) {
        return safe().balances[token];
    }

    function getTokensAllowedInToSafe() public view virtual returns (address[] memory) {
        return safe().allowedIn.values();
    }

    function getTokenAllowedInToSafe(uint tokenId) public view virtual returns (address) {
        return safe().allowedIn.at(tokenId);
    }

    function getTokensAllowedOutFromSafe() public view virtual returns (address[] memory) {
        return safe().allowedOut.values();
    }

    function getTokenAllowedOutFromSafe(uint tokenId) public view virtual returns (address) {
        return safe().allowedOut.at(tokenId);
    }

    function isAllowedIn(address token) public view virtual returns (bool) {
        return safe().allowedIn.contains(token);
    }

    function isAllowedOut(address token) public view virtual returns (bool) {
        return safe().allowedOut.contains(token);
    }

    function _onlyAllowedIn(address token) internal view virtual {
        require(isAllowedIn(token), 'FacetSafe: token is not allowed in');
    }

    function _onlyAllowedOut(address token) internal view virtual {
        require(isAllowedOut(token), 'FacetSafe: token is not allowed out');
    }

    function _onlyCallerHasSufficientBalance(address token, uint amount) internal view virtual {
        amount = amount.native(IERC20Metadata(token).decimals());
        require(IERC20(token).balanceOf(_msgSender()) >= amount);
    }

    function _onlyCallerHasSufficientBalance(uint amount) internal view virtual {
        require(_msgSender().balance >= amount, 'FacetSafe: insufficient balance');
    }

    function _onlySelfHasSufficientBalance(address token, uint amount) internal view virtual {
        require(safe().balances[token] >= amount, 'FacetSafe: insufficient balance');
    }

    function _onlySelf() internal view virtual {
        require(_msgSender() == _self(), 'FacetSafe: only self');
    }

    function _self() internal view virtual returns (address) {
        return address(this);
    }
    
    /// amountIn always in 10**18
    function _deposit(address tokenIn, uint amountIn) internal virtual {
        IERC20 token = IERC20(tokenIn);
        _onlyAllowedIn(tokenIn);
        _onlyCallerHasSufficientBalance(tokenIn, amountIn);
        token.transferFrom(_msgSender(), _self(), amountIn.native(IERC20Metadata(tokenIn).decimals()));
        safe().balances[tokenIn] += amountIn; /// amount in as 10**18
        safe().onHand.add(tokenIn);
        emit Deposit(_msgSender(), tokenIn, amountIn);
    }

    function _deposit() internal virtual {
        _onlyAllowedIn(address(0));
        _onlyCallerHasSufficientBalance(msg.value);
        safe().balances[address(0)] += msg.value; /// eth always in 10**18 no conversion required
        safe().onHand.add(address(0));
        emit Deposit(_msgSender(), address(0), msg.value);
    }

    /// amount out in 10**18
    function _withdraw(address to, address tokenOut, uint amountOut) internal virtual {
        IERC20 token = IERC20(tokenOut);
        require(tokenOut != address(0), 'FacetSafe: inapropriate method');
        _onlyAllowedOut(tokenOut);
        _onlySelfHasSufficientBalance(tokenOut, amountOut);
        safe().balances[tokenOut] -= amountOut;
        if (safe().balances[tokenOut] == 0) {
            safe().onHand.remove(tokenOut);
        }
        /// must be converted back into native to interact with non native contracts
        token.transfer(to, amountOut.native(IERC20Metadata(address(token)).decimals()));
        emit Withdraw(to, tokenOut, amountOut);
    }

    /// amount out always in 10**18 cause eth is natively 18 decimals
    function _withdraw(address to, uint amountOut) internal virtual {
        _onlyAllowedOut(address(0));
        _onlySelfHasSufficientBalance(address(0), amountOut);
        safe().balances[address(0)] -= amountOut;
        if (safe().balances[address(0)] == 0) {
            safe().onHand.remove(address(0));
        }
        payable(to).transfer(amountOut);
        emit Withdraw(to, address(0), amountOut);
    }
}