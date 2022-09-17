- create test ETH key: https://vanity-eth.tk/
- get public key from private key:

```
  npm install -g ethereum-private-key-to-public-key
  ethereum_private_key_to_public_key PRIVATE_KEY
```

- get address from public key [ account ]:

```
  npm install -g ethereum-public-key-to-address
  ethereum-public-key-to-address PUBLIC_KEY
```

- get free Ropsten ETH for CONTRACT OWNER ACCOUNT

https://faucet.egorfine.com/

### DEPLOY ERC 271 contract

```
  nvm use 16
  cd web3 # from project root
  npm i
  npm run deploy
```

This folder also contains:
- ./node.sh script to run the graph server
- the subgraph with yaml config and graphql mappings
