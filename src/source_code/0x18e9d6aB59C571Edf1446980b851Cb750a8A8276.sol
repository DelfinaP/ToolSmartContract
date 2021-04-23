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
    "contracts/BitsManipulationLibrary.sol": {
      "content": "// Copyright 2020 Cartesi Pte. Ltd.\n\n// SPDX-License-Identifier: Apache-2.0\n// Licensed under the Apache License, Version 2.0 (the \"License\"); you may not use\n// this file except in compliance with the License. You may obtain a copy of the\n// License at http://www.apache.org/licenses/LICENSE-2.0\n\n// Unless required by applicable law or agreed to in writing, software distributed\n// under the License is distributed on an \"AS IS\" BASIS, WITHOUT WARRANTIES OR\n// CONDITIONS OF ANY KIND, either express or implied. See the License for the\n// specific language governing permissions and limitations under the License.\n\n\npragma solidity ^0.7.0;\n\n/// @title Bits Manipulation Library\n/// @author Felipe Argento / Stephen Chen\n/// @notice Implements bit manipulation helper functions\nlibrary BitsManipulationLibrary {\n\n    /// @notice Sign extend a shorter signed value to the full int32\n    /// @param number signed number to be extended\n    /// @param wordSize number of bits of the signed number, ie, 8 for int8\n    function int32SignExtension(int32 number, uint32 wordSize)\n    public pure returns(int32)\n    {\n        uint32 uNumber = uint32(number);\n        bool isNegative = ((uint64(1) << (wordSize - 1)) & uNumber) > 0;\n        uint32 mask = ((uint32(2) ** wordSize) - 1);\n\n        if (isNegative) {\n            uNumber = uNumber | ~mask;\n        }\n\n        return int32(uNumber);\n    }\n\n    /// @notice Sign extend a shorter signed value to the full uint64\n    /// @param number signed number to be extended\n    /// @param wordSize number of bits of the signed number, ie, 8 for int8\n    function uint64SignExtension(uint64 number, uint64 wordSize)\n    public pure returns(uint64)\n    {\n        uint64 uNumber = number;\n        bool isNegative = ((uint64(1) << (wordSize - 1)) & uNumber) > 0;\n        uint64 mask = ((uint64(2) ** wordSize) - 1);\n\n        if (isNegative) {\n            uNumber = uNumber | ~mask;\n        }\n\n        return uNumber;\n    }\n\n    /// @notice Swap byte order of unsigned ints with 64 bytes\n    /// @param num number to have bytes swapped\n    function uint64SwapEndian(uint64 num) public pure returns(uint64) {\n        uint64 output = ((num & 0x00000000000000ff) << 56)|\n            ((num & 0x000000000000ff00) << 40)|\n            ((num & 0x0000000000ff0000) << 24)|\n            ((num & 0x00000000ff000000) << 8) |\n            ((num & 0x000000ff00000000) >> 8) |\n            ((num & 0x0000ff0000000000) >> 24)|\n            ((num & 0x00ff000000000000) >> 40)|\n            ((num & 0xff00000000000000) >> 56);\n\n        return output;\n    }\n\n    /// @notice Swap byte order of unsigned ints with 32 bytes\n    /// @param num number to have bytes swapped\n    function uint32SwapEndian(uint32 num) public pure returns(uint32) {\n        uint32 output = ((num >> 24) & 0xff) | ((num << 8) & 0xff0000) | ((num >> 8) & 0xff00) | ((num << 24) & 0xff000000);\n        return output;\n    }\n}\n\n"
    }
  }
}}