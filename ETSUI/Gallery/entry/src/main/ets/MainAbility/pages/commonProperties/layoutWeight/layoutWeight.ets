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
  public layoutWeight: number = 0;

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
      .layoutWeight(this.flexInfo.layoutWeight)
      .onClick(() => {
        this.clickedIndex = this.index
      })
  }
}

@Entry
@Component
struct LayOutWeightSample {
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
  @State @Watch('onClickedIndexChange') clickedIndex: number = 0;
  @State currentInfo: FlexInfo = this.children[this.clickedIndex];
  @State isContainerShow: boolean = true

  onClickedIndexChange(propName: string) {
    this.currentInfo = this.children[this.clickedIndex];
  }

  build() {
    Column() {
      NavigationBar({ title: '尺寸设置' })
      Column() {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          ForEach(this.children,
            (item, index) => {
              ItemTemplate({ index: index, clickedIndex: $clickedIndex, flexInfo: this.children[index] })
            }, (item) => item.index
          )
        }.width('100%')
        .height('100%')
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .backgroundColor('#b6dfff')

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Button('+', { type: ButtonType.Capsule, stateEffect: true })
              .borderRadius(14)
              .width(44)
              .height(28)
              .backgroundColor("#007DFF")
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .onClick((event: ClickEvent) => {
                this.children.push(new FlexInfo(this.children.length))
              })
            Button('-', { type: ButtonType.Capsule, stateEffect: true })
              .borderRadius(14)
              .width(44)
              .height(28)
              .backgroundColor("#007DFF")
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
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
          .height(45)
          .borderRadius(24)
          .padding({left:'3%',right:'3%'})
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text(`${this.clickedIndex + 1} el layoutWeight(${this.currentInfo.layoutWeight})`)
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Column() {
              Counter() {
                Text(`${this.currentInfo.layoutWeight}`)
                  .fontWeight(FontWeight.Regular)
                  .fontColor('#000000')
                  .fontSize('10fp')
              }
              .onInc(() => {
                this.currentInfo.layoutWeight++;
              })
              .onDec(() => {
                if (this.currentInfo.layoutWeight > 0) {
                  this.currentInfo.layoutWeight--;
                }
              })
              .height(24)
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }
      .margin({ top: 24 })
    }
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