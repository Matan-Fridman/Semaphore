//SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

/// @title Semaphore contract interface.
interface ISemaphore {
    error Semaphore__GroupHasNoMembers();
    error Semaphore__YouDidntSendEnoughFunds();
    error Semaphore__MerkleTreeDepthIsNotSupported();
    error Semaphore__MerkleTreeRootIsExpired();
    error Semaphore__MerkleTreeRootIsNotPartOfTheGroup();
    error Semaphore__YouAreUsingTheSameNullifierTwice();
    error Semaphore__InvalidProof();

    /// It defines all the group parameters used by Semaphore.sol.
    struct Group {
        uint256 merkleTreeDuration;
        uint boxFund;
        mapping(uint256 => uint256) merkleRootCreationDates;
        mapping(uint256 => bool) nullifiers;
    }

    /// It defines all the Semaphore proof parameters used by Semaphore.sol.
    struct Proof {
        uint256 merkleTreeRoot;
        uint256 nullifierHash;
        uint256[2] p_a;
        uint256[2][2] p_b;
        uint256[2] p_c;
    }
    struct CommitmentProof {
        uint256[2] p_a;
        uint256[2][2] p_b;
        uint256[2] p_c;
        uint256 commitment;
        uint256 amount;
    }

    /// @dev Event emitted when the Merkle tree duration of a group is updated.
    /// @param groupId: Id of the group.
    /// @param oldMerkleTreeDuration: Old Merkle tree duration of the group.
    /// @param newMerkleTreeDuration: New Merkle tree duration of the group.
    event GroupMerkleTreeDurationUpdated(
        uint256 indexed groupId,
        uint256 oldMerkleTreeDuration,
        uint256 newMerkleTreeDuration
    );

    /// @dev Event emitted when a Semaphore proof is validated.
    /// @param groupId: Id of the group.
    /// @param merkleTreeDepth: Depth of the Merkle tree.
    /// @param merkleTreeRoot: Root of the Merkle tree.
    /// @param nullifier: Nullifier.
    /// @param message: Semaphore message.
    /// @param scope: Scope.
    /// @param points: Zero-knowledge points.
    event ProofValidated(
        uint256 indexed groupId,
        uint256 merkleTreeDepth,
        uint256 indexed merkleTreeRoot,
        uint256 nullifier,
        uint256 message,
        uint256 indexed scope,
        uint256[8] points
    );

    /// @dev See {SemaphoreGroups-_createGroup}.
    function createGroup() external returns (uint256);

    /// @dev See {SemaphoreGroups-_createGroup}.
    function createGroup(address admin) external returns (uint256);

    /// @dev It creates a group with a custom Merkle tree duration.
    /// @param admin: Admin of the group. It can be an Ethereum account or a smart contract.
    /// @param merkleTreeDuration: Merkle tree duration.
    /// @return Id of the group.
    function createGroup(address admin, uint256 merkleTreeDuration) external returns (uint256);

    /// @dev See {SemaphoreGroups-_updateGroupAdmin}.
    function updateGroupAdmin(uint256 groupId, address newAdmin) external;

    /// @dev See {SemaphoreGroups-_acceptGroupAdmin}.
    function acceptGroupAdmin(uint256 groupId) external;

    /// @dev Updates the group Merkle tree duration.
    /// @param groupId: Id of the group.
    /// @param newMerkleTreeDuration: New Merkle tree duration.
    function updateGroupMerkleTreeDuration(uint256 groupId, uint256 newMerkleTreeDuration) external;

    /// @dev See {SemaphoreGroups-_addMember}.
    function addMember(uint256 groupId, uint256 identityCommitment) external;

    /// @dev See {SemaphoreGroups-_addMembers}.
    function addMembers(uint256 groupId, uint256[] calldata identityCommitments) external;

    /// @dev See {SemaphoreGroups-_updateMember}.
    function updateMember(
        uint256 groupId,
        uint256 oldIdentityCommitment,
        uint256 newIdentityCommitment,
        uint256[] calldata merkleProofSiblings
    ) external;

    /// @dev See {SemaphoreGroups-_removeMember}.
    function removeMember(uint256 groupId, uint256 identityCommitment, uint256[] calldata merkleProofSiblings) external;

}