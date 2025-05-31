// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SongNFT is ERC721URIStorage, Ownable {
    using SafeMath for uint256;

    uint256 private _tokenIds;
    uint256 public nftPrice;
    string public audioURI;
    address public artist;
    string public coverURI;
    uint256 private royaltyBalance;
    uint256 private constant ROYALTY_PERCENT = 30;

    struct NFTInfo {
        uint256 tokenId;
        address artist;
        string audioURI;
        string coverURI;
        uint256 royaltyBalance;
        address owner;
    }

    mapping(address => NFTInfo) private _nftInfo;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _nftPrice,
        string memory _audioURI,
        address _artist,
        string memory _coverURI
    ) ERC721(_name, _symbol) Ownable(msg.sender) {
        nftPrice = _nftPrice;
        audioURI = _audioURI;
        artist = _artist;
        coverURI = _coverURI;
    }

    function mintNFT(address recipient) public payable returns (uint256) {
        require(msg.value >= nftPrice, "Insufficient payment");
        _tokenIds = _tokenIds.add(1);
        uint256 newTokenId = _tokenIds;

        _mint(recipient, newTokenId);
        _setTokenURI(newTokenId, audioURI);

        uint256 royaltyAmount = msg.value.mul(ROYALTY_PERCENT).div(100);
        royaltyBalance = royaltyBalance.add(royaltyAmount);

        _nftInfo[recipient] = NFTInfo({
            tokenId: newTokenId,
            artist: artist,
            audioURI: audioURI,
            coverURI: coverURI,
            royaltyBalance: royaltyBalance,
            owner: recipient
        });

        return newTokenId;
    }

    function payRoyalties() public {
        uint256 amount = royaltyBalance;
        require(amount > 0, "No royalties to pay");
        royaltyBalance = 0;

        (bool success, ) = payable(artist).call{value: amount}("");
        require(success, "Royalty payout failed");
    }

    function getInfo(address _address) public view returns (NFTInfo memory) {
        return _nftInfo[_address];
    }

    function ROYALTY_PERCENTAGE() public pure returns (uint256) {
        return 30;
    }
}