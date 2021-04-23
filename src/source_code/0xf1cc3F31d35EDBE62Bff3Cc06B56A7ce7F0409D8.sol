{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "istanbul",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "remappings": [],
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    }
  },
  "sources": {
    "@openzeppelin/contracts/GSN/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.6.0;\n\n/*\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with GSN meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address payable) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes memory) {\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.6.0;\n\nimport \"../GSN/Context.sol\";\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\ncontract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor () internal {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        emit OwnershipTransferred(_owner, newOwner);\n        _owner = newOwner;\n    }\n}\n"
    },
    "contracts/tokens/AddressBook.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity >=0.6.2 <0.7.0;\n\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\nimport \"./IAddressBook.sol\";\n\ncontract AddressBook is Ownable, IAddressBook {\n  IAddressBook public defaultFactory;\n\n  mapping(address => address) public entries;\n\n  event EntrySet(address token, address wrapper);\n  event DefaultFactorySet(address factory);\n\n  constructor(IAddressBook _defaultFactory) public {\n    defaultFactory = _defaultFactory;\n    emit DefaultFactorySet(address(defaultFactory));\n  }\n\n  function calculateWrapperAddress(address token) external view override returns (address calculatedAddress) {\n    if (entries[token] != address(0)) {\n      return entries[token];\n    }\n\n    return defaultFactory.calculateWrapperAddress(token);\n  }\n\n  function getWrapperAddress(address token) external override returns (address wrapperAddress) {\n    if (entries[token] != address(0)) {\n      return entries[token];\n    }\n\n    return defaultFactory.getWrapperAddress(token);\n  }\n\n  function setEntry(address token, address wrapper) external onlyOwner {\n    entries[token] = wrapper;\n    emit EntrySet(token, wrapper);\n  }\n\n  function setDefaultFactory(address newFactory) external onlyOwner {\n    defaultFactory = IAddressBook(newFactory);\n    emit DefaultFactorySet(newFactory);\n  }\n}\n"
    },
    "contracts/tokens/IAddressBook.sol": {
      "content": "pragma solidity >=0.6.2 <0.7.0;\n\ninterface IAddressBook {\n  function getWrapperAddress(address token) external returns (address wrapperAddress);\n\n  function calculateWrapperAddress(address token) external view returns (address calculatedAddress);\n}\n"
    }
  }
}}