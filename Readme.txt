The code is present inside the VotingDAO.sol file
This code is written in solidity as Ethereum supports solidity.
We can deploy this code on polygon Blockchain as it is EVM based Blockchain and we can run this code on Remix and can interact with it after connecting it with the various options available under DEPLOY & RUN TRANSACTIONS section.


create a DAO on a polygon which can do the following things

1. People can apply for joining the DAO

// to apply this function is being used so for first step this is the function we are using
function applyForMembership() public {
        require(!members[msg.sender], "You are already a member.");
        members[msg.sender] = true;
        memberCount++;
    }
    
    
    
    
2. Admin can approve membership

function approveMembership(address newMember) public {
        require(msg.sender == admin, "Only the admin can approve new members.");
        require(!members[newMember], "This address is already a member.");
        members[newMember] = true;
        memberCount++;
    }


3. Anyone can create a proposal


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
    
    
    
4. People can vote on proposal


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
    
    
    
    
    
5. Admin can close the voting process and declare the result


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


