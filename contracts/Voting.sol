// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Voting {
    address public president;

    struct Proposal {
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool voted;
        uint256 votedProp; //index of voted prop
        uint256 weighting;
    }

    Proposal[] public proposals;

    mapping(address => Voter) public voters;

    modifier onlyPresident() {
        require(msg.sender == president, "Only the president can do this.");
        _; //puts all the code in a function after this
    }

    constructor(string[] memory _proposalName) {
        president = msg.sender;

        for (uint256 i = 0; i < _proposalName.length; i++) {
            proposals.push(Proposal({name: _proposalName[i], voteCount: 0}));
        }
    }

    //assignVote
    //vote
    //Winning proposal

    function assignVote(address _voter, uint256 _weighting)
        public
        onlyPresident
    {
        require(!voters[_voter].voted, "This person has voted already.");

        voters[_voter].voted = false;
        voters[_voter].weighting = _weighting;
        //voters[_voter] = Voter mapping
    }

    function vote(uint256 proposalIndex) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You cannnot vote twice.");
        proposals[proposalIndex].voteCount += sender.weighting;
        sender.voted = true;
        sender.votedProp = proposalIndex;
    }

    function winningProposal()
        public
        onlyPresident
        returns (uint256 winningProposal)
    {
        uint256 winCount = 0;
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winCount) {
                proposals[i].voteCount = winCount;
                winningProposal = i;
            }
        }
    }

    function returnWinner() public returns (string memory winnerName) {
        winnerName = proposals[winningProposal()].name;
        return winnerName;
    }
}
