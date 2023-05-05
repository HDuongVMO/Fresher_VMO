// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract Market {
    struct NFTMarket {
        address seller;
        uint256 price;
        string uri;
    }

    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    mapping(address => mapping(uint256 => NFTMarket)) _listedNFT;

    function list(
        address nft,
        uint256 tokenId,
        uint256 price
    ) external returns (bool) {
        require(IERC721(nft).ownerOf(tokenId) == msg.sender, "Not owner");
        require(
            IERC721(nft).getApproved(tokenId) == address(this),
            "Must be approved"
        );
        NFTMarket storage nftMarket = _listedNFT[nft][tokenId];
        nftMarket.seller = msg.sender;
        nftMarket.price = price;
        nftMarket.uri = IERC721Metadata(nft).tokenURI(tokenId);
        return true;
    }

    function buy(address nft, uint256 tokenId)
        external
        payable
        noReentrant
        returns (bool)
    {
        NFTMarket storage nftMarket = _listedNFT[nft][tokenId];
        require(nftMarket.seller != address(0), "Not listed yet");
        require(nftMarket.price == msg.value, "Invalid price");
        (bool success, ) = nftMarket.seller.call{value: msg.value}("");
        require(success, "Transfer ETH fail");
        IERC721(nft).safeTransferFrom(nftMarket.seller, msg.sender, tokenId);
        // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
        delete _listedNFT[nft][tokenId];
        return true;
    }

    // listWithERC20
    function listWithERC20(
        address nft,
        uint256 tokenId,
        uint256 price,
        address tokenAddress,
        uint256 tokenAmount
    ) external returns (bool) {
        require(IERC721(nft).ownerOf(tokenId) == msg.sender, "Not owner");
        require(
            IERC721(nft).getApproved(tokenId) == address(this),
            "Must be approved"
        );
        require(
            IERC20(tokenAddress).balanceOf(msg.sender) >= tokenAmount,
            "Insufficient balance"
        );
        require(
            IERC20(tokenAddress).allowance(msg.sender, address(this)) >=
                tokenAmount,
            "Insufficient allowance"
        );
        NFTMarket storage nftMarket = _listedNFT[nft][tokenId];
        nftMarket.seller = msg.sender;
        nftMarket.price = price;
        nftMarket.uri = IERC721Metadata(nft).tokenURI(tokenId);
        require(
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                address(this),
                tokenAmount
            ),
            "Token transfer failed"
        );
        return true;
    }

    // cancelList
    function cancelList(address nft, uint256 tokenId) external returns (bool) {
        NFTMarket storage nftMarket = _listedNFT[nft][tokenId];
        require(nftMarket.seller == msg.sender, "Not seller");
        delete _listedNFT[nft][tokenId];
        return true;
    }

    // buyWithERC20
    function buyWithERC20(
        address nft,
        uint256 tokenId,
        address tokenAddress,
        uint256 tokenAmount
    ) external noReentrant returns (bool) {
        NFTMarket storage nftMarket = _listedNFT[nft][tokenId];
        require(nftMarket.seller != address(0), "Not listed yet");
        require(
            IERC20(tokenAddress).balanceOf(msg.sender) >= tokenAmount,
            "Insufficient balance"
        );
        require(
            IERC20(tokenAddress).allowance(msg.sender, address(this)) >=
                tokenAmount,
            "Insufficient allowance"
        );
        require(
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                nftMarket.seller,
                tokenAmount
            ),
            "Token transfer failed"
        );
        IERC721(nft).safeTransferFrom(nftMarket.seller, msg.sender, tokenId);
        delete _listedNFT[nft][tokenId];
        return true;
    }

    // https://solidity-by-example.org/app/english-auction/
}

