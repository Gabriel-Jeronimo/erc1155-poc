import {ethers} from "hardhat";

describe("ConcertTickets", function () {
    async function deploy() {
        const TOKEN_EXCHANGE_RATE = 1000;
        const GENERAL_EXCHANGE_RATE = 1000;
        const VIP_EXCHANGE_RATE = 1000;

        const [owner, otherAccount] = await ethers.getSigners();

        const contract = await ethers.getContractFactory("ConcertTickets");
        const concertTickets = await contract.deploy(TOKEN_EXCHANGE_RATE, GENERAL_EXCHANGE_RATE, VIP_EXCHANGE_RATE);

        
    }
});