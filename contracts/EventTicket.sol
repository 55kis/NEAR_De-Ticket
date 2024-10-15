// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventTicket is ERC721Enumerable, Ownable {
    struct TicketCategory {
        string categoryName;
        uint price;
        uint totalSupply;
        uint availableSupply;
    }

    mapping(uint => TicketCategory) public ticketCategories;  // categoryId -> TicketCategory
    uint public nextCategoryId;

    mapping(uint => uint) public tokenToCategory;  // tokenId -> categoryId
    uint public nextTokenId;

    string public eventName;
    string public eventDescription;
    uint public eventDate;
    address public eventOrganizer;

    constructor(
        string memory _name,
        string memory _description,
        uint _date,
        string[] memory _categories,
        uint[] memory _prices,
        uint[] memory _supplies,
        address _organizer
    ) ERC721("EventTicket", "ETK") Ownable(msg.sender) {
        eventName = _name;
        eventDescription = _description;
        eventDate = _date;
        eventOrganizer = _organizer;

        for (uint i = 0; i < _categories.length; i++) {
            ticketCategories[nextCategoryId] = TicketCategory({
                categoryName: _categories[i],
                price: _prices[i],
                totalSupply: _supplies[i],
                availableSupply: _supplies[i]
            });
            nextCategoryId++;
        }
    }

    function buyTicket(uint categoryId) public payable {
        require(categoryId < nextCategoryId, "Invalid category");
        TicketCategory storage category = ticketCategories[categoryId];
        require(category.availableSupply > 0, "No tickets available in this category");
        require(msg.value == category.price, "Incorrect value sent");

        // Mint ticket to the buyer
        uint tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);

        // Map tokenId to category
        tokenToCategory[tokenId] = categoryId;

        nextTokenId++;
        category.availableSupply--;
    }

    // Function to get all tickets owned by a user
    function getUserTickets(address user) public view returns (uint[] memory) {
        uint ticketCount = balanceOf(user);
        uint[] memory tokenIds = new uint[](ticketCount);

        for (uint i = 0; i < ticketCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(user, i);
        }

        return tokenIds;
    }
}
