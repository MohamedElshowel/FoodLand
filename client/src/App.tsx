import React, { useEffect, useState } from 'react';
import './App.css';
import { initMetamask } from './init-metamask';

function App() {
  const [ result, setResult ] = useState(null);

  useEffect(() => {
    initMetamask('0xF88C7B6EE1C0e561162e2A27f8795ef5Ff2733f2')
      .then(async contract => {
        // get the NFT info
        const result = await contract.methods.tokenURI(1).call({
          from: '0xcEeB1373c3cB66c100591Ddf311307639BEb1496'
        });

        setResult(JSON.stringify(result));
      })
  }, []);

  return (
    <div className="App">
      This will be the actual appcode...TODO parse the following as base64: { result }
    </div>
  );
}

export default App;
