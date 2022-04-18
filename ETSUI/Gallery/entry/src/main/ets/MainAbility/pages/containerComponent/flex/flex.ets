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
 * WITHOUT WARRANTIES OR CONDITION S OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { NavigationBar } from "../../../common/components/navigationBar"

const BACKGROUND_COLORS: string[] = ["#EE82EE", "#87CEFA", "#FF4500"]

@Observed
class FlexInfo {
  public index: number = 0;
  public flexGrow: number = 0;
  public flexShirk: number = 1
  public flexBasis: any = 'auto'
  public alignSelf: ItemAlign = ItemAlign.Auto

  constructor(index: number) {
    this.index = index;
  }
}

@Component
struct ItemTemplate {
  private index: number = 0;
  @Link clickedIndex: number;
  @ObjectLink flexInfo: FlexInfo;

  build() {
    Text(`${this.index + 1}`)
      .width('20%')
      .border({
        width: (this.clickedIndex == this.index ? 5 : 1),
        color: (this.clickedIndex == this.index ? Color.Yellow : Color.Black)
      })
      .height(50)
      .backgroundColor(BACKGROUND_COLORS[this.index%3])
      .textAlign(TextAlign.Center)
      .lineHeight(35)
      .fontColor(Color.White)
      .fontSize(20)
      .flexGrow(this.flexInfo.flexGrow)
      .flexShrink(this.flexInfo.flexShirk)
      .flexBasis(this.flexInfo.flexBasis)
      .alignSelf(this.flexInfo.alignSelf)
      .onClick(() => {
        this.clickedIndex = this.index
      })
  }
}

@Entry
@Component
struct FlexSample {
  @State children: FlexInfo[] = [
    new FlexInfo(0),
    new FlexInfo(1),
    new FlexInfo(2),
  ]
  @State FlexOptions: FlexOptions = {
    direction: FlexDirection.Row,
    justifyContent: FlexAlign.Start,
    alignItems: ItemAlign.Start,
    wrap: FlexWrap.NoWrap
  }
  @State @Watch('onclickedIndexChange') clickedIndex: number = 0;
  @State currentInfo: FlexInfo = this.children[this.clickedIndex];
  @State isContainerShow: boolean = true

  onclickedIndexChange(propName: string) {
    this.currentInfo = this.children[this.clickedIndex];
  }

