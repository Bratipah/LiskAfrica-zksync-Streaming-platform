// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SongNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Paymaster {
    using SafeMath for uint256;

    SongNFT public songNFT;
    mapping(address => uint256) public artistRoyalties;

    event RoyaltiesAccumulated(address indexed artist, uint256 amount);
    event RoyaltiesPaid(address indexed artist, uint256 amount);

    constructor(address _songNFT) {
        songNFT = SongNFT(_songNFT);
    }

    function accumulateRoyalties(uint256 tokenId) external payable {
        require(msg.value > 0, "No payment sent");
        SongNFT.NFTInfo memory nftInfo = songNFT.getInfo(msg.sender);
        address artist = nftInfo.artist;
        uint256 royaltyAmount = msg.value.mul(songNFT.ROYALTY_PERCENTAGE()).div(100);
        artistRoyalties[artist] = artistRoyalties[artist].add(royaltyAmount);
        emit RoyaltiesAccumulated(artist, royaltyAmount);
    }

    function payRoyalties(address artist) external {
        uint256 amount = artistRoyalties[artist];
        require(amount > 0, "No royalties to pay");
        artistRoyalties[artist] = 0;
        (bool success, ) = payable(artist).call{value: amount}("");
        require(success, "Royalty payout failed");
        emit RoyaltiesPaid(artist, amount);
    }
}