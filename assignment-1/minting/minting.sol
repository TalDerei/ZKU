// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.4.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC721/extensions/ERC721Metadata.sol";

contract MintingContract is ERC721, ERC721URIStorage, ERC721Metadata {
    constructor() ERC721("ZKContract", "ZK") {}
    uint256 public constant maxSupply = 100;

    function minting(address user, uint256 tokenID, string memory uri) public
    {
        // require (totalSupply() < maxSupply);
        _safeMint(user, tokenID);
        _setTokenURI(tokenID, uri);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI (uint256 tokenID) 
    public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenID);
    }
}
