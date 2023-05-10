// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./RadesToken.sol";
import "./RadesNFT.sol";
import "./RadesBid.sol";

contract RadesMarketplace is Ownable {
    uint256 _nftCounter;

    RadesToken private RADT;
    RadesNFT private RADN;
    RadesBid private RADB;

    address marketplaceOwner;
    address[] private units ;
    string[] private _productType = ["Image"];

    struct RadesNFT {
        uint256 nftId;
        uint256 productId;
        uint256 priceId;
        string name;
        string description;
        string uri;
        address[] owners;
    }

    event ListedNFT(uint256) ;

    mapping(uint256 => RadesNFT) private _radesNFT;

    function mintNFT(address _from, uint256 _amount, uint256 _productId, uint256 _priceId, string memory _name, string memory description, string memory _uri) private returns(uint256) {
        uint256 _newNFTId = _nftCounter++;
        _radesNFT[_newNFTId].nftId = _newNFTId;
        _radesNFT[_newNFTId].productId = _productId;
        _radesNFT[_newNFTId].priceId = _priceId;
        _radesNFT[_newNFTId].name = _name;
        _radesNFT[_newNFTId].description = _description;
        _radesNFT[_newNFTId].uri = _uri;
        _radesNFT[_newNFTId].owners.push(_from);

        RADN.mint(_from, _newNFTId, _amount);
        return _newNFTId;
    }

    function findNFTById(uint256 _nftId) external view returns(nft memory) {
        return _radesNFT[_nftId] ;
    }
    function _marketplace () external view returns(address) {
        return _marketplaceOwner ;
    }
    modifier isValidNftId(uint256 _nftId) {
        require(_nftId < _nftCounter, "NFT Invalid") ;
        _;
    }
    modifier isOwner(address _account) {
        require(_account == marketplace_owner, "OK") ;
        _;
    }
}
