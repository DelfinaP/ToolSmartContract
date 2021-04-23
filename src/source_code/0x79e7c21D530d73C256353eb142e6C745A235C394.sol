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
    "contracts/Merkle.sol": {
      "content": "// Copyright 2020 Cartesi Pte. Ltd.\n\n// SPDX-License-Identifier: Apache-2.0\n// Licensed under the Apache License, Version 2.0 (the \"License\"); you may not use\n// this file except in compliance with the License. You may obtain a copy of the\n// License at http://www.apache.org/licenses/LICENSE-2.0\n\n// Unless required by applicable law or agreed to in writing, software distributed\n// under the License is distributed on an \"AS IS\" BASIS, WITHOUT WARRANTIES OR\n// CONDITIONS OF ANY KIND, either express or implied. See the License for the\n// specific language governing permissions and limitations under the License.\n\n\n/// @title Library for Merkle proofs\npragma solidity ^0.7.0;\n\n\nlibrary Merkle {\n    function getPristineHash(uint8 _log2Size) public pure returns (bytes32) {\n        require(_log2Size >= 3, \"Has to be at least one word\");\n        require(_log2Size <= 64, \"Cannot be bigger than the machine itself\");\n\n        bytes8 value = 0;\n        bytes32 runningHash = keccak256(abi.encodePacked(value));\n\n        for (uint256 i = 3; i < _log2Size; i++) {\n            runningHash = keccak256(abi.encodePacked(runningHash, runningHash));\n        }\n\n        return runningHash;\n    }\n\n    function getRoot(uint64 _position, bytes8 _value, bytes32[] memory proof) public pure returns (bytes32) {\n        bytes32 runningHash = keccak256(abi.encodePacked(_value));\n\n        return getRootWithDrive(\n            _position,\n            3,\n            runningHash,\n            proof\n        );\n    }\n\n    function getRootWithDrive(\n        uint64 _position,\n        uint8 _logOfSize,\n        bytes32 _drive,\n        bytes32[] memory siblings\n    ) public pure returns (bytes32)\n    {\n        require(_logOfSize >= 3, \"Must be at least a word\");\n        require(_logOfSize <= 64, \"Cannot be bigger than the machine itself\");\n\n        uint64 size = uint64(2) ** _logOfSize;\n\n        require(((size - 1) & _position) == 0, \"Position is not aligned\");\n        require(siblings.length == 64 - _logOfSize, \"Proof length does not match\");\n\n        bytes32 drive = _drive;\n\n        for (uint64 i = 0; i < siblings.length; i++) {\n            if ((_position & (size << i)) == 0) {\n                drive = keccak256(abi.encodePacked(drive, siblings[i]));\n            } else {\n                drive = keccak256(abi.encodePacked(siblings[i], drive));\n            }\n        }\n\n        return drive;\n    }\n\n    function getLog2Floor(uint256 number) public pure returns (uint8) {\n\n        uint8 result = 0;\n\n        uint256 checkNumber = number;\n        checkNumber = checkNumber >> 1;\n        while (checkNumber > 0) {\n            ++result;\n            checkNumber = checkNumber >> 1;\n        }\n\n        return result;\n    }\n\n    function isPowerOf2(uint256 number) public pure returns (bool) {\n\n        uint256 checkNumber = number;\n        if (checkNumber == 0) {\n            return false;\n        }\n\n        while ((checkNumber & 1) == 0) {\n            checkNumber = checkNumber >> 1;\n        }\n\n        checkNumber = checkNumber >> 1;\n\n        if (checkNumber == 0) {\n            return true;\n        }\n\n        return false;\n    }\n\n    /// @notice Calculate the root of Merkle tree from an array of power of 2 elements\n    /// @param hashes The array containing power of 2 elements\n    /// @return byte32 the root hash being calculated\n    function calculateRootFromPowerOfTwo(bytes32[] memory hashes) public pure returns (bytes32) {\n        // revert when the input is not of power of 2\n        require(isPowerOf2(hashes.length), \"The input array must contain power of 2 elements\");\n\n        if (hashes.length == 1) {\n            return hashes[0];\n        }else {\n            bytes32[] memory newHashes = new bytes32[](hashes.length >> 1);\n\n            for (uint256 i = 0; i < hashes.length; i += 2) {\n                newHashes[i >> 1] = keccak256(abi.encodePacked(hashes[i], hashes[i + 1]));\n            }\n\n            return calculateRootFromPowerOfTwo(newHashes);\n        }\n    }\n\n}\n"
    }
  }
}}