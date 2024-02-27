// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ConcertTickets is ERC1155, Ownable {
    uint256 public constant GENERAL = 1;
    uint256 public constant VIP = 2;
    uint256 public constant CONCERT_TOKEN = 3;

    uint256 private tokenExchangeRate;
    uint256 private generalExchangeRate;
    uint256 private vipExchangeRate;
    
    constructor(uint256  _tokenExchangeRate, uint256 _generalExchangeRate, uint256 _vipExchangeRate) ERC1155("") Ownable(msg.sender) {
        _mint(address(this), GENERAL, 300, "");
        _mint(address(this), VIP, 30, "");
        _mint(address(this), CONCERT_TOKEN, 10**27, "");
        tokenExchangeRate = _tokenExchangeRate;
        vipExchangeRate = _vipExchangeRate;
        generalExchangeRate = _generalExchangeRate;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function buyTokens(uint256 amount) public payable {
        require(msg.value >= amount * tokenExchangeRate, "Not enough Ether sent");
        require(balanceOf(address(this), CONCERT_TOKEN) >= amount, "Not enough tokens to transfer");

        _safeTransferFrom(address(this), msg.sender, CONCERT_TOKEN, amount * tokenExchangeRate , "");
    }

    // TODO: Add a cap of tickets by wallet
    // TODO: Make it payable with tickets
    // Q: How will they work if the value is broken? It will divide the NFT or floor it?
    function buyGeneralTicket(uint256 amount) public payable {
        require(balanceOf(address(this), GENERAL) >= amount, "Not enough GENERAL tickets to transfer");
        require(balanceOf(msg.sender, GENERAL) >= amount * generalExchangeRate, "Not enough concert tokens to transfer");


        _safeTransferFrom(address(this), msg.sender, GENERAL, amount * generalExchangeRate , "");
    }
}
