
// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

import "./draft-ERC20Permit.sol";



contract aLPMock is ERC20Permit {
	constructor() public ERC20("Test LP zkBTC/0xBTC", "mLP") ERC20Permit("Test LP zkBTC/0xBTC") {
        
    }
    function withdrawToken(uint256 _amount) external {
        // transfer the token from address of this contract
        // to address of the user (executing the withdrawToken() function)
                _mint(msg.sender, _amount);
    }
}

