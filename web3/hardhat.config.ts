import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.10",
  defaultNetwork: "velas",
  networks: {
    velas: {
      accounts: [ "0x346fb10e3d3deb11939a6d7e0efd467fc6c40a99bbc501b118f0b05a05eb5ffb" ],
      url: "https://evmexplorer.testnet.velas.com/rpc"
    }
  }
};

export default config;
