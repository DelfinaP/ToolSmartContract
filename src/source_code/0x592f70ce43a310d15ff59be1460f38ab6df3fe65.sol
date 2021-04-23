{{
  "language": "Solidity",
  "sources": {
    "temp-contracts/interfaces/IPoolFactory.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity ^0.6.0;\n\nimport \"@indexed-finance/proxies/contracts/interfaces/IDelegateCallProxyManager.sol\";\n\n\ninterface IPoolFactory {\n/* ========== Events ========== */\n\n  event NewPool(address pool, address controller, bytes32 implementationID);\n\n/* ========== Mutative ========== */\n\n  function approvePoolController(address controller) external;\n\n  function disapprovePoolController(address controller) external;\n\n  function deployPool(bytes32 implementationID, bytes32 controllerSalt) external returns (address);\n\n/* ========== Views ========== */\n\n  function proxyManager() external view returns (IDelegateCallProxyManager);\n\n  function isApprovedController(address) external view returns (bool);\n\n  function getPoolImplementationID(address) external view returns (bytes32);\n\n  function isRecognizedPool(address pool) external view returns (bool);\n\n  function computePoolAddress(\n    bytes32 implementationID,\n    address controller,\n    bytes32 controllerSalt\n  ) external view returns (address);\n}"
    },
    "@indexed-finance/proxies/contracts/interfaces/IDelegateCallProxyManager.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity ^0.6.0;\n\n\n/**\n * @dev Contract that manages deployment and upgrades of delegatecall proxies.\n *\n * An implementation identifier can be created on the proxy manager which is\n * used to specify the logic address for a particular contract type, and to\n * upgrade the implementation as needed.\n *\n * A one-to-one proxy is a single proxy contract with an upgradeable implementation\n * address.\n *\n * A many-to-one proxy is a single upgradeable implementation address that may be\n * used by many proxy contracts.\n */\ninterface IDelegateCallProxyManager {\n/* ==========  Events  ========== */\n\n  event DeploymentApprovalGranted(address deployer);\n  event DeploymentApprovalRevoked(address deployer);\n\n  event ManyToOne_ImplementationCreated(\n    bytes32 implementationID,\n    address implementationAddress\n  );\n\n  event ManyToOne_ImplementationUpdated(\n    bytes32 implementationID,\n    address implementationAddress\n  );\n\n  event ManyToOne_ProxyDeployed(\n    bytes32 implementationID,\n    address proxyAddress\n  );\n\n  event OneToOne_ProxyDeployed(\n    address proxyAddress,\n    address implementationAddress\n  );\n\n  event OneToOne_ImplementationUpdated(\n    address proxyAddress,\n    address implementationAddress\n  );\n\n/* ==========  Controls  ========== */\n\n  /**\n   * @dev Allows `deployer` to deploy many-to-one proxies.\n   */\n  function approveDeployer(address deployer) external;\n\n  /**\n   * @dev Prevents `deployer` from deploying many-to-one proxies.\n   */\n  function revokeDeployerApproval(address deployer) external;\n\n/* ==========  Implementation Management  ========== */\n\n  /**\n   * @dev Creates a many-to-one proxy relationship.\n   *\n   * Deploys an implementation holder contract which stores the\n   * implementation address for many proxies. The implementation\n   * address can be updated on the holder to change the runtime\n   * code used by all its proxies.\n   *\n   * @param implementationID ID for the implementation, used to identify the\n   * proxies that use it. Also used as the salt in the create2 call when\n   * deploying the implementation holder contract.\n   * @param implementation Address with the runtime code the proxies\n   * should use.\n   */\n  function createManyToOneProxyRelationship(\n    bytes32 implementationID,\n    address implementation\n  ) external;\n\n  /**\n   * @dev Lock the current implementation for `proxyAddress` so that it can never be upgraded again.\n   */\n  function lockImplementationManyToOne(bytes32 implementationID) external;\n\n  /**\n   * @dev Lock the current implementation for `proxyAddress` so that it can never be upgraded again.\n   */\n  function lockImplementationOneToOne(address proxyAddress) external;\n\n  /**\n   * @dev Updates the implementation address for a many-to-one\n   * proxy relationship.\n   *\n   * @param implementationID Identifier for the implementation.\n   * @param implementation Address with the runtime code the proxies\n   * should use.\n   */\n  function setImplementationAddressManyToOne(\n    bytes32 implementationID,\n    address implementation\n  ) external;\n\n  /**\n   * @dev Updates the implementation address for a one-to-one proxy.\n   *\n   * Note: This could work for many-to-one as well if the caller\n   * provides the implementation holder address in place of the\n   * proxy address, as they use the same access control and update\n   * mechanism.\n   *\n   * @param proxyAddress Address of the deployed proxy\n   * @param implementation Address with the runtime code for\n   * the proxy to use.\n   */\n  function setImplementationAddressOneToOne(\n    address proxyAddress,\n    address implementation\n  ) external;\n\n/* ==========  Proxy Deployment  ========== */\n\n  /**\n   * @dev Deploy a proxy contract with a one-to-one relationship\n   * with its implementation.\n   *\n   * The proxy will have its own implementation address which can\n   * be updated by the proxy manager.\n   *\n   * @param suppliedSalt Salt provided by the account requesting deployment.\n   * @param implementation Address of the contract with the runtime\n   * code that the proxy should use.\n   */\n  function deployProxyOneToOne(\n    bytes32 suppliedSalt,\n    address implementation\n  ) external returns(address proxyAddress);\n\n  /**\n   * @dev Deploy a proxy with a many-to-one relationship with its implemenation.\n   *\n   * The proxy will call the implementation holder for every transaction to\n   * determine the address to use in calls.\n   *\n   * @param implementationID Identifier for the proxy's implementation.\n   * @param suppliedSalt Salt provided by the account requesting deployment.\n   */\n  function deployProxyManyToOne(\n    bytes32 implementationID,\n    bytes32 suppliedSalt\n  ) external returns(address proxyAddress);\n\n/* ==========  Queries  ========== */\n\n  /**\n   * @dev Returns a boolean stating whether `implementationID` is locked.\n   */\n  function isImplementationLocked(bytes32 implementationID) external view returns (bool);\n\n  /**\n   * @dev Returns a boolean stating whether `proxyAddress` is locked.\n   */\n  function isImplementationLocked(address proxyAddress) external view returns (bool);\n\n  /**\n   * @dev Returns a boolean stating whether `deployer` is allowed to deploy many-to-one\n   * proxies.\n   */\n  function isApprovedDeployer(address deployer) external view returns (bool);\n\n  /**\n   * @dev Queries the temporary storage value `_implementationHolder`.\n   * This is used in the constructor of the many-to-one proxy contract\n   * so that the create2 address is static (adding constructor arguments\n   * would change the codehash) and the implementation holder can be\n   * stored as a constant.\n   */\n  function getImplementationHolder() external view returns (address);\n\n  /**\n   * @dev Returns the address of the implementation holder contract\n   * for `implementationID`.\n   */\n  function getImplementationHolder(bytes32 implementationID) external view returns (address);\n\n  /**\n   * @dev Computes the create2 address for a one-to-one proxy requested\n   * by `originator` using `suppliedSalt`.\n   *\n   * @param originator Address of the account requesting deployment.\n   * @param suppliedSalt Salt provided by the account requesting deployment.\n   */\n  function computeProxyAddressOneToOne(\n    address originator,\n    bytes32 suppliedSalt\n  ) external view returns (address);\n\n  /**\n   * @dev Computes the create2 address for a many-to-one proxy for the\n   * implementation `implementationID` requested by `originator` using\n   * `suppliedSalt`.\n   *\n   * @param originator Address of the account requesting deployment.\n   * @param implementationID The identifier for the contract implementation.\n   * @param suppliedSalt Salt provided by the account requesting deployment.\n  */\n  function computeProxyAddressManyToOne(\n    address originator,\n    bytes32 implementationID,\n    bytes32 suppliedSalt\n  ) external view returns (address);\n\n  /**\n   * @dev Computes the create2 address of the implementation holder\n   * for `implementationID`.\n   *\n   * @param implementationID The identifier for the contract implementation.\n  */\n  function computeHolderAddressManyToOne(bytes32 implementationID) external view returns (address);\n}"
    },
    "temp-contracts/PoolFactory.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity ^0.6.0;\npragma experimental ABIEncoderV2;\n\n/* ========== External Inheritance ========== */\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\n/* ========== External Interfaces ========== */\nimport \"@indexed-finance/proxies/contracts/interfaces/IDelegateCallProxyManager.sol\";\n\n/* ========== External Libraries ========== */\nimport \"@indexed-finance/proxies/contracts/SaltyLib.sol\";\n\n/* ========== Internal Interfaces ========== */\nimport \"./interfaces/IPoolFactory.sol\";\n\n\n/**\n * @title PoolFactory\n * @author d1ll0n\n */\ncontract PoolFactory is Ownable, IPoolFactory {\n/* ==========  Constants  ========== */\n\n  // Address of the proxy manager contract.\n  IDelegateCallProxyManager public override immutable proxyManager;\n\n/* ==========  Events  ========== */\n\n  /** @dev Emitted when a pool is deployed. */\n  event NewPool(address pool, address controller, bytes32 implementationID);\n\n/* ==========  Storage  ========== */\n\n  mapping(address => bool) public override isApprovedController;\n  mapping(address => bytes32) public override getPoolImplementationID;\n\n/* ==========  Modifiers  ========== */\n\n  modifier onlyApproved {\n    require(isApprovedController[msg.sender], \"ERR_NOT_APPROVED\");\n    _;\n  }\n\n/* ==========  Constructor  ========== */\n\n  constructor(IDelegateCallProxyManager proxyManager_) public Ownable() {\n    proxyManager = proxyManager_;\n  }\n\n/* ==========  Controller Approval  ========== */\n\n  /** @dev Approves `controller` to deploy pools. */\n  function approvePoolController(address controller) external override onlyOwner {\n    isApprovedController[controller] = true;\n  }\n\n  /** @dev Removes the ability of `controller` to deploy pools. */\n  function disapprovePoolController(address controller) external override onlyOwner {\n    isApprovedController[controller] = false;\n  }\n\n/* ==========  Pool Deployment  ========== */\n\n  /**\n   * @dev Deploys a pool using an implementation ID provided by the controller.\n   *\n   * Note: To support future interfaces, this does not initialize or\n   * configure the pool, this must be executed by the controller.\n   *\n   * Note: Must be called by an approved controller.\n   *\n   * @param implementationID Implementation ID for the pool\n   * @param controllerSalt Create2 salt provided by the deployer\n   */\n  function deployPool(bytes32 implementationID, bytes32 controllerSalt)\n    external\n    override\n    onlyApproved\n    returns (address poolAddress)\n  {\n    bytes32 suppliedSalt = keccak256(abi.encodePacked(msg.sender, controllerSalt));\n    poolAddress = proxyManager.deployProxyManyToOne(implementationID, suppliedSalt);\n    getPoolImplementationID[poolAddress] = implementationID;\n    emit NewPool(poolAddress, msg.sender, implementationID);\n  }\n\n/* ==========  Queries  ========== */\n\n  /**\n   * @dev Checks if an address is a pool that was deployed by the factory.\n   */\n  function isRecognizedPool(address pool) external view override returns (bool) {\n    return getPoolImplementationID[pool] != bytes32(0);\n  }\n\n  /**\n   * @dev Compute the create2 address for a pool deployed by an approved controller.\n   */\n  function computePoolAddress(bytes32 implementationID, address controller, bytes32 controllerSalt)\n    public\n    view\n    override\n    returns (address)\n  {\n    bytes32 suppliedSalt = keccak256(abi.encodePacked(controller, controllerSalt));\n    return SaltyLib.computeProxyAddressManyToOne(\n      address(proxyManager),\n      address(this),\n      implementationID,\n      suppliedSalt\n    );\n  }\n}"
    },
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.6.0;\n\nimport \"../GSN/Context.sol\";\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\ncontract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor () internal {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        emit OwnershipTransferred(_owner, newOwner);\n        _owner = newOwner;\n    }\n}\n"
    },
    "@openzeppelin/contracts/GSN/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.6.0;\n\n/*\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with GSN meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address payable) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes memory) {\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n        return msg.data;\n    }\n}\n"
    },
    "@indexed-finance/proxies/contracts/SaltyLib.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity ^0.6.0;\n\n/* ---  External Libraries  --- */\nimport { Create2 } from \"@openzeppelin/contracts/utils/Create2.sol\";\n\n/* ---  Proxy Contracts  --- */\nimport { CodeHashes } from \"./CodeHashes.sol\";\n\n\n/**\n * @dev Library for computing create2 salts and addresses for proxies\n * deployed by `DelegateCallProxyManager`.\n *\n * Because the proxy factory is meant to be used by multiple contracts,\n * we use a salt derivation pattern that includes the address of the\n * contract that requested the proxy deployment, a salt provided by that\n * contract and the implementation ID used (for many-to-one proxies only).\n */\nlibrary SaltyLib {\n/* ---  Salt Derivation  --- */\n\n  /**\n   * @dev Derives the create2 salt for a many-to-one proxy.\n   *\n   * Many different contracts in the Indexed framework may use the\n   * same implementation contract, and they all use the same init\n   * code, so we derive the actual create2 salt from a combination\n   * of the implementation ID, the address of the account requesting\n   * deployment and the user-supplied salt.\n   *\n   * @param originator Address of the account requesting deployment.\n   * @param implementationID The identifier for the contract implementation.\n   * @param suppliedSalt Salt provided by the account requesting deployment.\n   */\n  function deriveManyToOneSalt(\n    address originator,\n    bytes32 implementationID,\n    bytes32 suppliedSalt\n  )\n    internal\n    pure\n    returns (bytes32)\n  {\n    return keccak256(\n      abi.encodePacked(\n        originator,\n        implementationID,\n        suppliedSalt\n      )\n    );\n  }\n\n  /**\n   * @dev Derives the create2 salt for a one-to-one proxy.\n   *\n   * @param originator Address of the account requesting deployment.\n   * @param suppliedSalt Salt provided by the account requesting deployment.\n   */\n  function deriveOneToOneSalt(\n    address originator,\n    bytes32 suppliedSalt\n  )\n    internal\n    pure\n    returns (bytes32)\n  {\n    return keccak256(abi.encodePacked(originator, suppliedSalt));\n  }\n\n/* ---  Address Derivation  --- */\n\n  /**\n   * @dev Computes the create2 address for a one-to-one proxy deployed\n   * by `deployer` (the factory) when requested by `originator` using\n   * `suppliedSalt`.\n   *\n   * @param deployer Address of the proxy factory.\n   * @param originator Address of the account requesting deployment.\n   * @param suppliedSalt Salt provided by the account requesting deployment.\n   */\n  function computeProxyAddressOneToOne(\n    address deployer,\n    address originator,\n    bytes32 suppliedSalt\n  )\n    internal\n    pure\n    returns (address)\n  {\n    bytes32 salt = deriveOneToOneSalt(originator, suppliedSalt);\n    return Create2.computeAddress(salt, CodeHashes.ONE_TO_ONE_CODEHASH, deployer);\n  }\n\n  /**\n   * @dev Computes the create2 address for a many-to-one proxy for the\n   * implementation `implementationID` deployed by `deployer` (the factory)\n   * when requested by `originator` using `suppliedSalt`.\n   *\n   * @param deployer Address of the proxy factory.\n   * @param originator Address of the account requesting deployment.\n   * @param implementationID The identifier for the contract implementation.\n   * @param suppliedSalt Salt provided by the account requesting deployment.\n  */\n  function computeProxyAddressManyToOne(\n    address deployer,\n    address originator,\n    bytes32 implementationID,\n    bytes32 suppliedSalt\n  )\n    internal\n    pure\n    returns (address)\n  {\n    bytes32 salt = deriveManyToOneSalt(\n      originator,\n      implementationID,\n      suppliedSalt\n    );\n    return Create2.computeAddress(salt, CodeHashes.MANY_TO_ONE_CODEHASH, deployer);\n  }\n\n  /**\n   * @dev Computes the create2 address of the implementation holder\n   * for `implementationID`.\n   *\n   * @param deployer Address of the proxy factory.\n   * @param implementationID The identifier for the contract implementation.\n  */\n  function computeHolderAddressManyToOne(\n    address deployer,\n    bytes32 implementationID\n  )\n    internal\n    pure\n    returns (address)\n  {\n    return Create2.computeAddress(\n      implementationID,\n      CodeHashes.IMPLEMENTATION_HOLDER_CODEHASH,\n      deployer\n    );\n  }\n}"
    },
    "@openzeppelin/contracts/utils/Create2.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.6.0;\n\n/**\n * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.\n * `CREATE2` can be used to compute in advance the address where a smart\n * contract will be deployed, which allows for interesting new mechanisms known\n * as 'counterfactual interactions'.\n *\n * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more\n * information.\n */\nlibrary Create2 {\n    /**\n     * @dev Deploys a contract using `CREATE2`. The address where the contract\n     * will be deployed can be known in advance via {computeAddress}.\n     *\n     * The bytecode for a contract can be obtained from Solidity with\n     * `type(contractName).creationCode`.\n     *\n     * Requirements:\n     *\n     * - `bytecode` must not be empty.\n     * - `salt` must have not been used for `bytecode` already.\n     * - the factory must have a balance of at least `amount`.\n     * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.\n     */\n    function deploy(uint256 amount, bytes32 salt, bytes memory bytecode) internal returns (address) {\n        address addr;\n        require(address(this).balance >= amount, \"Create2: insufficient balance\");\n        require(bytecode.length != 0, \"Create2: bytecode length is zero\");\n        // solhint-disable-next-line no-inline-assembly\n        assembly {\n            addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)\n        }\n        require(addr != address(0), \"Create2: Failed on deploy\");\n        return addr;\n    }\n\n    /**\n     * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the\n     * `bytecodeHash` or `salt` will result in a new destination address.\n     */\n    function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {\n        return computeAddress(salt, bytecodeHash, address(this));\n    }\n\n    /**\n     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at\n     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.\n     */\n    function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address) {\n        bytes32 _data = keccak256(\n            abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash)\n        );\n        return address(uint256(_data));\n    }\n}\n"
    },
    "@indexed-finance/proxies/contracts/CodeHashes.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity ^0.6.0;\n\n\n/**\n * @dev Because we use the code hashes of the proxy contracts for proxy address\n * derivation, it is important that other packages have access to the correct\n * values when they import the salt library.\n */\nlibrary CodeHashes {\n  bytes32 internal constant ONE_TO_ONE_CODEHASH = 0x63d9f7b5931b69188c8f6b806606f25892f1bb17b7f7e966fe3a32c04493aee4;\n  bytes32 internal constant MANY_TO_ONE_CODEHASH = 0xa035ad05a1663db5bfd455b99cd7c6ac6bd49269738458eda140e0b78ed53f79;\n  bytes32 internal constant IMPLEMENTATION_HOLDER_CODEHASH = 0x11c370493a726a0ffa93d42b399ad046f1b5a543b6e72f1a64f1488dc1c58f2c;\n}"
    }
  },
  "settings": {
    "metadata": {
      "useLiteralContent": false
    },
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    }
  }
}}