import React from 'react';
import "./FoodItem.css";

interface FootItemProps extends IFoodItem {
  onClickHandler?: () => void;
}

export default function FoodItem({ title, imageUrl, onClickHandler }: FootItemProps) {
  return (
    <div className="food-item" style={{ backgroundImage: `url(${imageUrl}` }} onClick={onClickHandler}>
      <span className="food-item__title">{title}</span>
    </div>
  )
}
