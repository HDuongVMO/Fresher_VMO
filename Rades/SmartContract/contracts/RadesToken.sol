// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RadesToken is ERC20("Rades", "RDS"), ERC20Burnable, Ownable {
    uint256 private cap = 50_000_000 * 10 ** uint256(18);
    constructor(){
        _mint(msg.sender, cap);
        transferOwnership(msg.sender);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(
            ERC20.totalSupply() + amount <= cap,
            "Rades: cap exceeded"
        );
        _mint(to, amount);
    }
}