  build() {
    Column() {
      NavigationBar({ title: 'Flex' })
      Scroll() {
        Flex(this.FlexOptions) {
          ForEach(this.children,
            (item, index) => {
              ItemTemplate({ index: index, clickedIndex: $clickedIndex, flexInfo: this.children[index] })
            }, (item) => item.index
          )
        }
      }.width('100%')
      .height("35%")
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })


      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Button('+', { type: ButtonType.Capsule, stateEffect: true })
              .backgroundColor("#007DFF")
              .width(90)
              .fontSize('16fp')
              .onClick((event: ClickEvent) => {
                if (this.children.length < 10) {
                  this.children.push(new FlexInfo(this.children.length))
                }
              })
            Button('-', { type: ButtonType.Capsule, stateEffect: true })
              .backgroundColor("#007DFF")
              .width(90)
              .fontSize('16fp')
              .onClick(() => {
                if (this.children.length > 1) {
                  this.children.pop()
                  if (this.clickedIndex >= this.children.length) {
                    this.clickedIndex = this.children.length - 1;
                  }
                }
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Button('Container', { type: ButtonType.Capsule, stateEffect: true })
              .borderRadius(14)
              .borderStyle(BorderStyle.Dotted)
              .borderWidth(this.isContainerShow ? 2 : 0)
              .backgroundColor("#007DFF")
              .fontColor(Color.White)
              .width(110)
              .onClick(() => {
                this.isContainerShow = true;
              })

            Button('Item', { type: ButtonType.Capsule, stateEffect: true })
              .borderRadius(14)
              .borderStyle(BorderStyle.Dotted)
              .borderWidth(this.isContainerShow ? 0 : 2)
              .backgroundColor("#007DFF")
              .fontColor(Color.White)
              .width(110)
              .onClick(() => {
                this.isContainerShow = false;
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 8 })

          if (this.isContainerShow) {
            Column() {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text('direction')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                Column() {
                  Text(`FlexDirection.${FlexDirection[this.FlexOptions['direction']]}`)
                    .fontSize('16fp')
                    .fontColor('#182431')
                    .fontWeight(FontWeight.Medium)
                    .width('50%')
                    .textAlign(TextAlign.End)
                }
                .bindMenu([
                  {
                    value: 'FlexDirection.Row',
                    action: () => {
                      this.FlexOptions['direction'] = FlexDirection.Row
                    }
                  },
                  {
                    value: 'FlexDirection.RowReverse',
                    action: () => {
                      this.FlexOptions['direction'] = FlexDirection.RowReverse
                    }
                  },
                  {
                    value: 'FlexDirection.Column',
                    action: () => {
                      this.FlexOptions['direction'] = FlexDirection.Column
                    }
                  },
                  {
                    value: 'FlexDirection.ColumnReverse',
                    action: () => {
                      this.FlexOptions['direction'] = FlexDirection.ColumnReverse
                    }
                  }
                ])
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })

              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text('justifyContent')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                Column() {
                  Text(`FlexAlign.${FlexAlign[this.FlexOptions['justifyContent']]}`)
                    .fontSize('16fp')
                    .fontColor('#182431')
                    .fontWeight(FontWeight.Medium)
                    .width('50%')
                    .textAlign(TextAlign.End)
                }
                .bindMenu([
                  {
                    value: 'FlexAlign.Start',
                    action: () => {
                      this.FlexOptions['justifyContent'] = FlexAlign.Start
                    }
                  },
                  {
                    value: 'FlexAlign.Center',
                    action: () => {
                      this.FlexOptions['justifyContent'] = FlexAlign.Center
                    }
                  },
                  {
                    value: 'FlexAlign.End',
                    action: () => {
                      this.FlexOptions['justifyContent'] = FlexAlign.End
                    }
                  },
                  {
                    value: 'FlexAlign.SpaceBetween',
                    action: () => {
                      this.FlexOptions['justifyContent'] = FlexAlign.SpaceBetween
                    }
                  },
                  {
                    value: 'FlexAlign.SpaceAround',
                    action: () => {
                      this.FlexOptions['justifyContent'] = FlexAlign.SpaceAround
                    }
                  },
                  {
                    value: 'FlexAlign.SpaceEvenly',
                    action: () => {
                      this.FlexOptions['justifyContent'] = FlexAlign.SpaceEvenly
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
                Text('alignItems')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                Column() {
                  Text(`ItemAlign.${ItemAlign[this.FlexOptions['alignItems']]}`)
                    .fontSize('16fp')
                    .fontColor('#182431')
                    .fontWeight(FontWeight.Medium)
                    .width('50%')
                    .textAlign(TextAlign.End)
                }
                .bindMenu([
                  {
                    value: 'ItemAlign.Start',
                    action: () => {
                      this.FlexOptions['alignItems'] = ItemAlign.Start
                    }
                  },
                  {
                    value: 'ItemAlign.Center',
                    action: () => {
                      this.FlexOptions['alignItems'] = ItemAlign.Center
                    }
                  },
                  {
                    value: 'ItemAlign.End ',
                    action: () => {
                      this.FlexOptions['alignItems'] = ItemAlign.End
                    }
                  },
                  {
                    value: 'ItemAlign.Baseline',
                    action: () => {
                      this.FlexOptions['alignItems'] = ItemAlign.Baseline
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
                Text('wrap')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                Column() {
                  Text(`FlexWrap.${FlexWrap[this.FlexOptions['wrap']]}`)
                    .fontSize('16fp')
                    .fontColor('#182431')
                    .fontWeight(FontWeight.Medium)
                    .width('50%')
                    .textAlign(TextAlign.End)
                }
                .bindMenu([
                  {
                    value: 'FlexWrap.Wrap',
                    action: () => {
                      this.FlexOptions['wrap'] = FlexWrap.Wrap
                    }
                  },
                  {
                    value: 'FlexWrap.NoWrap',
                    action: () => {
                      this.FlexOptions['wrap'] = FlexWrap.NoWrap
                    }
                  },
                  {
                    value: 'WrapReverse',
                    action: () => {
                      this.FlexOptions['wrap'] = FlexWrap.WrapReverse
                    }
                  }
                ])
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8, bottom: 20 })
            }
            .height("60%")
          }
          else {
            Column() {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text(`${this.clickedIndex + 1} el flexGrow ${this.currentInfo.flexGrow}`)
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                Counter() {
                  Text(`${this.currentInfo.flexGrow}`).fontSize(22)
                }
                .height(30)
                .onInc(() => {
                  if (this.currentInfo.flexGrow < 99) {
                    this.currentInfo.flexGrow++;
                  }
                })
                .onDec(() => {
                  if (this.currentInfo.flexGrow > 0) {
                    this.currentInfo.flexGrow--;
                  }
                })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })

              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text(`${this.clickedIndex + 1} el flexShrink(${this.currentInfo.flexShirk})`)
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                Counter() {
                  Text(`${this.currentInfo.flexShirk}`).fontSize(22)
                }
                .height(30)
                .onInc(() => {
                  if (this.currentInfo.flexShirk < 99) {
                    this.currentInfo.flexShirk++;
                  }

                })
                .onDec(() => {
                  if (this.currentInfo.flexShirk > 0) {
                    this.currentInfo.flexShirk--;
                  }
                })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })

              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text('alignSelf')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                Column() {
                  Text(`${ItemAlign[this.currentInfo['alignSelf']]}`)
                    .fontSize('16fp')
                    .fontColor('#182431')
                    .fontWeight(FontWeight.Medium)
                    .width('50%')
                    .textAlign(TextAlign.End)
                }
                .bindMenu([
                  {
                    value: 'ItemAlign.Auto',
                    action: () => {
                      this.currentInfo['alignSelf'] = ItemAlign.Auto
                    }
                  },
                  {
                    value: 'ItemAlign.Start',
                    action: () => {
                      this.currentInfo['alignSelf'] = ItemAlign.Start
                    }
                  },
                  {
                    value: 'ItemAlign.Center',
                    action: () => {
                      this.currentInfo['alignSelf'] = ItemAlign.Center
                    }
                  },
                  {
                    value: 'ItemAlign.End',
                    action: () => {
                      this.currentInfo['alignSelf'] = ItemAlign.End
                    }
                  },
                  {
                    value: 'ItemAlign.Stretch',
                    action: () => {
                      this.currentInfo['alignSelf'] = ItemAlign.Stretch
                    }
                  },
                  {
                    value: 'ItemAlign.Baseline',
                    action: () => {
                      this.currentInfo['alignSelf'] = ItemAlign.Baseline
                    }
                  }
                ])
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })


              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text(`flexBasis  ${this.currentInfo.flexBasis}`)
                  .width('45%')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .fontSize('16fp')
                  .opacity(0.5)

                Counter() {
                  Text(typeof (this.currentInfo.flexBasis) === 'number' ? `${this.currentInfo.flexBasis}` : '0')
                    .fontSize(22)
                }
                .height(30)
                .onInc(() => {
                  if (typeof (this.currentInfo.flexBasis) === 'number') {
                    if (this.currentInfo.flexBasis < 99) {
                      this.currentInfo.flexBasis++;
                    }
                  } else {
                    this.currentInfo.flexBasis = 0;
                  }

                }).onDec(() => {
                  if (typeof (this.currentInfo.flexBasis) === 'number' && this.currentInfo.flexBasis > 0) {
                    this.currentInfo.flexBasis--;
                  } else {
                    this.currentInfo.flexBasis = 0;
                  }
                })

                Text("auto")
                  .onClick(() => {
                    this.currentInfo.flexBasis = 'auto'
                  })
                  .width('20%')
                  .fontColor(Color.Black)
                  .fontSize('16fp')
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })

            }
            .height("60%")
          }

        }
      }.width('100%')
      .height("60%")

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
