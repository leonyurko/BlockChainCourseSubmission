const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RoyaltyNFT Contract", function () {
  let royaltyNFT;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    
    const RoyaltyNFT = await ethers.getContractFactory("RoyaltyNFT");
    royaltyNFT = await RoyaltyNFT.deploy();
    await royaltyNFT.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the right creator", async function () {
      expect(await royaltyNFT.creatorAddress()).to.equal(owner.address);
    });

    it("Should have correct name and symbol", async function () {
      expect(await royaltyNFT.name()).to.equal("CourseFinalNFT");
      expect(await royaltyNFT.symbol()).to.equal("CFN");
    });
  });

  describe("Minting", function () {
    it("Should mint a new NFT", async function () {
      await royaltyNFT.mint(addr1.address);
      expect(await royaltyNFT.ownerOf(0)).to.equal(addr1.address);
    });

    it("Should increment token IDs", async function () {
      await royaltyNFT.mint(addr1.address);
      await royaltyNFT.mint(addr2.address);
      
      expect(await royaltyNFT.ownerOf(0)).to.equal(addr1.address);
      expect(await royaltyNFT.ownerOf(1)).to.equal(addr2.address);
    });
  });

  describe("Transfer with Royalty", function () {
    beforeEach(async function () {
      await royaltyNFT.mint(addr1.address);
    });

    it("Should transfer NFT and pay royalty", async function () {
      const royaltyAmount = ethers.parseEther("0.01");
      
      const ownerBalanceBefore = await ethers.provider.getBalance(owner.address);
      
      await royaltyNFT.connect(addr1).transferFrom(
        addr1.address,
        addr2.address,
        0,
        { value: royaltyAmount }
      );
      
      const ownerBalanceAfter = await ethers.provider.getBalance(owner.address);
      const expectedRoyalty = royaltyAmount * BigInt(10) / BigInt(100);
      
      expect(await royaltyNFT.ownerOf(0)).to.equal(addr2.address);
      expect(ownerBalanceAfter - ownerBalanceBefore).to.equal(expectedRoyalty);
    });

    it("Should store previous owner", async function () {
      const royaltyAmount = ethers.parseEther("0.01");
      
      await royaltyNFT.connect(addr1).transferFrom(
        addr1.address,
        addr2.address,
        0,
        { value: royaltyAmount }
      );
      
      expect(await royaltyNFT.previousOwners(0)).to.equal(addr1.address);
    });

    it("Should revert if not owner", async function () {
      await expect(
        royaltyNFT.connect(addr2).transferFrom(
          addr1.address,
          addr2.address,
          0,
          { value: ethers.parseEther("0.01") }
        )
      ).to.be.revertedWith("NFT: caller must be the owner");
    });
  });
});

describe("CourseERC20 Contract", function () {
  let courseERC20;
  let owner;
  let addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    
    const CourseERC20 = await ethers.getContractFactory("CourseERC20");
    courseERC20 = await CourseERC20.deploy();
    await courseERC20.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should have correct name and symbol", async function () {
      expect(await courseERC20.name()).to.equal("CourseToken");
      expect(await courseERC20.symbol()).to.equal("CRS");
    });

    it("Should assign total supply to owner", async function () {
      const ownerBalance = await courseERC20.balanceOf(owner.address);
      expect(await courseERC20.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transactions", function () {
    it("Should transfer tokens", async function () {
      const transferAmount = ethers.parseEther("100");
      
      await courseERC20.transfer(addr1.address, transferAmount);
      expect(await courseERC20.balanceOf(addr1.address)).to.equal(transferAmount);
    });

    it("Should fail if sender doesn't have enough tokens", async function () {
      const initialOwnerBalance = await courseERC20.balanceOf(owner.address);
      
      await expect(
        courseERC20.connect(addr1).transfer(owner.address, ethers.parseEther("1"))
      ).to.be.revertedWith("ERC20: Insufficient balance");
    });
  });
});
