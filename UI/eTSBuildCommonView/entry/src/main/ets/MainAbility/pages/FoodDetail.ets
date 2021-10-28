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

@Component
struct FoodImageDisplay {
  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image($r('app.media.Tomato'))
        .objectFit(ImageFit.Contain)
      Text('Tomato')
        .fontSize(26)
        .fontWeight(500)
        .margin({ left: 26, bottom: 17.4 })
    }
    .backgroundColor('#FFedf2f5')
    .height(357)
  }
}

@Component
struct ContentTable {
  @Builder IngredientItem(title:string, name: string, value: string) {
    Flex() {
      Text(title)
        .fontSize(17.4)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
      Flex({ alignItems: ItemAlign.Center }) {
        Text(name)
          .fontSize(17.4)
          .flexGrow(1)
        Text(value)
          .fontSize(17.4)
      }
      .layoutWeight(2)
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
      this.IngredientItem('Calories', 'Calories', '17kcal')
      this.IngredientItem('Nutrition', 'Protein', '0.9g')
      this.IngredientItem(' ', 'Fat', '0.2g')
      this.IngredientItem(' ', 'Carbohydrates', '3.9g')
      this.IngredientItem(' ', 'VitaminC', '17.8mg')
    }
    .padding({ top: 20, right: 20, left: 20 })
    .height(250)
  }
}

@Entry
@Component
struct FoodDetail {
  build() {
    Column() {
      FoodImageDisplay()
      ContentTable()
    }
    .alignItems(HorizontalAlign.Center)
  }
}