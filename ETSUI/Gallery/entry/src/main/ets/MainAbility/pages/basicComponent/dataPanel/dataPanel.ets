/*
 * Copyright (c) 2022  Huawei Device Co., Ltd.
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
import { NavigationBar } from "../../../common/components/navigationBar"

@Entry
@Component
struct DataPanelSample {
  @State showType: string = 'Circle'
  @State showWidth: string = '70%'
  @State showHeight: string = '70%'
  @State numMax: number = 100
  @State dataList: number[] = [25, 25, 25, 25]
  @State sum: number = this.dataList.reduce((prev, curr) => {
    return prev + curr
  })

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: 'DataPanel' })
      Scroll() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
          DataPanel({ values: this.dataList, max: 100, type: DataPanelType[this.showType] })
            .width(this.showWidth)
            .height(this.showHeight)
        }
        .width('100%')
        .height('100%')
      }
      .height('40%')
      .width('100%')
      .padding(18)

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('type')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.showType}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .bindMenu([
              {
                value: 'Circle',
                action: () => {
                  this.showType = 'Circle'
                  this.showWidth = '70%'
                  this.showHeight = '70%'
                }
              },
              {
                value: 'Line',
                action: () => {
                  this.showType = 'Line'
                  this.showWidth = '80%'
                  this.showHeight = '40'
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('Max')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              TextInput({ placeholder: '100' })
                .type(InputType.Number)
                .placeholderColor(Color.Black)
                .placeholderFont({
                  size: 14,
                  weight: FontWeight.Normal,
                  family: "sans-serif",
                  style: FontStyle.Normal
                })
                .enterKeyType(EnterKeyType.Next)
                .width('20%')
                .fontSize('10fp')
                .fontWeight(FontWeight.Regular)
                .backgroundColor('#FFFFFF')
                .fontColor('#182431')
                .maxLength(20)
                .onChange((value: string) => {
                  this.numMax = Number(value)
                })
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.Center }) {
            Button('+', { type: ButtonType.Circle, stateEffect: true })
              .width(55)
              .height(55)
              .backgroundColor(0x317aff)
              .fontSize('40fp')
              .onClick((event: ClickEvent) => {
                if (this.dataList.length < 9) {
                  this.dataList.push(0)
                } else if (this.dataList.length == 9) {
                  AlertDialog.show({ message: '数据值列表，最大支持9个数据' })
                }
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ direction: FlexDirection.Column }) {
            ForEach(this.dataList, (item, index) => {
              Row() {
                Column() {
                  Text(this.dataList[index].toFixed(0)).fontSize('16fp')
                }.width(20)

                Slider({
                  value: this.dataList[index],
                  min: 0,
                  max: this.numMax,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('80%')
                  .showSteps(false)
                  .showTips(false)
                  .onChange((value: number, mode: SliderChangeMode) => {
                    this.dataList[index] = value
                    this.sum = this.dataList.reduce((prev, curr) => {
                      return prev + curr
                    })
                    if (this.sum > this.numMax) {
                      this.dataList[index] = value - (this.sum - this.numMax)
                    }
                  })
                  .width('86%')
                Text('-')
                  .textAlign(TextAlign.Center)
                  .lineHeight(22)
                  .borderRadius(12)
                  .width(22)
                  .height(22)
                  .backgroundColor('#000000')
                  .fontColor('#FFFFFF')
                  .fontSize('22fp')
                  .onClick((event: ClickEvent) => {
                    this.dataList.splice(index, 1)
                  })
              }
              .padding({ top: 30 })
            })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Row().height(50).width('100%').backgroundColor('#F1F3F5').margin({ top: 20 })
        }.width('100%')
      }
      .width('100%')
      .height('60%')
      .margin({ top: 24 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })
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