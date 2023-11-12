// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import 'imports/openzeppelin/utils/Context.sol';
import 'ERC2335/facets/storage/storageAdmin.sol';
import 'ERC2335/facets/storage/storagePausable.sol';

contract facetPausable is Context, storagePausable, storageAdmin {
    event Paused(address indexed sender);
    event Unpaused(address indexed sender);

    function paused() public view virtual returns (bool) {
        return pausable().paused;
    }

    function pause() public virtual {
        require(!paused(), 'facetPausable: paused');
        require(_msgSender() == admin().admin, 'facetPausable: only admin');
        pausable().paused = true;
        emit Paused(_msgSender());
    }

    function unpause() public virtual {
        require(paused(), 'facetPausable: unpaused');
        require(_msgSender() == admin().admin, 'facetPausable: only admin');
        pausable().paused = false;
        emit Unpaused(_msgSender());
    }
}