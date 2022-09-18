import React, { useEffect, useState } from 'react'
import { initMetamask } from '../../init-metamask';

export default function RecipeDetails() {
  const [result, setResult] = useState(null);

  useEffect(() => {
    initMetamask("0xF88C7B6EE1C0e561162e2A27f8795ef5Ff2733f2").then(
      async (contract) => {
        // get the NFT info
        const res = await contract.methods.tokenURI(1).call({
          from: "0xcEeB1373c3cB66c100591Ddf311307639BEb1496",
        });
        decodeJSONBase64(res);
      }
    );
  }, []);

  const decodeJSONBase64 = (encodedBase24String: string) => {
    const encodedString = encodedBase24String.substring(29);
    const decodedString = window.atob(encodedString); // 29 = length of `"data:application/json;base64,"`
    const decodedJSON = JSON.parse(decodedString);
    setResult(decodedJSON);
  }

  if (!result) {
    return <h2>⚙️ Loading...</h2>
  }

  return (
    <div>RecipeDetails</div>
  )
}
