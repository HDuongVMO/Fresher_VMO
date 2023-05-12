// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./RadesToken.sol";
import "./RadesBid.sol";
import "./RadesNFT.sol";
import "./RadesRare.sol";

contract RadesMarketplace is Ownable {
    uint256 _nftCounter;

    RadesToken private RADT;
    RadesBid private RADB;
    RadesNFT private RADN;
    RadesRare private RADR;

    address marketplaceOwner;
    address[] private units;
    string[] private _productType = ["Ebook", "Video", "Image"];
    string private _productUnits = "rare";

    struct _RadesNFT {
        uint256 nftId;
        uint256 productId;
        uint256 priceId;
        string uri;
        address[] owners;
    }

    event ListedNFT(uint256);

    mapping(uint256 => _RadesNFT) private _radesNFT;

    constructor(address _RADT, address _RADB, address _RADN, address _RADR) {
        RADT = RadesToken(_RADT);
        RADB = RadesBid(_RADB);
        RADN = RadesNFT(_RADN);
        RADR = RadesRare(_RADR);

        marketplaceOwner = msg.sender;

        RADB.setMarketplaceToBid(address(this));
        RADN.setMarketplaceToNFT(address(this));
        RADR.setMarketplaceToRare(address(this));

        units.push(0x15D2e636E8B6113863D033cfb149916A37C482C0);
        units.push(_RADT);
    }

    function mintNFT(
        address _from,
        uint256 _amount,
        uint256 _productId,
        uint256 _priceId,
        string memory _uri
    ) private returns (uint256) {
        uint256 _newNFTId = _nftCounter++;
        _radesNFT[_newNFTId].nftId = _newNFTId;
        _radesNFT[_newNFTId].productId = _productId;
        _radesNFT[_newNFTId].priceId = _priceId;
        _radesNFT[_newNFTId].uri = _uri;
        _radesNFT[_newNFTId].owners.push(_from);

        RADN.mint(_from, _newNFTId, _amount);
        return _newNFTId;
    }

    function mintRare(
        uint256 _productId,
        RadesRare.rareParam memory _rareParam,
        string memory _uri
    ) external isValidProductId(_productId) isValidUnitId(_rareParam.bidUnit) {
        require(_rareParam.minimumBid > 0, "Minimum Bid: Invalid");
        require(_rareParam.itemAvailable > 0, "Item Available: Invalid");
        require(_rareParam.royalty > 0, "Royalty: Invalid");

        address _creator = msg.sender;
        uint256 _newId = mintNFT(
            msg.sender,
            _rareParam.itemAvailable,
            _productId,
            2,
            _uri
        );

        RADR.addRadesRare(_newId, _rareParam, _creator, false);
        RADR.updateOwner(_newId, _creator, 1);
    }

    function placeBid(
        uint256 _nftId,
        uint256 _amount,
        uint256 _price
    ) external isValidNftId(_nftId) isRare(_nftId){
        RadesRare.rare memory _rare = RADR.fetchRare(_nftId);

        address _creator = _rare.creator;
        require(_rare.creator != msg.sender , "You are creator") ;
        require(_rare.itemAvailable >= _amount, "Invalid amount") ;
        require(_rare.minimumBid <= _price, "Bid price is lower than minimum bid price") ;

        RADB.placeBid(_nftId, _creator, msg.sender, _amount, _price);

        delete _rare ;
    }

    function paymentBid(
        address _to,
        uint256 _price,
        uint256 _priceUnit
    ) external isValidUnitId(_priceUnit) {
        require(
            IERC20(units[_priceUnit]).balanceOf(msg.sender) >= _price,
            "Invalid balance"
        );
        IERC20(units[_priceUnit]).transferFrom(
            msg.sender,
            marketplaceOwner,
            _price / 100
        );
        IERC20(units[_priceUnit]).transferFrom(
            msg.sender,
            _to,
            (_price * 99) / 100
        );
    }

    function findNFTById(
        uint256 _nftId
    ) external view returns (_RadesNFT memory) {
        return _radesNFT[_nftId];
    }

    function radesMarketplace() external view returns (address) {
        return marketplaceOwner;
    }

    modifier isValidNftId(uint256 _nftId) {
        require(_nftId < _nftCounter, "NFT Invalid");
        _;
    }

    modifier isRare(uint256 _nftId) {
        require(_radesNFT[_nftId].priceId == 2, "Invalid Rare");
        _;
    }

    modifier isOwner(address _account) {
        require(_account == marketplaceOwner, "OK");
        _;
    }

    modifier isValidProductId(uint256 _productId) {
        require(_productId < _productType.length);
        _;
    }

    modifier isValidUnitId(uint256 _uintId) {
        require(_uintId < units.length, "Invalid");
        _;
    }
}
