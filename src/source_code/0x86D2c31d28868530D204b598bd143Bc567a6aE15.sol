// File: browser/CloneFactory.sol

/*
The MIT License (MIT)
Copyright (c) 2018 Murray Software, LLC.
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
contract CloneFactory { // Mystic implementation of eip-1167 - see https://eips.ethereum.org/EIPS/eip-1167
    function createClone(address target) internal returns (address result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
    }
}
// File: browser/WETHParty.sol


// File: contracts/oz/SafeMath.sol

pragma solidity 0.6.12;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;

        return c;
    }
}

library Address { // helper for address type - see openzeppelin-contracts/blob/master/contracts/utils/Address.sol
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
}

// File: contracts/oz/IERC20.sol

interface IERC20 { // brief interface for moloch erc20 token txs
    function balanceOf(address who) external view returns (uint256);
    
    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);
    
    function approve(address spender, uint256 amount) external returns (bool);
}

library SafeERC20 { // wrapper around erc20 token tx for non-standard contract - see openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol
    using Address for address;
    
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }
    
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }
    
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");
        (bool success, bytes memory returnData) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returnData.length > 0) { // return data is optional
            require(abi.decode(returnData, (bool)), "SafeERC20: erc20 operation did not succeed");
        }
    }
}

// File: contracts/oz/NewReentrancy.sol

contract ReentrancyGuard { // call wrapper for reentrancy check
    bool private _notEntered;

    function _initReentrancyGuard () internal {
        _notEntered = true;
    }

    modifier nonReentrant() {
        require(_notEntered, "ReentrancyGuard: reentrant call");

        _notEntered = false;

        _;

        _notEntered = true;
    }
}

// File: contracts/CloneParty.sol


    /*=====================
    WELCOME TO THE POOL Party vWETH
    
    **USE AT YOUR OWN RISK**
    Forked from an early version of the permissioned Mystic v2x by LexDAO 
    Special thanks to LexDAO for pushing the boundaries of Moloch mysticism 
    
    Developed by Peeps Democracy
    MIT License - But please use for good (ie. don't be a dick). 
    Definitely NO WARRANTIES.
    =======================*/


