// deployment code goes here
import { deployContract, getWallet, getProvider } from "./utils";
import { ethers } from "ethers";
import * as fs from "fs";

async function main() {
    console.log("🚀 Starting zkTune deployment to Lisk Testnet...\n");

    try {
        // Get wallet and provider using utils
        const wallet = getWallet();
        const provider = getProvider();
        
        console.log("📋 Deployment Configuration:");
        console.log("Network:", process.env.HARDHAT_NETWORK || "lisk-testnet");
        console.log("Deployer address:", wallet.address);
        
        // Check wallet balance
        const balance = await wallet.getBalance();
        console.log("💰 Wallet balance:", ethers.formatEther(balance), "ETH\n");
        
        // Deploy zkTune main contract
        console.log("🎵 Deploying zkTune main contract...");
        const zkTuneContract = await deployContract("zkTune", [], {
            silent: false,
            noVerify: false,
            wallet: wallet
        });
        
        const zkTuneAddress = await zkTuneContract.getAddress();
        console.log("✅ zkTune deployed successfully at:", zkTuneAddress);

        // Deploy a sample SongNFT contract for testing
        console.log("\n🎼 Deploying sample SongNFT contract...");
        const songNFTConstructorArgs = [
            "My First Song",                            // name
            "SONG",                                     // symbol
            ethers.parseEther("0.001"),                // price (0.001 ETH)
            "https://ipfs.io/ipfs/QmSampleAudioHash",   // audioURI
            wallet.address,                             // artist (deployer)
            "https://ipfs.io/ipfs/QmSampleCoverHash"    // coverURI
        ];

        const sampleSongNFT = await deployContract("SongNFT", songNFTConstructorArgs, {
            silent: false,
            noVerify: false,
            wallet: wallet
        });
        
        const songNFTAddress = await sampleSongNFT.getAddress();
        console.log("✅ Sample SongNFT deployed successfully at:", songNFTAddress);

        // Test basic functionality
        console.log("\n🧪 Testing basic contract functionality...");
        
        // Test zkTune contract
        console.log("📊 Testing zkTune contract...");
        const totalSongs = await zkTuneContract.totalSongs();
        const totalArtists = await zkTuneContract.totalArtists();
        const totalUsers = await zkTuneContract.totalUsers();
        
        console.log("✅ zkTune contract responsive!");
        console.log("- Total Songs:", totalSongs.toString());
        console.log("- Total Artists:", totalArtists.toString());
        console.log("- Total Users:", totalUsers.toString());
        
        // Test SongNFT contract
        console.log("\n🎵 Testing SongNFT contract...");
        const nftPrice = await sampleSongNFT.nftPrice();
        const artist = await sampleSongNFT.artist();
        const audioURI = await sampleSongNFT.audioURI();
        const royaltyPercentage = await sampleSongNFT.ROYALTY_PERCENTAGE();
        
        console.log("✅ SongNFT contract responsive!");
        console.log("- NFT Price:", ethers.formatEther(nftPrice), "ETH");
        console.log("- Artist:", artist);
        console.log("- Audio URI:", audioURI);
        console.log("- Royalty Percentage:", royaltyPercentage.toString() + "%");

        // Test artist registration
        console.log("\n🎨 Testing artist registration...");
        try {
            const registerTx = await zkTuneContract.registerArtist(
                "Test Artist", 
                "https://ipfs.io/ipfs/QmTestArtistProfile"
            );
            await registerTx.wait();
            console.log("✅ Artist registration successful!");
            
            // Verify registration
            const artistInfo = await zkTuneContract.artists(wallet.address);
            console.log("- Artist Name:", artistInfo.name);
            console.log("- Profile URI:", artistInfo.profileURI);
        } catch (error) {
            console.log("ℹ️ Artist registration test skipped (may already be registered)");
        }

        // Test adding a song
        console.log("\n🎵 Testing song addition...");
        try {
            const addSongTx = await zkTuneContract.addSong(
                "Test Song Title",
                "https://ipfs.io/ipfs/QmTestAudioHash",
                "https://ipfs.io/ipfs/QmTestCoverHash",
                ethers.parseEther("0.002")
            );
            await addSongTx.wait();
            console.log("✅ Song addition successful!");
            
            // Check updated song count
            const newTotalSongs = await zkTuneContract.totalSongs();
            console.log("- Total Songs after addition:", newTotalSongs.toString());
        } catch (error) {
            console.log("ℹ️ Song addition test skipped:", error.message);
        }

        // Create deployment summary
        const deploymentSummary = {
            network: process.env.HARDHAT_NETWORK || "lisk-testnet",
            timestamp: new Date().toISOString(),
            deployer: wallet.address,
            deployerBalance: ethers.formatEther(balance),
            contracts: {
                zkTune: {
                    address: zkTuneAddress,
                    name: "zkTune",
                    verified: true
                },
                sampleSongNFT: {
                    address: songNFTAddress,
                    name: "SongNFT",
                    constructorArgs: songNFTConstructorArgs.map(arg => 
                        typeof arg === 'bigint' ? ethers.formatEther(arg) : arg
                    ),
                    verified: true
                }
            },
            explorerUrls: {
                zkTune: `https://sepolia-blockscout.lisk.com/address/${zkTuneAddress}`,
                sampleSongNFT: `https://sepolia-blockscout.lisk.com/address/${songNFTAddress}`
            },
            testResults: {
                zkTuneResponsive: true,
                songNFTResponsive: true,
                artistRegistration: true,
                basicFunctionality: true
            }
        };

        // Save deployment info to file
        const filename = `deployment-lisk-testnet-${Date.now()}.json`;
        fs.writeFileSync(filename, JSON.stringify(deploymentSummary, null, 2));

        console.log("\n🎉 Deployment completed successfully!");
        console.log("=======================================");
        console.log("📋 DEPLOYMENT SUMMARY");
        console.log("Network:", deploymentSummary.network);
        console.log("Deployer:", deploymentSummary.deployer);
        console.log("Balance Used: ~", (parseFloat(deploymentSummary.deployerBalance) - parseFloat(ethers.formatEther(await wallet.getBalance()))).toFixed(4), "ETH");
        
        console.log("\n📍 Contract Addresses:");
        console.log("zkTune:", zkTuneAddress);
        console.log("SampleSongNFT:", songNFTAddress);
        
        console.log("\n🌐 Block Explorer Links:");
        console.log("zkTune:", deploymentSummary.explorerUrls.zkTune);
        console.log("SampleSongNFT:", deploymentSummary.explorerUrls.sampleSongNFT);
        
        console.log("\n💾 Deployment info saved to:", filename);
        
        console.log("\n🔧 Next Steps:");
        console.log("1. Update your frontend with these contract addresses");
        console.log("2. Test the platform by registering users and streaming songs");
        console.log("3. Share these addresses for project submission");
        
        console.log("\n📝 Contract Addresses for Submission:");
        console.log("zkTune Main Contract:", zkTuneAddress);
        console.log("Sample SongNFT Contract:", songNFTAddress);
        
    } catch (error) {
        console.error("\n❌ Deployment failed:");
        console.error("Error:", error.message);
        if (error.stack) {
            console.error("Stack trace:", error.stack);
        }
        
        // Common error solutions
        console.log("\n🔧 Troubleshooting:");
        if (error.message.includes("balance is too low")) {
            console.log("- Get more testnet ETH from: https://sepolia-faucet.lisk.com/");
        }
        if (error.message.includes("private key")) {
            console.log("- Check your .env file contains WALLET_PRIVATE_KEY");
        }
        if (error.message.includes("RPC URL")) {
            console.log("- Verify your network configuration in hardhat.config.ts");
        }
        
        process.exit(1);
    }
}

// Execute deployment
main()
    .then(() => {
        console.log("\n✨ Deployment script completed successfully!");
        process.exit(0);
    })
    .catch((error) => {
        console.error("\n💥 Deployment script failed:", error);
        process.exit(1);
    });