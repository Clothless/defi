// Testing the tokenfarm contract
contract('TokenFarm', ([owner, investor]) => {
    let daiToken, dappToken, tokenFarm;
    before(async () => {
        // Load Contracts
        daiToken = await DaiToken.new();
        dappToken = await DappToken.new();
        tokenFarm = await TokenFarm.new(dappToken.address, daiToken.address);
        // Transfer all Dapp tokens to farm (1 million)
        await dappToken.transfer(tokenFarm.address, '1000000000000000000000000');
        // Send tokens to investor
        await daiToken.transfer(investor, '100000000000000000000', { from: owner });
    })
    // Write tests here...
    })