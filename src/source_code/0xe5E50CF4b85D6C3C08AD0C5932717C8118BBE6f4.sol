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
    "@gelatonetwork/core/contracts/conditions/GelatoConditionsStandard.sol": {
      "content": "// \"SPDX-License-Identifier: UNLICENSED\"\npragma solidity >=0.6.10;\n\nimport \"./IGelatoCondition.sol\";\n\nabstract contract GelatoConditionsStandard is IGelatoCondition {\n    string internal constant OK = \"OK\";\n}\n"
    },
    "@gelatonetwork/core/contracts/conditions/IGelatoCondition.sol": {
      "content": "// \"SPDX-License-Identifier: UNLICENSED\"\npragma solidity >=0.6.10;\npragma experimental ABIEncoderV2;\n\n/// @title IGelatoCondition - solidity interface of GelatoConditionsStandard\n/// @notice all the APIs of GelatoConditionsStandard\n/// @dev all the APIs are implemented inside GelatoConditionsStandard\ninterface IGelatoCondition {\n\n    /// @notice GelatoCore calls this to verify securely the specified Condition securely\n    /// @dev Be careful only to encode a Task's condition.data as is and not with the\n    ///  \"ok\" selector or _taskReceiptId, since those two things are handled by GelatoCore.\n    /// @param _taskReceiptId This is passed by GelatoCore so we can rely on it as a secure\n    ///  source of Task identification.\n    /// @param _conditionData This is the Condition.data field developers must encode their\n    ///  Condition's specific parameters in.\n    /// @param _cycleId For Tasks that are executed as part of a cycle.\n    function ok(uint256 _taskReceiptId, bytes calldata _conditionData, uint256 _cycleId)\n        external\n        view\n        returns(string memory);\n}"
    },
    "contracts/constants/CInstaDapp.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\n\n// InstaDapp\naddress constant INSTA_MEMORY = 0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F;\n\n// Connectors\naddress constant CONNECT_MAKER = 0xac02030d8a8F49eD04b2f52C394D3F901A10F8A9;\naddress constant CONNECT_COMPOUND = 0x15FdD1e902cAC70786fe7D31013B1a806764B5a2;\naddress constant INSTA_POOL_V2 = 0xeB4bf86589f808f90EEC8e964dBF16Bd4D284905;\n\n// Tokens\naddress constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\naddress constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;\n\n// Insta Pool\naddress constant INSTA_POOL_RESOLVER = 0xa004a5afBa04b74037E9E52bA1f7eb02b5E61509;\nuint256 constant ROUTE_1_TOLERANCE = 1005e15;\n\n// Insta Mapping\naddress constant INSTA_MAPPING = 0xe81F70Cc7C0D46e12d70efc60607F16bbD617E88;\n"
    },
    "contracts/constants/CMaker.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\n\naddress constant MCD_MANAGER = 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;\n"
    },
    "contracts/contracts/gelato/conditions/ConditionBorrowAmountIsDust.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\npragma experimental ABIEncoderV2;\n\nimport {\n    GelatoConditionsStandard\n} from \"@gelatonetwork/core/contracts/conditions/GelatoConditionsStandard.sol\";\nimport {GelatoBytes} from \"../../../lib/GelatoBytes.sol\";\nimport {\n    _debtIsDustNewVault,\n    _debtIsDust,\n    _getMakerVaultDebt,\n    _isVaultOwner\n} from \"../../../functions/dapps/FMaker.sol\";\n\ncontract ConditionBorrowAmountIsDust is GelatoConditionsStandard {\n    using GelatoBytes for bytes;\n\n    function getConditionData(\n        address _dsa,\n        uint256 _fromVaultId,\n        uint256 _destVaultId,\n        string calldata _destColType\n    ) public pure virtual returns (bytes memory) {\n        return\n            abi.encodeWithSelector(\n                this.isBorrowAmountDust.selector,\n                _dsa,\n                _fromVaultId,\n                _destVaultId,\n                _destColType\n            );\n    }\n\n    function ok(\n        uint256,\n        bytes calldata _conditionData,\n        uint256\n    ) public view virtual override returns (string memory) {\n        (\n            address _dsa,\n            uint256 _fromVaultId,\n            uint256 _destVaultId,\n            string memory _destColType\n        ) = abi.decode(_conditionData[4:], (address, uint256, uint256, string));\n\n        return\n            isBorrowAmountDust(_dsa, _fromVaultId, _destVaultId, _destColType);\n    }\n\n    function isBorrowAmountDust(\n        address _dsa,\n        uint256 _fromVaultId,\n        uint256 _destVaultId,\n        string memory _destColType\n    ) public view returns (string memory) {\n        _destVaultId = _isVaultOwner(_destVaultId, _dsa) ? _destVaultId : 0;\n\n        uint256 wDaiToBorrow = _getMakerVaultDebt(_fromVaultId);\n\n        return\n            borrowAmountIsDustExplicit(_destVaultId, wDaiToBorrow, _destColType)\n                ? \"DebtNotGreaterThanDust\"\n                : OK;\n    }\n\n    function borrowAmountIsDustExplicit(\n        uint256 _vaultId,\n        uint256 _wDaiToBorrow,\n        string memory _colType\n    ) public view returns (bool) {\n        return\n            _vaultId == 0\n                ? _debtIsDustNewVault(_colType, _wDaiToBorrow)\n                : _debtIsDust(_vaultId, _wDaiToBorrow);\n    }\n}\n"
    },
    "contracts/functions/dapps/FMaker.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\n\nimport {MCD_MANAGER} from \"../../constants/CMaker.sol\";\nimport {INSTA_MAPPING} from \"../../constants/CInstaDapp.sol\";\nimport {\n    ITokenJoinInterface\n} from \"../../interfaces/dapps/Maker/ITokenJoinInterface.sol\";\nimport {IMcdManager} from \"../../interfaces/dapps/Maker/IMcdManager.sol\";\nimport {InstaMapping} from \"../../interfaces/InstaDapp/IInstaDapp.sol\";\nimport {IVat} from \"../../interfaces/dapps/Maker/IVat.sol\";\nimport {RAY, add, sub, mul} from \"../../vendor/DSMath.sol\";\nimport {_stringToBytes32, _convertTo18} from \"../../vendor/Convert.sol\";\n\nfunction _getMakerVaultDebt(uint256 _vaultId) view returns (uint256 wad) {\n    IMcdManager manager = IMcdManager(MCD_MANAGER);\n\n    (bytes32 ilk, address urn) = _getVaultData(manager, _vaultId);\n    IVat vat = IVat(manager.vat());\n    (, uint256 rate, , , ) = vat.ilks(ilk);\n    (, uint256 art) = vat.urns(ilk, urn);\n    uint256 dai = vat.dai(urn);\n\n    uint256 rad = sub(mul(art, rate), dai);\n    wad = rad / RAY;\n\n    wad = mul(wad, RAY) < rad ? wad + 1 : wad;\n}\n\nfunction _getMakerRawVaultDebt(uint256 _vaultId) view returns (uint256 tab) {\n    IMcdManager manager = IMcdManager(MCD_MANAGER);\n\n    (bytes32 ilk, address urn) = _getVaultData(manager, _vaultId);\n    IVat vat = IVat(manager.vat());\n    (, uint256 rate, , , ) = vat.ilks(ilk);\n    (, uint256 art) = vat.urns(ilk, urn);\n\n    uint256 rad = mul(art, rate);\n\n    tab = rad / RAY;\n    tab = mul(tab, RAY) < rad ? tab + 1 : tab;\n}\n\nfunction _getMakerVaultCollateralBalance(uint256 _vaultId)\n    view\n    returns (uint256)\n{\n    IMcdManager manager = IMcdManager(MCD_MANAGER);\n\n    IVat vat = IVat(manager.vat());\n    (bytes32 ilk, address urn) = _getVaultData(manager, _vaultId);\n    (uint256 ink, ) = vat.urns(ilk, urn);\n\n    return ink;\n}\n\nfunction _vaultWillBeSafe(\n    uint256 _vaultId,\n    uint256 _amtToBorrow,\n    uint256 _colToDeposit\n) view returns (bool) {\n    require(_vaultId != 0, \"_vaultWillBeSafe: invalid vault id.\");\n\n    IMcdManager manager = IMcdManager(MCD_MANAGER);\n\n    (bytes32 ilk, address urn) = _getVaultData(manager, _vaultId);\n\n    ITokenJoinInterface tokenJoinContract =\n        ITokenJoinInterface(InstaMapping(INSTA_MAPPING).gemJoinMapping(ilk));\n\n    IVat vat = IVat(manager.vat());\n    (, uint256 rate, uint256 spot, , ) = vat.ilks(ilk);\n    (uint256 ink, uint256 art) = vat.urns(ilk, urn);\n    uint256 dai = vat.dai(urn);\n\n    uint256 dink = _convertTo18(tokenJoinContract.dec(), _colToDeposit);\n    uint256 dart = _getBorrowAmt(_amtToBorrow, dai, rate);\n\n    ink = add(ink, dink);\n    art = add(art, dart);\n\n    uint256 tab = mul(rate, art);\n\n    return tab <= mul(ink, spot);\n}\n\nfunction _newVaultWillBeSafe(\n    string memory _colType,\n    uint256 _amtToBorrow,\n    uint256 _colToDeposit\n) view returns (bool) {\n    IMcdManager manager = IMcdManager(MCD_MANAGER);\n    IVat vat = IVat(manager.vat());\n\n    bytes32 ilk = _stringToBytes32(_colType);\n\n    (, uint256 rate, uint256 spot, , ) = vat.ilks(ilk);\n\n    ITokenJoinInterface tokenJoinContract =\n        ITokenJoinInterface(InstaMapping(INSTA_MAPPING).gemJoinMapping(ilk));\n\n    uint256 ink = _convertTo18(tokenJoinContract.dec(), _colToDeposit);\n    uint256 art = _getBorrowAmt(_amtToBorrow, 0, rate);\n\n    uint256 tab = mul(rate, art);\n\n    return tab <= mul(ink, spot);\n}\n\nfunction _debtCeilingIsReachedNewVault(\n    string memory _colType,\n    uint256 _amtToBorrow\n) view returns (bool) {\n    IMcdManager manager = IMcdManager(MCD_MANAGER);\n    IVat vat = IVat(manager.vat());\n\n    bytes32 ilk = _stringToBytes32(_colType);\n\n    (uint256 Art, uint256 rate, , uint256 line, ) = vat.ilks(ilk);\n    uint256 Line = vat.Line();\n    uint256 debt = vat.debt();\n\n    uint256 dart = _getBorrowAmt(_amtToBorrow, 0, rate);\n    uint256 dtab = mul(rate, dart);\n\n    debt = add(debt, dtab);\n    Art = add(Art, dart);\n\n    return mul(Art, rate) > line || debt > Line;\n}\n\nfunction _debtCeilingIsReached(uint256 _vaultId, uint256 _amtToBorrow)\n    view\n    returns (bool)\n{\n    IMcdManager manager = IMcdManager(MCD_MANAGER);\n    IVat vat = IVat(manager.vat());\n\n    (bytes32 ilk, address urn) = _getVaultData(manager, _vaultId);\n\n    (uint256 Art, uint256 rate, , uint256 line, ) = vat.ilks(ilk);\n    uint256 dai = vat.dai(urn);\n    uint256 Line = vat.Line();\n    uint256 debt = vat.debt();\n\n    uint256 dart = _getBorrowAmt(_amtToBorrow, dai, rate);\n    uint256 dtab = mul(rate, dart);\n\n    debt = add(debt, dtab);\n    Art = add(Art, dart);\n\n    return mul(Art, rate) > line || debt > Line;\n}\n\nfunction _debtIsDustNewVault(string memory _colType, uint256 _amtToBorrow)\n    view\n    returns (bool)\n{\n    IMcdManager manager = IMcdManager(MCD_MANAGER);\n    IVat vat = IVat(manager.vat());\n\n    bytes32 ilk = _stringToBytes32(_colType);\n\n    (, uint256 rate, , , uint256 dust) = vat.ilks(ilk);\n    uint256 art = _getBorrowAmt(_amtToBorrow, 0, rate);\n\n    uint256 tab = mul(rate, art);\n\n    return tab < dust;\n}\n\nfunction _debtIsDust(uint256 _vaultId, uint256 _amtToBorrow)\n    view\n    returns (bool)\n{\n    IMcdManager manager = IMcdManager(MCD_MANAGER);\n    IVat vat = IVat(manager.vat());\n\n    (bytes32 ilk, address urn) = _getVaultData(manager, _vaultId);\n    (, uint256 art) = vat.urns(ilk, urn);\n    (, uint256 rate, , , uint256 dust) = vat.ilks(ilk);\n\n    uint256 dai = vat.dai(urn);\n    uint256 dart = _getBorrowAmt(_amtToBorrow, dai, rate);\n    art = add(art, dart);\n    uint256 tab = mul(rate, art);\n\n    return tab < dust;\n}\n\nfunction _getVaultData(IMcdManager manager, uint256 vault)\n    view\n    returns (bytes32 ilk, address urn)\n{\n    ilk = manager.ilks(vault);\n    urn = manager.urns(vault);\n}\n\nfunction _getBorrowAmt(\n    uint256 _amt,\n    uint256 _dai,\n    uint256 _rate\n) pure returns (uint256 dart) {\n    dart = sub(mul(_amt, RAY), _dai) / _rate;\n    dart = mul(dart, _rate) < mul(_amt, RAY) ? dart + 1 : dart;\n}\n\nfunction _isVaultOwner(uint256 _vaultId, address _owner) view returns (bool) {\n    if (_vaultId == 0) return false;\n\n    try IMcdManager(MCD_MANAGER).owns(_vaultId) returns (address owner) {\n        return _owner == owner;\n    } catch Error(string memory error) {\n        revert(string(abi.encodePacked(\"FMaker._isVaultOwner:\", error)));\n    } catch {\n        revert(\"FMaker._isVaultOwner:undefined\");\n    }\n}\n"
    },
    "contracts/interfaces/InstaDapp/IInstaDapp.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\npragma experimental ABIEncoderV2;\n\n/// @notice Interface InstaDapp Index\ninterface IndexInterface {\n    function connectors(uint256 version) external view returns (address);\n\n    function list() external view returns (address);\n}\n\n/// @notice Interface InstaDapp List\ninterface ListInterface {\n    function accountID(address _account) external view returns (uint64);\n}\n\n/// @notice Interface InstaDapp InstaMemory\ninterface MemoryInterface {\n    function setUint(uint256 _id, uint256 _val) external;\n\n    function getUint(uint256 _id) external returns (uint256);\n}\n\n/// @notice Interface InstaDapp Defi Smart Account wallet\ninterface AccountInterface {\n    function cast(\n        address[] calldata _targets,\n        bytes[] calldata _datas,\n        address _origin\n    ) external payable returns (bytes32[] memory responses);\n\n    function version() external view returns (uint256);\n\n    function isAuth(address user) external view returns (bool);\n\n    function shield() external view returns (bool);\n}\n\ninterface ConnectorInterface {\n    function connectorID() external view returns (uint256 _type, uint256 _id);\n\n    function name() external view returns (string memory);\n}\n\ninterface InstaMapping {\n    function gemJoinMapping(bytes32) external view returns (address);\n}\n"
    },
    "contracts/interfaces/dapps/Maker/IMcdManager.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\n\ninterface IMcdManager {\n    function ilks(uint256) external view returns (bytes32);\n\n    function urns(uint256) external view returns (address);\n\n    function vat() external view returns (address);\n\n    function owns(uint256) external view returns (address);\n}\n"
    },
    "contracts/interfaces/dapps/Maker/ITokenJoinInterface.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\n\ninterface ITokenJoinInterface {\n    function dec() external view returns (uint256);\n}\n"
    },
    "contracts/interfaces/dapps/Maker/IVat.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\n\ninterface IVat {\n    function ilks(bytes32)\n        external\n        view\n        returns (\n            uint256,\n            uint256,\n            uint256,\n            uint256,\n            uint256\n        );\n\n    function dai(address) external view returns (uint256);\n\n    function urns(bytes32, address) external view returns (uint256, uint256);\n\n    function debt() external view returns (uint256);\n\n    // solhint-disable-next-line\n    function Line() external view returns (uint256);\n}\n"
    },
    "contracts/lib/GelatoBytes.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\n\nlibrary GelatoBytes {\n    function calldataSliceSelector(bytes calldata _bytes)\n        internal\n        pure\n        returns (bytes4 selector)\n    {\n        selector =\n            _bytes[0] |\n            (bytes4(_bytes[1]) >> 8) |\n            (bytes4(_bytes[2]) >> 16) |\n            (bytes4(_bytes[3]) >> 24);\n    }\n\n    function memorySliceSelector(bytes memory _bytes)\n        internal\n        pure\n        returns (bytes4 selector)\n    {\n        selector =\n            _bytes[0] |\n            (bytes4(_bytes[1]) >> 8) |\n            (bytes4(_bytes[2]) >> 16) |\n            (bytes4(_bytes[3]) >> 24);\n    }\n\n    function revertWithError(bytes memory _bytes, string memory _tracingInfo)\n        internal\n        pure\n    {\n        // 68: 32-location, 32-length, 4-ErrorSelector, UTF-8 err\n        if (_bytes.length % 32 == 4) {\n            bytes4 selector;\n            assembly {\n                selector := mload(add(0x20, _bytes))\n            }\n            if (selector == 0x08c379a0) {\n                // Function selector for Error(string)\n                assembly {\n                    _bytes := add(_bytes, 68)\n                }\n                revert(string(abi.encodePacked(_tracingInfo, string(_bytes))));\n            } else {\n                revert(\n                    string(abi.encodePacked(_tracingInfo, \"NoErrorSelector\"))\n                );\n            }\n        } else {\n            revert(\n                string(abi.encodePacked(_tracingInfo, \"UnexpectedReturndata\"))\n            );\n        }\n    }\n\n    function returnError(bytes memory _bytes, string memory _tracingInfo)\n        internal\n        pure\n        returns (string memory)\n    {\n        // 68: 32-location, 32-length, 4-ErrorSelector, UTF-8 err\n        if (_bytes.length % 32 == 4) {\n            bytes4 selector;\n            assembly {\n                selector := mload(add(0x20, _bytes))\n            }\n            if (selector == 0x08c379a0) {\n                // Function selector for Error(string)\n                assembly {\n                    _bytes := add(_bytes, 68)\n                }\n                return string(abi.encodePacked(_tracingInfo, string(_bytes)));\n            } else {\n                return\n                    string(abi.encodePacked(_tracingInfo, \"NoErrorSelector\"));\n            }\n        } else {\n            return\n                string(abi.encodePacked(_tracingInfo, \"UnexpectedReturndata\"));\n        }\n    }\n}\n"
    },
    "contracts/vendor/Convert.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity 0.7.4;\n\nimport {mul as _mul} from \"./DSMath.sol\";\n\nfunction _stringToBytes32(string memory str) pure returns (bytes32 result) {\n    require(bytes(str).length != 0, \"string-empty\");\n    assembly {\n        result := mload(add(str, 32))\n    }\n}\n\nfunction _convertTo18(uint256 _dec, uint256 _amt) pure returns (uint256 amt) {\n    amt = _mul(_amt, 10**(18 - _dec));\n}\n"
    },
    "contracts/vendor/DSMath.sol": {
      "content": "// \"SPDX-License-Identifier: AGPL-3.0-or-later\"\n/// math.sol -- mixin for inline numerical wizardry\n\n// This program is free software: you can redistribute it and/or modify\n// it under the terms of the GNU General Public License as published by\n// the Free Software Foundation, either version 3 of the License, or\n// (at your option) any later version.\n\n// This program is distributed in the hope that it will be useful,\n// but WITHOUT ANY WARRANTY; without even the implied warranty of\n// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n// GNU General Public License for more details.\n\n// You should have received a copy of the GNU General Public License\n// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\npragma solidity 0.7.4;\n\nfunction add(uint256 x, uint256 y) pure returns (uint256 z) {\n    require((z = x + y) >= x, \"ds-math-add-overflow\");\n}\n\nfunction sub(uint256 x, uint256 y) pure returns (uint256 z) {\n    require((z = x - y) <= x, \"ds-math-sub-underflow\");\n}\n\nfunction mul(uint256 x, uint256 y) pure returns (uint256 z) {\n    require(y == 0 || (z = x * y) / y == x, \"ds-math-mul-overflow\");\n}\n\nfunction min(uint256 x, uint256 y) pure returns (uint256 z) {\n    return x <= y ? x : y;\n}\n\nfunction max(uint256 x, uint256 y) pure returns (uint256 z) {\n    return x >= y ? x : y;\n}\n\nfunction imin(int256 x, int256 y) pure returns (int256 z) {\n    return x <= y ? x : y;\n}\n\nfunction imax(int256 x, int256 y) pure returns (int256 z) {\n    return x >= y ? x : y;\n}\n\nuint256 constant WAD = 10**18;\nuint256 constant RAY = 10**27;\n\n//rounds to zero if x*y < WAD / 2\nfunction wmul(uint256 x, uint256 y) pure returns (uint256 z) {\n    z = add(mul(x, y), WAD / 2) / WAD;\n}\n\n//rounds to zero if x*y < WAD / 2\nfunction rmul(uint256 x, uint256 y) pure returns (uint256 z) {\n    z = add(mul(x, y), RAY / 2) / RAY;\n}\n\n//rounds to zero if x*y < WAD / 2\nfunction wdiv(uint256 x, uint256 y) pure returns (uint256 z) {\n    z = add(mul(x, WAD), y / 2) / y;\n}\n\n//rounds to zero if x*y < RAY / 2\nfunction rdiv(uint256 x, uint256 y) pure returns (uint256 z) {\n    z = add(mul(x, RAY), y / 2) / y;\n}\n\n// This famous algorithm is called \"exponentiation by squaring\"\n// and calculates x^n with x as fixed-point and n as regular unsigned.\n//\n// It's O(log n), instead of O(n) for naive repeated multiplication.\n//\n// These facts are why it works:\n//\n//  If n is even, then x^n = (x^2)^(n/2).\n//  If n is odd,  then x^n = x * x^(n-1),\n//   and applying the equation for even x gives\n//    x^n = x * (x^2)^((n-1) / 2).\n//\n//  Also, EVM division is flooring and\n//    floor[(n-1) / 2] = floor[n / 2].\n//\nfunction rpow(uint256 x, uint256 n) pure returns (uint256 z) {\n    z = n % 2 != 0 ? x : RAY;\n\n    for (n /= 2; n != 0; n /= 2) {\n        x = rmul(x, x);\n\n        if (n % 2 != 0) {\n            z = rmul(z, x);\n        }\n    }\n}\n"
    }
  }
}}