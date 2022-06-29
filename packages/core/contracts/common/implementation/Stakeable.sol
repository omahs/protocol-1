/**
 * Stakeable contract.
 */

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import "../../oracle/interfaces/StakerInterface.sol";
import "./Withdrawable.sol";

/**
 * @title Base contract that extends the Withdrawable contract enabling a specific role to stake ERC20 tokens against the
 * Voting contract. Voting contract is fed in as a param rather than fetched from the finder to enable upgradability.
 */
abstract contract Stakeable is Withdrawable {
    using SafeERC20 for IERC20;

    uint256 private roleId;

    /**
     * @notice Stake ERC20 tokens from this contract to the votingContract.
     * @param amount amount of tokens to stake.
     * @param votingContract Address of the voting contract to stake into.
     */
    function stake(uint256 amount, address votingContract) external onlyRoleHolder(roleId) {
        StakerInterface voting = StakerInterface(votingContract);
        IERC20 votingToken = IERC20(voting.votingToken());
        votingToken.approve(votingContract, amount);
        voting.stake(amount);
    }

    /**
     * @notice Request unstaking of ERC20 tokens from this contract to the votingContract.
     * @param amount amount of tokens to unstake.
     * @param votingContract Address of the voting contract to unstake from.
     */
    function requestUnstake(uint256 amount, address votingContract) external onlyRoleHolder(roleId) {
        StakerInterface voting = StakerInterface(votingContract);
        voting.requestUnstake(amount);
    }

    /**
     * @notice Execute an unstake request that has passed liveness on the voting contract.
     * @param votingContract Address of the voting contract to execute the unstake from.
     */
    function executeUnstake(address votingContract) external onlyRoleHolder(roleId) {
        StakerInterface voting = StakerInterface(votingContract);
        voting.executeUnstake();
    }
}
