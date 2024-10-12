import { ethers } from "hardhat";

async function main() {
  const factoryAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const factory = await ethers.getContractAt("EventFactory", factoryAddress);

  // Create an event
  const createEventTx = await factory.createEvent(
    "Concert",
    "Live music",
    1723651200,
    ["VIP", "General"],
    [ethers.parseEther("2"), ethers.parseEther("1")],
    [100, 200]
  );

  await createEventTx.wait();
  console.log("Event created!");

  // Fetch all events
  const [eventContracts, organizers, eventNames, eventDates] = await factory.getAllEvents();

  // Loop through and log the events
  for (let i = 0; i < eventContracts.length; i++) {
    console.log(`Event ${i + 1}:`);
    console.log(`Contract Address: ${eventContracts[i]}`);
    console.log(`Organizer: ${organizers[i]}`);
    console.log(`Name: ${eventNames[i]}`);
    console.log(`Date: ${new Date(eventDates[i] * 1000).toISOString()}`);
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
