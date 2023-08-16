const BesuMembership = artifacts.require("BesuMembership");

describe("BesuMembership contract", function () {
    let accounts;
    
    before(async function () {
        [account,] = await web3.eth.getAccounts();
    });

    describe("Sending data", function () {
        it("Should deploy BesuMembership", async function () {
            const besuMembership = await BesuMembership.new();
            
            assert.equal(await besuMembership.owner(), account);

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

            const result = await besuMembership.getMembership(publicKey);

            console.log(result);


            
        });
    });
});