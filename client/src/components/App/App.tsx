import React from "react";
import { Routes, Route } from "react-router-dom";
// Components
import Header from "../Header";
import RecipesList from "../RecipesList";
import CategoriesList from "../CategoriesList";
import RecipeDetails from "../RecipeDetails";
// Styles
import "./App.css";

function App() {
  return (
    <div className="app">
      <Header />
      <Routes>
        <Route path="/" element={<CategoriesList />} />
        <Route path="recipes" element={<RecipesList />} />
        <Route path="recipe-details" element={<RecipeDetails />} />
      </Routes>
    </div>
  );
}

export default App;
