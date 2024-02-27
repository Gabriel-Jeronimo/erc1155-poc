import { ethers } from "hardhat";

async function main() {

  const concertTickets = await ethers.deployContract("ConcertTickets", [1000, 1000, 3000]);

  await concertTickets.waitForDeployment();

  console.log(
    `Contract deployed to ${concertTickets.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