contract Auction is Ownable {

    IERC721 private nft;
    IERC20 private token;

    uint public constant AUCTION_SERVICE_FEE_RATE = 3; 

    uint public constant MINIMUM_BID_RATE = 110; 

    constructor (IERC20 _token, IERC721 _nft) {
        token = _token;
        nft = _nft;
    }

    struct AuctionInfo {
        address auctioneer;
        uint256 _tokenId;
        uint256 initialPrice;

        address previousBidder;

        uint256 lastBid;
        address lastBidder;
        
        uint256 startTime;
        uint256 endTime;

        bool completed;
        bool active;
        uint256 auctionId;
    }

    AuctionInfo[] private auction;

    function createAuction(uint256 _tokenId, uint256 _initialPrice, uint256 _startTime, uint256 _endTime) public {
        
        require(block.timestamp <= _startTime, "Auction can not start");
        require(_startTime < _endTime, "Auction can not end before it starts");
        require(0 < _initialPrice, "Initial price must be greater than 0");
        require(nft.ownerOf(_tokenId) == msg.sender, "Must stake your own token");
        require(nft.getApproved(_tokenId) == address(this), "This contract must be approved to transfer the token");

        nft.safeTransferFrom(msg.sender, address(this), _tokenId);

        AuctionInfo memory _auction = AuctionInfo(
            msg.sender,
            _tokenId,        
            _initialPrice,  

            address(0),       
            _initialPrice,     
            address(0),        

            _startTime,      
            _endTime,     

            false,              
            true,               
            auction.length      
        );

        auction.push(_auction);
    }


    function joinAuction(uint256 _auctionId, uint256 _bid) public {

        AuctionInfo memory _auction = auction[_auctionId];

        require(block.timestamp >= _auction.startTime, "Auction has not started");
        require(_auction.completed == false, "Auction is already completed");
        require(_auction.active, "Auction is not active");

        uint256 _minBid = _auction.lastBidder == address(0) ? _auction.initialPrice : _auction.lastBid * MINIMUM_BID_RATE / 100;

        require(_minBid <= _bid, "Bid price must be greater than the minimum price");

        require(token.balanceOf(msg.sender) >= _bid, "Insufficient balance");
        require(token.allowance(msg.sender, address(this)) >= _bid, "Insufficient allowance");

        require(_auction.auctioneer != msg.sender, "Can not bid on your own auction");

        SafeERC20.safeTransferFrom(token, msg.sender, address(this), _bid);

        if (_auction.lastBidder != address(0)) {
            token.transfer(_auction.lastBidder, _auction.lastBid);
        }

        auction[_auctionId].previousBidder = _auction.lastBidder;
        auction[_auctionId].lastBidder = msg.sender;
        auction[_auctionId].lastBid = _bid;
    }

    function finishAuction(uint256 _auctionId) public onlyAuctioneer(_auctionId){
        
        require(auction[_auctionId].completed == false, "Auction is already completed");
        require(auction[_auctionId].active, "Auction is not active");

        nft.safeTransferFrom(address(this), auction[_auctionId].lastBidder, auction[_auctionId]._tokenId);

        uint256 lastBid = auction[_auctionId].lastBid;
        uint256 profit = auction[_auctionId].lastBid - auction[_auctionId].initialPrice;

        uint256 auctionServiceFee = profit * AUCTION_SERVICE_FEE_RATE / 100;

        uint256 auctioneerReceive = lastBid - auctionServiceFee;

        token.transfer(auction[_auctionId].auctioneer, auctioneerReceive);

        auction[_auctionId].completed = true;
        auction[_auctionId].active = false;
    }

    function cancelAuction(uint256 _auctionId) public onlyAuctioneer(_auctionId) {
        
        require(auction[_auctionId].completed == false, "Auction is already completed");
        require(auction[_auctionId].active, "Auction is not active");

        nft.safeTransferFrom(address(this), auction[_auctionId].auctioneer, auction[_auctionId]._tokenId);

        if (auction[_auctionId].lastBidder != address(0)) {
            token.transfer(auction[_auctionId].lastBidder, auction[_auctionId].lastBid);
        }
        auction[_auctionId].completed = true;
        auction[_auctionId].active = false;
    }
    
    modifier onlyAuctioneer(uint256 _auctionId) {
        require((msg.sender == auction[_auctionId].auctioneer||msg.sender==owner()), "Only auctioneer or owner can perform this action");
        _;
    }

}

contract NFT is ERC721 {
    mapping(uint256 => string) _uri;

    constructor() ERC721("Book", "BK") {}

    function mint(uint256 tokenId, string calldata uri) external {
        _mint(msg.sender, tokenId);
        _uri[tokenId] = uri;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return _uri[tokenId];
    }
}
