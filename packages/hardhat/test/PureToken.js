const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PureToken", function () {
  it("Should return the balance of the PureToken contract after a call to mintPure()", async function () {
    const PureToken = await ethers.getContractFactory("PureToken");
    const pureToken = await PureToken.deploy();
    await pureToken.deployed();

    expect(await storage.mintPure()).to.equal(10000);
  });
});