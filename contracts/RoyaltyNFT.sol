// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title RoyaltyNFT
 * @dev NFT Contract with 10% Royalty on Transfer & Owner Memory
 * The royalty is based on ETH sent with the transaction (msg.value).
 */
contract RoyaltyNFT {
    string public constant name = "CourseFinalNFT";
    string public constant symbol = "CFN";
    address public immutable creatorAddress;
    
    mapping(uint256 => address) private _owners;
    mapping(uint256 => address) public previousOwners; // Owner Memory Requirement
    
    uint256 private _nextTokenId;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event RoyaltyPaid(address indexed creator, uint256 amount);

    constructor() {
        creatorAddress = msg.sender;
    }

    /**
     * @dev Mints a new NFT to the specified address
     * @param to Address to mint the NFT to
     * @return newId The token ID of the newly minted NFT
     */
    function mint(address to) public returns (uint256) {
        uint256 newId = _nextTokenId++;
        _owners[newId] = to;
        emit Transfer(address(0), to, newId);
        return newId;
    }

    /**
     * @dev Returns the owner of the specified token ID
     * @param tokenId The token ID to query
     * @return The address of the token owner
     */
    function ownerOf(uint256 tokenId) public view returns (address) {
        require(_owners[tokenId] != address(0), "NFT: invalid token ID");
        return _owners[tokenId];
    }
    
    /**
     * @dev Transfers an NFT with 10% royalty payment to creator
     * @param from Current owner address
     * @param to Recipient address
     * @param tokenId Token ID to transfer
     */
    function transferFrom(address from, address to, uint256 tokenId) public payable {
        require(ownerOf(tokenId) == from, "NFT: sender must be owner");
        require(msg.sender == from, "NFT: caller must be the owner (simplified check)");
        require(to != address(0), "NFT: transfer to the zero address");

        // --- 10% Royalty Logic ---
        uint256 totalValue = msg.value;
        uint256 royaltyAmount = totalValue * 10 / 100;

        require(totalValue >= royaltyAmount, "NFT: Insufficient value sent for royalty");

        // Pay royalty to the creator
        (bool successRoyalty, ) = creatorAddress.call{value: royaltyAmount}("");
        require(successRoyalty, "NFT: Royalty payment failed");
        
        // Refund excess ETH back to the sender
        uint256 remainingValue = totalValue - royaltyAmount;
        if (remainingValue > 0) {
            (bool successRefund, ) = msg.sender.call{value: remainingValue}("");
            if (!successRefund) {
                 // Log or handle failed refund gracefully
            }
        }
        
        emit RoyaltyPaid(creatorAddress, royaltyAmount);
        
        // --- Token Transfer and Owner Memory ---
        previousOwners[tokenId] = from; // Store previous owner
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
}
