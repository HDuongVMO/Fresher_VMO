// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract RadesVault {
    mapping (address => uint256) _balances;

    receive() external payable {
        _balances[msg.sender] += msg.value;
    }

    function deposit() external payable{
        _balances[msg.sender] += msg.value;
    }

    function withDrawl(uint256 amount) public returns(bool) {
        require(_balances[msg.sender] >= amount,"Invalid");
        (bool success, ) = msg.sender.call{value: amount}("");
        _balances[msg.sender] -= amount;
        return success;
    }

    function balanceOf(address account) public view returns(uint256) {
        return _balances[account];
    }

    function transferVault(address _to, uint256 _amount) public {
        require(_balances[msg.sender] > _amount, "Invalid");
        _balances[msg.sender] -= _amount;
        _balances[_to] += _amount;
    }
    
    mapping(address => mapping(address => uint256)) private _allowances;

    function transferFromVault(address from, address to, uint256 amount) public returns (bool) {
    require(_balances[from] >= amount, "Balance invalid");
    require(_allowances[from][msg.sender] >= amount, "Allowance invalid");
    _balances[from] -= amount;
    _balances[to] += amount;
    _allowances[from][msg.sender] -= amount;
    return true;
    }

    function approveVault(address spender, uint256 amount) public returns (bool) {
    _allowances[msg.sender][spender] = amount;
    return true;
    }
}
