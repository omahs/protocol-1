const { ZERO_ADDRESS } = require("@uma/common");

const func = async function (hre) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  const Timer = (await deployments.getOrNull("Timer")) || { address: ZERO_ADDRESS };
  const VotingToken = await deployments.get("VotingToken");
  const Finder = await deployments.get("Finder");

  // Set the GAT percentage to 5%
  const gatPercentage = { rawValue: hre.web3.utils.toWei("0.05", "ether") };

  // Set the inflation rate.
  const emissionRate = "640000000000000000";

  const unstakeCooldown = 60 * 60 * 24 * 30; // 1 month.

  // Set phase length to one day.
  const phaseLength = "86400";

  await deploy("VotingV2", {
    from: deployer,
    args: [
      emissionRate,
      unstakeCooldown,
      phaseLength,
      gatPercentage,
      VotingToken.address,
      Finder.address,
      Timer.address,
    ],
    log: true,
    skipIfAlreadyDeployed: true,
  });
};
module.exports = func;
func.tags = ["dvmv2"];
func.dependencies = ["VotingToken", "Finder", "Timer"];