contract WETHParty is ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    
    /****************
    GOVERNANCE PARAMS
    ****************/
    uint256 public periodDuration; // default = 17280 = 4.8 hours in seconds (5 periods per day)
    uint256 public votingPeriodLength; // default = 35 periods (7 days)
    uint256 public gracePeriodLength; // default = 35 periods (7 days)
    uint256 public proposalDepositReward; // default = 10 ETH (~$1,000 worth of ETH at contract deployment)
    uint256 public depositRate; // rate to convert into shares during summoning time (default = 10000000000000000000 wei amt. // 100 wETH => 10 shares)
    uint256 public summoningTime; // needed to determine the current period
    uint256 public partyGoal; // savings goal for DAO 
    uint256 public dilutionBound;

    address public daoFee; // address where fees are sent
    address public depositToken; // deposit token contract reference; default = periodDuration
    address public wETH;
    address public idleToken; // = WETH address 
    
    bool public initialized;


    // HARD-CODED LIMITS
    // These numbers are quite arbitrary; they are small enough to avoid overflows when doing calculations
    // with periods or shares, yet big enough to not limit reasonable use cases.
     // default = 5
    uint256 constant MAX_INPUT = 10**36; // maximum bound for reasonable limits
    uint256 constant MAX_TOKEN_WHITELIST_COUNT = 100; // maximum number of whitelisted tokens

    // ***************
    // EVENTS
    // ***************
    event SummonComplete(address[] indexed summoners, address[] tokens, uint256 summoningTime, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDepositReward, uint256 partyGoal, uint256 depositRate);
    event MakeDeposit(address indexed memberAddress, uint256 tribute, uint256 mintedTokens, uint256 indexed shares, uint8 goalHit);
    event ProcessAmendGovernance(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass, address newToken, address newIdle, uint256 newPartyGoal, uint256 newDepositRate);    
    event SubmitProposal(address indexed applicant, uint256 sharesRequested, uint256 lootRequested, uint256 tributeOffered, address tributeToken, uint256 paymentRequested, address paymentToken, bytes32 details, bool[8] flags, uint256 proposalId, address indexed delegateKey, address indexed memberAddress);
    event SponsorProposal(address indexed sponsor, address indexed memberAddress, uint256 proposalId, uint256 proposalIndex, uint256 startingPeriod);
    event SubmitVote(uint256 proposalId, uint256 indexed proposalIndex, address indexed delegateKey, address indexed memberAddress, uint8 uintVote);
    event ProcessProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
    event ProcessGuildKickProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
    event Ragequit(address indexed memberAddress, uint256 sharesToBurn, uint256 lootToBurn);
    event TokensCollected(address indexed token, uint256 amountToCollect);
    event CancelProposal(uint256 indexed proposalId, address applicantAddress);
    event UpdateDelegateKey(address indexed memberAddress, address newDelegateKey);
    event WithdrawEarnings(address indexed memberAddress, address idleToken, uint256 earningsToUser, address depositToken);
    event Withdraw(address indexed memberAddress, address token, uint256 amount);

    // *******************
    // INTERNAL ACCOUNTING
    // *******************

    uint8 public goalHit; // tracks whether goal has been hit
    uint256 public proposalCount; // total proposals submitted
    uint256 public totalShares; // total shares across all members
    uint256 public totalLoot; // total loot across all members
    uint256 public totalDeposits; //track deposits made for goal and peg for earnings 


    address public constant GUILD = address(0xdead);
    address public constant ESCROW = address(0xbeef);
    address public constant TOTAL = address(0xbabe);
    mapping(address => mapping(address => uint256)) public userTokenBalances; // userTokenBalances[userAddress][tokenAddress]

    enum Vote {
        Null, // default value, counted as abstention
        Yes,
        No
    }

    struct Member {
        uint256 shares; // the # of voting shares assigned to this member
        uint256 loot; // the loot amount available to this member (combined with shares on ragequit)
        uint256 iTB; // WETH Balance
        uint256 iTW; // WETH withdrawals
        uint256 iVal; // base value off which earnings are calculated
        uint256 highestIndexYesVote; // highest proposal index # on which the member voted YES
        bool jailed; // set to proposalIndex of a passing guild kick proposal for this member, prevents voting on and sponsoring proposals
        bool exists; // always true once a member has been created
    }

    struct Proposal {
        address applicant; // the applicant who wishes to become a member - this key will be used for withdrawals (doubles as guild kick target for gkick proposals)
        address proposer; // the account that submitted the proposal (can be non-member)
        address sponsor; // the member that sponsored the proposal (moving it into the queue)
        uint256 sharesRequested; // the # of shares the applicant is requesting
        uint256 lootRequested; // the amount of loot the applicant is requesting
        uint256 tributeOffered; // amount of tokens offered as tribute
        address tributeToken; // tribute token contract reference
        uint256 paymentRequested; // amount of tokens requested as payment
        address paymentToken; // payment token contract reference
        uint256 startingPeriod; // the period in which voting can start for this proposal
        uint256 yesVotes; // the total number of YES votes for this proposal
        uint256 noVotes; // the total number of NO votes for this proposal
        bool[8] flags; // [sponsored, processed, didPass, cancelled, guildkick, spending, member, action]
        bytes32 details; // proposal details to add context for members 
        uint256 maxTotalSharesAndLootAtYesVote; // the maximum # of total shares encountered at a yes vote on this proposal
        mapping(address => Vote) votesByMember; // the votes on this proposal by each member
    }

    mapping(address => bool) public tokenWhitelist;
    address[] public approvedTokens;

    mapping(address => bool) public proposedToKick;

    mapping(address => Member) public members;
    address[] public memberList;

    mapping(uint256 => Proposal) public proposals;
    uint256[] public proposalQueue;
    mapping(uint256 => bytes) public actions; // proposalId => action data

    
    /******************
    SUMMONING FUNCTIONS
    ******************/
    function init(
        address[] calldata _founders,
        address[] calldata _approvedTokens,
        address _daoFee,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _proposalDepositReward,
        uint256 _depositRate,
        uint256 _partyGoal,
        uint256 _dilutionBound
    ) external {
        require(!initialized, "initialized");
        initialized = true;
        require(_periodDuration > 0, "_periodDuration zeroed");
        require(_votingPeriodLength > 0, "_votingPeriodLength zeroed");
        require(_votingPeriodLength <= MAX_INPUT, "_votingPeriodLength maxed");
        require(_gracePeriodLength <= MAX_INPUT, "_gracePeriodLength maxed");
        require(_approvedTokens.length > 0, "need token");
        
        depositToken = _approvedTokens[0];
        wETH = _approvedTokens[0];
        idleToken = _approvedTokens[0]; // Same address as WETH
        
        // NOTE: move event up here, avoid stack too deep if too many approved tokens
        emit SummonComplete(_founders, _approvedTokens, now, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDepositReward, _depositRate, _partyGoal);
        
        for (uint256 i = 0; i < _approvedTokens.length; i++) {
            require(!tokenWhitelist[_approvedTokens[i]], "token duplicated");
            tokenWhitelist[_approvedTokens[i]] = true;
            approvedTokens.push(_approvedTokens[i]);
        }
        
         for (uint256 i = 0; i < _founders.length; i++) {
             _addFounder(_founders[i]);
         }
        
        daoFee = _daoFee;
        periodDuration = _periodDuration;
        votingPeriodLength = _votingPeriodLength;
        gracePeriodLength = _gracePeriodLength;
        proposalDepositReward = _proposalDepositReward;
        depositRate = _depositRate;
        partyGoal = _partyGoal;
        summoningTime = now;
        goalHit = 0;
        dilutionBound = _dilutionBound;
        
        _initReentrancyGuard();
    }
    
    
    function _addFounder(address founder) internal {
            members[founder] = Member(0, 0, 0, 0, 0, 0, false, true);
            memberList.push(founder);
    }
    
    // Can also be used to upgrade the idle contract, but not switch to new DeFi token (ie. iDAI to iUSDC)
     function _setIdle(address _wETH) internal {
         wETH = _wETH;
         idleToken = _wETH;
     }
    

     /*****************
    PROPOSAL FUNCTIONS
    *****************/
    function submitProposal(
        address applicant,
        uint256 tributeOffered,
        uint256 sharesRequested,
        uint256 lootRequested,
        uint256 paymentRequested,
        uint256 flagNumber,
        address tributeToken,
        address paymentToken,
        bytes32 details
    ) public payable nonReentrant returns (uint256 proposalId) {
        require(sharesRequested.add(lootRequested) <= MAX_INPUT, "shares maxed");
        if(flagNumber != 7){
            require(tokenWhitelist[tributeToken] && tokenWhitelist[paymentToken], "tokens not whitelisted");
            // collect tribute from proposer and store it in the Moloch until the proposal is processed
            if (msg.value > 0) {
                require(tributeToken == wETH && msg.value == tributeOffered, "!ethBalance");
                (bool success,) = wETH.call{value: msg.value}("");
                require(success, "!ethCall");
                IERC20(wETH).safeTransfer(address(this), msg.value);
            } else {
                IERC20(tributeToken).safeTransferFrom(msg.sender, address(this), tributeOffered);
            }
        unsafeAddToBalance(ESCROW, tributeToken, tributeOffered);
        }
        require(applicant != address(0), "applicant cannot be 0");
        require(members[applicant].jailed == false, "applicant jailed");
        require(flagNumber != 0 || flagNumber != 1 || flagNumber != 2 || flagNumber != 3, "flag must be 4 - guildkick, 5 - spending, 6 - membership, 7 - governance");
        
        // collect deposit from proposer
        require(IERC20(depositToken).transferFrom(msg.sender, address(this), proposalDepositReward), "proposal deposit failed");
        unsafeAddToBalance(ESCROW, paymentToken, proposalDepositReward);

        
        // check whether pool goal is met before allowing spending proposals
        if(flagNumber == 5) {
            require(goalHit == 1, "goal not met yet");
        }
        
         if(flagNumber == 6) {
            require(paymentRequested == 0 || goalHit == 1, "goal not met yet");
        }
        
        bool[8] memory flags; // [sponsored, processed, didPass, cancelled, guildkick, spending, member, governance]
        flags[flagNumber] = true;
        
        if(flagNumber == 4) {
            _submitProposal(applicant, 0, 0, 0, address(0), 0, address(0), details, flags);
        } 
        
        else if (flagNumber == 7) { // for amend governance use sharesRequested for partyGoal, tributeRequested for depositRate, tributeToken for new Token, paymentToken for new WETHaddress
            _submitProposal(applicant, 0, 0, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags);
        } 
        
        else {
        
        _submitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags);

        }
        // NOTE: Should approve the 0x address as a blank token for guildKick proposals where there's no token. 
        return proposalCount - 1; // return proposalId - contracts calling submit might want it
    }
    

   function _submitProposal(
        address applicant,
        uint256 sharesRequested,
        uint256 lootRequested,
        uint256 tributeOffered,
        address tributeToken,
        uint256 paymentRequested,
        address paymentToken,
        bytes32 details,
        bool[8] memory flags
    ) internal {
        Proposal memory proposal = Proposal({
            applicant : applicant,
            proposer : msg.sender,
            sponsor : address(0),
            sharesRequested : sharesRequested,
            lootRequested : lootRequested,
            tributeOffered : tributeOffered,
            tributeToken : tributeToken,
            paymentRequested : paymentRequested,
            paymentToken : paymentToken,
            startingPeriod : 0,
            yesVotes : 0,
            noVotes : 0,
            flags : flags,
            details : details,
            maxTotalSharesAndLootAtYesVote : 0
        });
        
        proposals[proposalCount] = proposal;
        address memberAddress = msg.sender;
        // NOTE: argument order matters, avoid stack too deep
        emit SubmitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags, proposalCount, msg.sender, memberAddress);
        proposalCount += 1;
    }

    function sponsorProposal(uint256 proposalId) public nonReentrant  {

        Proposal storage proposal = proposals[proposalId];

        require(proposal.proposer != address(0), 'proposal must have been proposed');
        require(!proposal.flags[0], "proposal has already been sponsored");
        require(!proposal.flags[3], "proposal has been cancelled");
        require(members[proposal.applicant].jailed == false, "proposal applicant must not be jailed");

        if (proposal.tributeOffered > 0 && userTokenBalances[GUILD][proposal.tributeToken] == 0) {
            require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, 'cannot sponsor more tribute proposals for new tokens - guildbank is full');
        }

         if (proposal.flags[4]) {
            require(!proposedToKick[proposal.applicant], 'already proposed to kick');
            proposedToKick[proposal.applicant] = true;
        }

        // compute startingPeriod for proposal
        uint256 startingPeriod = max(
            getCurrentPeriod(),
            proposalQueue.length == 0 ? 0 : proposals[proposalQueue[proposalQueue.length.sub(1)]].startingPeriod
        ).add(1);

        proposal.startingPeriod = startingPeriod;

        address memberAddress = msg.sender;
        proposal.sponsor = memberAddress;

        proposal.flags[0] = true; // sponsored

        // append proposal to the queue
        proposalQueue.push(proposalId);
        
        emit SponsorProposal(msg.sender, memberAddress, proposalId, proposalQueue.length.sub(1), startingPeriod);
    }


    function submitVote(uint256 proposalIndex, uint8 uintVote) public nonReentrant {
        require(members[msg.sender].exists == true);
        Member storage member = members[msg.sender];

        require(proposalIndex < proposalQueue.length, "proposal does not exist");
        Proposal storage proposal = proposals[proposalQueue[proposalIndex]];

        require(uintVote < 3, "must be less than 3, 1 = yes, 2 = no");
        Vote vote = Vote(uintVote);

        require(getCurrentPeriod() >= proposal.startingPeriod, "voting period has not started");
        require(!hasVotingPeriodExpired(proposal.startingPeriod), "proposal voting period has expired");
        require(proposal.votesByMember[msg.sender] == Vote.Null, "member has already voted");
        require(vote == Vote.Yes || vote == Vote.No, "vote must be either Yes or No");

        proposal.votesByMember[msg.sender] = vote;

        if (vote == Vote.Yes) {
            proposal.yesVotes = proposal.yesVotes.add(member.shares);

            // set highest index (latest) yes vote - must be processed for member to ragequit
            if (proposalIndex > member.highestIndexYesVote) {
                member.highestIndexYesVote = proposalIndex;
            }

            // set maximum of total shares encountered at a yes vote - used to bound dilution for yes voters
            if (totalShares.add(totalLoot) > proposal.maxTotalSharesAndLootAtYesVote) {
                proposal.maxTotalSharesAndLootAtYesVote = totalShares.add(totalLoot);
            }

        } else if (vote == Vote.No) {
            proposal.noVotes = proposal.noVotes.add(member.shares);
        }
     
        emit SubmitVote(proposalQueue[proposalIndex], proposalIndex, msg.sender, msg.sender, uintVote);
    }

    function processProposal(uint256 proposalIndex) public nonReentrant {
        _validateProposalForProcessing(proposalIndex);

        uint256 proposalId = proposalQueue[proposalIndex];
        Proposal storage proposal = proposals[proposalId];
        
        //[sponsored -0 , processed -1, didPass -2, cancelled -3, guildkick -4, spending -5, member -6, governance -7]
        require(!proposal.flags[4] && !proposal.flags[7], "not standard proposal"); 

        proposal.flags[1] = true; // processed

        bool didPass = _didPass(proposalIndex);

        // Make the proposal fail if the new total number of shares and loot exceeds the limit
        // Make the proposal fail if the new total number of shares and loot exceeds the limit
        if (totalShares.add(totalLoot).add(proposal.sharesRequested).add(proposal.lootRequested) > MAX_INPUT) {
            didPass = false;
        }

        // Make the proposal fail if it is requesting more tokens as payment than the available guild bank balance
        if (proposal.paymentRequested > userTokenBalances[GUILD][proposal.paymentToken]) {
            didPass = false;
        }

        // PROPOSAL PASSED
        if (didPass) {
            proposal.flags[2] = true; // didPass

            // if the applicant is already a member, add to their existing shares & loot
            if (members[proposal.applicant].exists) {
                members[proposal.applicant].shares = members[proposal.applicant].shares.add(proposal.sharesRequested);
                members[proposal.applicant].loot = members[proposal.applicant].loot.add(proposal.lootRequested);
               
               // update member iTB and iVal
                if(proposal.sharesRequested > 0 || proposal.lootRequested > 0){
                    members[proposal.applicant].iTB += proposal.tributeOffered;
                    members[proposal.applicant].iVal += proposal.tributeOffered;
                }
                
            // the applicant is a new member, create a new record for them
            } else {
                members[proposal.applicant] = Member(proposal.sharesRequested, proposal.lootRequested, proposal.tributeOffered, 0, proposal.tributeOffered, 0, false, true);
                memberList.push(proposal.applicant);
            }

            // mint new shares & loot
            totalShares = totalShares.add(proposal.sharesRequested);
            totalLoot = totalLoot.add(proposal.lootRequested);

            unsafeInternalTransfer(ESCROW, GUILD, proposal.tributeToken, proposal.tributeOffered);
            unsafeInternalTransfer(GUILD, proposal.applicant, proposal.paymentToken, proposal.paymentRequested);
            
            // update earningsPeg for membership proposals and spending proposals
            if (proposal.sharesRequested > 0 || proposal.lootRequested > 0) {
                totalDeposits += proposal.tributeOffered;
            }
            
            if (proposal.paymentRequested > 0 && proposal.sharesRequested < 1) {
                totalDeposits -= proposal.paymentRequested;
            }

        // PROPOSAL FAILED
        } else {
            // return all tokens to the proposer (not the applicant, because funds come from proposer)
            unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
        }

        _returnDeposit();
        
        emit ProcessProposal(proposalIndex, proposalId, didPass);
    }


    function processGuildKickProposal(uint256 proposalIndex) public nonReentrant {
        _validateProposalForProcessing(proposalIndex);

        uint256 proposalId = proposalQueue[proposalIndex];
        Proposal storage proposal = proposals[proposalId];

        require(proposal.flags[4], "not guild kick");

        proposal.flags[1] = true; //[sponsored, processed, didPass, cancelled, guildkick, spending, member]

        bool didPass = _didPass(proposalIndex);

        if (didPass) {
            proposal.flags[2] = true; // didPass
            Member storage member = members[proposal.applicant];
            member.jailed == true;

            // transfer shares to loot
            member.loot = member.loot.add(member.shares);
            totalShares = totalShares.sub(member.shares);
            totalLoot = totalLoot.add(member.shares);
            member.shares = 0; // revoke all shares
        }

        proposedToKick[proposal.applicant] = false;

        _returnDeposit();

        emit ProcessGuildKickProposal(proposalIndex, proposalId, didPass);
    }
    
    function processAmendGovernance(uint256 proposalIndex) public nonReentrant {
        _validateProposalForProcessing(proposalIndex);

        uint256 proposalId = proposalQueue[proposalIndex];
        Proposal storage proposal = proposals[proposalId];

        require(proposal.flags[7], "not gov amendment");

        proposal.flags[1] = true; //[sponsored, processed, didPass, cancelled, guildkick, spending, member]

        bool didPass = _didPass(proposalIndex);

            if (didPass) {
                proposal.flags[2] = true; // didPass
            
            // Updates PartyGoal
            if(proposal.tributeOffered > 0){
                partyGoal = proposal.tributeOffered;
            }
            
            // Update depositRate
            if(proposal.paymentRequested > 0){
                depositRate = proposal.paymentRequested;
            }
            
            // Adds token to whitelist and approvedTokens
            if(proposal.tributeToken != depositToken) {
                require(!tokenWhitelist[proposal.tributeToken], "cannot already have whitelisted the token");
                require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, "too many tokens already");
                approvedTokens.push(proposal.tributeToken);
                tokenWhitelist[address(proposal.tributeToken)] = true;
            }
            // Used to upgrade wETH address
            if(proposal.paymentToken != address(wETH) && proposal.paymentToken != depositToken) {
                _setIdle(proposal.paymentToken);
                approvedTokens.push(proposal.paymentToken);
                tokenWhitelist[address(proposal.paymentToken)] = true;
            }
        }

        _returnDeposit();
        
        emit ProcessAmendGovernance(proposalIndex, proposalId, didPass, proposal.tributeToken, proposal.paymentToken, proposal.tributeOffered, proposal.paymentRequested);
    }
    

    function _didPass(uint256 proposalIndex) internal view returns (bool didPass) {
        Proposal memory proposal = proposals[proposalQueue[proposalIndex]];

        didPass = proposal.yesVotes > proposal.noVotes;

        // Make the proposal fail if the dilutionBound is exceeded
        if ((totalShares.add(totalLoot)).mul(dilutionBound / 100) < proposal.maxTotalSharesAndLootAtYesVote) {
            didPass = false;
        }

        // Make the proposal fail if the applicant is jailed
        // - for standard proposals, we don't want the applicant to get any shares/loot/payment
        // - for guild kick proposals, we should never be able to propose to kick a jailed member (or have two kick proposals active), so it doesn't matter
        if (members[proposal.applicant].jailed == true) {
            didPass = false;
        }

        return didPass;
    }
    

    function _validateProposalForProcessing(uint256 proposalIndex) internal view {
        require(proposalIndex < proposalQueue.length, "no such proposal");
        Proposal memory proposal = proposals[proposalQueue[proposalIndex]];

        require(getCurrentPeriod() >= proposal.startingPeriod.add(votingPeriodLength).add(gracePeriodLength), "proposal not ready");
        require(proposal.flags[1] == false, "proposal has already been processed");
        require(proposalIndex == 0 || proposals[proposalQueue[proposalIndex.sub(1)]].flags[1], "previous proposal unprocessed");
    }

    function _returnDeposit() internal {
        unsafeInternalTransfer(ESCROW, msg.sender, depositToken, proposalDepositReward);
    }

    function ragequit() public nonReentrant {
        /* 
        @Dev - to simplify accounting had to set ragequit to an all or nothing proposition.
        Since members who ragequit can always redeposit after the ragequit, it should not 
        be to limiting until a better system can be implemented in ModMol v3. 
        */
        
        require(members[msg.sender].shares.add(members[msg.sender].loot) > 0, "only users with balances can ragequit");
        _ragequit(msg.sender);
    }

    function _ragequit(address memberAddress) internal returns (uint256) {
        uint256 initialTotalSharesAndLoot = totalShares.add(totalLoot);

        Member storage member = members[memberAddress];

        require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");

        // set member shares and loot to 
        uint256 sharesToBurn = member.shares;
        uint256 lootToBurn = member.loot;
        uint256 sharesAndLootToBurn = sharesToBurn.add(lootToBurn);

        // burn shares and loot (obviously sets member shares and loot back to 0)
        member.shares = member.shares.sub(sharesToBurn);
        member.loot = member.loot.sub(lootToBurn);
        totalShares = totalShares.sub(sharesToBurn);
        totalLoot = totalLoot.sub(lootToBurn);
        
        uint256 feeEligible = fairShare(userTokenBalances[GUILD][wETH], sharesAndLootToBurn, initialTotalSharesAndLoot).sub(member.iTB);
        subFees(GUILD, feeEligible);

        for (uint256 i = 0; i < approvedTokens.length; i++) {
            uint256 amountToRagequit = fairShare(userTokenBalances[GUILD][approvedTokens[i]], sharesAndLootToBurn, initialTotalSharesAndLoot);
            if (amountToRagequit > 0) { // gas optimization to allow a higher maximum token limit
                userTokenBalances[GUILD][approvedTokens[i]] -= amountToRagequit;
                userTokenBalances[memberAddress][approvedTokens[i]] += amountToRagequit;
                totalDeposits -= amountToRagequit;
                // Only runs guild bank adjustment if member has withdrawn tokens.
                // Otherwise, adjustment would end up costing member their fair share
                    
                 if(member.iTW > 0) {
                    // @Dev - SafeMath wasn't working here. 
                     uint256 iAdj = member.iTW;
                     if(iAdj > 0) {
                        unsafeInternalTransfer(memberAddress, GUILD, address(wETH), iAdj);
                     }
                 }
                 
                // Reset member-specific internal accting 
                member.iTB = 0;
                member.iTW = 0;
                member.iVal = 0;
            }
        }
        emit Ragequit(msg.sender, sharesToBurn, lootToBurn);  
    }

    function ragekick(address memberToKick) public nonReentrant {
        Member storage member = members[memberToKick];

        require(member.jailed != true, "member not jailed");
        require(member.loot > 0, "member must have loot"); // note - should be impossible for jailed member to have shares
        require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");

        _ragequit(memberToKick);
    }
    
    function withdrawEarnings(address memberAddress, uint256 amount) external nonReentrant {
        uint256 initialTotalSharesAndLoot = totalShares.add(totalLoot);
        
        Member storage member = members[memberAddress];
        uint256 sharesM = member.shares;
        uint256 lootM = member.loot;
        uint256 sharesAndLootM = sharesM.add(lootM);
        
        require(member.exists == true, "not member");
        require(address(msg.sender) == memberAddress, "can only be called by member");

        //Calculates if user's share of wETH in the pool is creater than their deposit amts (used for potential earnings)
        uint256 iTBVal = fairShare(userTokenBalances[GUILD][wETH], sharesAndLootM, initialTotalSharesAndLoot);
        uint256 iBase = totalDeposits.div(initialTotalSharesAndLoot).mul(sharesAndLootM);
        require(iTBVal.sub(iBase) >= amount, "not enough earnings to redeem this many tokens");
        
        uint256 earningsToUser = subFees(GUILD, amount);

        // Accounting updates
        member.iTW += earningsToUser;
        member.iTB -= earningsToUser;
        totalDeposits -= earningsToUser;
        unsafeInternalTransfer(GUILD, memberAddress, address(wETH), earningsToUser);
        
        emit WithdrawEarnings(msg.sender, address(wETH), earningsToUser, depositToken);
    }
    

    function withdrawBalance(address token, uint256 amount) public nonReentrant {
        _withdrawBalance(token, amount);
    }
    

    function withdrawBalances(address[] memory tokens, uint256[] memory amounts, bool max) public nonReentrant {
        require(tokens.length == amounts.length, "tokens + amounts arrays must match");

        for (uint256 i=0; i < tokens.length; i++) {
            uint256 withdrawAmount = amounts[i];
            if (max) { // withdraw the maximum balance
                withdrawAmount = userTokenBalances[msg.sender][tokens[i]];
            }

            _withdrawBalance(tokens[i], withdrawAmount);
        }
    }
    
    
    function _withdrawBalance(address token, uint256 amount) internal {
        require(userTokenBalances[msg.sender][token] >= amount, "insufficient balance");
        unsafeSubtractFromBalance(msg.sender, token, amount);
        require(IERC20(token).transfer(msg.sender, amount), "transfer failed");
        emit Withdraw(msg.sender, token, amount);
    }
    

    // NOTE: gives the DAO the ability to collect payments and also recover tokens just sent to DAO address (if whitelisted)
    function collectTokens(address token) external {
        uint256 amountToCollect = IERC20(token).balanceOf(address(this)) - userTokenBalances[TOTAL][token];
        // only collect if 1) there are tokens to collect and 2) token is whitelisted
        require(amountToCollect > 0, "no tokens");
        require(tokenWhitelist[token], "not whitelisted");
        
        unsafeAddToBalance(GUILD, token, amountToCollect);

        emit TokensCollected(token, amountToCollect);
    }
    

    function cancelProposal(uint256 proposalId) public nonReentrant {
        Proposal storage proposal = proposals[proposalId];
        require(getCurrentPeriod() <= proposal.startingPeriod, "voting period has already started");
        require(!proposal.flags[3], "proposal already cancelled");
        require(msg.sender == proposal.proposer, "only proposer cancels");

        proposal.flags[3] = true; // cancelled
        
        unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
        emit CancelProposal(proposalId, msg.sender);
    }

    // can only ragequit if the latest proposal you voted YES on has been processed
    function canRagequit(uint256 highestIndexYesVote) public view returns (bool) {
        if(proposalQueue.length == 0){
            return true;
        } else {
            require(highestIndexYesVote < proposalQueue.length, "no such proposal");
            return proposals[proposalQueue[highestIndexYesVote]].flags[0];
        }
    }

    function hasVotingPeriodExpired(uint256 startingPeriod) public view returns (bool) {
        return getCurrentPeriod() >= startingPeriod.add(votingPeriodLength);
    }
    
    /***************
    GETTER FUNCTIONS
    ***************/
    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x : y;
    }

    function getCurrentPeriod() public view returns (uint256) {
        return now.sub(summoningTime).div(periodDuration);
    }

    function getProposalQueueLength() public view returns (uint256) {
        return proposalQueue.length;
    }

    function getProposalFlags(uint256 proposalId) public view returns (bool[8] memory) {
        return proposals[proposalId].flags;
    }

    function getUserTokenBalance(address user, address token) public view returns (uint256) {
        return userTokenBalances[user][token];
    }

    function getMemberProposalVote(address memberAddress, uint256 proposalIndex) public view returns (Vote) {
        require(members[memberAddress].exists, "no such member");
        require(proposalIndex < proposalQueue.length, "unproposed");
        return proposals[proposalQueue[proposalIndex]].votesByMember[memberAddress];
    }

    function getTokenCount() public view returns (uint256) {
        return approvedTokens.length;
    }

    /***************
    HELPER FUNCTIONS
    ***************/
    function getUserEarnings(uint256 amount) public returns (uint256) {
        uint256 initialTotalSharesAndLoot = totalShares.add(totalLoot);
        
        Member storage member = members[msg.sender];
        uint256 sharesM = member.shares;
        uint256 lootM = member.loot;
        uint256 sharesAndLootM = sharesM.add(lootM);
        
        uint256 iTBVal = fairShare(userTokenBalances[GUILD][wETH], sharesAndLootM, initialTotalSharesAndLoot);
        uint256 iBase = totalDeposits.div(initialTotalSharesAndLoot).mul(sharesAndLootM);
        
        uint256 earnings = iTBVal.sub(iBase);

        return earnings;
    }
    
    
    function getIdleValue(uint256 amount) public view returns (uint256){
        return 0;
    }
    

    function subFees(address holder, uint256 amount) internal returns (uint256) {
        uint256 poolFees = amount.div(uint256(100).div(2)); // 2% fee on earnings
        unsafeInternalTransfer(holder, daoFee, address(wETH), poolFees);
        return amount.sub(poolFees);
    }

    function makeDeposit(uint256 amount) external payable nonReentrant {
        require(members[msg.sender].exists == true, 'must be member to deposit shares');
        require(amount == msg.value);
        
        (bool success, ) = wETH.call{value: msg.value}("");
        require(success, "!ethCall");
        IERC20(wETH).safeTransfer(address(this), msg.value);
         
        amount = msg.value;
        uint256 shares = amount.div(depositRate);
        members[msg.sender].shares += shares;
        require(members[msg.sender].shares <= partyGoal.div(depositRate).div(2), "can't take over 50% of the shares w/o a proposal");
        totalShares += shares;
        
        depositToIdle(msg.sender, amount, shares);
    }
    
    // @Dev use better naming conventions next time (actually just updates internal accting)
    function depositToIdle(address depositor, uint256 amount, uint256 shares) internal {
        require(amount != 0, "no tokens to deposit");
        totalDeposits += amount;
        uint256 mintedTokens = amount;
        
        // Update internal accounting
        members[depositor].iTB += amount;
        members[depositor].iVal += amount;
        unsafeAddToBalance(GUILD, wETH, mintedTokens);
        
        // Checks to see if goal has been reached with this deposit
         goalHit = checkGoal();
        
        emit MakeDeposit(depositor, amount, mintedTokens, shares, goalHit);
    }
    
    function checkGoal() public returns (uint8) {
        uint256 daoFunds = getUserTokenBalance(GUILD, wETH);

        if(daoFunds >= partyGoal){
            return goalHit = 1;
        } else {
            return goalHit = 0;
        }
    }
    
    
    function unsafeAddToBalance(address user, address token, uint256 amount) internal {
        userTokenBalances[user][token] += amount;
        userTokenBalances[TOTAL][token] += amount;
    }

    function unsafeSubtractFromBalance(address user, address token, uint256 amount) internal {
        userTokenBalances[user][token] -= amount;
        userTokenBalances[TOTAL][token] -= amount;
    }

    function unsafeInternalTransfer(address from, address to, address token, uint256 amount) internal {
        unsafeSubtractFromBalance(from, token, amount);
        unsafeAddToBalance(to, token, amount);
    }

    function fairShare(uint256 balance, uint256 shares, uint256 totalSharesAndLoot) internal pure returns (uint256) {
        require(totalSharesAndLoot != 0);

        if (balance == 0) { return 0; }

        uint256 prod = balance * shares;

        if (prod / balance == shares) { // no overflow in multiplication above?
            return prod / totalSharesAndLoot;
        }

        return (balance / totalSharesAndLoot) * shares;
    } 
}

