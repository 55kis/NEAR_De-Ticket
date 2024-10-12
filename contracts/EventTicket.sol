// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract EventTicket is ERC721URIStorage {
    address public organizer;
    string public eventName;
    string public eventDescription;
    uint public eventDate;

    struct TicketCategory {
        string name;
        uint price;
        uint availableSupply;
        uint sold;
    }

    mapping(uint => TicketCategory) public categories;
    uint public categoryCount;

    uint public nextTokenId;

    constructor(
        string memory name,
        string memory description,
        uint date,
        string[] memory ticketCategories,
        uint[] memory ticketPrices,
        uint[] memory ticketSupplies,
        address organizer_
    ) ERC721(name, "TICKET") {
        organizer = organizer_;
        eventName = name;
        eventDescription = description;
        eventDate = date;

        for (uint i = 0; i < ticketCategories.length; i++) {
            categories[i] = TicketCategory({
                name: ticketCategories[i],
                price: ticketPrices[i],
                availableSupply: ticketSupplies[i],
                sold: 0
            });
        }
        categoryCount = ticketCategories.length;
    }

    function buyTicket(uint categoryIndex) public payable {
        require(categoryIndex < categoryCount, "Invalid category");
        TicketCategory storage category = categories[categoryIndex];
        require(category.sold < category.availableSupply, "Tickets sold out");
        require(msg.value == category.price, "Incorrect payment amount");

        (bool sent, ) = organizer.call{value: msg.value}("");
        require(sent, "Failed to send Ether to organizer");

        _mint(msg.sender, nextTokenId);
        nextTokenId++;

        category.sold++;
    }

    function updateDescription(string memory newDescription) public {
        require(msg.sender == organizer, "Only the organizer can update");
        eventDescription = newDescription;
    }

    function getCategoryDetails(uint categoryIndex) public view returns (string memory, uint, uint, uint) {
        require(categoryIndex < categoryCount, "Invalid category");
        TicketCategory memory category = categories[categoryIndex];
        return (category.name, category.price, category.availableSupply, category.sold);
    }
}
