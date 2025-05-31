# ZkSync Streaming Platform

A decentralized music streaming platform on Lisk Sepolia Testnet for minting song NFTs, streaming songs, and paying royalties.

## Contracts

- **SongNFT.sol**: Mints ERC-721 NFTs with song details (price, artist, audio/cover URIs, royalties). `mintNFT` creates NFTs, `payRoyalties` transfers royalties, and `getInfo` retrieves details for NFT owners.
- **zkTune.sol**: Manages artists, users, and songs. Supports registering artists/users, adding songs, streaming songs (minting NFTs if needed), and fetching song/artist data.
- **Paymaster.sol**: Handles royalty payments. `accumulateRoyalties` tracks royalties based on SongNFT’s 30% royalty percentage, and `payRoyalties` transfers funds to artists.

## Deployed Addresses (Lisk Sepolia)

- SongNFT: 0xaC5b6430722a5187d9fa26eBc20d46152995d7e9
- zkTune: 0x5d8A8b9Dd72B910d4e2934D5472779Bc484052B6
- Paymaster:0x0EE9e133264d073A1AD7E58b18c2Ae3CD0A6

## Usage

1. Deploy `SongNFT` with song details.
2. Deploy `zkTune` and `Paymaster`.
3. Register artists/users via `registerArtist`/`registerUser`.
4. Add songs with `addSong`.
5. Stream songs with `streamSong`.
6. Accumulate and pay royalties with `accumulateRoyalties` and `payRoyalties`.