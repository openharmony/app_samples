// @ts-nocheck
/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { ChangeData } from './foodData'

@Component
struct PageTitle {
  private index: number= router.getParams().foodIndex
  @ObjectLink foodItem: ChangeData;
  @StorageLink('FoodItems') FoodData: ChangeData[] = []
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      foodItem: this.foodItem,
      cancel: this.onCancel,
      confirm: this.onAccept.bind(this) }),
    autoCancel: true
  })

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
    this.FoodData.splice(this.index, 1, this.foodItem)
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Image($r('app.media.Back'))
        .width(21.8)
        .height(19.6)
        .onClick(() => {
          router.back()
        })
      Text('Food Detail')
        .fontSize(21.8)
      Image($r('app.media.ic_public_edit'))
        .width(30)
        .height(30)
        .margin({ right: 20 })
        .onClick(() => {
          this.dialogController.open()
        })
    }
    .height(61)
    .backgroundColor('#FFedf2f5')
    .padding({ top: 13, bottom: 15, left: 28.3 })
  }
}

@Component
struct FoodImageDisplay {
  @ObjectLink foodItem: ChangeData

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image(this.foodItem.image)
        .objectFit(ImageFit.Contain)
      Text(this.foodItem.name)
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
  @ObjectLink foodItem: ChangeData

  @Builder IngredientItem(title: string, name: string, value: string) {
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
      this.IngredientItem('Calories', 'Calories', `${this.foodItem.calories}` + 'kcal')
      this.IngredientItem('Nutrition', 'Protein', `${this.foodItem.protein}` + 'g')
      this.IngredientItem(' ', 'Fat', `${this.foodItem.fat}` + 'g')
      this.IngredientItem(' ', 'Carbohydrates', `${this.foodItem.carbohydrates}` + 'g')
      this.IngredientItem(' ', 'VitaminC', `${this.foodItem.vitaminC}` + 'mg')
    }
    .padding({ top: 20, right: 20, left: 20 })
    .height(250)
  }
}


@CustomDialog
struct CustomDialogExample {
  private foodItem: ChangeData
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Text(`name:`)
          .fontSize(20)
          .lineHeight(30)
        TextInput({ placeholder: this.foodItem.name })
          .width('60%')
          .onChange((value: string) => {
            if (value) {
              this.foodItem.name = value
            }
          })
      }.margin({ top: 10, left: 20, right: 20 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Text(`calories:`)
          .fontSize(20)
          .lineHeight(30)
        TextInput({ placeholder: this.foodItem.calories })
          .width('60%')
          .onChange((value: string) => {
            this.foodItem.calories = value
          })
      }.margin({ top: 10, left: 20, right: 20 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Text(`protein:`)
          .fontSize(20)
          .lineHeight(30)
        TextInput({ placeholder: this.foodItem.protein })
          .width('60%')
          .onChange((value: string) => {
            if (value) {
              this.foodItem.protein = value
            }
          })
      }.margin({ top: 10, left: 20, right: 20 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Text(`fat:`)
          .fontSize(20)
          .lineHeight(30)
        TextInput({ placeholder: this.foodItem.fat })
          .width('60%')
          .onChange((value: string) => {
            if (value) {
              this.foodItem.fat = value
            }
          })
      }.margin({ top: 10, left: 20, right: 20 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Text(`carbohydrates:`)
          .fontSize(20)
          .lineHeight(30)
        TextInput({ placeholder: this.foodItem.carbohydrates })
          .width('60%')
          .onChange((value: string) => {
            if (value) {
              this.foodItem.carbohydrates = value
            }
          })
      }.margin({ top: 10, left: 20, right: 20 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Text(`vitaminC:`)
          .fontSize(20)
          .lineHeight(30)
        TextInput({ placeholder: this.foodItem.vitaminC })
          .width('60%')
          .onChange((value: string) => {
            if (value) {
              this.foodItem.vitaminC = value
            }
          })
      }.margin({ top: 10, left: 20, right: 20 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black).fontSize(20)
        Button('confirm')
          .onClick(() => {
            this.confirm()
            this.foodItem.name = this.foodItem.name
            this.foodItem.image = this.foodItem.image
            this.foodItem.calories = this.foodItem.calories
            this.foodItem.protein = this.foodItem.protein
            this.foodItem.fat = this.foodItem.fat,
            this.foodItem.carbohydrates = this.foodItem.carbohydrates
            this.foodItem.vitaminC = this.foodItem.vitaminC
            this.controller.close()
          })
          .backgroundColor(0xffffff)
          .fontColor(Color.Red)
          .fontSize(20)
      }
      .margin({ bottom: 10, top: 20 })
    }
  }
}

@Entry
@Component
struct FoodDetailSample {
  private index: number= router.getParams().foodIndex
  @StorageLink('FoodItems') FoodData: ChangeData[] = []
  @State foodItem: ChangeData = this.FoodData[this.index]

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        FoodImageDisplay({ foodItem: this.foodItem })
        PageTitle({ foodItem: this.foodItem })
      }

      ContentTable({ foodItem: this.foodItem })
    }
    .alignItems(HorizontalAlign.Center)
  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }
}
