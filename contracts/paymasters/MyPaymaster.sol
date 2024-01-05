// SPDX-License-Identifier: MIT

//REMOVE THIS LINE        return 1500000; //(tokenReserves*1000) / ethReserves; // Normalize to token's decimals if necessary
    
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IPaymaster, ExecutionResult, PAYMASTER_VALIDATION_SUCCESS_MAGIC} from "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IPaymaster.sol";
import {IPaymasterFlow} from "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IPaymasterFlow.sol";
import {TransactionHelper, Transaction} from "@matterlabs/zksync-contracts/l2/system-contracts/libraries/TransactionHelper.sol";

import "@matterlabs/zksync-contracts/l2/system-contracts/Constants.sol";


contract Ownable4 {
    address public owner;

    event TransferOwnership(address _from, address _to);

    constructor() {
        owner = msg.sender;
        emit TransferOwnership(address(0), msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    function setOwner(address _owner) public onlyOwner {
        emit TransferOwnership(owner, _owner);
        owner = _owner;
    }
}

interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1);
}

interface zkBitcoin2 {
    function getMiningReward() external view returns (uint);
    function getMiningTarget() external view returns (uint);
    function getChallengeNumber() external view returns (bytes32);
    function getMultiMintChallengeNumber() external view returns (bytes32);
    function blocksToReadjust() external view returns (uint);
    function _BLOCKS_PER_READJUSTMENT() external view returns(uint);
    function reAdjustsToWhatDifficulty_MaxPain_Target() external view returns (uint);
    function multiMint_PayMaster(uint Mints,bytes32[] memory digests) external;

