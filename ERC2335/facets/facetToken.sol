// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import 'imports/openzeppelin/utils/structs/EnumerableSet.sol';
import 'imports/openzeppelin/utils/Context.sol';
import 'ERC2335/facets/storage/storageAdmin.sol';
import 'ERC2335/facets/storage/storagePausable.sol';
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import 'ERC2335/facets/storage/storageToken.sol';

contract facetToken is Context, storageToken, storageAdmin, storagePausable, IERC20Metadata {
    using EnumerableSet for EnumerableSet.AddressSet;

    event Snapshot(uint id);

    function name() public view virtual override returns (string memory) {
        return token().name;
    }

    function symbol() public view virtual override returns (string memory) {
        return token().symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return token().decimals;
    }

    function totalSupply() public view virtual override returns (uint) {
        return token().totalSupply;
    }

    function totalSupplyAt(uint snapshotId) public view virtual returns (uint) {
        (bool snapshotted, uint value) = _valueAt(snapshotId, token().totalSupplySnapshots);
        return snapshotted ? value : totalSupply();
    }

    function balanceOf(address account) public view virtual override returns (uint) {
        return token().balances[account];
    }

    function balanceOfAt(address account, uint snapshotId) public view virtual returns (uint) {
        (bool snapshotted, uint value) = _valueAt(snapshotId, token().accountBalanceSnapshots[account]);
        return snapshotted ? value : balanceOf(account);
    }

    function allowance(address owner_, address spender) public view virtual override returns (uint) {
        return token().allowances[owner_][spender];
    }

    function getCurrentSnapshotId() public view virtual returns (uint) {
        return token().currentSnapshotId.current();
    }

    /// To be set just after deployment.
    function setName(string memory newName) public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        string memory emptyString;
        require(token().name == emptyString, 'facetToken: cannot set name again');
        token().name = newName;
    }

    /// To be set just after deployment.
    function setSymbol(string memory newSymbol) public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        string memory emptyString;
        require(token().symbol == emptyString, 'facetToken: cannot set symbol again');
        token().symbol = newSymbol;
    }

    /// To be set just after deployment.
    function setDecimals(uint8 newDecimals) public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        require(token().decimals == 0, 'facetToken: cannot set decimals again');
        token().decimals = newDecimals;
    }

    /// To be set just after deployment.
    function setCap(uint newCap) public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        require(token().maxSupply == 0, 'facetToken: cannot set cap again');
        token().maxSupply = newCap;
    }

    function setTransferFee(uint newFee) public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        /// Can be set from 0 to 1%. Will shout at you if its above 1%!
        require(newFee <= 100, 'facetToken: fee is too high!');
        token().feeTransfer = newFee;
    }

    function setTransferFeeDestination(address account) public virtual {
        /// Set as zero to burn.
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().feeTransferTo = account;
    }

    /// If the whitelist is enabled then only whitelisted
    /// accounts will be able to receive and send the tokens.
    function addToWhitelist(address account) public virtual {
        if (token().enabledWhitelist) {
            require(_msgSender() == admin().admin, 'facetToken: only admin');
            token().whitelist.add(account);
        } else {
            revert('facetToken: whitelist disabled');
        }
    }

    /// If the whitelist is enabled then only whitelisted
    /// accounts will be able to receive and send the tokens.
    function removeFromWhitelist(address account) public virtual {
        if (token().enabledWhitelist) {
            require(_msgSender() == admin().admin, 'facetToken: only admin');
            token().whitelist.remove(account);
        } else {
            revert('facetToken: whitelist disabled');
        }
    }

    /// If the blacklist is enabled then blacklisted accounts
    /// will not be allowed to receive or sent the tokens.
    /// This can stack with the whitelist, an account that is
    /// whitelisted and blacklisted will not be able to
    /// receive or send the tokens.
    function addToBlacklist(address account) public virtual {
        if (token().enabledBlacklist) {
            require(_msgSender() == admin().admin, 'facetToken: only admin');
            token().blacklist.add(account);
        } else {
            revert('facetToken: blacklist disabled');
        }
    }

    /// If the blacklist is enabled then blacklisted accounts
    /// will not be allowed to receive or sent the tokens.
    /// This can stack with the whitelist, an account that is
    /// whitelisted and blacklisted will not be able to
    /// receive or send the tokens.
    function removeFromBlacklist(address account) public virtual {
        if (token().enabledBlacklist) {
            require(_msgSender() == admin().admin, 'facetToken: only admin');
            token().blacklist.remove(account);
        } else {
            revert('facetToken: blacklist disabled');
        }
    }

    function setWrappableToken(address newToken) public virtual {
        if (token().enabledTokenWrapper) {
            token().wrappableTokenIn = newToken;
        } else {
            revert('facetToken: token wrapper disabled');
        }
    }

    /// OPTIONAL To be set just after deployment.
    function enableCapped() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledCapped = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enableSoulBound() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledSoulBound = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enableWhitelist() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        addToWhitelist(address(0));
        token().enabledWhitelist = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enableBlacklist() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledBlacklist = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enableTransferFee() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledTransferFee = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enableSnapshot() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledSnapshot = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enableBurnable() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledBurnable = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enableAdminMarketMaker() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledAdminMarketMaker = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enablePausable() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledPausable = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enableTokenWrapper() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledTokenWrapper = true;
    }

    /// OPTIONAL To be set just after deployment.
    function enableForges() public virtual {
        require(_msgSender() == admin().admin, 'facetToken: only admin');
        token().enabledForges = true;
    }

    /// If settings enabled specific addresses will be able to
    /// mint the token. The reasons for this is if there may be
    /// external logic or an external staking contract.
    function mint(address to, uint amount) public virtual {
        require(!pausable().paused, 'facetToken: paused');
        /// The settings must be enabled and the caller must be
        /// from a forge account.
        if (token().enabledForges) {
            if (token().minters.contains(_msgSender())) {
                _mint(to, amount);
            }
        }
    }

    /// If settings enabled allow burning.
    function burn(uint amount) public virtual {
        require(!pausable().paused, 'facetToken: paused');
        /// Must have enabled token burnable settings and
        /// cannot be a wrapper. The unwrapping function will
        /// contain the burn function which returns the wrapped
        /// tokens.
        if (token().enabledBurnable) {
            if (!token().enabledTokenWrapper) {
                _burn(_msgSender(), amount);
            } else {
                revert('facetToken: wrapper is enabled');
            }
        } else {
            revert('facetToken: burn is disabled');
        }
    }

    /// Anyone can create a unique snapshot of the token.
    function snapshot() public virtual returns (uint) {
        require(!pausable().paused, 'facetToken: paused');
        return _snapshot();
    }

    function approve(address spender, uint amount) public virtual override returns (bool) {
        require(!pausable().paused, 'facetToken: paused');
        address owner = _msgSender();
        _approve(owner_, spender, amount);
        return true;
    }

    /// If settings enabled allows admin to make transfers directly on
    /// behalf of an account.
    function makeTransferOnBehalfOf(address from, address to, uint amount) public virtual {
        if (token().enabledAdminMarketMaker) {
            require(_msgSender() == admin().admin, 'facetToken: only admin');   
            _transfer(from, to, amount);
        } else {
            revert('facetToken: admin market making disabled');
        }
    }

    function wrapToken(uint amount) public virtual {
        require(!pausable().paused, 'facetToken: paused');
        if (token().enabledTokenWrapper) {
            IERC20Metadata tokenIn = IERC20Metadata(token().wrappableTokenIn);
            tokenIn.transferFrom(_msgSender(), address(this), amount);
            uint amountOut = amount * token().wrapperRate;
            _mint(_msgSender(), amountOut);
        } else {
            revert('facetToken: wrapper is disabled');
        }
    }

    function unwrapToken(uint amount) public virtual {
        require(!pausable().paused, 'facetToken: paused');
        if (token().enabledTokenWrapper) {
            _burn(_msgSender(), amount);
            IERC20Metadata tokenOut = IERC20Metadata(token().wrappableTokenIn);
            tokenOut.transfer(_msgSender(), amount / token().wrapperRate);
        } else {
            revert('facetToken: wrapper is disabled');
        }
    }

    function transfer(address to, uint amount) public virtual override returns (bool) {
        require(!pausable().paused, 'facetToken: paused');
        if (!token().enabledAdminMarketMaker) {
            if (!token().enabledSoulBound) {
                address owner_ = _msgSender();
                _transfer(owner_, to, amount);
                return true;
            } else {
                revert('facetToken: transfer disabled');
            }
        } else {
            /// The admin is the only account that can transfer on
            /// behalf of the users.
            revert('facetToken: admin market making enabled');
        }
    }

    function transferFrom(address from, address to, uint amount) public virtual override returns (bool) {
        require(!pausable().paused, 'facetToken: paused');
        if (!token().enabledAdminMarketMaker) {
            if (!token().enabledSoulBound) {
                address spender = _msgSender();
                _spendAllowance(from, spender, amount);
                _transfer(from, to, amount);
                return true;
            } else {
                revert('facetToken: transfer disabled');
            }
        } else {
            /// The admin is the only account that can transfer on
            /// behalf of the users.
            revert('facetToken: admin market making enabled');
        }
    }

    function increaseAllowance(address spender, uint addedValue) public virtual returns (bool) {
        require(!pausable().paused, 'facetToken: paused');
        if (!token().enabledAdminMarketMaker) {
            address owner = _msgSender();
            _approve(owner_, spender, allowance(owner_, spender) + addedValue);
            return true;
        } else {
            /// The admin is the only account that can transfer on
            /// behalf of the users.
            revert('facetToken: admin market making enabled');
        }
    }

    /// Decrease allowance is available always.
    function decreaseAllowance(address spender, uint subtractedValue) public virtual returns (bool) {
        require(!pausable().paused, 'facetToken: paused');
        address owner_ = _msgSender();
        uint currentAllowance = allowance(owner_, spender);
        require(currentAllowance >= subtractedValue, 'facetToken: decreased allowance below zero');
        unchecked {
            _approve(owner_, spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    function _snapshot() internal virtual returns (uint) {
        if (token().enabledSnapshot) {
            token().currentSnapshotId.increment();
            uint currentId = getCurrentSnapshotId();
            emit Snapshot(currentId);
            return currentId;
        } else {
            revert('facetToken: snapshot disabled');
        }
    }

    function _transfer(address from, address to, uint amount) internal virtual {
        if (token().enabledSoulBound) {
            revert('facetToken: is soul bound');
        }
        if (token().enabledTransferFee) {
            /// Sends transfer fee to destination address and sends the
            /// remaining amount to the given 'to' address.
            uint amountFee = (amount * token().feeTransfer) / 10000;
            if (token().feeTransferTo == address(0)) {
                _burn(from, amountFee);
            } else {
                _transfer(from, token().feeTransferTo, amountFee);
            }
            uint amount  = amount - amountFee;
        }
        require(from != address(0), 'facetToken: transfer from the zero address');
        require(to != address(0), 'facetToken: transfer to the zero address');
        _beforeTokenTransfer(from, to, amount);
        uint fromBalance = token().balances[from];
        require(fromBalance >= amount, 'facetToken: transfer amount exceeds balance');
        unchecked {
            token().balances[from] = fromBalance - amount;
            token().balances[to] += amount;
        }
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint amount) internal virtual {
        if (token().enabledCapped) { /// If cap is enabled enforce.
            require(totalSupply() + amount <= token().maxSupply, 'facetToken: is at cap');
        }
        require(account != address(0), 'facetToken: mint to the zero address');
        _beforeTokenTransfer(address(0), account, amount);
        token().totalSupply += amount;
        unchecked {
            token().balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint amount) internal virtual {
        require(account != address(0), 'facetToken: burn from the zero address');
        _beforeTokenTransfer(account, address(0), amount);
        uint accountBalance = token().balances[account];
        require(accountBalance >= amount, 'facetToken: burn amount exceeds balance');
        unchecked {
            token().balances[account] = accountBalance - amount;
            token().totalSupply -= amount;
        }
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }

    function _spendAllowance(address owner_, address spender, uint amount) internal virtual {
        uint currentAllowance = allowance(owner_, spender);
        if (currentAllowance != type(uint).max) {
            require(currentAllowance >= amount, 'facetToken: insufficient allowance');
            unchecked {
                _approve(owner_, spender, currentAllowance - amount);
            }
        }
    }

    function _approve(address owner_, address spender, uint amount) internal virtual {
        require(!pausable().paused, 'facetToken: paused');
        require(owner_ != address(0), 'facetToken: approve from the zero address');
        require(spender != address(0), 'facetToken: approve to the zero address');
        token().allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal virtual {
        if (token().enabledWhitelist) { /// Allow certain accounts to transfer and receieve the token,
            require(token().whitelist.contains(from), 'facetToken: from is not whitelisted');
            require(token().whitelist.contains(to), 'facetToken: to is not whitelisted');
        }
        if (token().enabledBlacklist) { /// Forbid certain accounts to transfer and receive the token.
            require(!token().blacklist.contains(from), 'facetToken: from is blacklisted');
            require(!token().blacklist.contains(to), 'facetToken: to is blacklisted');
        }
        /// Tracks holders of the token onchain.
        if (balanceOf(from) >= 1) {
            token().holders.add(from);
        } else {
            token().holders.remove(from);
        }
        if (balanceOf(to) >= 1) {
            token().holders.add(to);
        } else {
            token().holders.remove(to);
        }
        if (token().enabledSnapshot) {
            if (from == address(0)) {
                _updateAccountSnapshot(to);
                _updateTotalSupplySnapshot();
            } else if (to == address(0)) {
                _updateAccountSnapshot(from);
                _updateTotalSupplySnapshot();
            } else {
                _updateAccountSnapshot(from);
                _updateAccountSnapshot(to);
            }
        }
    }

    function _afterTokenTransfer(address from, address to, uint amount) internal virtual {}

    function _valueAt(uint snapshotId, Snapshots storage snapshots) private view returns (bool, uint) {
        require(snapshotId > 0, 'facetToken: id is 0');
        require(snapshotId <= getCurrentSnapshotId(), 'facetToken: nonexistent id');
        // When a valid snapshot is queried, there are three possibilities:
        //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
        //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
        //  to this id is the current one.
        //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
        //  requested id, and its value is the one to return.
        //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
        //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
        //  larger than the requested one.
        //
        // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
        // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
        // exactly this.
        uint index = snapshots.ids.findUpperBound(snapshotId);
        if (index == snapshots.ids.length) {
            return (false, 0);
        } else {
            return (true, snapshots.values[index]);
        }
    }

    function _lastSnapshotId(uint[] storage ids) private view returns (uint) {
        if (ids.length == 0) {
            return 0;
        } else {
            return ids[ids.length - 1];
        }
    }

    function _updateAccountSnapshot(address account) private {
        _updateSnapshot(token().accountBalanceSnapshots[account], balanceOf(account));
    }

    function _updateTotalSupplySnapshot() private {
        _updateSnapshot(token().totalSupplySnapshots, totalSupply());
    }

    function _updateSnapshot(Snapshots storage snapshots, uint currentValue) private {
        uint currentId = getCurrentSnapshotId();
        if (_lastSnapshotId(snapshots.ids) < currentId) {
            snapshots.ids.push(currentId);
            snapshots.values.push(currentValue);
        }
    }
}