//TESTNET Goerli ZKSYNC ERA VERSION https://testnet.zkBitcoin.org/ Just click around and find stuff for now
// Zero Knowledge Bitcoin - zkBitcoin (zkBTC) Token - Token and Mining Contract

//MUST FIX BEFORE LAUNCH Fix Start Time to normal
// startTime = 1705510800;
//
//MUST CHANGE reward_amount BACK in constructor
//		reward_amount = 50 * 10**18;  //Zero reward for first days to setup miners

/* must remove adjustDiff
//for testnet only
	function AdjustDiff(uint diff) public onlyOwner{
		require(diff<100000,"Low only");
		miningTarget=_MAXIMUM_TARGET.div(diff);
	}

//MUST REMOVE BOTH ABOVE FROM CONTRACT
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
// 100% of zkBTC Token is distributed using zkBitcoin Contract(this Contract) which distributes tokens to users by using Proof of work. Computers solve a complicated problem to gain tokens!
// 
// 100% Of the Token is distributed to the users! No dev fee or premine!
//
//
// Symbol: zkBTC
// Decimals: 18
//
// Total supply: 21,000,001.000000000000000000
//   =
// 21,000,000 Mined over 100+ years using Bitcoins Distrubtion halvings every ~4 years. Uses Proof-oF-Work to distribute the tokens. Public Miner is available see https://zkBitcoin.org 
//  
//
// 100% of the Ethereum from this contract goes to the PayMaster to pay for mints.
//
// No premine, dev cut, or advantage taken at launch. Public miner available at launch. 100% of the token is given away fairly over 100+ years using Bitcoins model!
//
// Send this contract any ERC20 token and it will become instantly mineable and able to distribute using proof-of-work!
// Donate this contract any NFT and we will also distribute it via Proof of Work to our miners!  
//  
//* 1 token were burned to create the LP pool.
//
// Credits: 0xBitcoin
//
// startTime = 1705510800;  //Date and time (GMT):  Wednesday, January 17, 2024 5:00:00 PM GMT openMining can then be called and mining will have rewards




pragma solidity ^0.8.11;

import "./draft-ERC20Permit.sol";	

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






contract zkBitcoin is Ownable, ERC20Permit {



////
// Minting Stuff Follows
////



	
    uint public targetTime = 10*60;
    uint public startTime = 1705510800;
    //Events
    using SafeMath2 for uint256;
    using ExtendedMath2 for uint;
    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
    event MegaMint(address indexed from, uint epochCount, bytes32 newChallengeNumber, uint NumberOfTokensMinted, uint256 TokenMultipler);

    // This mapping can be used to store combinations of challenge, user, and nonce which is the digest
    // to ensure they are not used again.
    mapping(bytes32 => bool) public usedCombinations;
    //ZKBITCOIN INITALIZE Start
	
    uint public constant _totalSupply = 21000000000000000000000000;
    uint public latestDifficultyPeriodStarted2 = block.timestamp; //BlockTime of last readjustment
    uint public latestDifficultyPeriodStarted = block.number; // for readjustments
    uint public epochCount = 0;//number of 'blocks' mined

    uint public _BLOCKS_PER_READJUSTMENT = 2048; // should be 2048 blocks more inline with BTC
    uint public  _MAXIMUM_TARGET = 2**234;
    //a little number
    uint public  _MINIMUM_TARGET =  2**16;
    uint public miningTarget = _MAXIMUM_TARGET.div(1);  //1 difficulty to start
  
    bytes32 public challengeNumber = blockhash(block.number - 1); //this is the next first challenge that will be used, challengeNumber is the main challenge to solve for
    mapping(bytes32 => bool) public usedChallenges;
    uint public rewardEra = 0;
    uint public maxSupplyForEra = (_totalSupply - _totalSupply.div( 2**(rewardEra + 1)));
    uint public reward_amount = 0;
    
    //Stuff for Functions
    uint public tokensMinted = 0;  //Tokens Minted only for Miners
    uint public epochOld = 0;  //Epoch count at each readjustment 
    // startup locks
    bool initeds = false;
    bool locked = false;

	constructor() ERC20("zkBitcoin", "zkBTC") ERC20Permit("zkBitcoin") {
		miningTarget = _MAXIMUM_TARGET.div(1); //easy difficulty u can solve but no reward until startTime and OpenMining is ran
//MUST CHANGE STARTTIME BACK
		startTime = block.timestamp;// 1705510800;  //Date and time (GMT):  Wednesday, January 17, 2024 5:00:00 PM GMT
//MUST CHANGE STARTTIME BACK
//MUST CHANGE reward_amount BACK
		reward_amount = 50 * 10**18;  //Zero reward for first days to setup miners
		rewardEra = 0;
		tokensMinted = 0;
//MUST CHANGE BACK EPOCHCOUNT TO 0
//MUST CHANGE BACK EPOCHCOUNT TO 0
		epochCount = 0;
		epochOld = 0;
		latestDifficultyPeriodStarted2 = block.timestamp;
		latestDifficultyPeriodStarted = block.number;	
		challengeNumber = blockhash(block.number -1); //generate a new one so we can start with a fresh
		usedChallenges[blockhash(block.number - 1)] = true;
		
	}


//for testnet only
	function AdjustDiff(uint diff) public onlyOwner{
//for testnet only
		require(diff<100000,"Low only");
		miningTarget=_MAXIMUM_TARGET.div(diff);
	}
	


	//Starts mining after a few days period for miners to setup is done
	function openMining() public returns (bool success) {
		require(!locked, "Only allowed to run once");
		locked = true;
		require(block.timestamp >= startTime && block.timestamp <= startTime + 60* 60 * 24* 7, "Must wait until after startTime (Jan 17th 2024 @ 5PM GMT) epcohTime 1705510800");
		challengeNumber = blockhash(block.number -1); //generate a new one so we can start fresh
		reward_amount = 50 * 10**18;
		rewardEra = 0;
		miningTarget = _MAXIMUM_TARGET.div(1);	
		
		usedChallenges[challengeNumber] = true;
		return true;
	}


	///
	// zkBitcoin Multi Minting
	///



	function multiMint_SameAddress(address mintToAddress, uint256 [] memory nonce) public {
	
        	uint NextEpochCount = blocksToReadjust();
		uint xLoop = 0;
		uint leftOver = 0;
		uint GoodLoops = 0;
		bytes32 localChallengeNumber=challengeNumber;
		uint localMiningTarget = miningTarget;
		uint xaa = 0;
		for (xLoop = 0; xLoop < nonce.length; xLoop++) {
		    bytes32 digest = keccak256(abi.encodePacked(localChallengeNumber, msg.sender, nonce[xLoop]));

		    if (usedCombinations[digest] || uint256(digest) >= localMiningTarget) {
		        continue;
		    }

		    GoodLoops = GoodLoops.add(1);
		    
	            usedCombinations[digest] = true;
		    if (GoodLoops == NextEpochCount) {
		    
			for(xaa = 0; xaa<=xLoop; xaa++){
				bytes32 digest2 = keccak256(abi.encodePacked(localChallengeNumber, msg.sender, nonce[xaa]));
				usedCombinations[digest2]=false;
			}
			break;
		    }

		  
		}

       	_startNewMiningEpoch_MultiMint_Mass_Epochs(GoodLoops);

		uint payout = GoodLoops * reward_amount;

		//if max supply for the era will be exceeded next reward round then enter the new era before that happens
		//59 is the final reward era, almost all tokens minted
		if( tokensMinted.add(payout) > maxSupplyForEra && rewardEra < 59)
		{
			rewardEra = rewardEra + 1;
			maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
			reward_amount = ( 50 * 10**18)/( 2**(rewardEra) );
			payout = payout.div(2);
		}
		_mint(mintToAddress, payout);

		emit Mint(msg.sender, payout, epochCount, localChallengeNumber );	
		
		tokensMinted = tokensMinted.add(payout);

	
	}
	


	//compatibility function
	function mint(uint256 nonce, bytes32 challenge_digest) public {
		mintTo(nonce, msg.sender);
	}
	

	function mintTo(uint256 nonce, address mintToAddress) public {
		bytes32 localChallengeNumber = challengeNumber;
		bytes32 digest =  keccak256(abi.encodePacked(localChallengeNumber, msg.sender, nonce));

		//the digest must be smaller than the target
		require(uint256(digest) < miningTarget, "Digest must be smaller than miningTarget");
		require(!usedCombinations[digest], "Must not been the first time this solve has been used");
		usedCombinations[digest] = true;
		
             	_startNewMiningEpoch();
	
        	_mint(mintToAddress, reward_amount);
		
		tokensMinted = tokensMinted.add(reward_amount);
		

		emit Mint(msg.sender, reward_amount, epochCount, localChallengeNumber);


	}


	

	function blocksFromReadjust() public view returns (uint256 blocks){
		blocks = (epochCount - epochOld);
		return blocks;
	}
	


	function blocksToReadjust() public view returns (uint blocks){
		
		uint256 blktimestamp = block.timestamp;
		uint local_BLOCKS_PER_READJUSTMENT = _BLOCKS_PER_READJUSTMENT;
		uint localEpochCount = epochCount;
		uint localEpochOld = epochOld;
		
		uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2;
		uint adjusDiffTargetTime = targetTime * local_BLOCKS_PER_READJUSTMENT;
		
		uint MultiplierOfTime = 3;
		if(localEpochCount - localEpochOld > 0){
			
			MultiplierOfTime = (((localEpochCount - localEpochOld - 1)/(local_BLOCKS_PER_READJUSTMENT/4))+3);
		}
		
		if(MultiplierOfTime == 6){
			MultiplierOfTime=5;
		}

		uint adjustFinal = adjusDiffTargetTime * MultiplierOfTime;

		if( TimeSinceLastDifficultyPeriod2 > adjustFinal)
		{
				blocks = local_BLOCKS_PER_READJUSTMENT/32 - ((localEpochCount - localEpochOld) % (local_BLOCKS_PER_READJUSTMENT/32));
				return (blocks);
		}else{
			    blocks = local_BLOCKS_PER_READJUSTMENT - ((localEpochCount - localEpochOld) % local_BLOCKS_PER_READJUSTMENT);
			    return (blocks);
		}
	
	}



	function seconds_Until_adjustmentSwitch() public view returns (uint secs){
		
		uint256 blktimestamp = block.timestamp;
		
		uint local_BLOCKS_PER_READJUSTMENT = _BLOCKS_PER_READJUSTMENT;
		uint adjusDiffTargetTime =local_BLOCKS_PER_READJUSTMENT * targetTime;
		uint localEpochCount = epochCount;
		uint localEpochOld = epochOld;
		
		uint MultiplierOfTime = 3;
		if(localEpochCount - localEpochOld > 0){
			
			MultiplierOfTime = (((localEpochCount - localEpochOld - 1)/(local_BLOCKS_PER_READJUSTMENT/4))+3);
		}
		
		if(MultiplierOfTime == 6){
			MultiplierOfTime=5;
		}

		uint adjustFinal = adjusDiffTargetTime * MultiplierOfTime;
		
		adjusDiffTargetTime =adjustFinal + latestDifficultyPeriodStarted2;
		if(adjusDiffTargetTime - blktimestamp <0){
			return 0;
		}
		return adjusDiffTargetTime - blktimestamp;
	
	}



	function _startNewMiningEpoch_MultiMint_Mass_Epochs(uint epochsz) internal {
	
		uint local_BLOCKS_PER_READJUSTMENT = _BLOCKS_PER_READJUSTMENT;
					
		uint localEpochCount = epochCount;
		uint localEpochOld = epochOld;
		
		uint totalruns = epochsz/(local_BLOCKS_PER_READJUSTMENT / 32);  	
		for(uint xy=0; xy<=totalruns; xy++){
			uint NextEpochCount = local_BLOCKS_PER_READJUSTMENT/32 - ((localEpochCount - localEpochOld) % (local_BLOCKS_PER_READJUSTMENT/32));
			if(epochsz >= NextEpochCount){
				
                     		localEpochCount +=NextEpochCount;
				epochsz=epochsz.sub(NextEpochCount);
					
				uint256 blktimestamp = block.timestamp;
				uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2;
				uint adjusDiffTargetTime = targetTime *  local_BLOCKS_PER_READJUSTMENT; 
				
				uint MultiplierOfTime = 3;
				if(localEpochCount - localEpochOld > 0){
					
					MultiplierOfTime = (((localEpochCount - localEpochOld - 1)/(local_BLOCKS_PER_READJUSTMENT/4))+3);
				}
				
				if(MultiplierOfTime == 6){
					MultiplierOfTime=5;
				}
				uint adjustFinal = adjusDiffTargetTime * MultiplierOfTime;
		
			
				if( TimeSinceLastDifficultyPeriod2 > adjustFinal || (localEpochCount - localEpochOld) % local_BLOCKS_PER_READJUSTMENT == 0) 
				{
					epochCount = localEpochCount;
					
					if(_totalSupply < tokensMinted){
						reward_amount = 0;
					}
					_reAdjustDifficulty();
					
					bytes32 localChallenge = blockhash(block.number - 1);
					
					require(usedChallenges[localChallenge] == false, "Must never have used this challenge before.");
					usedChallenges[localChallenge] = true;
					challengeNumber = localChallenge;
					
					localEpochOld =localEpochCount;
				}
			}
		}
		epochCount = epochsz+localEpochCount;

	}



	function _startNewMiningEpoch() internal {


		//if max supply for the era will be exceeded next reward round then enter the new era before that happens
		//59 is the final reward era, almost all tokens minted
		if( tokensMinted.add(reward_amount) > maxSupplyForEra && rewardEra < 59)
		{
			rewardEra = rewardEra + 1;
			maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
			reward_amount = ( 50 * 10**18)/( 2**(rewardEra ) );
		}


		uint local_BLOCKS_PER_READJUSTMENT = _BLOCKS_PER_READJUSTMENT;
		uint localEpochOld = epochOld;
		uint localEpochCount = epochCount.add(1);
		epochCount = localEpochCount;  
		
		//every so often, readjust difficulty
		if((localEpochCount - localEpochOld) % (local_BLOCKS_PER_READJUSTMENT / 32) == 0)
		{
			if(_totalSupply < tokensMinted){
				reward_amount = 0;
			}
			
			uint256 blktimestamp = block.timestamp;
			uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2;
			uint adjusDiffTargetTime = targetTime *  local_BLOCKS_PER_READJUSTMENT; 
			
			uint MultiplierOfTime = 3;
			if(localEpochCount - localEpochOld > 0){
				
				MultiplierOfTime = (((localEpochCount - localEpochOld - 1)/(local_BLOCKS_PER_READJUSTMENT/4))+3);
			}
			
			if(MultiplierOfTime == 6){
				MultiplierOfTime=5;
			}
		
			uint adjustFinal = adjusDiffTargetTime * MultiplierOfTime;
		
			
			if( TimeSinceLastDifficultyPeriod2 > adjustFinal || (localEpochCount - localEpochOld) % local_BLOCKS_PER_READJUSTMENT == 0) 
			{
				_reAdjustDifficulty();


				bytes32 localChallenge = blockhash(block.number - 1);
				require(usedChallenges[localChallenge] == false, "Must never have used this challenge before.");
				usedChallenges[localChallenge] = true;
				challengeNumber = localChallenge;
			}
		}

	}



	function reAdjustsToWhatDifficultyAVG(uint extraTime) public view returns (uint difficulty) {
		uint blktimestamp = block.timestamp;
		uint TimeSinceLastDifficultyPeriod2 = blktimestamp - latestDifficultyPeriodStarted2 + extraTime+1;
		uint epochTotal = epochCount - epochOld;
		uint adjusDiffTargetTime = targetTime * epochTotal+1;
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
		difficulty = _MAXIMUM_TARGET.div(miningTarget2);
			return difficulty;
	}


	function reAdjustsToWhatDifficulty_MaxPain_Difficulty() public view returns (uint difficulty) {
		difficulty = _MAXIMUM_TARGET.div(reAdjustsToWhatDifficulty_MaxPain_Target());
		return difficulty;
	}

	function reAdjustsToWhatDifficulty_MaxPain_Target() public view returns (uint target) {
		uint epochTotal = blocksToReadjust() + blocksFromReadjust();
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
		uint epochTotal =  blocksToReadjust() + blocksFromReadjust();
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
		RewardsAtTime = reward_amount;
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


	//this is a recent ethereum block hash
	function getChallengeNumber() public view returns (bytes32) {

		return challengeNumber;  

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
		return tokensMinted;
	}
	
	//21m coins total
	//reward begins at 150 and is cut in half every reward era (as tokens are mined)
	function getMiningReward() public view returns (uint) {
		//once we get half way thru the coins, only get 25 per block
		//every reward era, the reward amount halves.

		return ( 50 * 10**18)/( 2**(rewardEra) );
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

