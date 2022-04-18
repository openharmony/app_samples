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
import { ArrayType } from "../commonDataType/iterateArray"

@Entry
@Component
struct ConditionalRenderingSample {
  @State dataArray: ArrayType[] = [];
  @State showList: boolean = false

  private aboutToAppear(): void  {
    for (var index = 0; index < 15; index++) {
      this.dataArray.push({
        image: $r("app.media.ic_public_play_norm"),
        name: index.toString()
      })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {

        Row() {
          NavigationBar({ title: '条件渲染' })
        }

        .width('80%')

        Image($r("app.media.ic_public_shuffle"))
          .height(28)
          .width(28)
          .margin({ right: 24 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.showList = !this.showList
          })
      }

      Column() {
        if (this.showList) {
          List({ space: 12 }) {
            ForEach(this.dataArray, (item: ArrayType) => {
              ListItem() {
                Row() {
                  Image(item.image)
                    .objectFit(ImageFit.Contain)
                    .width('15%')
                    .margin({ top: 10, right: '7%', bottom: 10 })
                    .borderRadius('50%')
                  Text(item.name)
                    .textAlign(TextAlign.Center)
                    .fontSize(20)
                    .fontColor('#000')
                    .width('80%')
                    .height(30)
                    .margin({ top: 5 })
                  .backgroundColor('#ccc')
                }
              }
              .borderRadius(24)
              .padding({ left: '3.6%', right: '5.4%', top: 12, bottom: 12 })
              .backgroundColor('#ffffff')
            }, item => (item.image, item.name))
          }
        } else {
          Grid() {
            ForEach(this.dataArray, (item: ArrayType) => {
              GridItem() {
                Column() {
                  Image(item.image)
                    .objectFit(ImageFit.Contain)
                    .width('70%')
                  .height(70)
                  Text(item.name)
                    .textAlign(TextAlign.Center)
                    .width('100%')
                    .height(25)
                    .backgroundColor('#F1F3F5')
                    .fontSize('14fp')
                    .margin({ top: 12, bottom: 12 })
                  .backgroundColor('#ccc')
                }
              }
              .padding({ left: 10, right: 10 })
              .height('20%')
              .width('100%')
            })
          }
          .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(8)
          .rowsGap(8)
          .padding({ left: 10, right: 10 })
        }
      }
      .width('100%')
      .flexGrow(1)
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
