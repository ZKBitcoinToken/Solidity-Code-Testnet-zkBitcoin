pragma solidity ^0.8.0;

contract ContractAdelegate {
    address public contractBAddress = address(0xD79c279F8d10AF90e0a3aCea9003f8f28dF68509);

    // Set the address of ContractB
    function setContractB() public {
        contractBAddress = address(0xD79c279F8d10AF90e0a3aCea9003f8f28dF68509);
    }

    // Function to delegate call to multiMint_SameAddress in ContractB
    function multiMint_SameAddress(address mintToAddress, uint256[] memory nonce) public {
        bytes memory data = abi.encodeWithSignature("multiMint_SameAddress(address,uint256[])", mintToAddress, nonce);
        contractBAddress.delegatecall(data);
    }
}