// File: browser/WETHpartyStarter.sol

// Kovan Weth Wrapper 0xd0A1E359811322d97991E03f863a0C30C2cF029C
// Mainnet Weth Wrapper 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2

//"SPDX-License-Identifier: MIT"

pragma solidity 0.6.12;



// ["0xd0A1E359811322d97991E03f863a0C30C2cF029C","0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa"] kWETH, kDAI
// ["0x0bA6142464b224abE3845b652B65162dBdF2A285","0x7136fbDdD4DFfa2369A9283B6E90A040318011Ca","0x3792acDf2A8658FBaDe0ea70C47b89cB7777A5a5"] test members
// 1000000000000000000

contract WETHpartyStarter is CloneFactory {
    
    address public template;
    
    constructor (address _template) public {
        template = _template;
    }

    
    event PartyStarted(address indexed pty, address[] _founders, address[] _approvedTokens, address _daoFees, uint256 _periodDuration, uint256 _votingPeriodLength, uint256 _gracePeriodLength, uint256 _proposalDepositReward, uint256 _depositRate, uint256 _partyGoal, uint256 summoningTime, uint256 _dilutionBound);

    function startParty(
        address[] memory _founders,
        address[] memory _approvedTokens, //deposit token in 0, WETH in 0
        address _daoFees,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _proposalDepositReward,
        uint256 _depositRate,
        uint256 _partyGoal,
        uint256 _dilutionBound
    ) public returns (address) {
       WETHParty pty = WETHParty(createClone(template));
      
       pty.init(
            _founders,
            _approvedTokens,
            _daoFees,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _proposalDepositReward,
            _depositRate,
            _partyGoal,
            _dilutionBound);
        
        emit PartyStarted(address(pty), _founders, _approvedTokens, _daoFees, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDepositReward, _depositRate, _partyGoal, now, _dilutionBound);
        return address(pty);
    }
}