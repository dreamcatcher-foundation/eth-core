// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'diamonds/facets/slots/SlotToken.sol';
import 'imports/openzeppelin/utils/Context.sol';
import 'imports/openzeppelin/token/ERC20/IERC20.sol';
import 'imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import 'imports/openzeppelin/utils/Arrays.sol';
import 'imports/openzeppelin/utils/Counters.sol';

interface IFacetToken is IERC20, IERC20Metadata {
    event Snapshot(uint id);
    event TokenNameChanged(string indexed oldName, string indexed newName);
    event TokenSymbolChanged(string indexed oldSymbol, string indexed newSymbol);

    function ____setName(string memory newName) external;
    function ____setSymbol(string memory newSymbol) external;
    function ____mint(uint amount) external;
    function ____burn(uint amount) external;

    ///

    function totalSupplyAt(uint snapshotId) external view returns (uint);
    function balanceOfAt(address account, uint snapshotId) external view returns (uint);
    function getCurrentSnapshotId() external view returns (uint);
    function snapshot() external returns (uint);
}

contract FacetToken is SlotToken, Context, IERC20, IERC20Metadata {
    using Arrays for uint[];
    using Counters for Counters.Counter;

    event Snapshot(uint id);
    event TokenNameChanged(string indexed oldName, string indexed newName);
    event TokenSymbolChanged(string indexed oldSymbol, string indexed newSymbol);

    function ____setName(string memory newName) external virtual {
        _onlySelf();
        string memory oldName = token().name;
        token().name = newName;
        emit TokenNameChanged(oldName, newName);
    }

    function ____setSymbol(string memory newSymbol) external virtual {
        _onlySelf();
        string memory oldSymbol = token().symbol;
        token().symbol = newSymbol;
        emit TokenSymbolChanged(oldSymbol, newSymbol);
    }

    function ____mint(uint amount) external virtual {
        _onlySelf();
        _mint(_msgSender(), amount);
    }

    function ____burn(uint amount) external virtual {
        _onlySelf();
        _burn(_msgSender(), amount);
    }

    ///

    function name() public view virtual override returns (string memory) {
        return token().name;
    }

    function symbol() public view virtual override returns (string memory) {
        return token().symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint) {
        return token().totalSupply;
    }

    function totalSupplyAt(uint snapshotId) public view virtual returns (uint) {
        (bool snapshotted, uint value) = _valueAt(snapshotId, token().snapshotsOfTotalSupply);
        return snapshotted ? value : totalSupply();
    }

    function balanceOf(address account) public view virtual override returns (uint) {
        return token().balances[account];
    }

    function balanceOfAt(address account, uint snapshotId) public view virtual returns (uint) {
        (bool snapshotted, uint value) = _valueAt(snapshotId, token().snapshotsOfBalance[account]);
        return snapshotted ? value : balanceOf(account);
    }

    function allowance(address owner_, address spender) public view virtual override returns (uint) {
        return token().allowances[owner_][spender];
    }

    function getCurrentSnapshotId() public view virtual returns (uint) {
        return token().currentSnapshotId.current();
    }

    function approve(address spender, uint amount) public virtual override returns (bool) {
        address owner_ = _msgSender();
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
        address owner_ = _msgSender();
        _approve(owner_, spender, allowance(owner_, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint subtractedValue) public virtual returns (bool) {
        address owner_ = _msgSender();
        uint currentAllowance = allowance(owner_, spender);
        require(currentAllowance >= subtractedValue, 'FacetToken: decreased allowance below zero');
        unchecked {
            _approve(owner_, spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    function snapshot() public virtual returns (uint) {
        token().currentSnapshotId.increment();
        uint currentId = getCurrentSnapshotId();
        emit Snapshot(currentId);
        return currentId;
    }

    function _onlySelf() internal view virtual {
        require(_msgSender() == address(this), 'only self');
    }

    function _transfer(address from, address to, uint amount) internal virtual {
        require(from != address(0), 'FacetToken: transfer from the zero address');
        require(to != address(0), 'FacetToken: transfer to the zero address');
        _beforeTokenTransfer(from, to, amount);
        uint fromBalance = token().balances[from];
        require(fromBalance >= amount, 'FacetToken: transfer amount exceeds balance');
        unchecked {
            token().balances[from] = fromBalance - amount;
            token().balances[to] += amount;
        }
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint amount) internal virtual {
        require(account != address(0), 'FacetToken: mint to the zero address');
        _beforeTokenTransfer(address(0), account, amount);
        token().totalSupply += amount;
        unchecked {
            token().balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint amount) internal virtual {
        require(account != address(0), 'FacetToken: burn from the zero address');
        _beforeTokenTransfer(account, address(0), amount);
        uint accountBalance = token().balances[account];
        require(accountBalance >= amount, 'FacetToken: burn amount exceeds balance');
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
            require(currentAllowance >= amount, 'FacetToken: insufficient allowance');
            unchecked {
                _approve(owner_, spender, currentAllowance - amount);
            }
        }
    }

    function _approve(address owner_, address spender, uint amount) internal virtual {
        require(owner_ != address(0), 'FacetToken: approve from the zero address');
        require(spender != address(0), 'FacetToken: approve to the zero address');
        token().allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal virtual {
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

    function _afterTokenTransfer(address from, address to, uint amount) internal virtual {}

    function _valueAt(uint snapshotId, Snapshots storage snapshots) private view returns (bool, uint) {
        require(snapshotId > 0, 'FacetToken: id is 0');
        require(snapshotId <= getCurrentSnapshotId(), 'FacetToken: nonexistent id');
        uint index = snapshots.ids.findUpperBound(snapshotId);
        if (index == snapshots.ids.length) {
            return (false, 0);
        } else {
            return (true, snapshots.values[index]);
        }
    }

    function _updateAccountSnapshot(address account) private {
        _updateSnapshot(token().snapshotsOfBalance[account], balanceOf(account));
    }

    function _updateTotalSupplySnapshot() private {
        _updateSnapshot(token().snapshotsOfTotalSupply, totalSupply());
    }

    function _updateSnapshot(Snapshots storage snapshots, uint currentValue) private {
        uint currentId = getCurrentSnapshotId();
        if (_lastSnapshotId(snapshots.ids) < currentId) {
            snapshots.ids.push(currentId);
            snapshots.values.push(currentValue);
        }
    }

    function _lastSnapshotId(uint[] storage ids) private view returns (uint) {
        if (ids.length == 0) {
            return 0;
        } else {
            return ids[ids.length - 1];
        }
    }
}
