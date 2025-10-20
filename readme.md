# 🚀 Project Quick Start Guide

## Prerequisites
- Node.js installed
- MetaMask browser extension installed
- Chrome, Brave, Edge, or Firefox browser (not Opera)

---

## Setup Steps

### 1. Install Dependencies
```powershell
# Navigate to the project directory (wherever you cloned/downloaded it)
cd path\to\blockchainProject
npm install
```

### 2. Compile Contracts
```powershell
npm run compile
```

### 3. Launch the Complete DApp

**🚀 EASY METHOD - All-in-One Launcher (Recommended):**

Just run this single command:
```powershell
.\open-dapp.bat
```

This will automatically:
- ✅ Start the blockchain node
- ✅ Deploy the smart contracts
- ✅ Start the frontend server
- ✅ Open your browser

**⚙️ MANUAL METHOD - If you prefer step-by-step:**

**Terminal 1 - Start Blockchain Node:**
```powershell
# Navigate to the project directory
cd path\to\blockchainProject
npm run node
```
⚠️ **Keep this terminal open!**

**Terminal 2 - Deploy Contracts:**
```powershell
# Navigate to the project directory
cd path\to\blockchainProject
npm run deploy
```

**Terminal 3 - Start Frontend:**
```powershell
# Navigate to the frontend directory
cd path\to\blockchainProject\frontend
npx http-server -p 8000
```

---

### 4. Configure MetaMask

**Add Localhost Network:**
1. Open MetaMask
2. Click network dropdown → "Add Network"
3. Enter these details:
   - **Network Name:** `Localhost 8545`
   - **RPC URL:** `http://127.0.0.1:8545`
   - **Chain ID:** `31337`
   - **Currency Symbol:** `ETH`
4. Click "Save"
5. Switch to "Localhost 8545" network

**Import Test Account:**
1. Click account icon → "Import Account"
2. Paste private key:
   ```
   0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
   ```
3. Click "Import"
4. You now have 10,000 test ETH!

### 5. Use the DApp

The DApp should already be open at: **http://localhost:8000**

1. Click "Connect Wallet"
2. Approve in MetaMask
3. Start minting and transferring NFTs!

---

## Quick Usage

**Mint NFT:**
- Click "Mint New NFT"
- Confirm in MetaMask

**Transfer NFT:**
- Token ID: `0`
- Recipient: Any address
- ETH Value: `0.01`
- Click "Execute Transfer"
- 10% royalty paid automatically!

---

## Troubleshooting

**"Nonce too high" error:**
- MetaMask → Settings → Advanced → Reset Account

**Connection fails:**
- Ensure you're on "Localhost 8545" network
- Check blockchain node is running (Terminal 1)
- Refresh browser page

**Need to restart:**
1. Close all terminals
2. Repeat steps 3-7

---

## Summary
✅ 3 terminals running: blockchain, deploy (finished), http-server  
✅ MetaMask on "Localhost 8545" network  
✅ Test account imported  
✅ Browser at http://localhost:8000  
✅ Ready to mint and transfer NFTs!