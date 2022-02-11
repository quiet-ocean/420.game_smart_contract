// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract Voting is Ownable {
  
  struct Voter {
    mapping(uint => bool) voted; //if true, the person already voted to a question
    address addr; //voter acount address
  }

  struct Question {
    uint id;
    string value; // question string
    uint upCount; // approve count
    uint downCount; // opposite count
  }

  uint public voterCount; // number of voters
  uint public questionCount; // number of questions
  uint private currentId; // id of last question

  address public administrator; // address of administrator

  mapping(address => Voter) public voters; // voters map

  mapping(uint => Question) public questions; // question string
  
  event Voted(address voter, uint256 to, bool value); // event for vote logging

  // contructor
  constructor() {

    administrator = msg.sender;

    voterCount = questionCount = currentId = 0;
  }
  // add question with string v
  function addQuestion(string memory v) public {

    require(msg.sender == administrator, "only administrator can add question.");
    
    Question memory q = Question({ id: currentId, value: v, upCount: 0, downCount: 0 });
    questions[currentId] = q;

    questionCount = questionCount + 1;
    currentId = currentId + 1;
  }
  function updateQuestion(uint id) public {

  }
  function removeQuestion(uint id) public returns(bool) {
    
    Question memory q = questions[id];

    console.log(id);
    console.log(q.id);
    
    if(q.id == id) {
      delete questions[id];
      questionCount = questionCount - 1;
      return true;
    }
    return false;
  }
  //add a voter to voter list
  function addVoter(address _voter) public {

    voters[_voter].addr = _voter;
    voterCount ++;
  }
  //
  function vote(uint id, bool value) public {
    console.log(id);
    console.log(value);
    require(voters[msg.sender].voted[id] == false, "already voted");

    if(value) {
        questions[id].upCount = questions[id].upCount + 1;
    } else {
        questions[id].downCount = questions[id].downCount + 1;
    }
    console.log(questions[id].upCount);
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
  
  function getQuestions() public view returns(Question[] memory) {
    
    require(questionCount > 0, "not question exist");

    Question[] memory list = new Question[](currentId);
    for(uint i = 0; i < currentId; i++) {
      list[i] = questions[i];
    }
    return list;
  }
}