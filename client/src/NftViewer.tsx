import React, { useEffect } from "react";
import Web3 from 'web3'

const NftViewer = () => {
  const providerUrl = 'https://evmexplorer.testnet.velas.com/rpc';
  const provider = window['ethereum'];

  useEffect(() => {
    const web3 = new Web3(providerUrl)
    let selectedAccount;

    if (typeof provider !== 'undefined') {
        provider
            .request({method: 'eth_requestAccounts' })
            .then((accounts: any[]) => {
                selectedAccount = accounts[0];
                console.log(`Selected account is ${selectedAccount}`);
            })
            .catch((err: any) => {
                console.log(err);
            });
            
            window['ethereum'].on('accountsChanged', function (accounts: any[]){
            selectedAccount = accounts[0];
            console.log(`Selected account changed to ${selectedAccount}`);
            });
        }
    }, []);
 
    return (
        <div id="container">
            <div>
                <div>{ status }</div>
                <div>Here show nft info</div>
            </div>
        </div>
    );
};

export default NftViewer;
