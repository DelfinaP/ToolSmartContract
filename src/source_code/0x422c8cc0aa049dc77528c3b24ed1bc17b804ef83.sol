{"IERC20.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.6.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller\u0027s account to `recipient`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller\u0027s tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender\u0027s allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n     * allowance mechanism. `amount` is then deducted from the caller\u0027s\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n"},"SafeMath.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.6.0;\n\n/**\n * @dev Wrappers over Solidity\u0027s arithmetic operations with added overflow\n * checks.\n *\n * Arithmetic operations in Solidity wrap on overflow. This can easily result\n * in bugs, because programmers usually assume that an overflow raises an\n * error, which is the standard behavior in high level programming languages.\n * `SafeMath` restores this intuition by reverting the transaction when an\n * operation overflows.\n *\n * Using this library instead of the unchecked operations eliminates an entire\n * class of bugs, so it\u0027s recommended to use it always.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity\u0027s `+` operator.\n     *\n     * Requirements:\n     *\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c \u003e= a, \"SafeMath: addition overflow\");\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity\u0027s `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity\u0027s `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b \u003c= a, errorMessage);\n        uint256 c = a - b;\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity\u0027s `*` operator.\n     *\n     * Requirements:\n     *\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        // Gas optimization: this is cheaper than requiring \u0027a\u0027 not being zero, but the\n        // benefit is lost if \u0027b\u0027 is also tested.\n        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n        if (a == 0) {\n            return 0;\n        }\n\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers. Reverts on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b \u003e 0, errorMessage);\n        uint256 c = a / b;\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * Reverts when dividing by zero.\n     *\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return mod(a, b, \"SafeMath: modulo by zero\");\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * Reverts with custom message when dividing by zero.\n     *\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b != 0, errorMessage);\n        return a % b;\n    }\n}\n"},"ServiceInterface.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.6.12;\n\ninterface ServiceInterface {\n  function isEntityActive(address entity) external view returns (bool);\n}\n"},"StrongPoolInterface.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.6.12;\n\ninterface StrongPoolInterface {\n  function mineFor(address miner, uint256 amount) external;\n}\n"},"Vote.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.6.12;\n\nimport \"./SafeMath.sol\";\nimport \"./IERC20.sol\";\nimport \"./StrongPoolInterface.sol\";\nimport \"./ServiceInterface.sol\";\n\ncontract Vote {\n    event Voted(\n        address indexed voter,\n        address indexed service,\n        address indexed entity,\n        uint256 amount\n    );\n    event RecalledVote(\n        address indexed voter,\n        address indexed service,\n        address indexed entity,\n        uint256 amount\n    );\n    event Claimed(address indexed claimer, uint256 amount);\n    event VotesAdded(address indexed miner, uint256 amount);\n    event VotesSubtracted(address indexed miner, uint256 amount);\n    event DelegateVotesChanged(\n        address indexed delegate,\n        uint256 previousBalance,\n        uint256 newBalance\n    );\n\n    using SafeMath for uint256;\n\n    StrongPoolInterface public strongPool;\n    IERC20 public strongToken;\n\n    bool public initDone;\n    address public admin;\n    address public pendingAdmin;\n    address public superAdmin;\n    address public pendingSuperAdmin;\n    address public parameterAdmin;\n\n    uint256 public rewardBalance;\n\n    uint256 public voterRewardPerBlockNumerator;\n    uint256 public voterRewardPerBlockDenominator;\n    uint256 public entityRewardPerBlockNumerator;\n    uint256 public entityRewardPerBlockDenominator;\n\n    mapping(address =\u003e uint96) public balances;\n    mapping(address =\u003e address) public delegates;\n\n    mapping(address =\u003e mapping(uint32 =\u003e uint32)) public checkpointsFromBlock;\n    mapping(address =\u003e mapping(uint32 =\u003e uint96)) public checkpointsVotes;\n    mapping(address =\u003e uint32) public numCheckpoints;\n\n    mapping(address =\u003e uint256) public voterVotesOut;\n    uint256 public totalVotesOut;\n\n    mapping(address =\u003e uint256) public serviceVotes;\n    mapping(address =\u003e mapping(address =\u003e uint256)) public serviceEntityVotes;\n    mapping(address =\u003e mapping(address =\u003e mapping(address =\u003e uint256)))\n        public voterServiceEntityVotes;\n\n    mapping(address =\u003e address[]) public voterServices;\n    mapping(address =\u003e mapping(address =\u003e uint256)) public voterServiceIndex;\n\n    mapping(address =\u003e mapping(address =\u003e address[]))\n        public voterServiceEntities;\n    mapping(address =\u003e mapping(address =\u003e mapping(address =\u003e uint256)))\n        public voterServiceEntityIndex;\n\n    mapping(address =\u003e uint256) public voterBlockLastClaimedOn;\n    mapping(address =\u003e mapping(address =\u003e uint256))\n        public serviceEntityBlockLastClaimedOn;\n\n    address[] public serviceContracts;\n    mapping(address =\u003e uint256) public serviceContractIndex;\n    mapping(address =\u003e bool) public serviceContractActive;\n\n    function init(\n        address strongTokenAddress,\n        address strongPoolAddress,\n        address adminAddress,\n        address superAdminAddress,\n        uint256 voterRewardPerBlockNumeratorValue,\n        uint256 voterRewardPerBlockDenominatorValue,\n        uint256 entityRewardPerBlockNumeratorValue,\n        uint256 entityRewardPerBlockDenominatorValue\n    ) public {\n        require(!initDone, \"init done\");\n        strongToken = IERC20(strongTokenAddress);\n        strongPool = StrongPoolInterface(strongPoolAddress);\n        admin = adminAddress;\n        superAdmin = superAdminAddress;\n        voterRewardPerBlockNumerator = voterRewardPerBlockNumeratorValue;\n        voterRewardPerBlockDenominator = voterRewardPerBlockDenominatorValue;\n        entityRewardPerBlockNumerator = entityRewardPerBlockNumeratorValue;\n        entityRewardPerBlockDenominator = entityRewardPerBlockDenominatorValue;\n        initDone = true;\n    }\n\n    // ADMIN\n    // *************************************************************************************\n    function updateParameterAdmin(address newParameterAdmin) public {\n        require(newParameterAdmin != address(0), \"zero\");\n        require(msg.sender == superAdmin);\n        parameterAdmin = newParameterAdmin;\n    }\n\n    function setPendingAdmin(address newPendingAdmin) public {\n        require(newPendingAdmin != address(0), \"zero\");\n        require(msg.sender == admin, \"not admin\");\n        pendingAdmin = newPendingAdmin;\n    }\n\n    function acceptAdmin() public {\n        require(\n            msg.sender == pendingAdmin \u0026\u0026 msg.sender != address(0),\n            \"not pendingAdmin\"\n        );\n        admin = pendingAdmin;\n        pendingAdmin = address(0);\n    }\n\n    function setPendingSuperAdmin(address newPendingSuperAdmin) public {\n        require(newPendingSuperAdmin != address(0), \"zero\");\n        require(msg.sender == superAdmin, \"not superAdmin\");\n        pendingSuperAdmin = newPendingSuperAdmin;\n    }\n\n    function acceptSuperAdmin() public {\n        require(\n            msg.sender == pendingSuperAdmin \u0026\u0026 msg.sender != address(0),\n            \"not pendingSuperAdmin\"\n        );\n        superAdmin = pendingSuperAdmin;\n        pendingSuperAdmin = address(0);\n    }\n\n    // SERVICE CONTRACTS\n    // *************************************************************************************\n    function addServiceContract(address contr) public {\n        require(contr != address(0), \"zero\");\n        require(\n            msg.sender == admin ||\n                msg.sender == parameterAdmin ||\n                msg.sender == superAdmin,\n            \"not an admin\"\n        );\n        if (serviceContracts.length != 0) {\n            uint256 index = serviceContractIndex[contr];\n            require(serviceContracts[index] != contr, \"exists\");\n        }\n        uint256 len = serviceContracts.length;\n        serviceContractIndex[contr] = len;\n        serviceContractActive[contr] = true;\n        serviceContracts.push(contr);\n    }\n\n    function updateServiceContractActiveStatus(address contr, bool activeStatus)\n        public\n    {\n        require(contr != address(0), \"zero\");\n        require(\n            msg.sender == admin ||\n                msg.sender == parameterAdmin ||\n                msg.sender == superAdmin,\n            \"not an admin\"\n        );\n        require(serviceContracts.length \u003e 0, \"zero\");\n        uint256 index = serviceContractIndex[contr];\n        require(serviceContracts[index] == contr, \"not exists\");\n        serviceContractActive[contr] = activeStatus;\n    }\n\n    function getServiceContracts() public view returns (address[] memory) {\n        return serviceContracts;\n    }\n\n    // REWARD\n    // *************************************************************************************\n    function updateVoterRewardPerBlock(uint256 numerator, uint256 denominator)\n        public\n    {\n        require(\n            msg.sender == admin ||\n                msg.sender == parameterAdmin ||\n                msg.sender == superAdmin,\n            \"not an admin\"\n        );\n        require(denominator != 0, \"invalid value\");\n        voterRewardPerBlockNumerator = numerator;\n        voterRewardPerBlockDenominator = denominator;\n    }\n\n    function updateEntityRewardPerBlock(uint256 numerator, uint256 denominator)\n        public\n    {\n        require(\n            msg.sender == admin ||\n                msg.sender == parameterAdmin ||\n                msg.sender == superAdmin,\n            \"not an admin\"\n        );\n        require(denominator != 0, \"invalid value\");\n        entityRewardPerBlockNumerator = numerator;\n        entityRewardPerBlockDenominator = denominator;\n    }\n\n    function deposit(uint256 amount) public {\n        require(msg.sender == superAdmin, \"not an admin\");\n        require(amount \u003e 0, \"zero\");\n        strongToken.transferFrom(msg.sender, address(this), amount);\n        rewardBalance = rewardBalance.add(amount);\n    }\n\n    function withdraw(address destination, uint256 amount) public {\n        require(msg.sender == superAdmin, \"not an admin\");\n        require(amount \u003e 0, \"zero\");\n        require(rewardBalance \u003e= amount, \"not enough\");\n        strongToken.transfer(destination, amount);\n        rewardBalance = rewardBalance.sub(amount);\n    }\n\n    // CORE\n    // *************************************************************************************\n    function getVoterServices(address voter)\n        public\n        view\n        returns (address[] memory)\n    {\n        return voterServices[voter];\n    }\n\n    function getVoterServiceEntities(address voter, address service)\n        public\n        view\n        returns (address[] memory)\n    {\n        return voterServiceEntities[voter][service];\n    }\n\n    function getVoterReward(address voter) public view returns (uint256) {\n        if (totalVotesOut == 0) return 0;\n        if (voterBlockLastClaimedOn[voter] == 0) return 0;\n        uint256 blockResult = block.number.sub(voterBlockLastClaimedOn[voter]);\n        uint256 rewardPerBlockResult = blockResult\n            .mul(voterRewardPerBlockNumerator)\n            .div(voterRewardPerBlockDenominator);\n        return\n            rewardPerBlockResult.mul(voterVotesOut[voter]).div(totalVotesOut);\n    }\n\n    function getEntityReward(address service, address entity)\n        public\n        view\n        returns (uint256)\n    {\n        if (serviceVotes[service] == 0) return 0;\n        if (serviceEntityBlockLastClaimedOn[service][entity] == 0) return 0;\n        uint256 blockResult = block.number.sub(\n            serviceEntityBlockLastClaimedOn[service][entity]\n        );\n        uint256 rewardPerBlockResult = blockResult\n            .mul(entityRewardPerBlockNumerator)\n            .div(entityRewardPerBlockDenominator);\n        return\n            rewardPerBlockResult.mul(serviceEntityVotes[service][entity]).div(\n                serviceVotes[service]\n            );\n    }\n\n    function vote(\n        address service,\n        address entity,\n        uint256 amount\n    ) public {\n        require(amount \u003e 0, \"zero\");\n        require(\n            uint256(_getAvailableServiceEntityVotes(msg.sender)) \u003e= amount,\n            \"not enough\"\n        );\n        require(serviceContractActive[service], \"service not active\");\n        require(\n            ServiceInterface(service).isEntityActive(entity),\n            \"entity not active\"\n        );\n\n        uint256 serviceIndex = voterServiceIndex[msg.sender][service];\n        if (\n            voterServices[msg.sender].length == 0 ||\n            voterServices[msg.sender][serviceIndex] != service\n        ) {\n            uint256 len = voterServices[msg.sender].length;\n            voterServiceIndex[msg.sender][service] = len;\n            voterServices[msg.sender].push(service);\n        }\n\n        uint256 entityIndex = voterServiceEntityIndex[msg\n            .sender][service][entity];\n        if (\n            voterServiceEntities[msg.sender][service].length == 0 ||\n            voterServiceEntities[msg.sender][service][entityIndex] != entity\n        ) {\n            uint256 len = voterServiceEntities[msg.sender][service].length;\n            voterServiceEntityIndex[msg.sender][service][entity] = len;\n            voterServiceEntities[msg.sender][service].push(entity);\n        }\n\n        serviceVotes[service] = serviceVotes[service].add(amount);\n        serviceEntityVotes[service][entity] = serviceEntityVotes[service][entity]\n            .add(amount);\n        voterServiceEntityVotes[msg\n            .sender][service][entity] = voterServiceEntityVotes[msg\n            .sender][service][entity]\n            .add(amount);\n\n        voterVotesOut[msg.sender] = voterVotesOut[msg.sender].add(amount);\n        totalVotesOut = totalVotesOut.add(amount);\n\n        if (voterBlockLastClaimedOn[msg.sender] == 0) {\n            voterBlockLastClaimedOn[msg.sender] = block.number;\n        }\n\n        if (serviceEntityBlockLastClaimedOn[service][entity] == 0) {\n            serviceEntityBlockLastClaimedOn[service][entity] = block.number;\n        }\n\n        emit Voted(msg.sender, service, entity, amount);\n    }\n\n    function recallVote(\n        address service,\n        address entity,\n        uint256 amount\n    ) public {\n        require(amount \u003e 0, \"zero\");\n        require(\n            voterServiceEntityVotes[msg.sender][service][entity] \u003e= amount,\n            \"not enough\"\n        );\n\n        if (block.number \u003e voterBlockLastClaimedOn[msg.sender]) {\n            uint256 reward = getVoterReward(msg.sender);\n            if (reward \u003e 0) {\n                rewardBalance = rewardBalance.sub(reward);\n                strongToken.approve(address(strongPool), reward);\n                strongPool.mineFor(msg.sender, reward);\n                voterBlockLastClaimedOn[msg.sender] = block.number;\n            }\n        }\n\n        if (block.number \u003e serviceEntityBlockLastClaimedOn[service][entity]) {\n            uint256 reward = getEntityReward(service, entity);\n            if (reward \u003e 0) {\n                rewardBalance = rewardBalance.sub(reward);\n                strongToken.approve(address(strongPool), reward);\n                strongPool.mineFor(entity, reward);\n                serviceEntityBlockLastClaimedOn[service][entity] = block.number;\n            }\n        }\n\n        serviceVotes[service] = serviceVotes[service].sub(amount);\n        serviceEntityVotes[service][entity] = serviceEntityVotes[service][entity]\n            .sub(amount);\n        voterServiceEntityVotes[msg\n            .sender][service][entity] = voterServiceEntityVotes[msg\n            .sender][service][entity]\n            .sub(amount);\n\n        voterVotesOut[msg.sender] = voterVotesOut[msg.sender].sub(amount);\n        totalVotesOut = totalVotesOut.sub(amount);\n\n        if (voterVotesOut[msg.sender] == 0) {\n            voterBlockLastClaimedOn[msg.sender] = 0;\n        }\n\n        if (serviceEntityVotes[service][entity] == 0) {\n            serviceEntityBlockLastClaimedOn[service][entity] = 0;\n        }\n        emit RecalledVote(msg.sender, service, entity, amount);\n    }\n\n    function voterClaim() public {\n        require(voterBlockLastClaimedOn[msg.sender] != 0, \"error\");\n        require(block.number \u003e voterBlockLastClaimedOn[msg.sender], \"too soon\");\n        uint256 reward = getVoterReward(msg.sender);\n        require(reward \u003e 0, \"no reward\");\n        rewardBalance = rewardBalance.sub(reward);\n        strongToken.approve(address(strongPool), reward);\n        strongPool.mineFor(msg.sender, reward);\n        voterBlockLastClaimedOn[msg.sender] = block.number;\n        emit Claimed(msg.sender, reward);\n    }\n\n    function entityClaim(address service) public {\n        require(\n            serviceEntityBlockLastClaimedOn[service][msg.sender] != 0,\n            \"error\"\n        );\n        require(\n            block.number \u003e serviceEntityBlockLastClaimedOn[service][msg.sender],\n            \"too soon\"\n        );\n        require(\n            ServiceInterface(service).isEntityActive(msg.sender),\n            \"not active\"\n        );\n        uint256 reward = getEntityReward(service, msg.sender);\n        require(reward \u003e 0, \"no reward\");\n        rewardBalance = rewardBalance.sub(reward);\n        strongToken.approve(address(strongPool), reward);\n        strongPool.mineFor(msg.sender, reward);\n        serviceEntityBlockLastClaimedOn[service][msg.sender] = block.number;\n        emit Claimed(msg.sender, reward);\n    }\n\n    function updateVotes(\n        address voter,\n        uint256 rawAmount,\n        bool adding\n    ) public {\n        require(msg.sender == address(strongPool), \"not strongPool\");\n        uint96 amount = _safe96(rawAmount, \"amount exceeds 96 bits\");\n        if (adding) {\n            _addVotes(voter, amount);\n        } else {\n            require(\n                _getAvailableServiceEntityVotes(voter) \u003e= amount,\n                \"recall votes\"\n            );\n            _subVotes(voter, amount);\n        }\n    }\n\n    function getCurrentProposalVotes(address account)\n        external\n        view\n        returns (uint96)\n    {\n        return _getCurrentProposalVotes(account);\n    }\n\n    function getPriorProposalVotes(address account, uint256 blockNumber)\n        external\n        view\n        returns (uint96)\n    {\n        require(blockNumber \u003c block.number, \"not yet determined\");\n        uint32 nCheckpoints = numCheckpoints[account];\n        if (nCheckpoints == 0) {\n            return 0;\n        }\n        if (checkpointsFromBlock[account][nCheckpoints - 1] \u003c= blockNumber) {\n            return checkpointsVotes[account][nCheckpoints - 1];\n        }\n        if (checkpointsFromBlock[account][0] \u003e blockNumber) {\n            return 0;\n        }\n        uint32 lower = 0;\n        uint32 upper = nCheckpoints - 1;\n        while (upper \u003e lower) {\n            uint32 center = upper - (upper - lower) / 2;\n            uint32 fromBlock = checkpointsFromBlock[account][center];\n            uint96 votes = checkpointsVotes[account][center];\n            if (fromBlock == blockNumber) {\n                return votes;\n            } else if (fromBlock \u003c blockNumber) {\n                lower = center;\n            } else {\n                upper = center - 1;\n            }\n        }\n        return checkpointsVotes[account][lower];\n    }\n\n    function getAvailableServiceEntityVotes(address account)\n        public\n        view\n        returns (uint96)\n    {\n        return _getAvailableServiceEntityVotes(account);\n    }\n\n    // SUPPORT\n    // *************************************************************************************\n    function _addVotes(address voter, uint96 amount) internal {\n        require(voter != address(0), \"zero address\");\n        balances[voter] = _add96(\n            balances[voter],\n            amount,\n            \"vote amount overflows\"\n        );\n        _addDelegates(voter, amount);\n        emit VotesAdded(voter, amount);\n    }\n\n    function _subVotes(address voter, uint96 amount) internal {\n        balances[voter] = _sub96(\n            balances[voter],\n            amount,\n            \"vote amount exceeds balance\"\n        );\n        _subtractDelegates(voter, amount);\n        emit VotesSubtracted(voter, amount);\n    }\n\n    function _addDelegates(address miner, uint96 amount) internal {\n        if (delegates[miner] == address(0)) {\n            delegates[miner] = miner;\n        }\n        address currentDelegate = delegates[miner];\n        _moveDelegates(address(0), currentDelegate, amount);\n    }\n\n    function _subtractDelegates(address miner, uint96 amount) internal {\n        address currentDelegate = delegates[miner];\n        _moveDelegates(currentDelegate, address(0), amount);\n    }\n\n    function _moveDelegates(\n        address srcRep,\n        address dstRep,\n        uint96 amount\n    ) internal {\n        if (srcRep != dstRep \u0026\u0026 amount \u003e 0) {\n            if (srcRep != address(0)) {\n                uint32 srcRepNum = numCheckpoints[srcRep];\n                uint96 srcRepOld = srcRepNum \u003e 0\n                    ? checkpointsVotes[srcRep][srcRepNum - 1]\n                    : 0;\n                uint96 srcRepNew = _sub96(\n                    srcRepOld,\n                    amount,\n                    \"vote amount underflows\"\n                );\n                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n            }\n            if (dstRep != address(0)) {\n                uint32 dstRepNum = numCheckpoints[dstRep];\n                uint96 dstRepOld = dstRepNum \u003e 0\n                    ? checkpointsVotes[dstRep][dstRepNum - 1]\n                    : 0;\n                uint96 dstRepNew = _add96(\n                    dstRepOld,\n                    amount,\n                    \"vote amount overflows\"\n                );\n                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n            }\n        }\n    }\n\n    function _writeCheckpoint(\n        address delegatee,\n        uint32 nCheckpoints,\n        uint96 oldVotes,\n        uint96 newVotes\n    ) internal {\n        uint32 blockNumber = _safe32(\n            block.number,\n            \"block number exceeds 32 bits\"\n        );\n        if (\n            nCheckpoints \u003e 0 \u0026\u0026\n            checkpointsFromBlock[delegatee][nCheckpoints - 1] == blockNumber\n        ) {\n            checkpointsVotes[delegatee][nCheckpoints - 1] = newVotes;\n        } else {\n            checkpointsFromBlock[delegatee][nCheckpoints] = blockNumber;\n            checkpointsVotes[delegatee][nCheckpoints] = newVotes;\n            numCheckpoints[delegatee] = nCheckpoints + 1;\n        }\n\n        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n    }\n\n    function _safe32(uint256 n, string memory errorMessage)\n        internal\n        pure\n        returns (uint32)\n    {\n        require(n \u003c 2**32, errorMessage);\n        return uint32(n);\n    }\n\n    function _safe96(uint256 n, string memory errorMessage)\n        internal\n        pure\n        returns (uint96)\n    {\n        require(n \u003c 2**96, errorMessage);\n        return uint96(n);\n    }\n\n    function _add96(\n        uint96 a,\n        uint96 b,\n        string memory errorMessage\n    ) internal pure returns (uint96) {\n        uint96 c = a + b;\n        require(c \u003e= a, errorMessage);\n        return c;\n    }\n\n    function _sub96(\n        uint96 a,\n        uint96 b,\n        string memory errorMessage\n    ) internal pure returns (uint96) {\n        require(b \u003c= a, errorMessage);\n        return a - b;\n    }\n\n    function _getCurrentProposalVotes(address account)\n        internal\n        view\n        returns (uint96)\n    {\n        uint32 nCheckpoints = numCheckpoints[account];\n        return\n            nCheckpoints \u003e 0 ? checkpointsVotes[account][nCheckpoints - 1] : 0;\n    }\n\n    function _getAvailableServiceEntityVotes(address account)\n        internal\n        view\n        returns (uint96)\n    {\n        uint96 proposalVotes = _getCurrentProposalVotes(account);\n        return\n            proposalVotes == 0\n                ? 0\n                : proposalVotes -\n                    _safe96(\n                        voterVotesOut[account],\n                        \"voterVotesOut exceeds 96 bits\"\n                    );\n    }\n}\n"}}