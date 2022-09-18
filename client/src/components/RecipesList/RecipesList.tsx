import React from 'react'
import { useNavigate } from 'react-router';
import FoodItem from '../FoodItem';
import "./RecipesList.css";

export default function RecipesList() {
  const navigate = useNavigate();

  const recipes: IFoodItem[] = [
    {
      title: "Brown Rice",
      imageUrl: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fcf-images.us-east-1.prod.boltdns.net%2Fv1%2Fstatic%2F1033249144001%2Fd702244e-459f-41ac-a4d4-c759b9fea726%2F4dcf4bcd-e8ef-4571-b8be-2199f6b3eb7f%2F1280x720%2Fmatch%2Fimage.jpg",
    },
    {
      title: "Pistachios",
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW3X7pqvL_zhPcTqGRZGfxOvK9BaS6hEprgg&usqp=CAU",
    },
    {
      title: "Quinoa salad",
      imageUrl: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F7397974.jpg",
    },
    {
      title: "Spring Roll",
      imageUrl: "https://www.connoisseurusveg.com/wp-content/uploads/2022/04/baked-spring-rolls-sq.jpg",
    },
    {
      title: "Vegan Burger",
      imageUrl: "https://loveincorporated.blob.core.windows.net/contentimages/main/c9a5bc3f-9b8a-4f77-bd2c-f10b346362fa-ultimate-vegan-burger.jpg",
    },
    {
      title: "Sushi Roll",
      imageUrl: "https://st2.depositphotos.com/1020618/6765/i/450/depositphotos_67657295-stock-photo-japanese-seafood-sushi-set.jpg",
    }
  ];

  const navigateToRecipes = () => navigate('/recipe-details');

  return (
    <div className="recipes">
      <h1 className="recipes__header">Vegan Recipes</h1>
      <div className="recipes__list">
        {recipes.map(cat => <FoodItem key={cat.title.toLowerCase()} title={cat.title} imageUrl={cat.imageUrl} onClickHandler={navigateToRecipes}/>)}
      </div>
    </div>
  )
}
