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

    function senderSimilarAmount ( address[] memory _addresses, uint amount ) external onlyOwner { 
        for ( uint i = 0; i < _addresses.length; i++) {
            require(_addresses[i] != address(0), "zerro address!");
            token.transferFrom(msg.sender, _addresses[i], amount);
        }
    }

    function senderDifferentAnount ( address[] memory _addresses, uint[] memory amount ) external onlyOwner { 
        require ( _addresses.length == amount.length , " REJECTED" ); 
            for ( uint i = 0 ; i < amount.length; i++ ){ 
                require(_addresses[i] != address(0), "zerro address!");
                token.transferFrom(msg.sender, _addresses[i], amount[i]); 
            }
    }

    function sendMultiETH(
        address payable[] memory listReceivers,
        uint256[] memory listAmounts
    ) public payable {
        uint256 totalReceivers = listReceivers.length;
        uint256 totalAmounts;
        for (uint256 i = 0; i < totalReceivers; i++) {
            totalAmounts += listAmounts[i];
        }
        require(msg.sender.balance >= totalAmounts, "Total balance not enough");
        require(msg.value == totalAmounts, "Value not enough");
        for (uint256 i = 0; i < totalReceivers; i++) {
            (bool success, bytes memory data) = listReceivers[i].call{
                value: listAmounts[i]
            }("");
            delete data;
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
