# LiskAfrica-zksync-Streaming-platform
- SongNFT Contract: This is where the magic happens! We'll store all the juicy song details and mint our unique Song NFTs here. Imagine your favorite song as a one-of-a-kind collectible!
- zkTune Contract: Think of this as our playlist manager. It will help us create and manage playlists, track all the songs, add new ones, stream our jams, and keep tabs on our talented artists. It's like having Spotify, but way cooler and decentralized!
- Paymaster Contract: This contract is our financial wizard. It handles account abstraction using zkSync contracts, making sure everything runs smoothly without a hitch.


## The SongNFT contract
This contract lets a user mint an NFT of a song successfully when he meets the required payment price.
After the royalties of a successful mint is collected and stored in a variable.
The artist is then paid the royalties of his songs based on the royalty percentage defined.
The user also gets to access the information on every NFT he/she owns.

## The zkTune contract
This contract allows an artist too register himself if he's not on the platform.
Also user that are new to the platform gets to register.
Registered Artists are allowed to upload a song on the platform.
Users are able to stream songs based on the id they specify.
Anybody can view all the songs on the platform as well as all artists registered on it.
People can view all the songs uploaded by a particular artist.
People can also view the songs streamed by a particular user.