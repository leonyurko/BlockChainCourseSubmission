// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CourseERC20
 * @dev Basic Fungible Token Contract
 */
contract CourseERC20 {
    string public constant name = "CourseToken";
    string public constant symbol = "CRS";
    uint8 public constant decimals = 18;
    
    mapping(address => uint256) public balanceOf;
    event Transfer(address indexed from, address indexed to, uint256 value);
    uint256 public totalSupply;
    uint256 private constant INITIAL_SUPPLY = 1000000 * (10**18);

    constructor() {
        totalSupply = INITIAL_SUPPLY;
        balanceOf[msg.sender] = INITIAL_SUPPLY;
        emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
    }

    /**
     * @dev Transfer tokens to a specified address
     * @param to Recipient address
     * @param amount Amount of tokens to transfer
     * @return success True if transfer successful
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "ERC20: Insufficient balance");
        
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }
}
