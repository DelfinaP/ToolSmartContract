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
    "contracts/protocol/ConfigOptions.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.6.12;\n\n/**\n * @title ConfigOptions\n * @notice A central place for enumerating the configurable options of our GoldfinchConfig contract\n * @author Goldfinch\n */\n\nlibrary ConfigOptions {\n  // NEVER EVER CHANGE THE ORDER OF THESE!\n  // You can rename or append. But NEVER change the order.\n  enum Numbers {\n    TransactionLimit,\n    TotalFundsLimit,\n    MaxUnderwriterLimit,\n    ReserveDenominator,\n    WithdrawFeeDenominator,\n    LatenessGracePeriodInDays,\n    LatenessMaxDays\n  }\n  enum Addresses {\n    Pool,\n    CreditLineImplementation,\n    CreditLineFactory,\n    CreditDesk,\n    Fidu,\n    USDC,\n    TreasuryReserve,\n    ProtocolAdmin\n  }\n\n  function getNumberName(uint256 number) public pure returns (string memory) {\n    Numbers numberName = Numbers(number);\n    if (Numbers.TransactionLimit == numberName) {\n      return \"TransactionLimit\";\n    }\n    if (Numbers.TotalFundsLimit == numberName) {\n      return \"TotalFundsLimit\";\n    }\n    if (Numbers.MaxUnderwriterLimit == numberName) {\n      return \"MaxUnderwriterLimit\";\n    }\n    if (Numbers.ReserveDenominator == numberName) {\n      return \"ReserveDenominator\";\n    }\n    if (Numbers.WithdrawFeeDenominator == numberName) {\n      return \"WithdrawFeeDenominator\";\n    }\n    if (Numbers.LatenessGracePeriodInDays == numberName) {\n      return \"LatenessGracePeriodInDays\";\n    }\n    if (Numbers.LatenessMaxDays == numberName) {\n      return \"LatenessMaxDays\";\n    }\n    revert(\"Unknown value passed to getNumberName\");\n  }\n\n  function getAddressName(uint256 addressKey) public pure returns (string memory) {\n    Addresses addressName = Addresses(addressKey);\n    if (Addresses.Pool == addressName) {\n      return \"Pool\";\n    }\n    if (Addresses.CreditLineImplementation == addressName) {\n      return \"CreditLineImplementation\";\n    }\n    if (Addresses.CreditLineFactory == addressName) {\n      return \"CreditLineFactory\";\n    }\n    if (Addresses.CreditDesk == addressName) {\n      return \"CreditDesk\";\n    }\n    if (Addresses.Fidu == addressName) {\n      return \"Fidu\";\n    }\n    if (Addresses.USDC == addressName) {\n      return \"USDC\";\n    }\n    if (Addresses.TreasuryReserve == addressName) {\n      return \"TreasuryReserve\";\n    }\n    if (Addresses.ProtocolAdmin == addressName) {\n      return \"ProtocolAdmin\";\n    }\n    revert(\"Unknown value passed to getAddressName\");\n  }\n}\n"
    }
  }
}}