pragma solidity >=0.7.0 < 0.9.0;

contract Ballot {
  
  struct Voter {
    bool voted;
    uint vote;
  }

  struct Question {
    bytes32 value;
    uint voteCount;
  }
  uint public voterCount;
  uint public questionCount;

  address public administrator;

  mapping(address => Voter) public voters;

  Question[] public questions;

//   constructor() {

//   }
  function addQuestion(bytes32 v) public {
    questions.push(Question({ value: v, voteCount: 0 }));
  }
  function addVoter(address voter) public {

  }
  function vote(uint questionId) public {

  }
  function winningQuestion() public pure returns(uint winningQuestion_) {
    uint p = 0;
    winningQuestion_ = p;
  }
}