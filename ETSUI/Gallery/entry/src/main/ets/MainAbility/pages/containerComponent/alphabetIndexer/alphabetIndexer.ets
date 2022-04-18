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
import { NavigationBar } from "../../../common/components/navigationBar"
import { GetColor } from "../../../common/components/getColor"
import { listData } from "../../../model/AlphabetIndexerData"

@Entry
@Component
struct AlphabetIndexerSample {
  scroller: Scroller = new Scroller()
  private value: string[] = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
  private listValue: string[] = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
  @State index: number = 0
  @State selectedColor: string = '#00ffff'
  @State popupColor: string = '#00ffff'
  @State selectedBackgroundColor: string = '#ff0000'
  @State popupBackground: string = '#ff0000'
  @State usingPopup: boolean = true
  @State itemSize: number = 13
  @State location: boolean = true

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        NavigationBar({ title: 'AlphabetIndexer' })
      }.padding({ left: '3%' })

      Flex({ direction: this.location ? FlexDirection.Row : FlexDirection.RowReverse }) {
        List({ space: 10, initialIndex: 0, scroller: this.scroller }) {
          ForEach(this.listValue, (item) => {
            ListItem() {
              Column() {
                Text('     ' + item)
                  .height(30)
                  .fontSize(16)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                Column() {
                  ForEach(listData, (ele) => {
                    if (ele.substr(0, 1) == item.toUpperCase() || ele.substr(0, 1) == item.toLowerCase()) {
                      Text('' + ele)
                        .fontSize(16)
                        .width('100%')
                        .textAlign(TextAlign.Center)
                        .margin({ top: 5, bottom: 5 })
                        .height(72)
                        .borderRadius(24)
                        .backgroundColor('#ffffff')
                    }
                  })
                }
              }
            }
            .editable(true)
          }, item => item)
        }
        .listDirection(Axis.Vertical)
        .onScrollIndex((firstIndex: number, lastIndex: number) => {
          this.index = firstIndex
        })

        AlphabetIndexer({ arrayValue: this.value, selected: this.index })
          .selectedColor(this.selectedColor)
          .popupColor(this.popupColor)
          .selectedBackgroundColor(this.selectedBackgroundColor)
          .popupBackground(this.popupBackground)
          .usingPopup(this.usingPopup)
          .selectedFont({ size: 10, weight: FontWeight.Bolder })
          .popupFont({ size: 30, weight: FontWeight.Bolder })
          .itemSize(this.itemSize)
          .alignStyle(this.location ? IndexerAlign.Right : IndexerAlign.Left)
          .onSelected((index: number) => {
            this.scroller.scrollToIndex(index)
          })
      }
      .height('50%')
      .padding({ left: '3%', right: '3%', bottom: 10 })

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('selectedColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $selectedColor })
            }.width(48)
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('popupColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $popupColor })
            }.width(48)
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('selectedBackgroundColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $selectedBackgroundColor })
            }.width(48)
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('popupBackground')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)

              Text('' + this.popupBackground == '#fff000' ? '黄色' : '红色')
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
                .bindMenu([
                  {
                    value: '红色',
                    action: () => {
                      this.popupBackground = '#ff0000'
                    }
                  },
                  {
                    value: '黄色',
                    action: () => {
                      this.popupBackground = '#fff000'
                    }
                  }
                ])
            }
            .padding('3%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('usingPopup')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.Center)
              Toggle({ type: ToggleType.Switch, isOn: this.usingPopup })
                .selectedColor('#007DFF')
                .switchPointColor(0xe5ffffff)
                .onChange((isOn: boolean) => {
                  this.usingPopup = !this.usingPopup
                })
                .margin(0)
                .padding(0)
            }
            .padding('3%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('location')
                .fontSize(16)
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Text(this.location ? 'Right' : 'Left')
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .padding('3%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
          .bindMenu([
            {
              value: 'Left',
              action: () => {
                this.location = false
              }
            },
            {
              value: 'Right',
              action: () => {
                this.location = true
              }
            }
          ])

          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('itemSize')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Text('' + this.itemSize)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .height(35)

            Slider({
              value: this.itemSize,
              min: 0,
              max: 13,
              step: 1,
              style: SliderStyle.OutSet
            })
              .blockColor('#FFFFFF')
              .trackColor('#183431')
              .selectedColor('#007DFF')
              .borderColor('rgba(0,0,0,0.04)')
              .borderRadius(12)
              .showSteps(true)
              .showTips(false)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.itemSize = Math.floor(value)
              })
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
        .padding({ left: '3%', right: '3%', bottom: 10 })
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height('40%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
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