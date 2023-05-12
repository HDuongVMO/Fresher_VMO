/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract RadesNFT is ERC1155 {
    address private radesMarketplace = address(0);

    constructor() ERC1155("") {}

    function setMarketplaceToNFT(address _radesMarketplace) external {
        radesMarketplace = _radesMarketplace;
    }

    modifier isCalledMarketplace() {
        require(radesMarketplace == msg.sender, "Invalid");
        _;
    }

    function mint(
        address _from,
        uint256 _id,
        uint256 _amount
    ) external isCalledMarketplace {
        _mint(_from, _id, _amount, "");
    }

    function transfer(
        uint256 _nftId,
        address _from,
        address _to,
        uint256 _amount
    ) external isCalledMarketplace {
        _setApprovalForAll(_from, msg.sender, true);
        safeTransferFrom(_from, _to, _nftId, _amount, "");
    }

    function _balanceOf(
        address _owner,
        uint256 _nftId
    ) external view returns (uint256) {
        return balanceOf(_owner, _nftId);
    }
}
