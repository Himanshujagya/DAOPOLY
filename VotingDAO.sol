// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract DAO {
    address public admin;
    mapping(address => bool) public members;
    uint public memberCount;
    Proposal[] public proposals;

    struct Proposal {
        string description;
        uint yesVotes;
        uint noVotes;
        uint duration;
        bool open;
        string status;
        mapping(address => bool) voted;
    }

    constructor() {
        admin = msg.sender;
        memberCount = 0;
    }

    function applyForMembership() public {
        require(!members[msg.sender], "You are already a member.");
        members[msg.sender] = true;
        memberCount++;
    }

    function approveMembership(address newMember) public {
        require(msg.sender == admin, "Only the admin can approve new members.");
        require(!members[newMember], "This address is already a member.");
        members[newMember] = true;
        memberCount++;
    }

    function createProposal(string memory description, uint duration) public {
        require(members[msg.sender], "You must be a member to create a proposal.");
        Proposal storage newProposal = proposals.push();
        newProposal.description = description;
        newProposal.yesVotes = 0;
        newProposal.noVotes = 0;
        newProposal.duration = duration;
        newProposal.open = true;
        newProposal.status = "Open";
    }

    function vote(uint proposalIndex, bool support) public {
        require(members[msg.sender], "You must be a member to vote.");
        Proposal storage proposal = proposals[proposalIndex];
        require(proposal.open, "Voting is closed.");

        bool hasVoted = proposal.voted[msg.sender];
        require(!hasVoted, "You have already voted on this proposal.");

        proposal.voted[msg.sender] = true;

        if (support) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
    }

    function closeVoting(uint index) public {
        require(msg.sender == admin, "Only the admin can close the voting process.");
        require(block.timestamp >= proposals[index].duration, "Voting is still open.");

        uint yesVotes = proposals[index].yesVotes;
        uint noVotes = proposals[index].noVotes;
        uint totalVotes = yesVotes + noVotes;

        if (totalVotes == 0) {
            proposals[index].status = "No quorum";
        } else if (yesVotes > noVotes) {
            proposals[index].status = "Passed";
        } else {
            proposals[index].status = "Failed";
        }
        proposals[index].open = false;
    }
}

