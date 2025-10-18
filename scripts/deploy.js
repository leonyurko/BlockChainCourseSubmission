const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("🚀 Starting deployment...\n");

  // Get the deployer's address
  const [deployer] = await hre.ethers.getSigners();
  console.log("📝 Deploying contracts with account:", deployer.address);
  
  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("💰 Account balance:", hre.ethers.formatEther(balance), "ETH\n");

  // Deploy RoyaltyNFT
  console.log("🎨 Deploying RoyaltyNFT...");
  const RoyaltyNFT = await hre.ethers.getContractFactory("RoyaltyNFT");
  const royaltyNFT = await RoyaltyNFT.deploy();
  await royaltyNFT.waitForDeployment();
  const nftAddress = await royaltyNFT.getAddress();
  console.log("✅ RoyaltyNFT deployed to:", nftAddress);

  // Deploy CourseERC20
  console.log("\n💎 Deploying CourseERC20...");
  const CourseERC20 = await hre.ethers.getContractFactory("CourseERC20");
  const courseERC20 = await CourseERC20.deploy();
  await courseERC20.waitForDeployment();
  const erc20Address = await courseERC20.getAddress();
  console.log("✅ CourseERC20 deployed to:", erc20Address);

  // Mint some NFTs for testing
  console.log("\n🎨 Minting test NFTs...");
  const mintTx1 = await royaltyNFT.mint(deployer.address);
  await mintTx1.wait();
  console.log("✅ Minted NFT #0 to deployer");

  const mintTx2 = await royaltyNFT.mint(deployer.address);
  await mintTx2.wait();
  console.log("✅ Minted NFT #1 to deployer");

  // Save deployment info
  const deploymentInfo = {
    network: hre.network.name,
    chainId: (await hre.ethers.provider.getNetwork()).chainId.toString(),
    deployer: deployer.address,
    contracts: {
      RoyaltyNFT: {
        address: nftAddress,
        name: "CourseFinalNFT",
        symbol: "CFN"
      },
      CourseERC20: {
        address: erc20Address,
        name: "CourseToken",
        symbol: "CRS"
      }
    },
    timestamp: new Date().toISOString()
  };

  // Save to JSON file
  const deploymentsDir = path.join(__dirname, "..", "deployments");
  if (!fs.existsSync(deploymentsDir)) {
    fs.mkdirSync(deploymentsDir);
  }

  const deploymentPath = path.join(deploymentsDir, `${hre.network.name}.json`);
  fs.writeFileSync(deploymentPath, JSON.stringify(deploymentInfo, null, 2));
  
  console.log("\n📄 Deployment info saved to:", deploymentPath);

  // Update frontend HTML with contract address
  const frontendPath = path.join(__dirname, "..", "frontend", "index.html");
  if (fs.existsSync(frontendPath)) {
    let htmlContent = fs.readFileSync(frontendPath, "utf8");
    
    // Replace the placeholder contract address
    htmlContent = htmlContent.replace(
      /const NFT_CONTRACT_ADDRESS = "0x[a-fA-F0-9]{40}";/,
      `const NFT_CONTRACT_ADDRESS = "${nftAddress}";`
    );
    
    fs.writeFileSync(frontendPath, htmlContent);
    console.log("✅ Frontend HTML updated with contract address");
  }

  console.log("\n" + "=".repeat(60));
  console.log("🎉 DEPLOYMENT SUMMARY");
  console.log("=".repeat(60));
  console.log(`RoyaltyNFT:   ${nftAddress}`);
  console.log(`CourseERC20:  ${erc20Address}`);
  console.log(`Network:      ${hre.network.name}`);
  console.log(`Chain ID:     ${deploymentInfo.chainId}`);
  console.log("=".repeat(60));
  console.log("\n✅ Deployment completed successfully!");
  console.log("🌐 Open frontend/index.html in your browser to interact with the DApp");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
