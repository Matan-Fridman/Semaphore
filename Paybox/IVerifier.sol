
    //SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

/// @title SemaphoreVerifier contract interface.
interface IVerifier {
    
function verifyProof(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[3] memory input
        ) external view returns (bool r);
}