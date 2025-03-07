// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.16;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./BaseEscalationManager.sol";

contract WhitelistCallerEscalationManager is BaseEscalationManager, Ownable {
    mapping(address => bool) whitelistedAssertingCallers;

    constructor(address _optimisticAsserter) BaseEscalationManager(_optimisticAsserter) {}

    function setAssertingCallerInWhitelist(address assertingCaller, bool value) public onlyOwner {
        whitelistedAssertingCallers[assertingCaller] = value;
    }

    function getAssertionPolicy(bytes32 assertionId) public view override returns (AssertionPolicy memory) {
        return
            AssertionPolicy({
                blockAssertion: !whitelistedAssertingCallers[
                    optimisticAsserter.getAssertion(assertionId).escalationManagerSettings.assertingCaller
                ],
                arbitrateViaEscalationManager: false,
                discardOracle: false,
                validateDisputers: false
            });
    }
}
