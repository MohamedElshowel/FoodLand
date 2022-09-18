import React from 'react'
import { useNavigate } from 'react-router';
import FoodItem from '../FoodItem';
import "./CategoriesList.css";

export default function CategoriesList() {
  const navigate = useNavigate();

  const categories: IFoodItem[] = [
    {
      title: "Vegan",
      imageUrl: "https://foodandnutrition.org/wp-content/uploads/big-bowl-vegetables-1047798504-1-780x520.jpg",
    },
    {
      title: "Vegetarian",
      imageUrl: "https://www.eatright.org/-/media/eatrightimages/food/nutrition/vegetarianandspecialdiets/vegetarianism-basic-facts-878734076.jpg",
    },
    {
      title: "Non-Veg",
      imageUrl: "https://deckfamilyfarm.com/wordpress/images/2015/09/poultryHerbRoastedChicken.jpg",
    },
    {
      title: "Plant-Based",
      imageUrl: "http://www.piedmont.org/media/BlogImages/Vegan-vs-plant-based.jpg"
    },
  ];

  const navigateToRecipes = () => navigate('/recipes');

  return (
    <div className="categories">
      <h1 className="categories__header">Food Categories</h1>
      <div className="categories__list">
        {categories.map(cat => <FoodItem key={cat.title.toLowerCase()} title={cat.title} imageUrl={cat.imageUrl} onClickHandler={navigateToRecipes}/>)}
      </div>
    </div>
  )
}
