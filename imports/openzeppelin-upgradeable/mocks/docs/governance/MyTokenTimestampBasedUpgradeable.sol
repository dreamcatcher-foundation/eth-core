// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../token/ERC20/ERC20Upgradeable.sol";
import "../../../token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "../../../token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "../../../proxy/utils/Initializable.sol";

contract MyTokenTimestampBasedUpgradeable is Initializable, ERC20Upgradeable, ERC20PermitUpgradeable, ERC20VotesUpgradeable {
    function __MyTokenTimestampBased_init() internal onlyInitializing {
        __ERC20_init_unchained("MyTokenTimestampBased", "MTK");
        __EIP712_init_unchained("MyTokenTimestampBased", "1");
        __ERC20Permit_init_unchained("MyTokenTimestampBased");
    }

    function __MyTokenTimestampBased_init_unchained() internal onlyInitializing {}

    // Overrides IERC6372 functions to make the token & governor timestamp-based

    function clock() public view override returns (uint48) {
        return uint48(block.timestamp);
    }

    // solhint-disable-next-line func-name-mixedcase
    function CLOCK_MODE() public pure override returns (string memory) {
        return "mode=timestamp";
    }

    // The functions below are overrides required by Solidity.

    function _update(address from, address to, uint256 amount) internal override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        super._update(from, to, amount);
    }

    function nonces(address owner) public view virtual override(ERC20PermitUpgradeable, NoncesUpgradeable) returns (uint256) {
        return super.nonces(owner);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}
