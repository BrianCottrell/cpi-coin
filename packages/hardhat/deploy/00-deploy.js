// deploy/00_deploy_my_contract.js

// const { ethers } = require("hardhat");

// const sleep = (ms) =>
//   new Promise((r) =>
//     setTimeout(() => {
//       console.log(`waited for ${(ms / 1000).toFixed(3)} seconds`);
//       r();
//     }, ms)
//   );

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy("Greeter", {
    from: deployer,
    args: ["hello world"],
    log: true,
  });

  await deploy("Storage", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    //args: [ "Hello", ethers.utils.parseEther("1.5") ],
    log: true,
  });

  await deploy("PureToken", {
    from: deployer,
    args: ["Pure Token", "PTK"],
    log: true,
  });

  await deploy("PureGovernanceToken", {
    from: deployer,
    args: ["Pure Governance Token", "PGT"],
    log: true,
  });
};

module.exports.tags = ["Greeter", "Storage", "PureToken", "PureGovernanceToken"];
