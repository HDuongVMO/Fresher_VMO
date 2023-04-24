const { expect } = require("chai");

describe("ChocoVillage Test", function () {
  it("Should mint village", async function () {

    const accounts = await ethers.getSigners();

    const ChocoVillage = await ethers.getContractFactory("ChocoVillage");
    const chocoVillage = await ChocoVillage.deploy();

    await chocoVillage.mintVillage();
    const balance = await chocoVillage.balanceOf(accounts[0].address, 0)
    expect(1).to.equal(Number(balance.toString()));
  });
  it("Should mint castle", async function () {
    const accounts = await ethers.getSigners();

    const ChocoVillage = await ethers.getContractFactory("ChocoVillage");
    const chocoVillage = await ChocoVillage.deploy();

    await chocoVillage.mintVillage();
    await chocoVillage.mintMine();
    await chocoVillage.mintFarm();
    await chocoVillage.mintMill();
    await chocoVillage.mintCastle();
    const balance = await chocoVillage.balanceOf(accounts[0].address, 4)
    expect(1).to.equal(Number(balance.toString()));
  });
});