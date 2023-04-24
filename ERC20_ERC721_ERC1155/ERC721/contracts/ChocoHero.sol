// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChocoHero is  ERC721URIStorage, Ownable{
    constructor() ERC721("ChocoHero","CCH") {}

    function mint(address _to, uint256 _tokenId, string calldata _uri) external {
        _mint(_to, _tokenId);
        _setTokenURI(_tokenId, _uri);
    }
}