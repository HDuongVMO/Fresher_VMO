// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

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