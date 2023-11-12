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

    /// TODO

    function approve(address spender, uint amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner_, spender, amount);
        return true;
    }

    function transfer(address to, uint amount) public virtual override returns (bool) {
        address owner_ = _msgSender();
        _transfer(owner_, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint addedValue) public virtual returns (bool) {
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
        if (token().enabledSoulBound) {
            revert('facetToken: is soul bound');
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
        require(owner_ != address(0), 'facetToken: approve from the zero address');
        require(spender != address(0), 'facetToken: approve to the zero address');
        token().allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, value);
    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal virtual {

    }

    function _afterTokenTransfer(address from, address to, uint amount) internal virtual {

    }
}