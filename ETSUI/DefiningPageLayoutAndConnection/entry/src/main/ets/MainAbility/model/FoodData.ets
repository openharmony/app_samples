/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export enum Category  {
  Fruit,
  Vegetable,
  Nut,
  Seafood,
  Dessert
}

let NextId = 0;
export class FoodData {
  id: string;
  name: string;
  image: Resource
  category: Category;
  calories: number;
  protein: number;
  fat: number;
  carbohydrates: number;
  vitaminC: number;

  constructor(name: string, image: Resource, category: Category, calories: number, protein: number, fat: number, carbohydrates: number, vitaminC: number) {
    this.id = `${ NextId++ }`;
    this.name = name;
    this.image = image;
    this.category = category;
    this.calories = calories;
    this.protein = protein;
    this.fat = fat;
    this.carbohydrates = carbohydrates;
    this.vitaminC = vitaminC;
  }
}