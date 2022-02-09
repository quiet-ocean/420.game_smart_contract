// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

import "hardhat/console.sol";

contract Ballot {
  
  struct Voter {
    mapping(uint => bool) voted; // store vote status. if true, the person already voted to a question
    address addr; //voter acount address
  }

  struct Question {
    string value; // question string
    uint upCount; // approve count
    uint downCount; // opposite count
  }

  uint256 public voterCount; // number of voters
  uint public questionCount; // number of questions

  address public administrator; // address of administrator

  mapping(address => Voter) public voters; // voters map

  Question[] public questions; // question string
  
  event Voted(address voter, uint256 to, bool value); // event for vote logging

  // contructor
  constructor() {

    voterCount = 0;
    questionCount = 0;
  }
  // add question with string v
  function addQuestion(string memory v) public {

    questions.push(Question({ value: v, upCount: 0, downCount: 0 }));
    questionCount = questionCount + 1;

    console.log(questionCount);
  }
  //add a voter to voter list
  function addVoter(address _voter) public {

    voters[_voter].addr = _voter;
    voterCount ++;
  }
  //
  function vote(uint id, bool value) public payable {

    require(voters[msg.sender].voted[id] == false, "already voted"); //check sender voted or not

    //if the person didn't vote, vote and make the voted status to true
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
    
    require(questionCount > 0, "not question exist"); // check question list is null or not

    string[] memory list = new string[](questionCount);

    for(uint i = 0; i < questionCount; i++) {
      list[i] = questions[i].value;
    }
    return list;
  }
}