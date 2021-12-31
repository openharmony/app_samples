// @ts-nocheck
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

import router from '@system.router'
import {Category, FoodData} from '../model/FoodData'
import {initializeOnStartup} from '../model/FoodDataModels'


@Component
struct FoodListItem {
  private foodItem: FoodData

  build() {
    Navigator({ target: 'pages/FoodDetail' }) {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Row() {
          Image(this.foodItem.image)
            .objectFit(ImageFit.Contain)
            .autoResize(false)
            .height(40)
            .width(40)
        }
        .backgroundColor('#FFf1f3f5')
        .margin({ right: 16 })

        Text(this.foodItem.name)
          .fontSize(14)
          .flexGrow(1)
        Text(this.foodItem.calories + ' kcal')
          .fontSize(14)
      }
      .height(64)
    }
    .params({ foodId: this.foodItem })
    .margin({ right: 24, left: 32 })
  }
}


@Component
struct FoodList {
  @State foodItems: FoodData[]= FoodData
  @State text: string = ""
  @State boolOne: boolean = false
  @State boolTwo: boolean = false

  @Builder listMovingBuilder() {
    Flex({ justifyContent: FlexAlign.start, alignItems: ItemAlign.Center }) {
      Row() {
        Image(this.text.image)
          .height(40)
          .width(40)
      }
      .backgroundColor('#FFf1f3f5')
      .margin({ right: 16 })

      Text(this.text.name)
        .fontSize(14)
        .flexGrow(1)
      Text(this.text.calories + 'kcal')
        .fontSize(14)
    }
    .height(40)
    .margin({ right: 24, left: 32 })
    .backgroundColor('#FFFFFF')
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text('Food List')
          .fontSize(20)
          .margin({ left: 20 })
      }
      .height('7%')
      .backgroundColor('#FFf1f3f5')

      List() {
        ForEach(this.foodItems, (item) => {
          ListItem() {
            FoodListItem({ foodItem: item })
          }
        }, item => item.id.toString())
      }
      .height('93%')
      .editMode(true)
      .onItemDragStart((event: ItemDragInfo, itemIndex: number) => {
        this.boolOne = true
        this.text = this.foodItems[itemIndex]
        return this.listMovingBuilder
      })
      .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
        if (isSuccess) {
          if (this.boolTwo) {
            this.foodItems.splice(itemIndex, 1)
            this.boolOne = false
            this.boolTwo = false
          } else if (this.boolOne) {
            this.foodItems.splice(itemIndex, 1)
            this.foodItems.splice(insertIndex, 0, this.text)
            this.boolOne = false
            this.boolTwo = false
          }
        }
      })
    }
  }
}

@Component
struct FoodGridItem {
  private foodItem: FoodData

  build() {
    Column() {
      Row() {
        Image(this.foodItem.image)
          .objectFit(ImageFit.Contain)
          .height(152)
          .width('100%')
      }.backgroundColor('#FFf1f3f5')

      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text(this.foodItem.name)
          .fontSize(14)
          .flexGrow(1)
          .padding({ left: 8 })
        Text(this.foodItem.calories + 'kcal')
          .fontSize(14)
          .margin({ right: 6 })
      }
      .height(32)
      .width('100%')
      .backgroundColor('#FFe5e5e5')
    }
    .height(184)
    .width('100%')
    .onClick(() => {
      router.push({ uri: 'pages/FoodDetail', params: { foodId: this.foodItem } })
    })
  }
}

@Component
struct FoodGrid {
  @State foodItems: FoodData[]= FoodData
  private gridRowTemplate: string = ''
  private heightValue: number
  private NumberTmp: String[] = ['{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}']
  private virtualFoodData: String[] = ['{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}']
  private DragItemIndex: number

  aboutToAppear() {
    var rows = Math.round(this.foodItems.length / 2);
    this.gridRowTemplate = '1fr '.repeat(rows);
    this.heightValue = rows * 192 - 8;
  }

  @Builder gridMovingBuilder() {
    Column() {
      Row() {
        Image(this.virtualFoodData[this.DragItemIndex].image)
          .objectFit(ImageFit.Contain)
          .height(152)
          .width('100%')
      }.backgroundColor('#FFf1f3f5')

      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text(this.virtualFoodData[this.DragItemIndex].name)
          .fontSize(14)
          .flexGrow(1)
          .padding({ left: 8 })
        Text(this.virtualFoodData[this.DragItemIndex].calories + 'kcal')
          .fontSize(14)
          .margin({ right: 6 })
      }
      .height(32)
      .width('100%')
      .backgroundColor('#FFe5e5e5')
    }
    .width('49%')
  }

  build() {
    Scroll() {

      Grid() {
        ForEach(this.foodItems, (item: FoodData) => {
          GridItem() {
            FoodGridItem({ foodItem: item })
          }
        }, (item: FoodData) => item.id.toString())

      }
      .rowsTemplate(this.gridRowTemplate)
      .columnsTemplate('1fr 1fr')
      .columnsGap(8)
      .rowsGap(8)
      .height(this.heightValue)
      .editMode(true)

      .onItemDragStart((event, itemIndex) => {
        this.virtualFoodData = this.foodItems;
        this.DragItemIndex = itemIndex;
        return this.gridMovingBuilder
      })

      .onItemDrop((event, itemIndex, insertIndex, isSuccess) => {
        if (isSuccess) {
          if (itemIndex >= 0 && insertIndex >= 0) {
            this.NumberTmp = this.foodItems;
            if (itemIndex > insertIndex) {
              this.NumberTmp.splice(insertIndex, 0, this.virtualFoodData[itemIndex]);
              this.NumberTmp.splice(itemIndex + 1, 1);
            } else {
              this.NumberTmp.splice(insertIndex + 1, 0, this.virtualFoodData[itemIndex]);
              this.NumberTmp.splice(itemIndex, 1);
            }
            this.foodItems = this.NumberTmp;
          } else if (itemIndex == -1 && insertIndex >= 0) {
            this.foodItems.splice(insertIndex, 0, this.virtualFoodData[this.DragItemIndex]);
          } else if (itemIndex >= 0 && insertIndex == -1) { 
            this.foodItems.splice(itemIndex, 1);
          }
        }
      })

    }
    .scrollBar(BarState.Off)
    .padding({ left: 16, right: 16 })

  }
}

@Component
struct FoodCategory {
  private foodItems: FoodData[]

  build() {
    Stack() {
      Tabs() {
        TabContent() {
          FoodGrid({ foodItems: this.foodItems })
        }.tabBar('All')

        TabContent() {
          FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Vegetable)) })
        }.tabBar('Vegetable')

        TabContent() {
          FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Fruit)) })
        }.tabBar('Fruit')

        TabContent() {
          FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Nut)) })
        }.tabBar('Nut')

        TabContent() {
          FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Seafood)) })
        }.tabBar('Seafood')

        TabContent() {
          FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Dessert)) })
        }.tabBar('Dessert')
      }
      .barWidth(280)
      .barMode(BarMode.Scrollable)

    }
  }
}

@Entry
@Component
struct FoodCategoryList {
  private foodItems: FoodData[] = initializeOnStartup()
  @State private showList: boolean = false

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopEnd }) {
        if (this.showList) {
          FoodList({ foodItems: this.foodItems })
        } else {
          FoodCategory({ foodItems: this.foodItems })
        }
        Image($r('app.media.Switch'))
          .height(24)
          .width(24)
          .margin({ top: 15, right: 10 })
          .onClick(() => {
            this.showList = !this.showList
          })
      }
    }.height('100%')
  }
}
