{"auth.sol":{"content":"// This program is free software: you can redistribute it and/or modify\n// it under the terms of the GNU General Public License as published by\n// the Free Software Foundation, either version 3 of the License, or\n// (at your option) any later version.\n\n// This program is distributed in the hope that it will be useful,\n// but WITHOUT ANY WARRANTY; without even the implied warranty of\n// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n// GNU General Public License for more details.\n\n// You should have received a copy of the GNU General Public License\n// along with this program.  If not, see \u003chttp://www.gnu.org/licenses/\u003e.\n\npragma solidity \u003e=0.4.23;\n\ninterface DSAuthority {\n    function canCall(\n        address src, address dst, bytes4 sig\n    ) external view returns (bool);\n}\n\ncontract DSAuthEvents {\n    event LogSetAuthority (address indexed authority);\n    event LogSetOwner     (address indexed owner);\n}\n\ncontract DSAuth is DSAuthEvents {\n    DSAuthority  public  authority;\n    address      public  owner;\n\n    constructor() public {\n        owner = msg.sender;\n        emit LogSetOwner(msg.sender);\n    }\n\n    function setOwner(address owner_)\n        public\n        auth\n    {\n        owner = owner_;\n        emit LogSetOwner(owner);\n    }\n\n    function setAuthority(DSAuthority authority_)\n        public\n        auth\n    {\n        authority = authority_;\n        emit LogSetAuthority(address(authority));\n    }\n\n    modifier auth {\n        require(isAuthorized(msg.sender, msg.sig), \"ds-auth-unauthorized\");\n        _;\n    }\n\n    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n        if (src == address(this)) {\n            return true;\n        } else if (src == owner) {\n            return true;\n        } else if (authority == DSAuthority(0)) {\n            return false;\n        } else {\n            return authority.canCall(src, address(this), sig);\n        }\n    }\n}\n"},"haw.sol":{"content":"pragma solidity ^0.6.7;\n\nimport \"math.sol\";\nimport \"auth.sol\";\n\n\ncontract HawToken is DSMath, DSAuth {\n    bool                                              public  stopped;\n    uint256                                           public  totalSupply;\n    uint256                                           public  circulatingSupply = 0;\n    mapping (address =\u003e uint256)                      public  balanceOf;\n    mapping (address =\u003e mapping (address =\u003e uint256)) public  allowance;\n    bytes32                                           public  symbol;\n    uint256                                           public  decimals = 18; // standard token precision. override to customize\n    bytes32                                           public  name = \"\";     // Optional token name\n\n    constructor(bytes32 symbol_, uint256 totalSupply_) public {\n        symbol = symbol_;\n        totalSupply = totalSupply_;\n    }\n\n    event Approval(address indexed src, address indexed guy, uint wad);\n    event Transfer(address indexed src, address indexed dst, uint wad);\n    event Mint(address indexed guy, uint wad);\n    event Burn(address indexed guy, uint wad);\n    event Stop();\n    event Start();\n\n    modifier stoppable {\n        require(!stopped, \"ds-stop-is-stopped\");\n        _;\n    }\n\n    function approve(address guy) external returns (bool) {\n        return approve(guy, uint(-1));\n    }\n\n    function approve(address guy, uint wad) public stoppable returns (bool) {\n        allowance[msg.sender][guy] = wad;\n\n        emit Approval(msg.sender, guy, wad);\n\n        return true;\n    }\n\n    function transfer(address dst, uint wad) external returns (bool) {\n        return transferFrom(msg.sender, dst, wad);\n    }\n\n    function transferFrom(address src, address dst, uint wad)\n        public\n        stoppable\n        returns (bool)\n    {\n        if (src != msg.sender \u0026\u0026 allowance[src][msg.sender] != uint(-1)) {\n            require(allowance[src][msg.sender] \u003e= wad, \"ds-token-insufficient-approval\");\n            allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);\n        }\n\n        require(balanceOf[src] \u003e= wad, \"ds-token-insufficient-balance\");\n        balanceOf[src] = sub(balanceOf[src], wad);\n        balanceOf[dst] = add(balanceOf[dst], wad);\n\n        emit Transfer(src, dst, wad);\n\n        return true;\n    }\n\n    function push(address dst, uint wad) external {\n        transferFrom(msg.sender, dst, wad);\n    }\n\n    function pull(address src, uint wad) external {\n        transferFrom(src, msg.sender, wad);\n    }\n\n    function move(address src, address dst, uint wad) external {\n        transferFrom(src, dst, wad);\n    }\n\n\n    function mint(uint wad) external {\n        mint(msg.sender, wad);\n    }\n\n    function burn(uint wad) external {\n        burn(msg.sender, wad);\n    }\n\n    function mint(address guy, uint wad) public auth stoppable {\n        require(totalSupply \u003e= add(circulatingSupply, wad), \"to reach uplimit of mint!\");\n        balanceOf[guy] = add(balanceOf[guy], wad);\n        circulatingSupply = add(circulatingSupply, wad);\n        emit Mint(guy, wad);\n    }\n\n    function burn(address guy, uint wad) public auth stoppable {\n        if (guy != msg.sender \u0026\u0026 allowance[guy][msg.sender] != uint(-1)) {\n            require(allowance[guy][msg.sender] \u003e= wad, \"ds-token-insufficient-approval\");\n            allowance[guy][msg.sender] = sub(allowance[guy][msg.sender], wad);\n        }\n\n        require(balanceOf[guy] \u003e= wad, \"ds-token-insufficient-balance\");\n        balanceOf[guy] = sub(balanceOf[guy], wad);\n        totalSupply = sub(totalSupply, wad);\n        circulatingSupply = sub(circulatingSupply, wad);\n        emit Burn(guy, wad);\n    }\n\n    function stop() public auth {\n        stopped = true;\n        emit Stop();\n    }\n\n    function start() public auth {\n        stopped = false;\n        emit Start();\n    }\n\n    function setName(bytes32 name_) external auth {\n        name = name_;\n    }\n}\n"},"math.sol":{"content":"/// math.sol -- mixin for inline numerical wizardry\n\n// This program is free software: you can redistribute it and/or modify\n// it under the terms of the GNU General Public License as published by\n// the Free Software Foundation, either version 3 of the License, or\n// (at your option) any later version.\n\n// This program is distributed in the hope that it will be useful,\n// but WITHOUT ANY WARRANTY; without even the implied warranty of\n// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n// GNU General Public License for more details.\n\n// You should have received a copy of the GNU General Public License\n// along with this program.  If not, see \u003chttp://www.gnu.org/licenses/\u003e.\n\npragma solidity \u003e0.4.13;\n\ncontract DSMath {\n    function add(uint x, uint y) internal pure returns (uint z) {\n        require((z = x + y) \u003e= x, \"ds-math-add-overflow\");\n    }\n    function sub(uint x, uint y) internal pure returns (uint z) {\n        require((z = x - y) \u003c= x, \"ds-math-sub-underflow\");\n    }\n    function mul(uint x, uint y) internal pure returns (uint z) {\n        require(y == 0 || (z = x * y) / y == x, \"ds-math-mul-overflow\");\n    }\n\n    function min(uint x, uint y) internal pure returns (uint z) {\n        return x \u003c= y ? x : y;\n    }\n    function max(uint x, uint y) internal pure returns (uint z) {\n        return x \u003e= y ? x : y;\n    }\n    function imin(int x, int y) internal pure returns (int z) {\n        return x \u003c= y ? x : y;\n    }\n    function imax(int x, int y) internal pure returns (int z) {\n        return x \u003e= y ? x : y;\n    }\n\n    uint constant WAD = 10 ** 18;\n    uint constant RAY = 10 ** 27;\n\n    //rounds to zero if x*y \u003c WAD / 2\n    function wmul(uint x, uint y) internal pure returns (uint z) {\n        z = add(mul(x, y), WAD / 2) / WAD;\n    }\n    //rounds to zero if x*y \u003c WAD / 2\n    function rmul(uint x, uint y) internal pure returns (uint z) {\n        z = add(mul(x, y), RAY / 2) / RAY;\n    }\n    //rounds to zero if x*y \u003c WAD / 2\n    function wdiv(uint x, uint y) internal pure returns (uint z) {\n        z = add(mul(x, WAD), y / 2) / y;\n    }\n    //rounds to zero if x*y \u003c RAY / 2\n    function rdiv(uint x, uint y) internal pure returns (uint z) {\n        z = add(mul(x, RAY), y / 2) / y;\n    }\n\n    // This famous algorithm is called \"exponentiation by squaring\"\n    // and calculates x^n with x as fixed-point and n as regular unsigned.\n    //\n    // It\u0027s O(log n), instead of O(n) for naive repeated multiplication.\n    //\n    // These facts are why it works:\n    //\n    //  If n is even, then x^n = (x^2)^(n/2).\n    //  If n is odd,  then x^n = x * x^(n-1),\n    //   and applying the equation for even x gives\n    //    x^n = x * (x^2)^((n-1) / 2).\n    //\n    //  Also, EVM division is flooring and\n    //    floor[(n-1) / 2] = floor[n / 2].\n    //\n    function rpow(uint x, uint n) internal pure returns (uint z) {\n        z = n % 2 != 0 ? x : RAY;\n\n        for (n /= 2; n != 0; n /= 2) {\n            x = rmul(x, x);\n\n            if (n % 2 != 0) {\n                z = rmul(z, x);\n            }\n        }\n    }\n}\n"}}