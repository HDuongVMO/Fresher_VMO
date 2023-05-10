// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault{
    mapping (address => uint256) _balances;

    receive() external payable {
        _balances[msg.sender] += msg.value;
    }

    function deposit() external payable{
        _balances[msg.sender] += msg.value;
    }

    function withDrawl(uint256 _amount) public returns(bool) {
        require(_balances[msg.sender] >= _amount,"Invalid");
        (bool success, ) = msg.sender.call{value: _amount}("");
        _balances[msg.sender] -= _amount;
        return success;
    }

    function balanceOf(address account) public view returns(uint256) {
        return _balances[account];
    }

    function transferVault(address _to, uint256 _amount) public returns(bool) {
    require(_balances[msg.sender] >= _amount, "Invalid");
    _balances[msg.sender] -= _amount;
    _balances[_to] += _amount;
    return true;
    }
    
    mapping(address => mapping(address => uint256)) private _allowances;

    function transferFromVault(address _from, address _to, uint256 _amount) public returns (bool) {
    require(_balances[_from] >= _amount, "Balance invalid");
    require(_allowances[_from][msg.sender] >= _amount, "Allowance invalid");
    _balances[_from] -= _amount;
    _balances[_to] += _amount;
    _allowances[_from][msg.sender] -= _amount;
    return true;
    }

    function approveVault(address _spender, uint256 _amount) public returns (bool) {
    _allowances[msg.sender][_spender] = _amount;
    return true;
    }
}