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

    function getAllEvents() public view returns (EventDetails[] memory) {
        return events;
    }

    // Function to get all tickets owned by a user across all events
    function getUserTicketsAcrossEvents(address user) public view returns (uint[] memory, address[] memory) {
        uint totalTicketCount = 0;
        
        // First pass: calculate total number of tickets owned
        for (uint i = 0; i < events.length; i++) {
            EventTicket eventContract = EventTicket(events[i].eventContract);
            totalTicketCount += eventContract.balanceOf(user);
        }

        // Create arrays for storing token IDs and their respective event contracts
        uint[] memory tokenIds = new uint[](totalTicketCount);
        address[] memory eventContracts = new address[](totalTicketCount);

        uint index = 0;
        // Second pass: gather all ticket IDs and event addresses
        for (uint i = 0; i < events.length; i++) {
            EventTicket eventContract = EventTicket(events[i].eventContract);
            uint ticketCount = eventContract.balanceOf(user);
            if (ticketCount > 0) {
                uint[] memory eventTokenIds = eventContract.getUserTickets(user);
                for (uint j = 0; j < eventTokenIds.length; j++) {
                    tokenIds[index] = eventTokenIds[j];
                    eventContracts[index] = address(eventContract);
                    index++;
                }
            }
        }

        return (tokenIds, eventContracts);
    }
}
