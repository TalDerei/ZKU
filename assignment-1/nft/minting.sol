// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.4.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MintingContract is ERC721, ERC721URIStorage {
    // mapping tokenId to set of attributes
    // mapping(uint256 => Attributes) public attributes;
    
    // struct containing attributes
    // struct Attributes {
    //     string name;
    //     string description;
    // }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;
    
    // constructor
    constructor() ERC721("ZKContract", "ZK") {}

    // mint function
    function mint(address user, string memory uri)
    public
    {
        // increment tokenID
        _tokenIDs.increment();

        uint256 tokenID = _tokenIDs.current();

        _safeMint(user, tokenID);
        _setTokenURI(tokenID, uri);
        // attributes[tokenID] = Attributes(_name, _description);
    }

    // burn function
    function _burn(uint256 tokenId) 
    internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    // tokenURI containing metadata
    function tokenURI (uint256 tokenID) 
    public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenID);
    }
}