// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SongNFT is ERC721, Ownable, ReentrancyGuard {
    // Struct to store NFT metadata
    struct NFTMetadata {
        string audioURI;
        string coverURI;
        address artist;
        uint256 price;
        uint256 mintedAt;
    }

    // Private variable to track the current token ID
    uint256 private _currentTokenId;
    
    // Price to mint the NFT
    uint256 public nftPrice;
    
    // Artist who created this song
    address public artist;
    
    // Base URI for metadata
    string private _baseTokenURI;
    
    // Mapping from token ID to NFT metadata
    mapping(uint256 => NFTMetadata) public tokenMetadata;
    
    // Total supply of NFTs
    uint256 public totalSupply;

    // Events
    event NFTMinted(address indexed to, uint256 indexed tokenId, uint256 price);
    event PriceUpdated(uint256 oldPrice, uint256 newPrice);
    event WithdrawalMade(address indexed artist, uint256 amount);

    // Constructor to initialize the NFT contract
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _nftPrice,
        string memory _audioURI,
        address _artist,
        string memory _coverURI
    ) ERC721(_name, _symbol) {
        nftPrice = _nftPrice;
        artist = _artist;
        _currentTokenId = 0;
        totalSupply = 0;
        
        // Transfer ownership to the artist
        _transferOwnership(_artist);
        
        // Store the initial metadata template
        tokenMetadata[0] = NFTMetadata({
            audioURI: _audioURI,
            coverURI: _coverURI,
            artist: _artist,
            price: _nftPrice,
            mintedAt: block.timestamp
        });
    }

    // Modifier to ensure only the artist can perform certain actions
    modifier onlyArtist() {
        require(msg.sender == artist, "Only artist can perform this action");
        _;
    }

    // Function to mint NFT (payable)
    function mintNFT(address _to) external payable nonReentrant {
        require(msg.value >= nftPrice, "Insufficient payment");
        require(_to != address(0), "Cannot mint to zero address");

        _currentTokenId++; // Increment current token ID
        uint256 newTokenId = _currentTokenId; // FIXED: Added semicolon

        // Mint the NFT
        _safeMint(_to, newTokenId);
        
        // Store metadata for this token
        tokenMetadata[newTokenId] = NFTMetadata({
            audioURI: tokenMetadata[0].audioURI,
            coverURI: tokenMetadata[0].coverURI,
            artist: artist,
            price: nftPrice,
            mintedAt: block.timestamp
        });

        totalSupply++;

        emit NFTMinted(_to, newTokenId, msg.value);

        // Refund excess payment
        if (msg.value > nftPrice) {
            payable(msg.sender).transfer(msg.value - nftPrice);
        }
    }

    // Function to update NFT price (only artist)
    function updatePrice(uint256 _newPrice) external onlyArtist {
        require(_newPrice > 0, "Price must be greater than 0");
        uint256 oldPrice = nftPrice;
        nftPrice = _newPrice;
        emit PriceUpdated(oldPrice, _newPrice);
    }

    // Function for artist to withdraw earnings
    function withdraw() external onlyArtist nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        payable(artist).transfer(balance);
        emit WithdrawalMade(artist, balance);
    }

    // Function to get NFT metadata
    function getTokenMetadata(uint256 _tokenId) external view returns (NFTMetadata memory) {
        require(_exists(_tokenId), "Token does not exist");
        return tokenMetadata[_tokenId];
    }

    // Function to get audio URI for a token
    function getAudioURI(uint256 _tokenId) external view returns (string memory) {
        require(_exists(_tokenId), "Token does not exist");
        return tokenMetadata[_tokenId].audioURI;
    }

    // Function to get cover URI for a token
    function getCoverURI(uint256 _tokenId) external view returns (string memory) {
        require(_exists(_tokenId), "Token does not exist");
        return tokenMetadata[_tokenId].coverURI;
    }

    // Override tokenURI to return custom metadata
    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(_exists(_tokenId), "Token does not exist");
        
        // You can customize this to return proper JSON metadata
        return string(abi.encodePacked(_baseTokenURI, toString(_tokenId)));
    }

    // Function to set base URI (only artist)
    function setBaseURI(string memory _baseTokenURI) external onlyArtist {
        _baseTokenURI = _baseTokenURI;
    }

    // Function to check if a token exists
    function exists(uint256 _tokenId) external view returns (bool) {
        return _exists(_tokenId);
    }

    // Function to get total number of tokens owned by an address
    function balanceOfOwner(address _owner) external view returns (uint256) {
        return balanceOf(_owner);
    }

    // Function to get all token IDs owned by an address
    function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](tokenCount);
        uint256 index = 0;

        for (uint256 i = 1; i <= _currentTokenId; i++) {
            if (_exists(i) && ownerOf(i) == _owner) {
                tokenIds[index] = i;
                index++;
            }
        }

        return tokenIds;
    }

    // Utility function to convert uint to string
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    // Function to get current token ID
    function getCurrentTokenId() external view returns (uint256) {
        return _currentTokenId;
    }

    // Function to get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Fallback function to receive Ether
    receive() external payable {}
}