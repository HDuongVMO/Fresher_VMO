// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RadesBid {
    address private marketplace = address(0);
    enum BidStatus{Pending, Accepted, Denied}

    uint256 _bidCounter;

    modifier isCalledMarketplace() {
        require(marketplace == msg.sender, "Invalid") ;
        _;
    }

    modifier isValidBidId(uint256 _bidId) {
        require(_bidCounter > _bidId, "Invalid");
        _;
    }

    struct bid {
        uint256 bidId;
        uint256 nftId;
        address from;
        address to;
        uint256 amount;
        uint256 price;
        BidStatus status;
        uint256 placeAt;
        uint256 checkedAt;
    }

    mapping(uint256 => bid) private bidData;
    
    function setMarketplaceToBid(address _marketplace) external {
        require(_marketplace == address(0), "Invalid");
        marketplace = _marketplace;
    }

    function place(uint256 _nftId, address _from, address _to, uint256 _amount, uint256 _price) external isCalledMarketplace {
        uint256 _newBidId = _bidCounter;

        bidData[_newBidId].bidId = _newBidId;
        bidData[_newBidId].nftId = _nftId;
        bidData[_newBidId].from = _from;
        bidData[_newBidId].to = _to;
        bidData[_newBidId].amount = _amount;
        bidData[_newBidId].price = _price;
        bidData[_newBidId].status = BidStatus.Pending;
        bidData[_newBidId].placeAt = block.timestamp;
        bidData[_newBidId].checkedAt = block.timestamp;

        _bidCounter++;
    }

    function accept(uint256 _bidId) external isValidBidId(_bidId) isCalledMarketplace {
        bidData[_bidId].status = BidStatus.Accepted;
        bidData[_bidId].checkedAt = block.timestamp;
    }

    function deniedBid(uint256 _bidId) external isValidBidId(_bidId) {
        require(bidData[_bidId].from == msg.sender, "You can't deny this bid") ;

        bidData[_bidId].status = BidStatus.Denied;
        bidData[_bidId].checkedAt = block.timestamp;
    }

    function findBid(uint256 _bidId) external isValidBidId(_bidId) view returns(bid memory) {
        return bidData[_bidId];
    }

    function isPending(uint256 _bidId) external isValidBidId(_bidId) view returns(bool) {
        if(bidData[_bidId].status == BidStatus.Pending) return true;
        return false;
    }
}