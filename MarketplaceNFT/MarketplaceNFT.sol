// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

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
