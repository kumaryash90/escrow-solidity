const { ethers } = require('hardhat');

const main = async () => {
    const Escrow = await ethers.getContractFactory("Escrow");
    const escrow = await Escrow.deploy();
    await escrow.deployed();
    console.log("deployed at: ", escrow.address);
}

main()
.then(() => process.exit(0))
.catch(err => {
    console.log(err);
    process.exit(1);
})