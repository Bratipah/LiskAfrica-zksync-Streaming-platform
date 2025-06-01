# zkTune - Decentralized Music Streaming Platform

A blockchain-based music platform where artists mint songs as NFTs and earn royalties from streaming.

## What is zkTune?

zkTune allows musicians to upload their songs as NFTs on the blockchain. When users want to listen to a song, they purchase the NFT which gives them streaming access. Artists automatically earn 30% royalties from each NFT sale.

## How it Works

1. **Artists** register and upload songs
2. **Users** register and stream songs by buying NFTs
3. **Artists** earn 30% royalties automatically
4. **Users** own NFTs that give them permanent streaming access

## Smart Contracts

### zkTune.sol (Main Contract)
- Manages artists, users, and songs
- Handles song streaming and NFT purchases
- Tracks platform statistics

### SongNFT.sol (Individual Song Contract)
- One contract per song
- Handles NFT minting and royalty distribution
- Stores song metadata and pricing

## Key Functions

**For Artists:**
- `registerArtist()` - Sign up as an artist
- `addSong()` - Upload a new song
- `payRoyalties()` - Withdraw earned royalties

**For Users:**
- `registerUser()` - Sign up as a user
- `streamSong()` - Listen to songs by buying NFTs

## Contract Addresses (Lisk Testnet)

- **zkTune Main**: `0x[YOUR_CONTRACT_ADDRESS]`
- **Sample Song**: `0x[YOUR_SONGNFT_ADDRESS]`

**Network**: Lisk Sepolia Testnet (Chain ID: 4202)
**Explorer**: https://sepolia-blockscout.lisk.com

## Features

- Artist and user registration
- Song uploading and NFT creation
- Stream-to-own model
- 30% automatic royalty system
- Ownership tracking
- Platform analytics

## Getting Started

1. Get Lisk testnet ETH from the faucet
2. Connect your wallet to Lisk Testnet
3. Register as artist or user
4. Start uploading or streaming music

## Technology

- **Blockchain**: Lisk (zkSync-based)
- **Smart Contracts**: Solidity 0.8.19
- **NFT Standard**: ERC721
- **Development**: Hardhat, OpenZeppelin

## License

MIT License