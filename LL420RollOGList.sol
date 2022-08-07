// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract LL420RollOGList is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 internal randomNumber;

    uint256 public totalFilled;
    uint256 public totalRuns;
    uint256 public spotLimit;
    address public owner;

    mapping(address => bool) public rollBook;
    address[] public signedAddresses;

    event RollWin(uint256 indexed index, address indexed user);
    event AllSpotsFilled();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint256 _fee,
        uint256 _spotLimit
    ) VRFConsumerBase(_vrfCoordinator, _linkToken) {
        keyHash = _keyHash;
        fee = _fee;
        spotLimit = _spotLimit;
        owner = msg.sender;
    }

    function initialize(address[] calldata _lists) external onlyOwner {
        for (uint256 i = 0; i < _lists.length; i++) {
            signedAddresses.push(_lists[i]);
        }
    }

    function rollAddress() internal returns (address) {
        require(totalFilled < spotLimit, "All spots have been filled");

        uint256 index = random() % signedAddresses.length;
        address selectedAddress = signedAddresses[index];

        if (rollBook[selectedAddress] == false) {
            rollBook[selectedAddress] = true;
            emit RollWin(totalFilled, selectedAddress);

            totalFilled++;

            return selectedAddress;
        }

        return address(0);
    }

    function batchRoll(uint256 _count) public {
        require(_count < signedAddresses.length, "Exceeds the max limit");
        require(randomNumber > 0, "Random number is not fulfilled");

        for (uint256 i = 0; i < _count; i++) {
            if (totalFilled >= spotLimit) {
                emit AllSpotsFilled();
                break;
            }

            rollAddress();
        }

        // Requires to use new random number on the next run
        randomNumber = 0;
    }

    function singleRoll() external {
        batchRoll(1);
    }

    function setSpotLimit(uint256 _newLimit) external onlyOwner {
        require(_newLimit < signedAddresses.length, "Exceeds the max amount");

        spotLimit = _newLimit;
    }

    function withdrawLink() external onlyOwner {
        LINK.transfer(owner, LINK.balanceOf(address(this)));
    }

    /**
     * Requests randomness
     */
    function startRoll() external onlyOwner returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill the contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    function random() internal returns (uint256) {
        totalRuns += 1;
        return uint256(keccak256(abi.encodePacked(randomNumber, totalRuns)));
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32, uint256 randomness) internal override {
        randomNumber = randomness;
    }
}
