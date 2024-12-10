// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {ISemaphore} from "./ISemaphorePaybox.sol";
import {Semaphore} from "../Semaphore.sol";
import {ICommitmentVerifier} from "./ICommitmentVerifier.sol";
import {ISemaphoreVerifier} from "../ISemaphoreVerifier.sol";
import {SemaphorePayboxGroups} from "./SemaphorePayboxGroups.sol";
import {MIN_DEPTH, MAX_DEPTH} from "../Constants.sol";
import {ZKTree} from "./MerkleTree.sol";
import {ISemaphoreVerifier} from "../ISemaphoreVerifier.sol";

/// @title Semaphore
/// @dev This contract uses the Semaphore base contracts to provide a complete service
/// to allow admins to create and manage groups and their members to verify Semaphore proofs
/// Group admins can add, update or remove group members, and can be an Ethereum account or a smart contract.
/// This contract also assigns each new Merkle tree generated with a new root a duration (or an expiry)
/// within which the proofs generated with that root can be validated.
struct Box {
    uint fund;
    address owner;
}

contract TCpaybox{
    ZKTree public MerkleTree;
    ICommitmentVerifier public commitmentVerifier;
    event Commit (uint256 commitment);
    /// @dev Gets a group id and returns the group parameters.
    mapping(uint256 => Box) public boxes;
    mapping(uint256 => uint) public funds;

    /// @dev Counter to assign an incremental id to the groups.
    uint256 public boxCounter = 0;

    constructor(ICommitmentVerifier _commitmentVerifier, ZKTree _MerkleTree){
        commitmentVerifier =_commitmentVerifier;
        MerkleTree = _MerkleTree;
    }

    /// @dev See {SemaphoreGroups-_createGroup}.
    function createGroup(uint256 commitment) external {
        require(boxes[commitment].owner == address(0x0), "box already exists");
        require(funds[commitment] == 0, "box already exists");
        MerkleTree._commit(bytes32(commitment));
        funds[commitment] = 1;
    }

    function addDeposit(    // commitment proof       
        uint256[2] memory p_a,
        uint256[2][2] memory p_b,
        uint256[2] memory p_c,
        uint256 commitment,
        uint256 amount,
        uint256 nullifierHash)public payable{
        require(msg.value >= amount, "not enough funds sent with function");
        require(verifyCommitment(
            p_a,
            p_b,
            p_c,
            commitment, 
            amount,
            nullifierHash), "commitment and amount dont match");

        MerkleTree._commit(bytes32(commitment));  // need permissions to add myself
        // commitmentAmounts[commitment] = amount;
    }
    // now we separated the person who deposited from the group they deposited to
    function addCommitmentToGroup(
        uint256[2] memory p_a,
        uint256[2][2] memory p_b,
        uint256[2] memory p_c,
        uint256 nullifierHash,
        uint256 amount,
        uint root,
        uint256 boxId
        )public{ // call this function using general wallet

        MerkleTree._nullify(
            bytes32(nullifierHash), 
            bytes32(root),
            amount, 
            p_a, p_b, p_c
            );
        boxes[boxId].fund += amount;
        // if proof is validated amount is added to group funds
    }

    function withdraw(        
        uint256[2] memory p_a,
        uint256[2][2] memory p_b,
        uint256[2] memory p_c,
        uint256 nullifierHash,
        uint256 amount,
        uint root) public {
        
        payable(msg.sender).transfer(amount);
    }

    function viewFunds(uint256 boxId)public view returns (uint){
        return boxes[boxId].fund;
    }
    function verifyCommitment(
        uint256[2] memory p_a,
        uint256[2][2] memory p_b,
        uint256[2] memory p_c,
        uint256 commitment,
        uint256 amount,
        uint256 nullifierHash
    ) public view returns (bool){
        return commitmentVerifier.verifyProof(p_a, p_b, p_c,
        [
            commitment,
            amount,
            nullifierHash
        ]
        );
    }
}