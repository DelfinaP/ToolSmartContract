{"Address.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.6.2;\r\n\r\n/**\r\n * @dev Collection of functions related to the address type\r\n */\r\nlibrary Address {\r\n    /**\r\n     * @dev Returns true if `account` is a contract.\r\n     *\r\n     * [IMPORTANT]\r\n     * ====\r\n     * It is unsafe to assume that an address for which this function returns\r\n     * false is an externally-owned account (EOA) and not a contract.\r\n     *\r\n     * Among others, `isContract` will return false for the following\r\n     * types of addresses:\r\n     *\r\n     *  - an externally-owned account\r\n     *  - a contract in construction\r\n     *  - an address where a contract will be created\r\n     *  - an address where a contract lived, but was destroyed\r\n     * ====\r\n     */\r\n    function isContract(address account) internal view returns (bool) {\r\n        // This method relies on extcodesize, which returns 0 for contracts in\r\n        // construction, since the code is only stored at the end of the\r\n        // constructor execution.\r\n\r\n        uint256 size;\r\n        // solhint-disable-next-line no-inline-assembly\r\n        assembly { size := extcodesize(account) }\r\n        return size \u003e 0;\r\n    }\r\n\r\n    /**\r\n     * @dev Replacement for Solidity\u0027s `transfer`: sends `amount` wei to\r\n     * `recipient`, forwarding all available gas and reverting on errors.\r\n     *\r\n     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\r\n     * of certain opcodes, possibly making contracts go over the 2300 gas limit\r\n     * imposed by `transfer`, making them unable to receive funds via\r\n     * `transfer`. {sendValue} removes this limitation.\r\n     *\r\n     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\r\n     *\r\n     * IMPORTANT: because control is transferred to `recipient`, care must be\r\n     * taken to not create reentrancy vulnerabilities. Consider using\r\n     * {ReentrancyGuard} or the\r\n     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\r\n     */\r\n    function sendValue(address payable recipient, uint256 amount) internal {\r\n        require(address(this).balance \u003e= amount, \"Address: insufficient balance\");\r\n\r\n        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\r\n        (bool success, ) = recipient.call{ value: amount }(\"\");\r\n        require(success, \"Address: unable to send value, recipient may have reverted\");\r\n    }\r\n\r\n    /**\r\n     * @dev Performs a Solidity function call using a low level `call`. A\r\n     * plain`call` is an unsafe replacement for a function call: use this\r\n     * function instead.\r\n     *\r\n     * If `target` reverts with a revert reason, it is bubbled up by this\r\n     * function (like regular Solidity function calls).\r\n     *\r\n     * Returns the raw returned data. To convert to the expected return value,\r\n     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `target` must be a contract.\r\n     * - calling `target` with `data` must not revert.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\r\n      return functionCall(target, data, \"Address: low-level call failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\r\n     * `errorMessage` as a fallback revert reason when `target` reverts.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\r\n        return functionCallWithValue(target, data, 0, errorMessage);\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\r\n     * but also transferring `value` wei to `target`.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - the calling contract must have an ETH balance of at least `value`.\r\n     * - the called Solidity function must be `payable`.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\r\n        return functionCallWithValue(target, data, value, \"Address: low-level call with value failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\r\n     * with `errorMessage` as a fallback revert reason when `target` reverts.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\r\n        require(address(this).balance \u003e= value, \"Address: insufficient balance for call\");\r\n        require(isContract(target), \"Address: call to non-contract\");\r\n\r\n        // solhint-disable-next-line avoid-low-level-calls\r\n        (bool success, bytes memory returndata) = target.call{ value: value }(data);\r\n        return _verifyCallResult(success, returndata, errorMessage);\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\r\n     * but performing a static call.\r\n     *\r\n     * _Available since v3.3._\r\n     */\r\n    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\r\n        return functionStaticCall(target, data, \"Address: low-level static call failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\r\n     * but performing a static call.\r\n     *\r\n     * _Available since v3.3._\r\n     */\r\n    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\r\n        require(isContract(target), \"Address: static call to non-contract\");\r\n\r\n        // solhint-disable-next-line avoid-low-level-calls\r\n        (bool success, bytes memory returndata) = target.staticcall(data);\r\n        return _verifyCallResult(success, returndata, errorMessage);\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\r\n     * but performing a delegate call.\r\n     *\r\n     * _Available since v3.3._\r\n     */\r\n    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\r\n        return functionDelegateCall(target, data, \"Address: low-level delegate call failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\r\n     * but performing a delegate call.\r\n     *\r\n     * _Available since v3.3._\r\n     */\r\n    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\r\n        require(isContract(target), \"Address: delegate call to non-contract\");\r\n\r\n        // solhint-disable-next-line avoid-low-level-calls\r\n        (bool success, bytes memory returndata) = target.delegatecall(data);\r\n        return _verifyCallResult(success, returndata, errorMessage);\r\n    }\r\n\r\n    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\r\n        if (success) {\r\n            return returndata;\r\n        } else {\r\n            // Look for revert reason and bubble it up if present\r\n            if (returndata.length \u003e 0) {\r\n                // The easiest way to bubble the revert reason is using memory via assembly\r\n\r\n                // solhint-disable-next-line no-inline-assembly\r\n                assembly {\r\n                    let returndata_size := mload(returndata)\r\n                    revert(add(32, returndata), returndata_size)\r\n                }\r\n            } else {\r\n                revert(errorMessage);\r\n            }\r\n        }\r\n    }\r\n}\r\n"},"IERC20.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.6.0;\r\n\r\n/**\r\n * @dev Interface of the ERC20 standard as defined in the EIP.\r\n */\r\ninterface IERC20 {\r\n    /**\r\n     * @dev Returns the amount of tokens in existence.\r\n     */\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Returns the amount of tokens owned by `account`.\r\n     */\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from the caller\u0027s account to `recipient`.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Returns the remaining number of tokens that `spender` will be\r\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\r\n     * zero by default.\r\n     *\r\n     * This value changes when {approve} or {transferFrom} are called.\r\n     */\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Sets `amount` as the allowance of `spender` over the caller\u0027s tokens.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\r\n     * that someone may use both the old and the new allowance by unfortunate\r\n     * transaction ordering. One possible solution to mitigate this race\r\n     * condition is to first reduce the spender\u0027s allowance to 0 and set the\r\n     * desired value afterwards:\r\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\r\n     *\r\n     * Emits an {Approval} event.\r\n     */\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\r\n     * allowance mechanism. `amount` is then deducted from the caller\u0027s\r\n     * allowance.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\r\n     * another (`to`).\r\n     *\r\n     * Note that `value` may be zero.\r\n     */\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    /**\r\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\r\n     * a call to {approve}. `value` is the new allowance.\r\n     */\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n"},"Launchpad.sol":{"content":"// SPDX-License-Identifier: MIT\r\npragma solidity ^0.6.0;\r\n\r\nimport \"./IERC20.sol\";\r\nimport \"./SafeERC20.sol\";\r\n\r\ncontract Launchpad{\r\n\r\n    using SafeMath for uint256;\r\n    using SafeERC20 for IERC20;\r\n   \r\n    uint256 private constant _BASE_PRICE = 100000000000;\r\n\r\n    uint256 private constant _totalPercent = 10000;\r\n    \r\n    uint256 private constant _fee1 = 100;\r\n\r\n    uint256 private constant _fee3 = 300;\r\n\r\n    address private constant _layerFeeAddress = 0xa6A7cFCFEFe8F1531Fc4176703A81F570d50D6B5;\r\n    \r\n    address private constant _stakeFeeAddress = 0xfB5B0474B28f18A635579c1bF073fc05bE1BB63b;\r\n    \r\n    address private constant _supportFeeAddress = 0xD3cDe6FA51A69EEdFB1B8f58A1D7DCee00EC57A8;\r\n\r\n    mapping (address =\u003e uint256) private _balancesToClaim;\r\n\r\n    mapping (address =\u003e uint256) private _balancesToClaimTokens;\r\n\r\n    uint256 private _liquidityPercent;\r\n\r\n    uint256 private _teamPercent;\r\n\r\n    uint256 private _end;\r\n\r\n    uint256 private _start;\r\n\r\n    uint256 private _releaseTime;\r\n    \r\n    uint256[3] private _priceInv;\r\n     \r\n    uint256[3] private _caps;\r\n\r\n    uint256 private _priceUniInv;\r\n\r\n    bool    private _isRefunded = false;\r\n\r\n    bool    private _isSoldOut = false;\r\n\r\n    bool    private _isLiquiditySetup = false;\r\n\r\n    uint256 private _raisedETH;\r\n\r\n    uint256 private _claimedAmount;\r\n\r\n    uint256 private _softCap;\r\n\r\n    uint256 private _maxCap;\r\n\r\n    address private _teamWallet;\r\n\r\n    address private _owner;\r\n    \r\n    address private _liquidityCreator;\r\n\r\n    IERC20 public _token;\r\n    \r\n    string private _tokenName;\r\n\r\n    string private _siteUrl;\r\n    \r\n    string private _paperUrl;\r\n\r\n    string private _twitterUrl;\r\n\r\n    string private _telegramUrl;\r\n\r\n    string private _mediumUrl;\r\n    \r\n    string private _gitUrl;\r\n    \r\n    string private _discordUrl;\r\n    \r\n    string private _tokenDesc;\r\n    \r\n    uint256 private _tokenTotalSupply;\r\n    \r\n    uint256 private _tokensForSale;\r\n    \r\n    uint256 private _minContribution = 1 ether;\r\n    \r\n    uint256 private _maxContribution = 50 ether;\r\n    \r\n    uint256 private _round;\r\n    \r\n    bool private _uniListing;\r\n    \r\n    bool private _tokenMint;\r\n    \r\n    /**\r\n    * @dev Emitted when maximum value of ETH is raised\r\n    *\r\n    */    \r\n    event SoldOut();\r\n    \r\n    /**\r\n    * @dev Emitted when ETH are Received by this wallet\r\n    *\r\n    */\r\n    event Received(address indexed from, uint256 value);\r\n    \r\n    /**\r\n    * @dev Emitted when tokens are claimed by user\r\n    *\r\n    */\r\n    event Claimed(address indexed from, uint256 value);\r\n    /**\r\n    * @dev Emitted when refunded if not successful\r\n    *\r\n    */\r\n    event Refunded(address indexed from, uint256 value);\r\n    \r\n    modifier onlyOwner {\r\n        require(msg.sender == _owner);\r\n        _;\r\n    }    \r\n\r\n    constructor(\r\n        IERC20 token, \r\n        uint256 priceUniInv, \r\n        uint256 softCap, \r\n        uint256 maxCap, \r\n        uint256 liquidityPercent, \r\n        uint256 teamPercent, \r\n        uint256 end, \r\n        uint256 start, \r\n        uint256 releaseTime,\r\n        uint256[3] memory caps, \r\n        uint256[3] memory priceInv,\r\n        address owner, \r\n        address teamWallet,\r\n        address liquidityCreator\r\n    ) \r\n    public \r\n    {\r\n        require(start \u003e block.timestamp, \"start time needs to be above current time\");\r\n        require(releaseTime \u003e block.timestamp, \"release time above current time\");\r\n        require(end \u003e start, \"End time above start time\");\r\n        require(liquidityPercent \u003c= 3000, \"Max Liquidity allowed is 30 %\");\r\n        require(owner != address(0), \"Not valid address\" );\r\n        require(caps.length \u003e 0, \"Caps can not be zero\" );\r\n        require(caps.length == priceInv.length, \"Caps and price not same length\" );\r\n    \r\n        uint256 totalPercent = teamPercent.add(liquidityPercent).add(_fee1.mul(2)).add(_fee3);\r\n        require(totalPercent == _totalPercent, \"Funds are distributed max 100 %\");\r\n\r\n        _softCap = softCap;\r\n        _maxCap = maxCap;\r\n        _start = start;\r\n        _end = end;\r\n        _liquidityPercent = liquidityPercent;\r\n        _teamPercent = teamPercent;\r\n        _caps = caps;\r\n        _priceInv = priceInv;\r\n        _owner = owner;\r\n        _liquidityCreator = liquidityCreator;\r\n        _releaseTime = releaseTime;\r\n        _token = token;\r\n        _teamWallet = teamWallet;\r\n        _priceUniInv = priceUniInv;\r\n    }\r\n    \r\n    function setDetails(\r\n        string memory tokenName,\r\n        string memory siteUrl,\r\n        string memory paperUrl,\r\n        string memory twitterUrl,\r\n        string memory telegramUrl,\r\n        string memory mediumUrl,\r\n        string memory gitUrl,\r\n        string memory discordUrl,\r\n        string memory tokenDesc,\r\n        uint256 tokensForSale,\r\n        uint256 minContribution,\r\n        uint256 maxContribution,\r\n        uint256 tokenTotalSupply,\r\n        bool uniListing,\r\n        bool tokenMint\r\n    ) external {\r\n        _tokenName = tokenName;\r\n        _siteUrl = siteUrl;\r\n        _paperUrl = paperUrl;\r\n        _twitterUrl = twitterUrl;\r\n        _telegramUrl = telegramUrl;\r\n        _mediumUrl = mediumUrl;\r\n        _gitUrl = gitUrl;\r\n        _discordUrl = discordUrl;\r\n        _tokenDesc = tokenDesc;\r\n        _tokensForSale = tokensForSale;\r\n        _minContribution = minContribution;\r\n        _maxContribution = maxContribution;\r\n        _uniListing = uniListing;\r\n        _tokenMint = tokenMint;\r\n        _tokenTotalSupply = tokenTotalSupply;\r\n    }\r\n    \r\n    function getDetails() public view returns \r\n    (\r\n        uint256 priceUniInv,\r\n        address owner,\r\n        address teamWallet, \r\n        uint256 softCap, \r\n        uint256 maxCap, \r\n        uint256 liquidityPercent, \r\n        uint256 teamPercent, \r\n        uint256 end, \r\n        uint256 start, \r\n        uint256 releaseTime,\r\n        uint256 raisedETH,\r\n        uint256 tokensForSale,\r\n        uint256 minContribution,\r\n        uint256 maxContribution\r\n    ) {\r\n        priceUniInv = _priceUniInv;\r\n        owner = _owner;\r\n        teamWallet = _teamWallet; \r\n        softCap = _softCap; \r\n        maxCap = _maxCap; \r\n        liquidityPercent = _liquidityPercent; \r\n        teamPercent = _teamPercent;\r\n        end = _end;\r\n        start = _start; \r\n        releaseTime = _releaseTime;\r\n        raisedETH = _raisedETH;\r\n        tokensForSale = _tokensForSale;\r\n        minContribution = _minContribution;\r\n        maxContribution = _maxContribution;\r\n    }\r\n    \r\n    function getMoreDetails() public view returns \r\n    (\r\n        bool uniListing,\r\n        bool tokenMint,\r\n        bool isRefunded,\r\n        bool isSoldOut,\r\n        string memory tokenName,\r\n        uint256 tokenTotalSupply,\r\n        uint256 liquidityLock,\r\n        uint256 round\r\n    ) {\r\n        uniListing = _uniListing;\r\n        tokenMint = _tokenMint;\r\n        isRefunded = _isRefunded;\r\n        isSoldOut = _isSoldOut;\r\n        tokenName = _tokenName;\r\n        tokenTotalSupply = _tokenTotalSupply;\r\n        liquidityLock = _maxCap.mul(_liquidityPercent).div(_totalPercent);\r\n        round = _round;\r\n    }\r\n    \r\n    function getInfos() public view returns (string memory, string memory) {\r\n        string memory res = \u0027\u0027;\r\n        res = append(_siteUrl, \u0027|\u0027, _paperUrl, \u0027|\u0027, _twitterUrl);\r\n        res = append(res, \u0027|\u0027, _telegramUrl, \u0027|\u0027, _mediumUrl );\r\n        res = append(res, \u0027|\u0027, _gitUrl, \u0027|\u0027, _discordUrl );\r\n        return(res, _tokenDesc);\r\n    }\r\n    \r\n    function getMinInfos() public view returns (\r\n        string memory siteUrl,\r\n        string memory tokenName,\r\n        bool isRefunded,\r\n        bool isSoldOut,\r\n        uint256 start, \r\n        uint256 end,\r\n        uint256 softCap,\r\n        uint256 maxCap,\r\n        uint256 raisedETH\r\n    ) {\r\n        siteUrl = _siteUrl;\r\n        tokenName = _tokenName;\r\n        isRefunded = _isRefunded;\r\n        isSoldOut = _isSoldOut;\r\n        start = _start;\r\n        end = _end;\r\n        softCap = _softCap;\r\n        maxCap = _maxCap;\r\n        raisedETH = _raisedETH;\r\n    }\r\n    \r\n    /**\r\n    * @dev Function to get the length of caps array\r\n    * @return length\r\n    */        \r\n    function getCapSize() public view returns(uint) {\r\n        return _caps.length;\r\n    }\r\n\r\n    /**\r\n    * @dev Function to get the cap value, price inverse and amount.\r\n    * @param index - cap index.\r\n    * @return cap value, price inverse and amount.\r\n    */ \r\n    function getCapPrice(uint index) public view returns(uint, uint, uint) {\r\n        return (_caps[index], _priceInv[index], ( _caps[index].mul(_BASE_PRICE).div(_priceInv[index])));\r\n    }\r\n\r\n    /**\r\n    * @dev Function to get the balance to claim of user in ETH.\r\n    * @param account - user address.\r\n    * @return balance to claim.\r\n    */\r\n    function balanceToClaim(address account) public view returns (uint256) {\r\n        return _balancesToClaim[account];\r\n    }\r\n\r\n    /**\r\n    * @dev Function to get the balance to claim of user in TOKEN.\r\n    * @param account - user address.\r\n    * @return balance to claim.\r\n    */\r\n    function balanceToClaimTokens(address account) public view returns (uint256) {\r\n        return _balancesToClaimTokens[account];\r\n    }\r\n    \r\n    /**\r\n    * @dev Receive ETH and updates the launchpad values.\r\n    */\r\n    receive() external payable {\r\n        require(block.timestamp \u003e _start , \"LaunchpadToken: not started yet\");\r\n        require(block.timestamp \u003c _end , \"LaunchpadToken: finished\");\r\n        require(_isRefunded == false , \"LaunchpadToken: Refunded is activated\");\r\n        require(_isSoldOut == false , \"LaunchpadToken: SoldOut\");\r\n        uint256 amount = msg.value;\r\n        require(amount \u003e= _minContribution \u0026\u0026 amount \u003c= _maxContribution, \u0027Amount must be between MIN and MAX\u0027);\r\n        uint256 price = _priceInv[2];\r\n        require(amount \u003e 0, \"LaunchpadToken: eth value sent needs to be above zero\");\r\n      \r\n        _raisedETH = _raisedETH.add(amount);\r\n        uint total = 0;\r\n        for (uint256 index = 0; index \u003c _caps.length; index++) {\r\n            total = total + _caps[index];\r\n            if(_raisedETH \u003c total){\r\n                price = _priceInv[index];\r\n                _round = index;\r\n                break;\r\n            }\r\n        }\r\n        \r\n        _balancesToClaim[msg.sender] = _balancesToClaim[msg.sender].add(amount);\r\n        _balancesToClaimTokens[msg.sender] = _balancesToClaimTokens[msg.sender].add(amount.mul(_BASE_PRICE).div(price));\r\n\r\n        if(_raisedETH \u003e= _maxCap){\r\n            _isSoldOut = true;\r\n            uint256 refundAmount = _raisedETH.sub(_maxCap);\r\n            if(refundAmount \u003e 0){\r\n                // Subtract value that is higher than maxCap\r\n                _balancesToClaim[msg.sender] = _balancesToClaim[msg.sender].sub(refundAmount);\r\n                _balancesToClaimTokens[msg.sender] = _balancesToClaimTokens[msg.sender].sub(refundAmount.mul(_BASE_PRICE).div(price));\r\n                payable(msg.sender).transfer(refundAmount);\r\n            }\r\n            emit SoldOut();\r\n        }\r\n\r\n        emit Received(msg.sender, amount);\r\n    }\r\n\r\n    /**\r\n    * @dev Function to claim tokens to user, after release time, if project not reached softcap funds are returned back.\r\n    */\r\n    function claim() public returns (bool)  {\r\n        // if sold out no need to wait for the time to finish, make sure liquidity is setup\r\n        require(block.timestamp \u003e= _end || (!_isSoldOut \u0026\u0026 _isLiquiditySetup), \"LaunchpadToken: sales still going on\");\r\n        require(_balancesToClaim[msg.sender] \u003e 0, \"LaunchpadToken: No ETH to claim\");\r\n        require(_balancesToClaimTokens[msg.sender] \u003e 0, \"LaunchpadToken: No ETH to claim\");\r\n       // require(_isRefunded != false , \"LaunchpadToken: Refunded is activated\");\r\n        uint256 amount =  _balancesToClaim[msg.sender];\r\n        _balancesToClaim[msg.sender] = 0;\r\n         uint256 amountTokens =  _balancesToClaimTokens[msg.sender];\r\n        _balancesToClaimTokens[msg.sender] = 0;\r\n        if(_isRefunded){\r\n            // return back funds\r\n            payable(msg.sender).transfer(amount);\r\n            emit Refunded(msg.sender, amount);\r\n            return true;\r\n        }\r\n        // Transfer Tokens to User\r\n        _token.safeTransfer(msg.sender, amountTokens);\r\n        _claimedAmount = _claimedAmount.add(amountTokens);\r\n        emit Claimed(msg.sender, amountTokens);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n    * @dev Function to setup liquidity and transfer all amounts according to defined percents, if softcap not reached set Refunded flag.\r\n    */\r\n    function setupLiquidity() public onlyOwner {\r\n        require(_isSoldOut == true || block.timestamp \u003e _end , \"LaunchpadToken: not sold out or time not elapsed yet\" );\r\n        require(_isRefunded == false, \"Launchpad: refunded is activated\");\r\n        require(_isLiquiditySetup == false, \"Setup has already been completed\");\r\n        _isLiquiditySetup = true;\r\n        if(_raisedETH \u003c _softCap){\r\n            _isRefunded = true;\r\n            return;\r\n        }\r\n        uint256 ethBalance = address(this).balance;\r\n        require(ethBalance \u003e 0, \"LaunchpadToken: eth balance needs to be above zero\" );\r\n        uint256 liquidityAmount = ethBalance.mul(_liquidityPercent).div(_totalPercent);\r\n        uint256 tokensAmount = _token.balanceOf(address(this));\r\n        require(tokensAmount \u003e= liquidityAmount.mul(_BASE_PRICE).div(_priceUniInv), \"Launchpad: Not sufficient tokens amount\");\r\n        uint256 teamAmount = ethBalance.mul(_teamPercent).div(_totalPercent);\r\n        uint256 layerFeeAmount = ethBalance.mul(_fee3).div(_totalPercent);\r\n        uint256 supportFeeAmount = ethBalance.mul(_fee1).div(_totalPercent);\r\n        uint256 stakeFeeAmount = ethBalance.mul(_fee1).div(_totalPercent);\r\n        payable(_layerFeeAddress).transfer(layerFeeAmount);\r\n        payable(_supportFeeAddress).transfer(supportFeeAmount);\r\n        payable(_stakeFeeAddress).transfer(stakeFeeAmount);\r\n        payable(_teamWallet).transfer(teamAmount);\r\n        payable(_liquidityCreator).transfer(liquidityAmount);\r\n        _token.safeTransfer(address(_liquidityCreator), liquidityAmount.mul(_BASE_PRICE).div(_priceUniInv));\r\n    }\r\n\r\n    /**\r\n     * @notice Transfers non used tokens held by Lock to owner.\r\n       @dev Able to withdraw funds after end time and liquidity setup, if refunded is enabled just let token owner \r\n       be able to withraw.\r\n     */\r\n    function release(IERC20 token) public onlyOwner {\r\n        uint256 amount = token.balanceOf(address(this));\r\n        if(_isRefunded){\r\n             token.safeTransfer(_owner, amount);\r\n        }\r\n        // solhint-disable-next-line not-rely-on-time\r\n        require(block.timestamp \u003e= _end || _isSoldOut == true, \"Launchpad: current time is before release time\");\r\n        require(_isLiquiditySetup == true, \"Launchpad: Liquidity is not setup\");\r\n        // TO Define: Tokens not claimed should go back to time after release time?\r\n        require(_claimedAmount == _raisedETH || block.timestamp \u003e= _releaseTime, \"Launchpad: Tokens still to be claimed\");\r\n        require(amount \u003e 0, \"Launchpad: no tokens to release\");\r\n\r\n        token.safeTransfer(_owner, amount);\r\n    }\r\n    \r\n    /**\r\n    * @dev Function to append strings.\r\n    * @param a - string a.\r\n    * @param b - string b.\r\n    * @param c - string c.\r\n    * @param d - string d.\r\n    * @param e - string e.\r\n    * @return new string.\r\n    */    \r\n    function append(string memory a, string memory b, string memory c, string memory d, string memory e) internal pure returns (string memory) {\r\n    return string(abi.encodePacked(a, b, c, d, e));\r\n    }    \r\n}"},"SafeERC20.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.6.0;\r\n\r\nimport \"./IERC20.sol\";\r\nimport \"./SafeMath.sol\";\r\nimport \"./Address.sol\";\r\n\r\n/**\r\n * @title SafeERC20\r\n * @dev Wrappers around ERC20 operations that throw on failure (when the token\r\n * contract returns false). Tokens that return no value (and instead revert or\r\n * throw on failure) are also supported, non-reverting calls are assumed to be\r\n * successful.\r\n * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\r\n * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\r\n */\r\nlibrary SafeERC20 {\r\n    using SafeMath for uint256;\r\n    using Address for address;\r\n\r\n    function safeTransfer(IERC20 token, address to, uint256 value) internal {\r\n        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\r\n    }\r\n\r\n    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\r\n        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\r\n    }\r\n\r\n    /**\r\n     * @dev Deprecated. This function has issues similar to the ones found in\r\n     * {IERC20-approve}, and its usage is discouraged.\r\n     *\r\n     * Whenever possible, use {safeIncreaseAllowance} and\r\n     * {safeDecreaseAllowance} instead.\r\n     */\r\n    function safeApprove(IERC20 token, address spender, uint256 value) internal {\r\n        // safeApprove should only be called when setting an initial allowance,\r\n        // or when resetting it to zero. To increase and decrease it, use\r\n        // \u0027safeIncreaseAllowance\u0027 and \u0027safeDecreaseAllowance\u0027\r\n        // solhint-disable-next-line max-line-length\r\n        require((value == 0) || (token.allowance(address(this), spender) == 0),\r\n            \"SafeERC20: approve from non-zero to non-zero allowance\"\r\n        );\r\n        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\r\n    }\r\n\r\n    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\r\n        uint256 newAllowance = token.allowance(address(this), spender).add(value);\r\n        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\r\n    }\r\n\r\n    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\r\n        uint256 newAllowance = token.allowance(address(this), spender).sub(value, \"SafeERC20: decreased allowance below zero\");\r\n        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\r\n    }\r\n\r\n    /**\r\n     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\r\n     * on the return value: the return value is optional (but if data is returned, it must not be false).\r\n     * @param token The token targeted by the call.\r\n     * @param data The call data (encoded using abi.encode or one of its variants).\r\n     */\r\n    function _callOptionalReturn(IERC20 token, bytes memory data) private {\r\n        // We need to perform a low level call here, to bypass Solidity\u0027s return data size checking mechanism, since\r\n        // we\u0027re implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\r\n        // the target address contains contract code and also asserts for success in the low-level call.\r\n\r\n        bytes memory returndata = address(token).functionCall(data, \"SafeERC20: low-level call failed\");\r\n        if (returndata.length \u003e 0) { // Return data is optional\r\n            // solhint-disable-next-line max-line-length\r\n            require(abi.decode(returndata, (bool)), \"SafeERC20: ERC20 operation did not succeed\");\r\n        }\r\n    }\r\n}\r\n"},"SafeMath.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.6.0;\r\n\r\n/**\r\n * @dev Wrappers over Solidity\u0027s arithmetic operations with added overflow\r\n * checks.\r\n *\r\n * Arithmetic operations in Solidity wrap on overflow. This can easily result\r\n * in bugs, because programmers usually assume that an overflow raises an\r\n * error, which is the standard behavior in high level programming languages.\r\n * `SafeMath` restores this intuition by reverting the transaction when an\r\n * operation overflows.\r\n *\r\n * Using this library instead of the unchecked operations eliminates an entire\r\n * class of bugs, so it\u0027s recommended to use it always.\r\n */\r\nlibrary SafeMath {\r\n    /**\r\n     * @dev Returns the addition of two unsigned integers, reverting on\r\n     * overflow.\r\n     *\r\n     * Counterpart to Solidity\u0027s `+` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Addition cannot overflow.\r\n     */\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c \u003e= a, \"SafeMath: addition overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting on\r\n     * overflow (when the result is negative).\r\n     *\r\n     * Counterpart to Solidity\u0027s `-` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Subtraction cannot overflow.\r\n     */\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\r\n     * overflow (when the result is negative).\r\n     *\r\n     * Counterpart to Solidity\u0027s `-` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Subtraction cannot overflow.\r\n     */\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003c= a, errorMessage);\r\n        uint256 c = a - b;\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the multiplication of two unsigned integers, reverting on\r\n     * overflow.\r\n     *\r\n     * Counterpart to Solidity\u0027s `*` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Multiplication cannot overflow.\r\n     */\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        // Gas optimization: this is cheaper than requiring \u0027a\u0027 not being zero, but the\r\n        // benefit is lost if \u0027b\u0027 is also tested.\r\n        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers. Reverts on\r\n     * division by zero. The result is rounded towards zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\r\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\r\n     * uses an invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\r\n     * division by zero. The result is rounded towards zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\r\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\r\n     * uses an invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003e 0, errorMessage);\r\n        uint256 c = a / b;\r\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n     * Reverts when dividing by zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\r\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n     * invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return mod(a, b, \"SafeMath: modulo by zero\");\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n     * Reverts with custom message when dividing by zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\r\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n     * invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b != 0, errorMessage);\r\n        return a % b;\r\n    }\r\n}\r\n"}}