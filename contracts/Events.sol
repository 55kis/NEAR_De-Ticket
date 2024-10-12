// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./EventTicket.sol";

contract EventFactory {
    struct EventDetails {
        address eventContract;
        address organizer;
        string eventName;
        uint eventDate;
    }

    EventDetails[] public events;

    event EventCreated(address indexed eventContract, string eventName, address organizer);

    function createEvent(
        string memory name,
        string memory description,
        uint date,
        string[] memory ticketCategories,
        uint[] memory ticketPrices,
        uint[] memory ticketSupplies
    ) public {
        require(ticketCategories.length == ticketPrices.length, "Categories and prices mismatch");
        require(ticketCategories.length == ticketSupplies.length, "Categories and supplies mismatch");

        EventTicket newEvent = new EventTicket(name, description, date, ticketCategories, ticketPrices, ticketSupplies, msg.sender);
        
        events.push(EventDetails({
            eventContract: address(newEvent),
            organizer: msg.sender,
            eventName: name,
            eventDate: date
        }));

        emit EventCreated(address(newEvent), name, msg.sender);
    }

    function getAllEvents() public view returns (address[] memory, address[] memory, string[] memory, uint[] memory) {
    address[] memory eventContracts = new address[](events.length);
    address[] memory organizers = new address[](events.length);
    string[] memory eventNames = new string[](events.length);
    uint[] memory eventDates = new uint[](events.length);

    for (uint i = 0; i < events.length; i++) {
        eventContracts[i] = events[i].eventContract;
        organizers[i] = events[i].organizer;
        eventNames[i] = events[i].eventName;
        eventDates[i] = events[i].eventDate;
    }

    return (eventContracts, organizers, eventNames, eventDates);
}

}