    function usedCombinations(bytes32) external view returns (bool);
}
contract MyPaymaster is IPaymaster, Ownable4 {
bytes4 public functionselector2;
//10% extra under 250 tokens
uint public minimumMintLevelForFee=5;
uint public minimumLevelFee=10000;
uint public maxFee;
uint public arraytestsize;
	uint public mintReward  = 50 * 10 **18;
	uint256 constant PRICE_FOR_PAYING_FEES = 1;
	bytes public data5555;
	    
	uint public zkBTC_Contract_Owns=0;
	address public allowedToken;
	
	
mapping(uint256 => bool) seenNonces;
    modifier onlyBootloader() {
        require(
            msg.sender == BOOTLOADER_FORMAL_ADDRESS,
            "Only bootloader can call this method"
        );
        // Continue execution if called from the bootloader.
        _;
    }

    constructor(address _erc20) {
        allowedToken = _erc20;
    }
    
    
    
    function setRewardAmt ()public {
	    mintReward = zkBitcoin2(allowedToken).getMiningReward();
	    maxFee = (minimumMintLevelForFee*mintReward*1000)/minimumLevelFee;
    }
    
    
    function setMinimumMintLevelForFee (uint256 feeLevel)public onlyOwner {
	    minimumMintLevelForFee = feeLevel;
	    maxFee = (minimumMintLevelForFee*mintReward*1000)/minimumLevelFee;
    }
    
    function setMinimumLevelFee (uint256 fee)public onlyOwner {
	    minimumLevelFee = fee;
	    maxFee = (minimumMintLevelForFee*mintReward*1000)/minimumLevelFee;
    }
    
    function getMinimumMintLevelForFee  ()public returns (uint) {
	    return minimumMintLevelForFee;
    }
    
    function getMinimumLevelFee ()public returns (uint) {
	    return minimumLevelFee;
    }
    
	address public pairAddress = 0xff89102328Da98c50F8D60998EEb2d7fD470Bc92;
   // address public constant token = 0x1df65D169234fa1D4F3407b822b5e08fE944cF49; // zkBTC address
address public constant WETH = 0x20b28B1e4665FFf290650586ad76E977EAb90c5D; // Wrapped ETH address

    // Returns the price of `token` in terms of ETH
    
    
    function  getPriceX1000() public view returns (uint) {

        IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
        (uint reserves0, uint reserves1) = pair.getReserves();

        // Ensure that reserves are returned in the correct order (token, WETH)
        (uint tokenReserves, uint ethReserves) = allowedToken < WETH ? (reserves0, reserves1) : (reserves1, reserves0);

        return 1500000; //(tokenReserves*1000) / ethReserves; // Normalize to token's decimals if necessary
    }
    
    
    
    
    
    
    

    function validateAndPayForPaymasterTransaction(
        bytes32,
        bytes32,
        Transaction calldata _transaction
    )
        external
        payable
        onlyBootloader
        returns (bytes4 magic, bytes memory context)
    {

        magic = PAYMASTER_VALIDATION_SUCCESS_MAGIC;
        require(
            _transaction.paymasterInput.length >= 4,
            "The standard paymaster input must be at least 4 bytes long"
        );

        bytes4 paymasterInputSelector = bytes4(
            _transaction.paymasterInput[0:4]
        );
        if (paymasterInputSelector == IPaymasterFlow.approvalBased.selector) {
           // the data is not needed for this paymaster
            
            
            require(address(uint160(_transaction.to)) ==allowedToken,
                "CANT MINT ANYTHING ELSE"
            );
            		bytes4 functionSelector=  bytes4(_transaction.data[:4]);
            		//delet line below
            		functionselector2 = functionSelector;
            		require(functionSelector == functionselector2,"EVENTUALLY ONLY THE PAYMASTER FUNCTION PLEASE");
        		address mintToAddress;
        		uint256[] memory nonce;
       		 bytes32[] memory challengeNumber2;

        		// Decode the input data
        		(mintToAddress, nonce, challengeNumber2) = abi.decode( _transaction.data[4:], (address, uint256[], bytes32[]));

			uint256 requiredETH = _transaction.gasLimit * _transaction.maxFeePerGas;

			uint price = getPriceX1000();
			
			 uint totalZKBTC = (requiredETH * price)/1000;
           		bool leftOver = true;
			uint totalGoodLoops = 0;
			uint NextEpochCount = zkBitcoin2(allowedToken).blocksToReadjust();
			uint miningTarget = zkBitcoin2(allowedToken).getMiningTarget();
			bytes32 MultiMintChallengeNumber = zkBitcoin2(allowedToken).getMultiMintChallengeNumber();
			bytes32[] memory submittedDigests = new bytes32[](nonce.length);
			for (uint i = 0; i < nonce.length; i++) {
			    if (!seenNonces[nonce[i]]) {
				seenNonces[nonce[i]] = true;

				// Your logic here...

			    
					bytes32 digest =  keccak256(abi.encodePacked(challengeNumber2[0], address(uint160(_transaction.from)), nonce[0]));
					
					if(uint256(digest) < miningTarget && !zkBitcoin2(allowedToken).usedCombinations(digest) && challengeNumber2[0] == MultiMintChallengeNumber)
						submittedDigests[totalGoodLoops]=digest;		{
						totalGoodLoops=totalGoodLoops+1;
					}
					
					if(totalGoodLoops == NextEpochCount){
						if(!leftOver){
							break;
						}
						MultiMintChallengeNumber = zkBitcoin2(allowedToken).getChallengeNumber();
						NextEpochCount = totalGoodLoops + zkBitcoin2(allowedToken)._BLOCKS_PER_READJUSTMENT();
						
						miningTarget = zkBitcoin2(allowedToken).reAdjustsToWhatDifficulty_MaxPain_Target();
						leftOver = false;
					}
				}
				
			}
        			
        			
        		
			if(minimumMintLevelForFee>totalGoodLoops){
				totalZKBTC = totalZKBTC + (totalZKBTC*1000)/minimumLevelFee;
			}
		
        	
		
		require(totalGoodLoops*mintReward >= totalZKBTC,"MUST mint at least enough zkBTC to cover the transaction cost");
		zkBTC_Contract_Owns = zkBTC_Contract_Owns + totalZKBTC;

		zkBitcoin2(allowedToken).multiMint_PayMaster(totalGoodLoops, submittedDigests);


            // The bootloader never returns any data, so it can safely be ignored here.
            (bool success, ) = payable(BOOTLOADER_FORMAL_ADDRESS).call{
                value: requiredETH
            }("");
            require(
                success,
                "Failed to transfer tx fee to the bootloader. Paymaster balance might not be enough."
            );
        } else {
            revert("Unsupported paymaster flow");
        }
    }

    function postTransaction(
        bytes calldata _context,
        Transaction calldata _transaction,
        bytes32,
        bytes32,
        ExecutionResult _txResult,
        uint256 _maxRefundedGas
    ) external payable override onlyBootloader { 
    
    uint256 requiredETH_refund =  _maxRefundedGas;
    uint price = getPriceX1000();
		
    uint totalZKBTC_refund = (requiredETH_refund * price)/1000;
  // CHANGE TO THIS ON LIVE 
 zkBTC_Contract_Owns = zkBTC_Contract_Owns - totalZKBTC_refund;	
		if(IERC20(allowedToken).balanceOf(address(this))-zkBTC_Contract_Owns >0){
       IERC20(allowedToken).transfer(address(uint160(_transaction.from)), IERC20(allowedToken).balanceOf(address(this))-zkBTC_Contract_Owns);
	}
    }
    
    

	function returnETH() public onlyOwner{
		uint bal = address(this).balance;
		payable(msg.sender).call{value: bal}("");
	}

	function returnZKBTC() public onlyOwner{
		IERC20(allowedToken).transfer(msg.sender, IERC20(allowedToken).balanceOf(address(this)));
		zkBTC_Contract_Owns = 0;
	}

	function returnERC20(address t) public onlyOwner{
		IERC20(t).transfer(msg.sender, IERC20(t).balanceOf(address(this)));
	}

    receive() external payable {}
}

