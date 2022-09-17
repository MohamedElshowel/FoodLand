import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.10",
  defaultNetwork: "velas",
  networks: {
    velas: {
      accounts: [ "a0a5ec2c80740fc16aea32ba807f38e3feae96c84f08c5409427e0276ee1e491" ],
      url: "https://evmexplorer.testnet.velas.com/rpc"
    }
  }
};

export default config;
