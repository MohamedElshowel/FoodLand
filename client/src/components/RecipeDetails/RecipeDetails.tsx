import React, { useEffect, useState } from 'react'
import { initMetamask } from '../../init-metamask';
import "./RecipeDetails.css";

export default function RecipeDetails() {
  const [result, setResult] = useState<Metamask>(null);

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
    console.log(decodedJSON);
  }

  if (!result) {
    return <h2>⚙️ Loading...</h2>
  }

  return (
    <div className="recipe-details">
      <section className="recipe-details__section">
        <h1 className="recipe-details__header">{result.name} receipe</h1>
        <div dangerouslySetInnerHTML={{ __html: result.svgBase64 }}></div>
      </section>
      <section className="recipe-details__section">
        <h2 className="recipe-details__header">Ingredients</h2>
        <span>{result.mainIngredient}</span>
        <ul className="recipe-details__sub-section">
          <li>Created by: &nbsp; <b>@{result.createdBy}</b></li>
          <li>
            Audit ID: &nbsp; <code>{result.auditId}</code>
            <img src="verified.png" alt="verified" className="verified-icon" />
          </li>
        </ul>
      </section>
    </div>
  )
}
