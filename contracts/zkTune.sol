// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SongNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract zkTune is Ownable {
    using SafeMath for uint256;

    SongNFT public songNFT;

    struct Artist {
        string name;
        string profileURI;
        bool isRegistered;
    }

    struct User {
        string name;
        bool isRegistered;
    }

    struct Song {
        uint256 songId;
        string name;
        string audioURI;
        string coverURI;
        address artist;
        uint256 price;
        uint256 streamCount;
    }

    mapping(address => Artist) public artists;
    mapping(address => User) public users;
    mapping(uint256 => Song) public songs;
    mapping(address => uint256[]) private userStreamedSongs;
    uint256 private songCount;

    event ArtistRegistered(address indexed artist, string name, string profileURI);
    event UserRegistered(address indexed user, string name);
    event SongAdded(uint256 indexed songId, string name, address indexed artist);
    event SongStreamed(uint256 indexed songId, address indexed user);

    constructor() Ownable(msg.sender) {}

    function registerArtist(string memory _name, string memory _profileURI) public {
        require(!artists[msg.sender].isRegistered, "Artist already registered");
        artists[msg.sender] = Artist({
            name: _name,
            profileURI: _profileURI,
            isRegistered: true
        });
        emit ArtistRegistered(msg.sender, _name, _profileURI);
    }

    function registerUser(string memory _name) public {
        require(!users[msg.sender].isRegistered, "User already registered");
        users[msg.sender] = User({
            name: _name,
            isRegistered: true
        });
        emit UserRegistered(msg.sender, _name);
    }

    function addSong(
        string memory _name,
        string memory _audioURI,
        string memory _coverURI,
        uint256 _price
    ) public {
        require(artists[msg.sender].isRegistered, "Only registered artists can add songs");
        songCount = songCount.add(1);
        songs[songCount] = Song({
            songId: songCount,
            name: _name,
            audioURI: _audioURI,
            coverURI: _coverURI,
            artist: msg.sender,
            price: _price,
            streamCount: 0
        });
        emit SongAdded(songCount, _name, msg.sender);
    }

    function streamSong(uint256 _songId) public payable {
        require(users[msg.sender].isRegistered, "Only registered users can stream");
        require(songs[_songId].songId != 0, "Song does not exist");
        require(msg.value >= songs[_songId].price, "Insufficient payment");

        Song storage song = songs[_songId];
        song.streamCount = song.streamCount.add(1);
        userStreamedSongs[msg.sender].push(_songId);

        if (songNFT != SongNFT(address(0))) {
            songNFT.mintNFT{value: msg.value}(msg.sender);
        }

        emit SongStreamed(_songId, msg.sender);
    }

    function getSong(uint256 _songId) public view returns (Song memory) {
        require(songs[_songId].songId != 0, "Song does not exist");
        return songs[_songId];
    }

    function getArtist(address _artist) public view returns (Artist memory) {
        require(artists[_artist].isRegistered, "Artist not registered");
        return artists[_artist];
    }

    function getUser(address _user) public view returns (User memory) {
        require(users[_user].isRegistered, "User not registered");
        return users[_user];
    }

    function getUserStreamedSongs(address _user) public view returns (uint256[] memory) {
        return userStreamedSongs[_user];
    }

    function setSongNFT(address _songNFT) public onlyOwner {
        songNFT = SongNFT(_songNFT);
    }
}