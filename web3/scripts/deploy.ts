import { ethers } from "hardhat";

async function main() {
  const ProfessionalVeganRecipe = await ethers.getContractFactory("ProfessionalVeganRecipe");
  const professionalVeganRecipe = await ProfessionalVeganRecipe.deploy();

  await professionalVeganRecipe.deployed();

  console.log("ProfessionalVeganRecipe deployed to:", professionalVeganRecipe.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
