const { ethers } = require('hardhat');
const abi = require('../artifacts/contracts/Escrow.sol/Escrow.json');

const main = async () => {
    const [addr1, addr2, addr3, addr4] = await ethers.getSigners();
    const escrow = new ethers.Contract('0x5FbDB2315678afecb367f032d93F642f64180aa3', abi.abi, ethers.provider);
    console.log("got contract: ", escrow.address);
    
    console.log("id: ", (await escrow.id()).toString());
    
    // await escrow.connect(addr1).createPayment(addr2.address, addr3.address, {
    //     value: ethers.utils.parseEther("0.01")
    // })

    // await escrow.connect(addr3).createPayment(addr2.address, addr4.address, {
    //     value: ethers.utils.parseEther("0.01")
    // })

    console.log("balance of escrow: ", (await ethers.provider.getBalance(escrow.address)).toString());
    //console.log("id: ", (await escrow.connect(addr1).id.call()).toString());
    //console.log("payment 0: ", (await escrow.payments.call()).length);
}

main()
.then(() => process.exit(0))
.catch(err => {
    console.log(err);
    process.exit(1);
});