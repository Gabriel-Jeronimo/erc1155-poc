// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

contract ConcertTickets is ERC1155, Ownable, IERC1155Receiver {
    uint256 public constant GENERAL = 1;
    uint256 public constant VIP = 2;
    uint256 public constant CONCERT_TOKEN = 3;

    uint256 private tokenExchangeRate;
    uint256 private generalExchangeRate;
    uint256 private vipExchangeRate;

    event TokenReceived(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes data
    );
    event TokenBatchReceived(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes data
    );
    event TokenBought(address receiver, uint256 amount);
    event TicketBought(address receiver, uint256 amount, uint256 id);
    
    constructor(
        uint256 _tokenExchangeRate,
        uint256 _generalExchangeRate,
        uint256 _vipExchangeRate
    ) ERC1155("") Ownable(msg.sender) {
        _mint(address(this), GENERAL, 300, "");
        _mint(address(this), VIP, 30, "");
        _mint(address(this), CONCERT_TOKEN, 10 ** 18, "");
        tokenExchangeRate = _tokenExchangeRate;
        vipExchangeRate = _vipExchangeRate;
        generalExchangeRate = _generalExchangeRate;
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override returns (bytes4) {
        emit TokenReceived(operator, from, id, value, data);
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external override returns (bytes4) {
        for (uint256 i = 0; i < ids.length; i++) {
            emit TokenBatchReceived(operator, from, ids[i], values[i], data);
        }
        return this.onERC1155BatchReceived.selector;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function buyTokens(uint256 amount) public payable {
        require(
            msg.value >= amount * tokenExchangeRate,
            "Not enough Ether sent. Please send at least " +
                (amount * tokenExchangeRate).toString() +
                " wei."
        );
        require(
            balanceOf(address(this), CONCERT_TOKEN) >= amount,
            "Not enough concert tokens to transfer. Please try a smaller amount."
        );

        _safeTransferFrom(address(this), msg.sender, CONCERT_TOKEN, amount, "");
        emit TokenBought(msg.sender, amount);
    }

    function buyGeneralTicket(uint256 amount) public {
        require(
            balanceOf(address(this), GENERAL) >= amount,
            "Not enough GENERAL tickets to transfer. Please try a smaller amount."
        );
        require(
            balanceOf(msg.sender, CONCERT_TOKEN) >=
                amount * generalExchangeRate,
            "Not enough concert tokens to transfer. Please send at least " +
                (amount * generalExchangeRate).toString() +
                " tokens."
        );

        _safeTransferFrom(
            msg.sender,
            address(this),
            CONCERT_TOKEN,
            amount * generalExchangeRate,
            ""
        );
        _safeTransferFrom(address(this), msg.sender, GENERAL, amount, "");
        emit TicketBought(msg.sender, amount, GENERAL);

    }

    function buyVIPTicket(uint256 amount) public {
        require(
            balanceOf(address(this), VIP) >= amount,
            "Not enough VIP tickets to transfer. Please try a smaller amount."
        );
        require(
            balanceOf(msg.sender, CONCERT_TOKEN) >= amount * vipExchangeRate,
            "Not enough concert tokens to transfer. Please send at least " +
                (amount * vipExchangeRate).toString() +
                " tokens."
        );

        _safeTransferFrom(
            msg.sender,
            address(this),
            CONCERT_TOKEN,
            amount * vipExchangeRate,
            ""
        );
        _safeTransferFrom(address(this), msg.sender, VIP, amount, "");
        emit TicketBought(msg.sender, amount, VIP);
    }
}
