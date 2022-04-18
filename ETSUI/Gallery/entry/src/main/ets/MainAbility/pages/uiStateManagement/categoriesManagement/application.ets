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

import router from '@system.router';
import { NavigationBar } from "../../../common/components/navigationBar"
import { ChangeData } from './foodData';

@Entry
@Component
struct ApplicationSample {
  @StorageLink('FoodItems') foodData: ChangeData[] = [];

  private aboutToAppear(): void  {
    AppStorage.SetOrCreate<ChangeData[]>("FoodItems", [{
                                                         name: "Tomato",
                                                         image: $r('app.media.Tomato'),
                                                         calories: '17',
                                                         protein: '0.9',
                                                         fat: '0.2',
                                                         carbohydrates: '3.9',
                                                         vitaminC: '17.8'
                                                       },
                                                       {
                                                         name: "Walnut",
                                                         image: $r('app.media.Walnut'),
                                                         calories: '654',
                                                         protein: '15',
                                                         fat: '65',
                                                         carbohydrates: '14',
                                                         vitaminC: '1.3'
                                                       },
                                                       {
                                                         name: "Cucumber",
                                                         image: $r('app.media.Cucumber'),
                                                         calories: '30',
                                                         protein: '3',
                                                         fat: '0',
                                                         carbohydrates: '1.9',
                                                         vitaminC: '2.1'
                                                       },
                                                       {
                                                         name: "Blueberry",
                                                         image: $r('app.media.Blueberry'),
                                                         calories: '57',
                                                         protein: '0.7',
                                                         fat: '0.3',
                                                         carbohydrates: '14',
                                                         vitaminC: '9.7'
                                                       },
                                                       {
                                                         name: "Crab",
                                                         image: $r('app.media.Crab'),
                                                         calories: '97',
                                                         protein: '19',
                                                         fat: '1.5',
                                                         carbohydrates: '0',
                                                         vitaminC: ' 7.6'
                                                       },
                                                       {
                                                         name: "IceCream",
                                                         image: $r('app.media.IceCream'),
                                                         calories: '207',
                                                         protein: '3.5',
                                                         fat: '11',
                                                         carbohydrates: ' 24',
                                                         vitaminC: '0.6'
                                                       },
                                                       {
                                                         name: "Onion",
                                                         image: $r('app.media.Onion'),
                                                         calories: '39',
                                                         protein: '1.1',
                                                         fat: '0.1',
                                                         carbohydrates: '9',
                                                         vitaminC: '7.4'
                                                       },
                                                       {
                                                         name: "Mushroom",
                                                         image: $r('app.media.Mushroom'),
                                                         calories: '22',
                                                         protein: '3.1',
                                                         fat: '0.3',
                                                         carbohydrates: '3.3',
                                                         vitaminC: '2.1'
                                                       },
                                                       {
                                                         name: "Kiwi",
                                                         image: $r('app.media.Kiwi'),
                                                         calories: '60',
                                                         protein: '1.1',
                                                         fat: '0.5',
                                                         carbohydrates: '15',
                                                         vitaminC: '20.5'
                                                       },
                                                       {
                                                         name: "Pitaya",
                                                         image: $r('app.media.Pitaya'),
                                                         calories: '60',
                                                         protein: '1.2',
                                                         fat: '0',
                                                         carbohydrates: '10',
                                                         vitaminC: '60.9'
                                                       },
                                                       {
                                                         name: "Avocado",
                                                         image: $r('app.media.Avocado'),
                                                         calories: '160',
                                                         protein: ' 2',
                                                         fat: '15',
                                                         carbohydrates: '9',
                                                         vitaminC: '10'
                                                       },
                                                       {
                                                         name: "Strawberry",
                                                         image: $r('app.media.Strawberry'),
                                                         calories: '32',
                                                         protein: '0.7',
                                                         fat: '0.3',
                                                         carbohydrates: '8',
                                                         vitaminC: '58.8'
                                                       }])
  }

  build() {
    Column() {
      NavigationBar({ title: '@Observed&@ObjectLink' })
      Column() {
        Scroll() {
          Grid() {
            ForEach(this.foodData, (item: ChangeData, index) => {
              GridItem() {
                Column() {
                  Image(item.image)
                    .objectFit(ImageFit.Contain)
                    .height(152)
                    .width('100%')
                    .backgroundColor('#F1F3F5')

                  Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                    Text(item.name)
                      .fontSize(14)
                      .flexGrow(1)
                      .padding({ left: 8 })
                    Text(item.calories + 'kcal')
                      .fontSize(14)
                      .margin({ right: 6 })
                  }
                  .height(32)
                  .width('100%')
                  .backgroundColor('#FFe5e5e5')
                }
              }
              .height(184)
              .width('100%')
              .onClick(() => {
                router.push({
                  uri: 'pages/uiStateManagement/categoriesManagement/foodDetail',
                  params: { foodIndex: index }
                })
              })
            })
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(8)
          .rowsGap(8)
          .height('93%')
        }
        .scrollBar(BarState.Off)
      }
    }
    .height('100%')
    .backgroundColor('#FFFFFF')
    .padding({ bottom: 10, left: '3%', right: '3%' })
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

