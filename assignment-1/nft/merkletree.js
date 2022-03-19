const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

let whitelistAddresses = [
   "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
   "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
   "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",
   "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"
]

// Leaves, merkleTree, and roothash are all determined prior to claim,
// and whitelist addresses are collected and known beforehand.

// Creates new array 'leafNodes' by hashing all the indexes of the 
// 'whitelistAddresses' using keccack256. Then create a Merkle Tree 
// object using keccack256 as the desired hashing algorithm
const leafNodes = whitelistAddresses.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, {sortPairs: true});

// Return root hash of merkle tree in hex format
const rootHash = merkleTree.getRoot();

// Print mertkle tree
console.log('Whitelist merkle tree\n', merkleTree.toString());

// Client side, you would use msg.sender address to query
// an API that returns the merkle proof required to derive 
// the root hash of the merkle tree
const claimingAddress = leafNodes[0];

// 'getHexProof' returns the neighbor leaf and all parent node hashes 
// (i.e. the merkle path) that will be required to derive the root hash
const hexProof = merkleTree.getHexProof(claimingAddress);

console.log('hexProof is: \n', hexProof.toString());


