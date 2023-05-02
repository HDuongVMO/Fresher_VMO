// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 

contract Multisender is Ownable {
    IERC20 public token; 
     constructor (  address _token ) { 
        require ( _token != address(0), "ZERRO address");
        token = IERC20(_token);
    }
    function sendERC20TokendERC20Token ( address[] memory _addresses, uint[] memory amount ) external onlyOwner { 
        require ( _addresses.length == amount.length , " REJECTED" ); 
            for ( uint i = 0 ; i < amount.length; i++ ){ 
                require(_addresses[i] != address(0), "zero address!");
                token.transferFrom(msg.sender, _addresses[i], amount[i]); 
            }
    }

    mapping (address => uint256) _balances;

    function deposit() external payable{
        _balances[msg.sender] += msg.value;
    }
    function sendETH(address payable[] memory receivers, uint256[] memory amounts) public payable {
        require(receivers.length == amounts.length, "Invalid input");
        for (uint i = 0; i < receivers.length; i++) {
            receivers[i].transfer(amounts[i]);
        }
    }

    function sendNFTs(address _nftContractAddress, address[] memory _receivers, uint256[] memory _tokenIds) external {
        require(_receivers.length > 0 && _receivers.length == _tokenIds.length, "Invalid receiver or token ID count");
        
        IERC721 nft = IERC721(_nftContractAddress);
        for (uint i = 0; i < _tokenIds.length; i++) {
            nft.safeTransferFrom(msg.sender, _receivers[i], _tokenIds[i]);
        }
    }
}
