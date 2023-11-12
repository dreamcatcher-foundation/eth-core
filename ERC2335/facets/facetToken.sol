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

    function balanceOf(address account) public view virtual override returns (uint) {
        return token().balances[account];
    }

    function allowance(address owner_, address spender) public view virtual override returns (uint) {
        return token().allowances[owner_][spender];
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

    function addToWhitelist(address account) public virtual {
        if (token().enabledWhitelist) {
            require(_msgSender() == admin().admin, 'facetToken: only admin');
            token().whitelist.add(account);
        } else {
            revert('facetToken: whitelist disabled');
        }
    }

    function removeFromWhitelist(address account) public virtual {
        if (token().enabledWhitelist) {
            require(_msgSender() == admin().admin, 'facetToken: only admin');
            token().whitelist.remove(account);
        } else {
            revert('facetToken: whitelist disabled');
        }
    }

    function addToBlacklist(address account) public virtual {
        if (token().enabledBlacklist) {
            require(_msgSender() == admin().admin, 'facetToken: only admin');
            token().blacklist.add(account);
        } else {
            revert('facetToken: blacklist disabled');
        }
    }

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

    function approve(address spender, uint amount) public virtual override returns (bool) {
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

    function transfer(address to, uint amount) public virtual override returns (bool) {
        if (token().enabledAdminMarketMaker) {
            revert('facetToken: admin market making enabled');
        }
        address owner_ = _msgSender();
        _transfer(owner_, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint amount) public virtual override returns (bool) {
        if (token().enabledAdminMarketMaker) {
            revert('facetToken: admin market making enabled');
        }
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint addedValue) public virtual returns (bool) {
        if (token().enabledAdminMarketMaker) {
            revert('facetToken: admin market making enabled');
        }
        address owner = _msgSender();
        _approve(owner_, spender, allowance(owner_, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint subtractedValue) public virtual returns (bool) {
        address owner_ = _msgSender();
        uint currentAllowance = allowance(owner_, spender);
        require(currentAllowance >= subtractedValue, 'facetToken: decreased allowance below zero');
        unchecked {
            _approve(owner_, spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    function _transfer(address from, address to, uint amount) internal virtual {
        require(!pausable().paused, 'facetToken: paused');
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
        require(!pausable().paused, 'facetToken: paused');
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
        require(!pausable().paused, 'facetToken: paused');
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
        require(!pausable().paused, 'facetToken: paused');
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
        emit Approval(owner_, spender, value);
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
    }

    function _afterTokenTransfer(address from, address to, uint amount) internal virtual {

    }
}