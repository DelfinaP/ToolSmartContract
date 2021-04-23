pragma solidity ^0.5.2;
/*
        Uniswap Gold is the abbreviation of UNIG www.unig.finance
        Uniswap Gold's success is due to the core technology from UNI.
        The development core team comes from the United States, China, and South Korea.
        The UNI technology is independently forked and upgraded to a cluster interactive intelligent aggregator,
        which aggregates multiple platforms Agreement to realize the interaction of assets on different decentralized liquidity platforms.
        */
contract ERC20Interface {
  string public name;
  string public symbol;
  uint8 public decimals;
  uint public totalSupply;
  function transfer(address _to, uint256 _value) public returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
  function approve(address _spender, uint256 _value) public returns (bool success);
  function allowance(address _owner, address _spender) public view returns (uint256 remaining);
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
contract UniswapGold is ERC20Interface {
  mapping (address => uint256) public balanceOf;
  mapping (address => mapping (address => uint256) ) internal allowed;
  constructor() public {
    name = "Uniswap Gold";
    symbol = "UNIG";
    decimals = 18;
    // 
     totalSupply = 1000000000* (10 ** 18);
    balanceOf[msg.sender] = totalSupply;
  }
  function transfer(address _to, uint256 _value) public returns (bool success){
    require(_to != address(0));
    require(balanceOf[msg.sender] >= _value);
    require(balanceOf[_to] + _value >= balanceOf[_to]);
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    success = true;
  }
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
    require(_to != address(0));
    require(balanceOf[_from] >= _value);
    require(allowed[_from][msg.sender]  >= _value);
    require(balanceOf[_to] + _value >= balanceOf[_to]);
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allowed[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
    success = true;
  }
  function approve(address _spender, uint256 _value) public returns (bool success){
      require((_value == 0)||(allowed[msg.sender][_spender] == 0));
      allowed[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      success = true;
  }
  function allowance(address _owner, address _spender) public view returns (uint256 remaining){
    return allowed[_owner][_spender];
  }
}