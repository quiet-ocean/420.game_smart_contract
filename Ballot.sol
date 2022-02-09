// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

import "hardhat/console.sol";

contract Ballot {
  
  struct Voter {
    mapping(uint => bool) voted;
    address addr;
  }

  struct Question {
    string value;
    uint upCount;
    uint downCount;
  }

  uint256 public voterCount;
  uint public questionCount;

  address public administrator;

  mapping(address => Voter) public voters;

  Question[] public questions;
  
  event Voted(address voter, uint256 to, bool value);

  constructor() {

    voterCount = 0;
    questionCount = 0;
  }

  function addQuestion(string memory v) public {

    questions.push(Question({ value: v, upCount: 0, downCount: 0 }));
    questionCount = questionCount + 1;

    console.log(questionCount);
  }

  function addVoter(address _voter) public {

    voters[_voter].addr = _voter;
    voterCount ++;
  }

  function vote(uint id, bool value) public payable {

    require(voters[msg.sender].voted[id] == false, "already voted");

    if(value) {
        questions[id].upCount ++;
    } else {
        questions[id].downCount ++;
    }

    voters[msg.sender].voted[id] = true;
    emit Voted(msg.sender, id, value);
  }

  function winningQuestion() public view returns(uint winningQuestion_) {
    // int a = 2 - 5;
    // console.log(a);
    // uint p = 0;
    // require(questionCount > 0, "no question");
    // if(questionCount == 1) return 0;
    
    // Question memory win = questions[p];
    // Question memory q;
    // for(uint i = 1; i < questionCount; i++) {
    //   q = questions[i];
    //   int sum = int(win.upCount) - int(win.downCount);
    //   int _sum = int(q.upCount) - int(q.downCount);
    //   if(_sum > sum) p = i;
    // }
    // winningQuestion_ = p;
  }

  function getQuestions() public returns(string[] memory) {
    
    require(questionCount > 0, "not question exist");

    string[] memory list = new string[](questionCount);

    for(uint i = 0; i < questionCount; i++) {
      list[i] = questions[i].value;
    }
    return list;
  }
}