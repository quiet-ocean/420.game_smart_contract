// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

import "hardhat/console.sol";

contract Ballot {
  
  uint constant UP = 1;
  uint constant DOWN = 2;
  struct Voter {
    mapping(uint => bool) voted;
    address addr;
  }

  struct Question {
    string value;
    uint voteUpCount;
    uint voteDownCount;
  }

  uint256 public voterCount;
  uint public questionCount;

  address public administrator;

  mapping(address => Voter) public voters;

  Question[] public questions;

  constructor() {
    voterCount = 0;
    questionCount = 0;
  }
  function addQuestion(string memory v) public {
    questions.push(Question({ value: v, voteUpCount: 0, voteDownCount: 0 }));
    questionCount = questionCount + 1;
  }
  function addVoter(address _voter) public {
    voters[_voter].addr = _voter;
    voterCount ++;
  }
  function vote(uint id, uint value) public payable {
    require(voters[msg.sender].voted[id] == false, "already voted");
    if(value == UP) {
        questions[id].voteUpCount ++;
    } else {
        questions[id].voteDownCount ++;
    }
    voters[msg.sender].voted[id] = true;
  }
  function winningQuestion() public pure returns(uint winningQuestion_) {
    uint p = 0;
    winningQuestion_ = p;
  }
}