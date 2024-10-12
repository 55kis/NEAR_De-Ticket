import { ethers } from "hardhat";

async function main() {
  // Deploy the EventFactory contract
  const EventFactory = await ethers.getContractFactory("EventFactory");
  const eventFactory = await EventFactory.deploy();
  console.log("EventFactory deployed to:", eventFactory.target);
}

main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
