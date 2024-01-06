//TESTNET Goerli ZKSYNC ERA VERSION https://testnet.zkBitcoin.org/ Just click around and find stuff for now
//DELETE THESE LINES

// Zero Knowledge Bitcoin - zkBitcoin (zkBTC) Token - Token and Mining Contract
//
//MUST FIX BEFORE LAUNCH Fix Start Time to normal
// startTime = 1704906000;
//
/* must remove adjustDiff
//for testnet only
	function AdjustDiff(uint diff) public onlyOwner{
		require(diff<100000,"Low only");
		miningTarget=_MAXIMUM_TARGET.div(diff);
	}



*///
// Zero Knowledge Bitcoin - zkBitcoin (zkBTC) Token - Token and Mining and Paymaster Contract
//
// Website: https://zkBitcoin.org
// Staking zkBitcoin / Ethereum LP dAPP: https://zkBitcoin.org/dapp/stakingETH/
// Staking zkBitcoin / 0xBitcoin LP dAPP: https://zkBitcoin.org/dapp/staking0xBTC/
// Auctions dAPP: https://zkBitcoin.org/dapp/auctions/
// Github: https://github.com/zkBitcoinToken/
// Discord: https://discord.gg/hZ8yzcCRFJ
//
//
// Distrubtion of Zero Knowledge Bitcoin Token - zkBitcoin (zkBTC) Token is as follows:
//
// 40% of zkBTC Token is distributed as Liquidiy Pools as rewards in the zkBitcoinStakingETH and zkBitcoinStaking0xBTC Contract which distributes tokens to users who deposit the Liquidity Pool.
// +
// 40% of zkBTC Token is distributed using zkBitcoin Contract(this Contract) which distributes tokens to users by using Proof of work. Computers solve a complicated problem to gain tokens!
// +
// 20% of zkBTC Token is Auctioned in the zkBitcoinAuctions Contract which distributes tokens to users who use Ethereum to buy tokens in fair price. Each auction lasts ~12 days.
// +
// = 100% Of the Token is distributed to the users! No dev fee or premine!
//
//
// Symbol: zkBTC
// Decimals: 18
//
// Total supply: 52,500,001.000000000000000000
//   =
// 21,000,000 zkBitcoin Tokens go to Liquidity Providers of the token over 100+ year using Bitcoin distribution!  Helps prevent LP losses!  Uses the zkBitcoinStaking0xBTC & zkBitcoinStakingETH Contract!
//   +
// 21,000,000 Mined over 100+ years using Bitcoins Distrubtion halvings every ~4 years. Uses Proof-oF-Work to distribute the tokens. Public Miner is available see https://zkBitcoin.org  Uses this contract.
//   +
// 10,500,000 Auctioned over 100+ years into 4 day auctions split fairly among all buyers. ALL Ethereum proceeds go into THIS contract which it fairly uses to Pay for Mints using the PayMaster functions.
//  
//
// ~100% of the Ethereum from this contract goes to the PayMaster to pay for mints.
//
// No premine, dev cut, or advantage taken at launch. Public miner available at launch. 100% of the token is given away fairly over 100+ years using Bitcoins model!
//
// Send this contract any ERC20 token and it will become instantly mineable and able to distribute using proof-of-work!
// Donate this contract any NFT and we will also distribute it via Proof of Work to our miners!  
//  
//* 1 token were burned to create the LP pool.
//
// Credits: 0xBitcoin, Vether, Synethix, ABAS, Paymaster
//
// startTime = 1704906000;  //Date and time (GMT):  Wednesday, January 10, 2024 5:00:00 PM GMT openMining can then be called and mining can called




pragma solidity ^0.8.11;

import "./draft-ERC20Permit.sol";	


import {IPaymaster, ExecutionResult, PAYMASTER_VALIDATION_SUCCESS_MAGIC} from "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IPaymaster.sol";
import {IPaymasterFlow} from "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IPaymasterFlow.sol";
import {TransactionHelper, Transaction} from "@matterlabs/zksync-contracts/l2/system-contracts/libraries/TransactionHelper.sol";

import "@matterlabs/zksync-contracts/l2/system-contracts/Constants.sol";


contract Ownable {
    address public owner;
    event TransferOwnership(address _from, address _to);

    constructor() {
        owner = msg.sender;
        emit TransferOwnership(address(0), msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner, paymaster for this contract");
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

pragma solidity >=0.4.21 <0.9.0;



library IsContract {
    function isContract(address _addr) internal view returns (bool) {
        bytes32 codehash;
        /* solium-disable-next-line */
        assembly { codehash := extcodehash(_addr) }
        return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
    }
}



// File: contracts/utils/SafeMath.sol

library SafeMath2 {
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 z = x + y;
        require(z >= x, "Add overflow");
        return z;
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256) {
        require(x >= y, "Sub underflow");
        return x - y;
    }

    function mult(uint256 x, uint256 y) internal pure returns (uint256) {
        if (x == 0) {
            return 0;
        }

        uint256 z = x * y;
        require(z / x == y, "Mult overflow");
        return z;
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "Div by zero");
        return x / y;
    }

    function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "Div by zero");
        uint256 r = x / y;
        if (x % y != 0) {
            r = r + 1;
        }

        return r;
    }
}



// File: contracts/utils/Math.sol

library ExtendedMath2 {


    //return the smaller of the two inputs (a or b)
    function limitLessThan(uint a, uint b) internal pure returns (uint c) {

        if(a > b) return b;

        return a;

    }
}

// File: contracts/interfaces/IERC20.sol




interface IERC721 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}



//Recieve NFTs
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
//Main contract



interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}



interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC
     5MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}




