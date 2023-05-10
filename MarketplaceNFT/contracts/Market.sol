// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Market {
    struct NFTMarket {
        address seller;
        uint256 price;
        string uri;
        address tokenAddress;
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
    // buyWithERC20
    function listWithERC20(
    address nft,
    uint256 tokenId,
    address tokenAddress,
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
    nftMarket.tokenAddress = tokenAddress;

    SafeERC20.safeTransferFrom(
        ERC20(tokenAddress),
        msg.sender,
        address(this),
        price
    );

    return true;
}

    function buyWithERC20(
        address nft,
        uint256 tokenId
    ) external noReentrant returns (bool) {
        NFTMarket storage nftMarket = _listedNFT[nft][tokenId];
        require(nftMarket.seller != address(0), "Not listed yet");
        uint256 price = nftMarket.price;
        require(price > 0, "Invalid price");

        ERC20 token = ERC20(nftMarket.tokenAddress);
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= price, "Token allowance not enough");

        token.transferFrom(msg.sender, nftMarket.seller, price);
        IERC721(nft).safeTransferFrom(nftMarket.seller, msg.sender, tokenId);
        delete _listedNFT[nft][tokenId];

        return true;
    }

    // cancelList
    function cancelList(address nft, uint256 tokenId) external returns (bool) {
        NFTMarket storage nftMarket = _listedNFT[nft][tokenId];
        require(nftMarket.seller == msg.sender, "Not seller");
        delete _listedNFT[nft][tokenId];
        return true;
    }
}
