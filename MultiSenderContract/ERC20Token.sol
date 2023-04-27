// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    constructor() ERC20("Choco", "CCT") {
        _mint(msg.sender, 100000);
    }
}

// [
// "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
// "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",
// "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"
// ]