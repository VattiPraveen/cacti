const { expect } = require("chai");
const anyValue = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const BesuMembership = artifacts.require("BesuMembership");

describe("BesuMembership contract", function () {
    let accounts;
    let besuMembership;
    
    beforeEach(async () => {
        [account,] = await web3.eth.getAccounts();
        besuMembership = await BesuMembership.new();
    });

    // Test case for createMembership all possible cases

    describe("createMembership testcase", function () {
        it("Should create Membership", async function () {
            securityDomain = "network1";
            publicKey = "0x123456123abc987123";
            memberValue = "0x123456123abc987123";
            memberType= "Public Key" ;
            memberChain = ["okay", "notOkay"];

            const res = web3.eth.abi.encodeParameters(
                    ["string", "string", "string", "string", "string[]"],
                    [securityDomain, publicKey, memberValue, memberType, memberChain]
                );
            
            const txn = await besuMembership.createMembership(res);
        });

        it("Cannot update membership as member does not exit", async function () {
            securityDomain = "network1";
            publicKey = "0x123456123abc987123";
            memberValue = "0x123456123abc987123";
            memberType= "Public Key" ;
            memberChain = ["okay", "notOkay"];

            let res = web3.eth.abi.encodeParameters(
                    ["string", "string", "string", "string", "string[]"],
                    [securityDomain, publicKey, memberValue, memberType, memberChain]
                );
            
            let txn = await besuMembership.createMembership(res);


            publicKey = "0x123456123ab23452345";
            memberValue = "0x123456123ab23452345";

            res = web3.eth.abi.encodeParameters(
                    ["string", "string", "string", "string", "string[]"],
                    [securityDomain, publicKey, memberValue, memberType, memberChain]
                );
            
            
            expect(await besuMembership.updateMembership(res)).to.be.revertedWith('Member does not exist');
        });

        it("cannot update as membership does not exit", async function () {
            securityDomain = "network1";
            publicKey = "0x123456123abc987123";
            memberValue = "0x123456123abc987123";
            memberType= "Public Key" ;
            memberChain = ["okay", "notOkay"];

            let res = web3.eth.abi.encodeParameters(
                    ["string", "string", "string", "string", "string[]"],
                    [securityDomain, publicKey, memberValue, memberType, memberChain]
                );
            
            let txn = await besuMembership.createMembership(res);

            securityDomain = "network2";
            publicKey = "0x123456123ab23452345";
            memberValue = "0x123456123ab23452345";

            res = web3.eth.abi.encodeParameters(
                    ["string", "string", "string", "string", "string[]"],
                    [securityDomain, publicKey, memberValue, memberType, memberChain]
                );
            
            
            expect(await besuMembership.updateMembership(res)).to.be.revertedWith('Membership not found');
        });

        it("Update membership", async function () {
            securityDomain = "network1";
            publicKey = "0x123456123abc987123";
            memberValue = "0x123456123abc987123";
            memberType= "Public Key" ;
            memberChain = ["okay", "notOkay"];

            let res = web3.eth.abi.encodeParameters(
                    ["string", "string", "string", "string", "string[]"],
                    [securityDomain, publicKey, memberValue, memberType, memberChain]
                );
            
            let txn = await besuMembership.createMembership(res);

            memberValue = "0x123456123ab23452345";

            res = web3.eth.abi.encodeParameters(
                    ["string", "string", "string", "string", "string[]"],
                    [securityDomain, publicKey, memberValue, memberType, memberChain]
                );
            
            await besuMembership.updateMembership(res);
            
            let member = await besuMembership.getMemberships(securityDomain, publicKey);

            expect(member.memberValue).to.equal(memberValue);
        });

        it("delete membership", async function () {
            securityDomain = "network1";
            publicKey = "0x123456123abc987123";
            memberValue = "0x123456123abc987123";
            memberType= "Public Key" ;
            memberChain = ["okay", "notOkay"];

            let res = web3.eth.abi.encodeParameters(
                    ["string", "string", "string", "string", "string[]"],
                    [securityDomain, publicKey, memberValue, memberType, memberChain]
                );
            
            let txn = await besuMembership.createMembership(res);

            await besuMembership.deleteMembership(securityDomain);
            
            expect(await besuMembership.getMemberships(securityDomain, publicKey)).to.be.rejectedWith('Membership not found');
        });

        it("cannot delete member as member does not exit", async function () {
            securityDomain = "network1";
            publicKey = "0x123456123abc987123";

            expect (await besuMembership.deleteMember(securityDomain, publicKey)).to.be.revertedWith('Membership not found');
        });


    });
});