interface IERC1155Receiver is IERC165 {
    /**
     * @dev Handles the receipt of a single ERC1155 token type. This function is
     * called at the end of a `safeTransferFrom` after the balance has been updated.
     *
     * NOTE: To accept the transfer, this must return
     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * (i.e. 0xf23a6e61, or its own function selector).
     *
     * @param operator The address which initiated the transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param id The ID of the token being transferred
     * @param value The amount of tokens being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @dev Handles the receipt of a multiple ERC1155 token types. This function
     * is called at the end of a `safeBatchTransferFrom` after the balances have
     * been updated.
     *
     * NOTE: To accept the transfer(s), this must return
     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * (i.e. 0xbc197c81, or its own function selector).
     *
     * @param operator The address which initiated the batch transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param ids An array containing ids of each token being transferred (order and length must match values array)
     * @param values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}



contract zkBTCAuctionsCT{
    uint256 public totalAuctioned;
    }
    



contract zkBitcoin is Ownable, ERC20Permit, IPaymaster {






////
//PayMaster Stuff First then Minting
////


    uint public ETHBalance;
    address public prevMiner;
    uint16 public prevGoodLoops=1;
    uint16 public prevBadLoops;

    //20% extra under 500 tokens
    uint public minimumMintLevelForFee=10;
    uint public minimumLevelFee=10;
    //5% extra for every fails is overdoing it I believe right
    uint public BADLevelFee=1000; 
    uint public minimumBADMintLevelForFee=1;

    address public constant WETH = 0x20b28B1e4665FFf290650586ad76E977EAb90c5D; // Wrapped ETH address
    address public pairAddress = 0xff89102328Da98c50F8D60998EEb2d7fD470Bc92;
    uint256 public GAS_BUFFER = 55000; // This is the buffer amount


    
    modifier onlyBootloader() {
        require(
            msg.sender == BOOTLOADER_FORMAL_ADDRESS,
            "Only bootloader can call this method"
        );
        // Continue execution if called from the bootloader.
        _;
    }

    
    bool setOnce =false;
    function setPool(address pairETH) public onlyOwner{
    	require(!setOnce, "Only set the pool once");
    	setOnce = true;
    	pairAddress = pairETH;
    }
    
    
    
    function setBADLevelFee (uint256 BADfee)public onlyOwner {
	    BADLevelFee = BADfee;
    }
    
    function setMinimumBADMintLevelForFee (uint256 BADfeeLevel)public onlyOwner {
	    minimumBADMintLevelForFee = BADfeeLevel;
    }
    
    
    function setMinimumMintLevelForFee (uint256 feeLevel)public onlyOwner {
	    minimumMintLevelForFee = feeLevel;
    }
    
    function setMinimumLevelFee (uint256 fee)public onlyOwner {
	    minimumLevelFee = fee;
    }
    
    function setGAS_BUFFER (uint256 GAS_BUFFER_set)public onlyOwner {
	    GAS_BUFFER = GAS_BUFFER_set;
    }
    
    
    function getGAS_BUFFER  ()public view returns (uint) {
	    return GAS_BUFFER;
    }
    
    
    function getMinimumMintLevelForFee  ()public view returns (uint) {
	    return minimumMintLevelForFee;
    }
    
    function getMinimumLevelFee ()public view returns (uint) {
	    return minimumLevelFee;
    }
    

    
    
    function getMinimumBADMintLevelForFee  ()public view returns (uint) {
	    return minimumBADMintLevelForFee;
    }
    
    function getBADLevelFee () public view returns (uint) {
	    return BADLevelFee;
    }
    

    // Returns the price of `token` in terms of ETH
    
    
    function  getPriceX1000() public view returns (uint) {

        IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
        (uint reserves0, uint reserves1) = pair.getReserves();

        // Ensure that reserves are returned in the correct order (token, WETH)
        (uint tokenReserves, uint ethReserves) = address(this) < WETH ? (reserves0, reserves1) : (reserves1, reserves0);

        return (tokenReserves*1000) / ethReserves; // Normalize to token's decimals if necessary
    }
	    
	    
	    
    function calculateMinimumTotalZKBTC(uint _goodLoops, uint _badLoops, uint _requiredETH) public view returns (uint) {
        uint price = getPriceX1000();

        uint totalZKBTC = (_requiredETH * price) / 1000;
        uint costPerGoodMint = totalZKBTC / _goodLoops;
        if (_badLoops > minimumBADMintLevelForFee) {
            uint baseIncreasePerBadLoop = (costPerGoodMint * 5 / 100) * 1000 / BADLevelFee;
            uint excessBadLoops = _badLoops - minimumBADMintLevelForFee;
            totalZKBTC = totalZKBTC + (baseIncreasePerBadLoop * excessBadLoops);
        }
        
        
    // Calculate the fee for good loops
        if (_goodLoops < minimumMintLevelForFee) {
            uint deficit = minimumMintLevelForFee - _goodLoops;
            uint feeMultiplier = (deficit * 2000) / minimumLevelFee;
            totalZKBTC += (totalZKBTC * feeMultiplier) / 1000;
        }

        return totalZKBTC;
    }
	    
	    
	    
    function findMinimumGoodLoops(uint _requiredETH) public view returns (uint) {
        uint price = getPriceX1000();
        uint goodLoops = 1; // Start with 1 good loop

        while (true) {
            uint totalZKBTC = (_requiredETH * price) / 1000;

            // Calculate the fee for good loops
            if (goodLoops < minimumMintLevelForFee) {
		    uint deficit = minimumMintLevelForFee - goodLoops;
		    uint feeMultiplier = (deficit * 2000) / minimumLevelFee;
		    totalZKBTC += (totalZKBTC * feeMultiplier) / 1000;
            }
            
            if (goodLoops*reward_amount>totalZKBTC) {
		    return goodLoops;
            }
	    goodLoops++;
	}
    }
    
    
    
    function refundPayMasterLast () public {
	

        uint refundAmtz = refundAmtZKBTC();
        if(refundAmtz < balanceOf(address(this))){
            IERC20(address(this)).transfer(prevMiner, refundAmtz);
        }
        ETHBalance = address(this).balance;
		 
		
    }
	
    function refundAmtZKBTC () public view returns (uint){
		
        uint amt = address(this).balance - ETHBalance;
        return calculateMinimumTotalZKBTC(prevGoodLoops, prevBadLoops, amt);
    }
	
	
	
    function validateAndPayForPaymasterTransaction(bytes32, bytes32,Transaction calldata _transaction) external payable onlyBootloader returns (bytes4 magic, bytes memory context)
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
            
		require(address(uint160(_transaction.to)) ==address(this),"CANT MINT TO ANYTHING ELSE");
            
		uint refundAmtz = refundAmtZKBTC();
		if(refundAmtz < balanceOf(address(this))){
			//save payment til later for only 1 send if same person
			if(prevMiner != address(uint160(_transaction.from))){
				IERC20(address(this)).transfer(prevMiner, refundAmtz);
				refundAmtz=0;
			}
		}else{
			refundAmtz=0;
		}
		
    		bytes4 functionSelector=  bytes4(_transaction.data[:4]);
		require(bytes4(0x4005c5f4) ==functionSelector,"CANT MINT ANYTHING ELSE");
		address mintToAddress;
		uint256[] memory nonce;
	 	bytes32[] memory challengeNumber2;

		// Decode the input data
		(mintToAddress, nonce, challengeNumber2) = abi.decode( _transaction.data[4:], (address, uint256[], bytes32[]));

		uint256 requiredETH = _transaction.gasLimit * _transaction.maxFeePerGas;

		uint price = getPriceX1000();
		
   		bool leftOver = true;
		uint16 totalGoodLoops = 0;
		uint NextEpochCount = blocksToReadjust();
		uint16 badLoops =0;
		uint miningTarget2 = miningTarget;
		for (uint i = 0; i < nonce.length; i++) {
		    
		    
				bytes32 digest =  keccak256(abi.encodePacked(challengeNumber2[i], address(uint160(_transaction.from)), nonce[i]));
				
				if(uint256(digest) < miningTarget2 && !usedCombinations[digest] && challengeNumber2[i] == MultiMintChallengeNumber)
				{
					usedCombinations[digest] = true;
					totalGoodLoops=totalGoodLoops+1;
				}else{
					badLoops = badLoops + 1;
	  			}
				if(totalGoodLoops == NextEpochCount){
					if(!leftOver){
						break;
					}
					MultiMintChallengeNumber = getChallengeNumber();
					NextEpochCount = totalGoodLoops + _BLOCKS_PER_READJUSTMENT;
					miningTarget2 = reAdjustsToWhatDifficulty_MaxPain_Target();
					leftOver = false;
				}
			
			
		}
		uint totalZKBTC = calculateMinimumTotalZKBTC(totalGoodLoops, badLoops, requiredETH);

		require(totalGoodLoops*reward_amount >= totalZKBTC,"MUST mint at least enough zkBTC to cover the transaction cost, try increasing the number of solutions per submission");

		multiMint_PayMaster(totalGoodLoops, address(uint160(_transaction.from)));

       	IERC20(address(this)).transfer(address(uint160(_transaction.from)), reward_amount*totalGoodLoops - totalZKBTC + refundAmtz);
		
            // The bootloader never returns any data, so it can safely be ignored here.
            (bool success, ) = payable(BOOTLOADER_FORMAL_ADDRESS).call{value: requiredETH }("");
            require(success,"Failed to transfer tx fee to the bootloader. Paymaster balance might not be enough.");
		 ETHBalance = address(this).balance;
		 prevMiner = address(uint160(_transaction.from));
		 prevGoodLoops = totalGoodLoops;
		 prevBadLoops = badLoops;
            require(gasleft() > GAS_BUFFER, "Not enough gas left to safely proceed, please raise your gasLimit before sending");

        } else {
            revert("Unsupported paymaster flow");
        }
    }

	function postTransaction(bytes calldata _context, Transaction calldata _transaction, bytes32, bytes32, ExecutionResult _txResult, uint256 _maxRefundedGas) external payable override onlyBootloader {
     
   		//Nothing here
   
}
    
    

	function skimZKBTC_For_LPs() public {
		require(epochCount>250000,"not in first era PayMaster Rewards help relieve 2nd Era LPers");
		IERC20(address(this)).transfer(AddressLPReward, IERC20(address(this)).balanceOf(address(this)).div(2));
		IERC20(address(this)).transfer(AddressLPReward2, IERC20(address(this)).balanceOf(address(this)));

	}


	function TheEndOfPayMaster() public {
	    // Calculate half of the contract's current balance
	    uint256 halfBalance = address(this).balance / 2;
  	    require(_totalSupply <= tokensMinted+100*10**18,"Mining not over, get to work!");
	    // Ensure there is some balance to send
	    if (halfBalance > 0) {
		address payable to = payable(AddressLPReward);
		// Send half of the contract's balance
		(bool sent, ) = to.call{value: halfBalance}("");
		require(sent, "Failed to send Ether");
		address payable to2 = payable(AddressLPReward2);
		// Send half of the contract's balance
		(bool sent2, ) = to2.call{value: halfBalance}("");
		require(sent2, "Failed to send Ether");
	    }
	}

//Allow ETH to enter
	receive() external payable {
		ETHBalance += msg.value;

	}


	fallback() external payable {
		ETHBalance += msg.value;
	}



////
// Minting Stuff Follows
////




    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
    
    function onERC1155Received(address, address, uint256, uint256, bytes calldata) external pure returns (bytes4){
	return IERC1155Receiver.onERC1155Received.selector;
	}	
    function onERC1155BatchReceived(address, address, uint256, uint256, bytes calldata) external pure returns (bytes4){
	return IERC1155Receiver.onERC1155Received.selector;
	}
	
    uint public targetTime = 12*60;
    uint public startTime = 1704906000;
    // SUPPORTING CONTRACTS
    address public AddressAuction;
    zkBTCAuctionsCT public AuctionsCT;
    address public AddressLPReward;
    address public AddressLPReward2;
    //Events
    using SafeMath2 for uint256;
    using ExtendedMath2 for uint;
    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
    event MegaMint(address indexed from, uint epochCount, bytes32 newChallengeNumber, uint NumberOfTokensMinted, uint256 TokenMultipler);

    // This mapping can be used to store combinations of nonce, challenge, and user
    // to ensure they are not used again.
    mapping(bytes32 => bool) public usedCombinations;
    //ZKBITCOIN INITALIZE Start
	
    uint public constant _totalSupply = 21000000000000000000000000;
    uint public latestDifficultyPeriodStarted2 = block.timestamp; //BlockTime of last readjustment
    uint public latestDifficultyPeriodStarted = block.number; // for readjustments
    uint public epochCount = 0;//number of 'blocks' mined
//MUST CHANGE BACK TO 2048
    uint public _BLOCKS_PER_READJUSTMENT = 2048; // should be 2048 blocks more inline with BTC
    uint public  _MAXIMUM_TARGET = 2**234;
    //a little number
    uint public  _MINIMUM_TARGET =  2**16;
    uint public miningTarget = _MAXIMUM_TARGET.div(1);  //500 difficulty to start
  
    bytes32 public challengeNumber = blockhash(block.number -1); //generate a new one when a new reward is minted
    bytes32 public MultiMintChallengeNumber = blockhash(block.number -2); //Use this variable for minting zkBitcoin, challengeNumber is the backup if you trigger a difficutly adjustment
    uint public rewardEra = 0;
    uint public maxSupplyForEra = (_totalSupply - _totalSupply.div( 2**(rewardEra + 1)));
    uint public reward_amount = 0;
    
    //Stuff for Functions
    uint public previousBlockTime  =  block.timestamp; // Previous Blocktime for ERC20 mintings
    uint public tokensMinted = 0;			//Tokens Minted only for Miners
    uint public slowBlocks = 0;  //Used for NFT minting
    uint public epochOld = 0;  //Epoch count at each readjustment 
    uint public lastTokensMinted = 0;  //Counter for distributing tokens to LP fairly
    // startup locks
    bool initeds = false;
    bool locked = false;

	// mint 1 token to setup LPs
	constructor() ERC20("zkBitcoin", "zkBTC") ERC20Permit("zkBitcoin") {
		// mint 1 token to setup LPs
		_mint(msg.sender, 1000000000000000000);
		miningTarget = _MAXIMUM_TARGET.div(4); //easy difficulty u can solve but no reward until startTime and OpenMining is ran
//MUST CHANGE STARTTIME BACK
		startTime = block.timestamp;// 1704906000;  //Date and time (GMT):  Wednesday, January 10, 2024 5:00:00 PM GMT
//MUST CHANGE STARTTIME BACK
		reward_amount = 0;  //Zero reward for first days to setup miners
		rewardEra = 0;
		tokensMinted = 0;
		epochCount = 0;
		epochOld = 0;
		latestDifficultyPeriodStarted2 = block.timestamp;
		latestDifficultyPeriodStarted = block.number;	
		challengeNumber = blockhash(block.number -1); //generate a new one so we can start with a fresh seed
		MultiMintChallengeNumber = blockhash(block.number -3); //generate a new one so we can start with a fresh seed and allow it to be MultiMined
		
	}


	//////////////////////////////////
	// Initialize Function          //
	//////////////////////////////////

	function zinit2(address AuctionAddress2, address LPGuild, address LPGuild2) public onlyOwner{
		uint x = 21000000000000000000000000; 
		// Only init once
		assert(!initeds);
		initeds = true;
		previousBlockTime = block.timestamp;
		reward_amount = 0; 
	   	rewardEra = 0;
		tokensMinted = 0;

	    	miningTarget = _MAXIMUM_TARGET.div(20); //super difficult so no1 can solve till OpenMining
	    	_startNewMiningEpoch();

		epochCount = 0;
		epochOld = 0;
		latestDifficultyPeriodStarted2 = block.timestamp;
		latestDifficultyPeriodStarted = block.number;
		previousBlockTime = block.timestamp;
		// Init contract variables and mint
		 _mint(AuctionAddress2, x/2);

	    	AddressAuction = AuctionAddress2;
		AuctionsCT = zkBTCAuctionsCT(AddressAuction);
		AddressLPReward = payable(LPGuild);
		AddressLPReward2 = payable(LPGuild2);
		slowBlocks = 1;
		
     
  	}


//for testnet only
	function AdjustDiff(uint diff) public onlyOwner{
//for testnet only
		require(diff<100000,"Low only");
		miningTarget=_MAXIMUM_TARGET.div(diff);
	}


	function openMining() public returns (bool success) {
		//Starts mining after a few days period for miners to setup is done
		require(!locked, "Only allowed to run once");
		locked = true;
		require(block.timestamp >= startTime && block.timestamp <= startTime + 60* 60 * 24* 7, "Must wait until after startTime (Jan 3rd 2024 @ 5PM GMT) epcohTime 1704301242");
		challengeNumber = blockhash(block.number -1); //generate a new one so we can start with a fresh seed
		MultiMintChallengeNumber = blockhash(block.number -3); //generate a new one so we can start with a fresh seed and allow it to be MultiMined
		previousBlockTime = block.timestamp;	
		reward_amount = 50 * 10**18;
		rewardEra = 0;
		miningTarget = _MAXIMUM_TARGET.div(1);	
		
		return true;
	}


	///
	// Managment
	///
	

	function ARewardSender() public {
		//runs every _BLOCKS_PER_READJUSTMENT / 8
		
		uint zkBTCtoSend = (tokensMinted - lastTokensMinted).div(2);

		

		if(zkBTCtoSend!=0){
			
			_mint(AddressLPReward, zkBTCtoSend );
			_mint(AddressLPReward2,  zkBTCtoSend);
		}

		lastTokensMinted = tokensMinted;
	}

	///
	// zkBitcoin Multi Minting
	///


	function multiMint_PayMaster_EZ(address mintToAddress, uint256 [] memory nonce, bytes32 [] memory challengeNumber2) public  {

	}

	function multiMint_PayMaster(uint Mints, address mintToAddress) internal  {
	
		_startNewMiningEpoch_MultiMint_Mass_Epochs(Mints);
		uint payout = reward_amount * Mints;
		
		//if max supply for the era will be exceeded next reward round then enter the new era before that happens
		//59 is the final reward era, almost all tokens minted
		if( tokensMinted.add(payout) > maxSupplyForEra && rewardEra < 59)
		{
			rewardEra = rewardEra + 1;
			maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
			if(rewardEra < 3){
				targetTime = ((12 * 60) * 2**rewardEra);
				_BLOCKS_PER_READJUSTMENT = _BLOCKS_PER_READJUSTMENT.div(2);
			}else{
				reward_amount = ( 50 * 10**18)/( 2**(rewardEra - 2  ) );
			}
			payout = payout.div(2);
		}

		_mint(address(this), payout);

		emit Mint(mintToAddress, payout, epochCount, challengeNumber );
		
		tokensMinted = tokensMinted.add(payout);

	}


	function multiMint_SameAddress_EZ(address mintToAddress, uint256 [] memory nonce, bytes32 [] memory challengeNumber2) public {
        	uint NextEpochCount = blocksToReadjust();
		uint xLoop = 0;
		uint leftOver = 0;
		uint GoodLoops = 0;

		for (xLoop = 0; xLoop < nonce.length; xLoop++) {
		    bytes32 digest = keccak256(abi.encodePacked(challengeNumber2[xLoop], msg.sender, nonce[xLoop]));

		    if (challengeNumber2[xLoop] != MultiMintChallengeNumber || usedCombinations[digest] || uint256(digest) >= miningTarget) {
		        continue;
		    }

		    GoodLoops = GoodLoops.add(1);

			    // Your existing logic goes here
			    // ...

			    // Mark this combination as used
	            usedCombinations[digest] = true;
		    if (GoodLoops == NextEpochCount) {


			if(leftOver != 0){
				break;
			}

		        _startNewMiningEpoch_MultiMint_Mass_Epochs(GoodLoops-leftOver);
		        NextEpochCount = GoodLoops + _BLOCKS_PER_READJUSTMENT;
			leftOver=GoodLoops;
		    }

		  
		}

       		_startNewMiningEpoch_MultiMint_Mass_Epochs(GoodLoops - leftOver);

		uint payout = GoodLoops * reward_amount;

		//if max supply for the era will be exceeded next reward round then enter the new era before that happens
		//59 is the final reward era, almost all tokens minted
		if( tokensMinted.add(payout) > maxSupplyForEra && rewardEra < 59)
		{
			rewardEra = rewardEra + 1;
			maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
			if(rewardEra < 3){
				targetTime = ((12 * 60) * 2**rewardEra);
				_BLOCKS_PER_READJUSTMENT = _BLOCKS_PER_READJUSTMENT.div(2);
			}else{
				reward_amount = ( 50 * 10**18)/( 2**(rewardEra - 2 ) );
			}
			payout = payout.div(2);
		}
		_mint(mintToAddress, payout);

		emit Mint(msg.sender, payout, epochCount, challengeNumber );	
		
		tokensMinted = tokensMinted.add(payout);

	
	}
	





	///
	// NFT Minting
	///



	function mintNFTGOBlocksUntil() public view returns (uint num) {
		return _BLOCKS_PER_READJUSTMENT - (slowBlocks % (_BLOCKS_PER_READJUSTMENT ));
	}
	


	function mintNFTGO() public view returns (uint num) {
		return slowBlocks % (_BLOCKS_PER_READJUSTMENT);
	}
	

	function mintNFT721(address nftaddy, uint nftNumber, uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
		require(mintNFTGO() == 0, "Only mint on slowBlocks % _BLOCKS_PER_READJUSTMENT/8 == 0");
		mintTo(nonce, msg.sender);
		IERC721(nftaddy).safeTransferFrom(address(this), msg.sender, nftNumber, "");
		if(mintNFTGO() == 0){
			slowBlocks = slowBlocks.add(1);
		}
		return true;
	}



	function mintNFT1155(address nftaddy, uint nftNumber, uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
		require(mintNFTGO() == 0, "Only mint on slowBlocks % _BLOCKS_PER_READJUSTMENT/8 == 0");
		mintTo(nonce, msg.sender);
		IERC1155(nftaddy).safeTransferFrom(address(this), msg.sender, nftNumber, 1, "" );
		if(mintNFTGO() == 0){
			slowBlocks = slowBlocks.add(1);
		}
		return true;
	}


	///
	// Single Mint zkBitcoin Minting
	///



	//compatibility function
	function mint(uint256 nonce, bytes32 challenge_digest) public {
		mintTo(nonce, msg.sender);
	}
	

	function mintTo(uint256 nonce, address mintToAddress) public {

		bytes32 digest =  keccak256(abi.encodePacked(MultiMintChallengeNumber, msg.sender, nonce));

		//the digest must be smaller than the target
		require(uint256(digest) < miningTarget, "Digest must be smaller than miningTarget");
		require(!usedCombinations[digest], "Must not been the first time this solve has been used");
		usedCombinations[digest] = true;
             	_startNewMiningEpoch();
	
        	_mint(mintToAddress, reward_amount);
		
		tokensMinted = tokensMinted.add(reward_amount);
		

		emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );


	}



	///
	// ERC20 Minting
	///

	function mintTokensArrayTo(uint256 nonce, bytes32 challenge_digest, address[] memory ExtraFunds, address[] memory MintTo) public returns (uint256 owedzz) {
		uint256 xa = ((block.timestamp - previousBlockTime) * 888) / targetTime;
		uint ratio = xa * 100 / 888 ;
	
		previousBlockTime = block.timestamp;
		
		if(ratio > 100){
			
			slowBlocks = slowBlocks.add(1);
			
		}
		
		uint totalOwed = (24*xa*5086060).div(888)+3456750000;
		//best @ 3000 ratio totalOwed / 100000000 = 71.6
		if(ratio < 3000){
			totalOwed = (508606*(15*xa**2)).div(888 ** 2)+ (9943920 * (xa)).div(888);
		}else {
			totalOwed = (24*xa*5086060).div(888)+3456750000;
		}
		mintTo(nonce, MintTo[0]);
		uint256 totalOd = totalOwed;

		require(MintTo.length == ExtraFunds.length + 1,"MintTo has to have an extra address compared to ExtraFunds");
		uint xy=0;
		for(xy = 0; xy< ExtraFunds.length; xy++)
		{
		
			require(ExtraFunds[xy] != address(this), "No printing our token");
			if(epochCount % (2**(xy+1)) != 0){
				break;
			}
			for(uint y=xy+1; y< ExtraFunds.length; y++){
				require(ExtraFunds[y] != ExtraFunds[xy], "No printing The same tokens");
			}
		}
		
		uint TotalOwned = 0;
		uint totalToSend = 0;
		for(uint x=0; x<xy; x++)
		{
			//epoch count must evenly dividable by 2^n in order to get extra mints. 
			//ex. epoch 2 = 1 extramint, epoch 4 = 2 extra, epoch 8 = 3 extra mints, ..., epoch 32 = 5 extra mints w/ a divRound for the 5th mint(allows small balance token minting aka NFTs)
			if(epochCount % (2**(x+1)) == 0){
				TotalOwned = ERC20(ExtraFunds[x]).balanceOf(address(this));
				if(TotalOwned != 0){
					if( x % 3 == 0 && x != 0 && totalOd > 17600000){
						totalToSend = ( (2** rewardEra) *TotalOwned * totalOd).divRound(100000000 * 20000);
						
					}else{
						totalToSend = ( (2** rewardEra) * TotalOwned * totalOd).div(100000000 * 20000);
					}
				}
				if(TotalOwned < totalToSend){ totalToSend = TotalOwned; }
			    	ERC20(ExtraFunds[x]).transfer(MintTo[x+1], totalToSend);
			}
			totalToSend = 0;
		}
        	
        	
		emit MegaMint(msg.sender, epochCount, challengeNumber, xy, totalOd );

		return totalOd;

	}



	function mintTokensSameAddress(uint256 nonce, bytes32 challenge_digest, address[] memory ExtraFunds, address MintTo) public {
		address[] memory dd = new address[](ExtraFunds.length + 1); 

		for(uint x=0; x< (ExtraFunds.length + 1); x++)
		{
			dd[x] = MintTo;
		}
		
		mintTokensArrayTo(nonce, challenge_digest, ExtraFunds, dd);
	}


	function rewardAtCurrentTime() public view returns (uint256 reward){
		return reward_amount;
	}


	
	function rewardAtTime(uint timeDifference) public view returns (uint256 rewards){

		return reward_amount;
	}



	function rewardAtTimeTokenBaseNow(address RewardToken) public view returns (uint256 rewards){
		return rewardAtTimeTokenBase((block.timestamp - previousBlockTime), RewardToken);
	}
	

	function rewardAtTimeTokenBase(uint timeDifference, address RewardToken) public view returns (uint256 rewards){
		uint256 x = (timeDifference * 888) / targetTime;
		uint ratio = x * 100 / 888 ;
		uint totalOwed = 0;


		//best @ 3000 ratio totalOwed / 100000000 = 71.6
		if(ratio < 3000){
			totalOwed = (508606*(15*x**2)).div(888 ** 2)+ (9943920 * (x)).div(888);
		}else {
			totalOwed = (24*x*5086060).div(888)+3456750000;
		}

		rewards = 0;
		ERC20 erc20Token = ERC20(address(RewardToken));

		uint TotalOwned = erc20Token.balanceOf(address(this));
			if(totalOwed > 17600000 ){
				rewards = ( (2** rewardEra) * TotalOwned * totalOwed).divRound(100000000 * 20000);
			}else{
				rewards = ( (2** rewardEra) * TotalOwned * totalOwed).div(100000000 * 20000 );
			}
		return rewards;
	}

	function blocksFromReadjust() public view returns (uint256 blocks){
		blocks = (epochCount - epochOld);
		return blocks;
	}
	

	function blocksToReadjust() public view returns (uint blocks){
		
		uint256 blktimestamp = block.timestamp;
		uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2;
		uint blocksTotalForReadjustPossible =blocksFromReadjust() + (_BLOCKS_PER_READJUSTMENT/8 - ((epochCount - epochOld) % (_BLOCKS_PER_READJUSTMENT/8)));		
		uint adjusDiffTargetTime =8* targetTime * blocksTotalForReadjustPossible; 
		if( TimeSinceLastDifficultyPeriod2 > adjusDiffTargetTime)
		{
				blocks = _BLOCKS_PER_READJUSTMENT/8 - ((epochCount - epochOld) % (_BLOCKS_PER_READJUSTMENT/8));
				return (blocks);
		}else{
			    blocks = _BLOCKS_PER_READJUSTMENT - ((epochCount - epochOld) % _BLOCKS_PER_READJUSTMENT);
			    return (blocks);
		}
	
	}



	function seconds_Until_adjustmentSwitch() public view returns (uint secs){
		
		uint256 blktimestamp = block.timestamp;
		uint blocksTotalForReadjustPossible =blocksFromReadjust() + (_BLOCKS_PER_READJUSTMENT/8 - ((epochCount - epochOld) % (_BLOCKS_PER_READJUSTMENT/8)));		
		uint adjusDiffTargetTime =8* targetTime * blocksTotalForReadjustPossible+latestDifficultyPeriodStarted2;
		if(adjusDiffTargetTime - blktimestamp <0){
			return 0;
		}
		return adjusDiffTargetTime - blktimestamp;
	
	}



	function _startNewMiningEpoch_MultiMint_Mass_Epochs(uint epochsz) internal {

		uint totalruns = epochsz/(_BLOCKS_PER_READJUSTMENT / 8);
		
		for(uint xy=0; xy<=totalruns; xy++){
			uint NextEpochCount = _BLOCKS_PER_READJUSTMENT/8 - ((epochCount - epochOld) % (_BLOCKS_PER_READJUSTMENT/8));
			if(epochsz >= NextEpochCount){
					
					epochCount = epochCount.add(NextEpochCount);
					epochsz=epochsz.sub(NextEpochCount);
					if(xy<1){
						ARewardSender();
					}
					if(_totalSupply < tokensMinted){
						reward_amount = 0;
					}
					
					uint256 blktimestamp = block.timestamp;
					uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2;
					uint adjusDiffTargetTime = 8*targetTime *  blocksFromReadjust(); 
							
					if( TimeSinceLastDifficultyPeriod2 > adjusDiffTargetTime || (epochCount - epochOld) % _BLOCKS_PER_READJUSTMENT == 0) 
					{
						_reAdjustDifficulty();
						MultiMintChallengeNumber = challengeNumber;
						challengeNumber = blockhash(block.number -1);
						require(MultiMintChallengeNumber != challengeNumber,"Minting problem");
				
					}
			}
		}
		epochCount = epochCount.add(epochsz);

	}

	function _startNewMiningEpoch() internal {


		//if max supply for the era will be exceeded next reward round then enter the new era before that happens
		//59 is the final reward era, almost all tokens minted
		if( tokensMinted.add(reward_amount) > maxSupplyForEra && rewardEra < 59)
		{
			rewardEra = rewardEra + 1;
			maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
			if(rewardEra < 3){
				targetTime = ((12 * 60) * 2**rewardEra);
				_BLOCKS_PER_READJUSTMENT = _BLOCKS_PER_READJUSTMENT.div(2);
			}else{
				reward_amount = ( 50 * 10**18)/( 2**(rewardEra - 2  ) );
			}
		}

		epochCount = epochCount.add(1);

		//every so often, readjust difficulty. Dont readjust when deploying
		if((epochCount - epochOld) % (_BLOCKS_PER_READJUSTMENT / 8) == 0)
		{
			ARewardSender();
			if(_totalSupply < tokensMinted){
				reward_amount = 0;
			}
			
			uint256 blktimestamp = block.timestamp;
			uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2;
			uint adjusDiffTargetTime = 8*targetTime *  blocksFromReadjust(); 

			if( TimeSinceLastDifficultyPeriod2 > adjusDiffTargetTime || (epochCount - epochOld) % _BLOCKS_PER_READJUSTMENT == 0) 
			{
				_reAdjustDifficulty();
				MultiMintChallengeNumber = challengeNumber;
				challengeNumber = blockhash(block.number -1);
				require(MultiMintChallengeNumber != challengeNumber,"Minting problem");
					
			}
		}

	}



	function reAdjustsToWhatDifficultyAVG(uint extraTime) public view returns (uint difficulty) {
		

		uint256 blktimestamp = block.timestamp;
		uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2 + extraTime+1;
		uint epochTotal = epochCount - epochOld;
		uint adjusDiffTargetTime = targetTime *  epochTotal+1;
		uint miningTarget2 = 0;

		//if there were less eth blocks passed in time than expected
		if( TimeSinceLastDifficultyPeriod2 < adjusDiffTargetTime )
		{
			uint excess_block_pct = (adjusDiffTargetTime.mult(100)).div( TimeSinceLastDifficultyPeriod2 );
			uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
			//make it harder 
			miningTarget2 = miningTarget.sub(miningTarget.div(1333).mult(excess_block_pct_extra));   //by up to 50 %
		}else{
			uint shortage_block_pct = (TimeSinceLastDifficultyPeriod2.mult(100)).div( adjusDiffTargetTime );

			uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
			//make it easier
			miningTarget2 = miningTarget.add(miningTarget.div(333).mult(shortage_block_pct_extra));   //by up to 200 %
		}

		if(miningTarget2 < _MINIMUM_TARGET) //very difficult
		{
			miningTarget2 = _MINIMUM_TARGET;
		}
		if(miningTarget2 > _MAXIMUM_TARGET) //very easy
		{
			miningTarget2 = _MAXIMUM_TARGET;
		}
		difficulty = _MAXIMUM_TARGET.div(miningTarget2);
			return difficulty;
	}


	function reAdjustsToWhatDifficulty_MaxPain_Difficulty() public view returns (uint difficulty) {
		difficulty = _MAXIMUM_TARGET.div(reAdjustsToWhatDifficulty_MaxPain_Target());
		return difficulty;
	}

	function reAdjustsToWhatDifficulty_MaxPain_Target() public view returns (uint target) {
		uint blocksTo = blocksToReadjust();
		uint blocksFrom = blocksFromReadjust();
		uint epochTotal = blocksTo + blocksFrom;
		uint adjusDiffTargetTime = targetTime *  epochTotal; 
		uint256 blktimestamp = block.timestamp;
		uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2+1;
        uint miningTarget2 = 0;

		//if there were less eth blocks passed in time than expected
		if( TimeSinceLastDifficultyPeriod2 < adjusDiffTargetTime )
		{
			uint excess_block_pct = (adjusDiffTargetTime.mult(100)).div( TimeSinceLastDifficultyPeriod2 );
			uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
			//make it harder 
			miningTarget2 = miningTarget.sub(miningTarget.div(1333).mult(excess_block_pct_extra));   //by up to 4x
		}else{
			uint shortage_block_pct = (TimeSinceLastDifficultyPeriod2.mult(100)).div( adjusDiffTargetTime );

			uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
			//make it easier
			miningTarget2 = miningTarget.add(miningTarget.div(333).mult(shortage_block_pct_extra));   //by up to 4x
		}

		if(miningTarget2 < _MINIMUM_TARGET) //very difficult
		{
			miningTarget2 = _MINIMUM_TARGET;
		}
		if(miningTarget2 > _MAXIMUM_TARGET) //very easy
		{
			miningTarget2 = _MAXIMUM_TARGET;
		}
		//difficulty = _MAXIMUM_TARGET.div(miningTarget2);
			return miningTarget2;
	}


	function reAdjustsToWhatDifficulty_MaxPain_Difficulty_AdditionalTime(uint addTime) public view returns (uint difficulty) {
		difficulty = _MAXIMUM_TARGET.div(reAdjustsToWhatDifficulty_MaxPain_Target_AdditionalTime(addTime));
		return difficulty;
	}
	

	function reAdjustsToWhatDifficulty_MaxPain_Target_AdditionalTime(uint addTime) public view returns (uint target) {
		uint blocksTo = blocksToReadjust();
		uint blocksFrom = blocksFromReadjust();
		uint epochTotal = blocksTo + blocksFrom;
		uint adjusDiffTargetTime = targetTime *  epochTotal; 
		uint256 blktimestamp = block.timestamp + addTime;
		uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2+1;
        uint miningTarget2 = 0;

		//if there were less eth blocks passed in time than expected
		if( TimeSinceLastDifficultyPeriod2 < adjusDiffTargetTime )
		{
			uint excess_block_pct = (adjusDiffTargetTime.mult(100)).div( TimeSinceLastDifficultyPeriod2 );
			uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
			//make it harder 
			miningTarget2 = miningTarget.sub(miningTarget.div(1333).mult(excess_block_pct_extra));   //by up to 4x
		}else{
			uint shortage_block_pct = (TimeSinceLastDifficultyPeriod2.mult(100)).div( adjusDiffTargetTime );

			uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
			//make it easier
			miningTarget2 = miningTarget.add(miningTarget.div(333).mult(shortage_block_pct_extra));   //by up to 4x
		}

		if(miningTarget2 < _MINIMUM_TARGET) //very difficult
		{
			miningTarget2 = _MINIMUM_TARGET;
		}
		if(miningTarget2 > _MAXIMUM_TARGET) //very easy
		{
			miningTarget2 = _MAXIMUM_TARGET;
		}
		//difficulty = _MAXIMUM_TARGET.div(miningTarget2);
			return miningTarget2;
	}



	function _reAdjustDifficulty() internal {
		uint256 blktimestamp = block.timestamp;
		uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2 +1;
		uint epochTotal = epochCount - epochOld;
		uint adjusDiffTargetTime = targetTime *  epochTotal; 
		epochOld = epochCount;

		//if there were less eth blocks passed in time than expected
		if( TimeSinceLastDifficultyPeriod2 < adjusDiffTargetTime )
		{
			uint excess_block_pct = (adjusDiffTargetTime.mult(100)).div( TimeSinceLastDifficultyPeriod2 );

			uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
			//make it harder 
			miningTarget = miningTarget.sub(miningTarget.div(1333).mult(excess_block_pct_extra));   //by up to 2x
		}else{
			uint shortage_block_pct = (TimeSinceLastDifficultyPeriod2.mult(100)).div( adjusDiffTargetTime );

			uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
			//make it easier
			miningTarget = miningTarget.add(miningTarget.div(333).mult(shortage_block_pct_extra));   //by up to 4x
		}

		latestDifficultyPeriodStarted2 = blktimestamp;
		latestDifficultyPeriodStarted = block.number;

		if(miningTarget < _MINIMUM_TARGET) //very difficult
		{
			miningTarget = _MINIMUM_TARGET;
		}
		if(miningTarget > _MAXIMUM_TARGET) //very easy
		{
			miningTarget = _MAXIMUM_TARGET;
		}
		
	}


	//Stat Functions

	function inflationMined () public view returns (uint YearlyInflation, uint EpochsPerYear, uint RewardsAtTime, uint TimePerEpoch){
		if(epochCount - epochOld == 0){
			return (0, 0, 0, 0);
		}
		uint256 blktimestamp = block.timestamp;
		uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2;

        
		TimePerEpoch = TimeSinceLastDifficultyPeriod2 / blocksFromReadjust(); 
		RewardsAtTime = rewardAtTime(TimePerEpoch);
		uint year = 365 * 24 * 60 * 60;
		EpochsPerYear = year / TimePerEpoch;
		YearlyInflation = RewardsAtTime * EpochsPerYear;
		return (YearlyInflation, EpochsPerYear, RewardsAtTime, TimePerEpoch);
	}

	

	function toNextEraDays () public view returns (uint daysToNextEra, uint _maxSupplyForEra, uint _tokensMinted, uint amtDaily){

        (uint totalamt,,,) = inflationMined();
		(amtDaily) = totalamt / 365;
		if(amtDaily == 0){
			return(0,0,0,0);
		}
		daysToNextEra = (maxSupplyForEra - tokensMinted) / amtDaily;
		return (daysToNextEra, maxSupplyForEra, tokensMinted, amtDaily);
	}
	


	function toNextEraEpochs () public view returns ( uint epochs, uint epochTime, uint daysToNextEra){
		if(blocksFromReadjust() == 0){
			return (0,0,0);
        }
		uint256 blktimestamp = block.timestamp;
        uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2;
		uint timePerEpoch = TimeSinceLastDifficultyPeriod2 / blocksFromReadjust();
		(uint daysz,,,) = toNextEraDays();
		uint amt = daysz * (60*60*24) / timePerEpoch;
		return (amt, timePerEpoch, daysz);
	}


	//help debug mining software
	function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
		bytes32 digest = bytes32(keccak256(abi.encodePacked(challenge_number,msg.sender,nonce)));
		if(uint256(digest) > testTarget) revert();

		return (digest == challenge_digest);
	}


	//help debug mining software2
	function checkMintSolution2(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget, address senda) public view returns (bytes32 success) {
		bytes32 digest = bytes32(keccak256(abi.encodePacked(challenge_number,senda,nonce)));
		if(uint256(digest) > testTarget) revert();

		return digest;
	}


	//this is a recent ethereum block hash, used to prevent pre-mining future blocks
	function getChallengeNumber() public view returns (bytes32) {

		return challengeNumber;

	}

	//this is a recent ethereum block hash, used to prevent pre-mining future blocks
	//Use this for your solves in zkBitcoin, getChallengeNumber is used for a backup
	function getMultiMintChallengeNumber() public view returns (bytes32) {

		return MultiMintChallengeNumber;

	}

	
	//the number of zeroes the digest of the PoW solution requires.  Auto adjusts
	function getMiningDifficulty() public view returns (uint) {
			return _MAXIMUM_TARGET.div(miningTarget);
	}


	function getMiningTarget() public view returns (uint) {
			return (miningTarget);
	}



	function getMiningMinted() public view returns (uint) {
		return tokensMinted;
	}

	function getCirculatingSupply() public view returns (uint) {
		return tokensMinted * 2 + AuctionsCT.totalAuctioned();
	}
	
	//21m coins total
	//reward begins at 150 and is cut in half every reward era (as tokens are mined)
	function getMiningReward() public view returns (uint) {
		//once we get half way thru the coins, only get 25 per block
		//every reward era, the reward amount halves.

		if(rewardEra < 3){
			return ( 50 * 10**18);
		}else{
			return ( 50 * 10**18)/( 2**(rewardEra - 2 ) );
		}
	}



	function getEpoch() public view returns (uint) {

		return epochCount ;

	}


	//help debug mining software
	function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {

		bytes32 digest =  keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));

		return digest;

	}



}

/*
*
* MIT License
* ===========
*
* Copyright (c) 2023 Zero Knowledge Bitcoin (zkBTC)
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.   
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*/

