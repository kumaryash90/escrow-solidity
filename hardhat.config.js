require('@nomiclabs/hardhat-ethers');
require('dotenv').config();

module.exports = {
  solidity: "0.8.3",
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_URL,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
};
