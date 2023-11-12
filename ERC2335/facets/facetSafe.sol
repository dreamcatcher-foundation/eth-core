// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import 'imports/openzeppelin/utils/Context.sol';
import 'ERC2335/facets/storage/storageSafe.sol';
import 'ERC2335/facets/storage/storageAdmin.sol';
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';

/**
* NOTE In non reentrant logic the contract cannot call itself directly
*      or indirectly. If this is required, create a private function 
*      and call it within an external function as show below.
*
* NOTE address(0) is eth.
 */
contract facetSafe is Context, storageSafe, storageAdmin {
    using EnumerableSet for EnumerableSet.AddressSet;

    event Deposited(address indexed from, address indexed tokenIn, uint indexed amountIn);
    event Withdrawn(address indexed to, address indexed tokenOut, uint indexed amountOut);
    event TokenInPermissionGranted(address indexed token);
    event TokenInPermissionRevoked(address indexed token);
    event TokenOutPermissionGranted(address indexed token);
    event TokenOutPermissionRevoked(address indexed token);
    
    modifier nonReentrant() {
        require(!safe().locked, 'facetSafe: reentrant call');
        safe().locked = true;
        _;
        safe().locked = false;
    }

    function getHoldingsInSafe(address token) public view virtual returns (uint) {
        return safe().amounts[token];
    }

    function getTokensAllowedInToSafe() public view virtual returns (address[] memory) {
        return safe().allowedIn.values();
    }

    function getTokensAllowedOutOfSafe() public view virtual returns (address[] memory) {
        return safe().allowedOut.values();
    }

    function getTokensOnHandInSafe() public view virtual returns (address[] memory) {
        return safe().onHand.values();
    }

    function allowTokenIntoSafe(address token) public virtual {
        require(_msgSender() == admin().admin, 'facetSafe: only admin');
        safe().allowedIn.add(token);
        emit TokenInPermissionGranted(token);
    }

    function forbidTokenIntoSafe(address token) public virtual {
        require(_msgSender() == admin().admin, 'facetSafe: only admin');
        safe().allowedIn.remove(token);
        emit TokenInPermissionRevoked(token);
    }

    function allowTokenOutOfSafe(address token) public virtual {
        require(_msgSender() == admin().admin, 'facetSafe: only admin');
        safe().allowedOut.add(token);
        emit TokenOutPermissionGranted(token);
    }

    function forbidTokenOutOfSafe(address token) public virtual {
        require(_msgSender() == admin().admin, 'facetSafe: only admin');
        safe().allowedOut.remove(token);
        emit TokenOutPermissionRevoked(token);
    }

    function deposit(address tokenIn, uint amountIn) nonReentrant() external virtual {
        _deposit(tokenIn, amountIn);
    }

    function deposit() nonReentrant() external virtual {
        _deposit();
    }

    function withdraw(address to, address tokenOut, uint amountOut) nonReentrant() external virtual {
        _withdraw(to, tokenOut, amountOut);
    }

    function withdraw(address to, uint amountOut) nonReentrant() external virtual {
        _withdraw(to, amountOut);
    }

    function _deposit(address tokenIn, uint amountIn) private virtual {
        require(safe().allowedIn.contains(tokenIn), 'facetSafe: token is not allowed in');
        IERC20Metadata token = IERC20Metadata(tokenIn);
        require(token.balanceOf(_msgSender()) >= amountIn, 'facetSafe: insufficient balance');
        safe().amounts[tokenIn] += amountIn;
        safe().onHand.add(tokenIn);
        token.transferFrom(_msgSender(), address(this), amountIn);
        emit Deposited(_msgSender(), tokenIn, amountIn);
    }

    function _deposit() private payable virtual {
        require(safe().allowedIn.contains(address(0)), 'facetSafe: eth is not allowed in');
        require(msg.value >= 1, 'facetSafe: insufficient amount in');
        safe().amounts[address(0)] += msg.value;
        safe().onHand.add(address(0));
        emit Deposited(_msgSender(), address(0), msg.value);
    }

    function _withdraw(address to, address tokenOut, uint amountOut) private virtual {
        require(_msgSender() == admin().admin, 'facetSafe: only admin');
        require(safe().allowedOut.contains(tokenOut), 'facetSafe: token is not allowed out');
        IERC20Metadata token = IERC20Metadata(tokenOut);
        require(token.balanceOf(address(this)) >= safe().amounts[tokenOut], 'facetSafe: insufficient balance');
        safe().amounts[tokenOut] -= amountOut;
        if (safe().amounts[tokenOut] == 0) {
            safe().onHand.remove(tokenOut);
        }
        token.transfer(to, amountOut);
        emit Withdrawn(to, tokenOut, amountOut);
    }

    function _withdraw(address to, uint amountOut) private virtual {
        require(_msgSender() == admin().admin, 'facetSafe: only admin');
        require(safe().allowedOut.contains(address(0)), 'facetSafe: eth is not allowed out');
        require(amountOut >= 1, 'facetSafe: insufficient amount out');
        require(safe().amounts[address(0)] >= amountOut, 'facetSafe: insufficient balance');
        safe().amounts[address(0)] -= msg.value;
        if (safe().amounts[address(0)] == 0) {
            safe().onHand.remove(address(0));
        }
        payable(to).transfer(amountOut);
        emit Withdrawn(to, address(0), amountOut);
    }
}