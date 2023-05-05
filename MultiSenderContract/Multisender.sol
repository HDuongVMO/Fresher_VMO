// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";


contract Multisender is Ownable {
    IERC20 public token; 
     constructor (  address _token ) { 
        require (_token != address(0));
        token = IERC20(_token);
    }
    function sendERC20Token ( address[] memory _addresses, uint[] memory amount ) external onlyOwner { 
      require ( _addresses.length == amount.length , "Invalid" ); 
      for ( uint i = 0 ; i < amount.length; i++ ){ 
        require(_addresses[i] != address(0), "Invalid!");
        token.transferFrom(msg.sender, _addresses[i], amount[i]); 
      }
    }

    mapping (address => uint256) _balances;

    receive() external payable {
        _balances[msg.sender] += msg.value;
    }
    function sendETH(address payable[] memory receivers, uint256[] memory amounts) public payable {
      require(receivers.length == amounts.length, "Invalid input");
      for (uint i = 0; i < receivers.length; i++) {
        (bool success, ) = receivers[i].call{value: amounts[i]}("");
        require(success, "Failed to send eth");
      }
    }

    function sendERC721Tokend (
      address tokenAddress, 
      address[] memory receivers,
      uint256[] memory tokenIds
    ) external onlyOwner {
      require(receivers.length == tokenIds.length, "Invalid input");  
      for (uint256 i = 0; i < receivers.length; i++) {
        IERC721(tokenAddress).safeTransferFrom(msg.sender, receivers[i], tokenIds[i]);
      }
    }
}
