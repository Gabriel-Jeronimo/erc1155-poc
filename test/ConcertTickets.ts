import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import {ethers} from "hardhat";
import { expect } from "chai";


describe("ConcertTickets", function () {
    async function deploy() {
        const TOKEN_EXCHANGE_RATE = 1000;
        const GENERAL_EXCHANGE_RATE = 1000;
        const VIP_EXCHANGE_RATE = 1000;

        const [owner, otherAccount] = await ethers.getSigners();

        const contract = await ethers.getContractFactory("ConcertTickets");
        const concertTickets = await contract.deploy(TOKEN_EXCHANGE_RATE, GENERAL_EXCHANGE_RATE, VIP_EXCHANGE_RATE);

        return {concertTickets, owner, otherAccount, TOKEN_EXCHANGE_RATE, GENERAL_EXCHANGE_RATE, VIP_EXCHANGE_RATE};
    }

    describe("Deployment", () => {
        it("Should set the right owner", async () => {
            const {concertTickets, owner} = await loadFixture(deploy);

            expect(await concertTickets.owner()).to.equal(owner.address);
        })
    })
});