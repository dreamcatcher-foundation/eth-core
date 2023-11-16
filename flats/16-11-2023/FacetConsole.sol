
/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetConsole.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;

interface IFacetConsole {
    function ____setOperator(address newOperator) external;
    function ____setTimelock(uint newTimelockSeconds) external;

    ///

    function operator() external view returns (address);
    function getCurrentRequestId() external view returns (uint);
    function getRequestTarget(uint requestId) external view returns (address);
    function getRequestArgs(uint requestId) external view returns (bytes memory);
    function getRequestStartTimestamp(uint requestId) external view returns (uint);
    function getRequestDuration(uint requestId) external view returns (uint);
    function requestHasBeenExecuted(uint requestId) external view returns (bool);
    function claim() external;
    function request(address to, bytes memory args) external returns (uint);
    function execute(uint requestId) external returns (bool, bytes memory);
}



/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetConsole.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.19;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}




/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetConsole.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;

contract SlotConsole {
    bytes32 internal constant _CONSOLE = keccak256('slot.console');

    struct StorageConsole {
        address operator;
        uint delaySeconds;
        Request[] requests;
    }

    struct Request {
        address to;
        bytes args;
        uint startTimestamp;
        uint duration;
        bool executed;
    }

    function console() internal pure virtual returns (StorageConsole storage s) {
        bytes32 location = _CONSOLE;
        assembly {
            s.slot := location
        }
    }
}

/** 
 *  SourceUnit: c:\Users\marco\OneDrive\Documents\GitHub\eth-core\diamonds\facets\FacetConsole.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.0;
////import 'diamonds/facets/slots/SlotConsole.sol';
////import 'imports/openzeppelin/utils/Context.sol';
////import 'diamonds/facets/interfaces/IFacetConsole.sol';

contract FacetConsole is SlotConsole, Context {
    event OperatorChanged(address indexed oldOperator, address indexed newOperator);
    event TimelockChanged(uint indexed oldTimelockSeconds, uint indexed newTimelockSeconds);
    event NewRequest(uint indexed requestId, address indexed to, bytes indexed args);
    event RequestPassed(uint indexed requestId);

    function ____setOperator(address newOperator) external virtual {
        _onlySelf();
        address oldOperator = console().operator;
        console().operator = newOperator;
        emit OperatorChanged(oldOperator, newOperator);
    }

    function ____setTimelock(uint newTimelockSeconds) external virtual {
        _onlySelf();
        uint oldTimelockSeconds = console().delaySeconds;
        console().delaySeconds = newTimelockSeconds;
        emit TimelockChanged(oldTimelockSeconds, newTimelockSeconds);
    }

    ///

    function operator() public view virtual returns (address) {
        return console().operator;
    }

    function getCurrentRequestId() public view virtual returns (uint) {
        return console().requests.length - 1;
    }

    function getRequestTarget(uint requestId) public view virtual returns (address) {
        return console().requests[requestId].to;
    }

    function getRequestArgs(uint requestId) public view virtual returns (bytes memory) {
        return console().requests[requestId].args;
    }

    function getRequestStartTimestamp(uint requestId) public view virtual returns (uint) {
        return console().requests[requestId].startTimestamp;
    }

    function getRequestDuration(uint requestId) public view virtual returns (uint) {
        return console().requests[requestId].duration;
    }

    function requestHasBeenExecuted(uint requestId) public view virtual returns (bool) {
        return console().requests[requestId].executed;
    }

    function claim() public virtual {
        require(console().operator == address(0), 'FacetConsole: already claimed');
        IFacetConsole(address(this)).____setOperator(_msgSender());
    }

    function request(address to, bytes memory args) public virtual returns (uint) {
        require(_msgSender() == console().operator, 'FacetConsole: only operator');
        SlotConsole.Request memory newRequest;
        newRequest.to = to;
        newRequest.args = args;
        newRequest.startTimestamp = block.timestamp;
        newRequest.duration = console().delaySeconds;
        newRequest.executed = false;
        console().requests.push(newRequest);
        uint requestId = console().requests.length - 1;
        emit NewRequest(requestId, to, args);
        return requestId;
    }

    function execute(uint requestId) public virtual returns (bool, bytes memory) {
        require(_msgSender() == console().operator, 'FacetConsole: only operator');
        SlotConsole.Request storage request_ = console().requests[requestId];
        uint requestEndTimestamp = request_.startTimestamp + request_.duration;
        require(block.timestamp >= requestEndTimestamp, 'FacetConsole: request is timelocked');
        require(!request_.executed, 'FacetConsole: request already executed');
        address target = request_.to;
        bytes memory args = request_.args;
        (bool success, bytes memory response) = target.call(args);
        request_.executed = true;
        emit RequestPassed(requestId);
        return (success, response);
    }

    function _onlySelf() internal view virtual {
        require(_msgSender() == address(this), 'only self');
    }
}
