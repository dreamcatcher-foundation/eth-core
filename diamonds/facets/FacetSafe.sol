// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/slots/SlotSafe.sol';
import 'imports/openzeppelin/utils/Context.sol';
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';

interface IFacetSafe {
    event Deposit(address indexed from, address indexed tokenIn, uint indexed amountIn);
    event Withdraw(address indexed to, address indexed tokenOut, uint indexed amountOut);
    event PermissionGrantedTokenIn(address indexed tokenIn);
    event PermissionRevokedTokenIn(address indexed tokenIn);
    event PermissionGrantedTokenOut(address indexed tokenOut);
    event PermissionRevokedTokenOut(address indexed tokenOut);

    function ____allowTokenInToSafe(address token) external;
    function ____forbidTokenInToSafe(address token) external;
    function ____allowTokenOutOutOfSafe(address token) external;
    function ____forbidTokenOutOfSafe(address token) external;
    function ____withdraw(address to, address tokenOut, uint amountOut) external;
    function ____withdraw(address to, uint amountOut) external;

    ///

    function getHoldingsInSafe(address token) external view returns (uint);
    function getTokensAllowedInToSafe() external view returns (address[] memory);
    function getTokenAllowedInToSafe(uint tokenId) external view returns (address);
    function getTokensAllowedOutFromSafe() external view returns (address[] memory);
    function getTokenAllowedOutFromSafe(uint tokenId) external view returns (address);
    function isAllowedIn(address token) external view returns (bool);
    function isAllowedOut(address token) external view returns (bool);
    function deposit(address tokenIn, uint amountIn) external;
    function deposit() external;
}

/// simple safe to move funds in and out of contract
contract FacetSafe is SlotSafe, Context {
    using EnumerableSet for EnumerableSet.AddressSet;

    event Deposit(address indexed from, address indexed tokenIn, uint indexed amountIn);
    event Withdraw(address indexed to, address indexed tokenOut, uint indexed amountOut);
    event PermissionGrantedTokenIn(address indexed tokenIn);
    event PermissionRevokedTokenIn(address indexed tokenIn);
    event PermissionGrantedTokenOut(address indexed tokenOut);
    event PermissionRevokedTokenOut(address indexed tokenOut);

    function ____allowTokenInToSafe(address token) external {
        _onlySelf();
        safe().allowedIn.add(token);
        emit PermissionGrantedTokenIn(token);
    }

    function ____forbidTokenInToSafe(address token) external {
        _onlySelf();
        safe().allowedIn.remove(token);
        emit PermissionRevokedTokenIn(token);
    }

    function ____allowTokenOutOfSafe(address token) external {
        _onlySelf();
        safe().allowedOut.add(token);
        emit PermissionGrantedTokenOut(token);
    }

    function ____forbidTokenOutOfSafe(address token) external {
        _onlySelf();
        safe().allowedOut.remove(token);
        emit PermissionRevokedTokenOut(token);
    }

    function ____withdraw(address to, address tokenOut, uint amountOut) external {
        IERC20Metadata token = IERC20Metadata(tokenOut);
        _onlySelf();
        require(tokenOut != address(0), 'FacetSafe: improper method');
        require(isAllowedOut(tokenOut), 'FacetSafe: token is not allowed out');
        require(safe().balances[tokenOut] >= amountOut, 'FacetSafe: insufficient balance');
        safe().balances[tokenOut] -= amountOut;
        if (safe().balances[tokenOut] == 0) {
            safe().onHand.remove(tokenOut);
        }
        token.transfer(to, amountOut);
        emit Withdraw(to, tokenOut, amountOut);
    }

    function ____withdraw(address to, uint amountOut) external {
        _onlySelf();
        require(isAllowedOut(address(0)), 'FacetSafe: eth is not allowed out');
        require(safe().balances[address(0)] >= amountOut, 'FacetSafe: insufficient balance');
        safe().balances[address(0)] -= amountOut;
        if (safe().balances[address(0)] == 0) {
            safe().onHand.remove(address(0));
        }
        payable(to).transfer(amountOut);
        emit Withdraw(to, address(0), amountOut);
    }

    ///

    modifier nonReentrant() {
        require(!safe().locked, 'FacetSafe: reentrant call');
        safe().locked = true;
        _;
        safe().locked = false;
    }

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

    /// for erc20
    function deposit(address tokenIn, uint amountIn) nonReentrant() public virtual {
        _deposit(tokenIn, amountIn);
    }

    /// for eth
    function deposit() nonReentrant() public payable virtual {
        _deposit();
    }

    function _onlySelf() internal view virtual {
        require(_msgSender() == address(this), 'FacetSafe: only self');
    }

    /// for erc20
    function _deposit(address tokenIn, uint amountIn) private {
        IERC20Metadata token = IERC20Metadata(tokenIn);
        require(isAllowedIn(tokenIn), 'FacetSafe: token is not allowed in');
        require(token.balanceOf(_msgSender()) >= amountIn, 'FacetSafe: insufficient balance');
        token.transferFrom(_msgSender(), address(this), amountIn);
        safe().balances[tokenIn] += amountIn;
        safe().onHand.add(tokenIn);
        emit Deposit(_msgSender(), tokenIn, amountIn);
    }

    /// for eth
    function _deposit() private virtual {
        require(isAllowedIn(address(0)), 'FacetSafe: eth is not allowed in');
        require(msg.value >= 1, 'FacetSafe: insufficient amount in');
        safe().balances[address(0)] += msg.value;
        safe().onHand.add(address(0));
        emit Deposit(_msgSender(), address(0), msg.value);
    }
}