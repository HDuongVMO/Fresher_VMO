// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract WalletContract {
    mapping (address => uint256) private balances;

    event Burn(address indexed from, uint256 amount);
    event Mint(address indexed to, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function getBalance(address account) public view returns(uint256) {
        return balances[account];
    }

    function burnToken(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        emit burnToken(msg.sender, amount);
    }

    function mintToken(address _to, uint256 amount) public {
        balances[_to] += amount;
        emit mintToken(msg.sender, amount);
    }

    function transferToken(address _to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[_to] += amount;
        emit transferToken(msg.sender ,_to, amount);
    }
}