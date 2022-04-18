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

@Entry
@Component
struct SidebarExample {
  @State text: string = ''
  @State setShowSideBar: boolean = true;
  @State setShowControlButton: boolean = true;
  @State setSideBarWidth: number = 100;
  @State setMinSideBarWidth: number = 0;
  @State setMaxSideBarWidth: number = 1000;
  @State setSideBarColor: string = 'rgba(225,225,225,1)';

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'SideBarContainer' })

      SideBarContainer(SideBarContainerType.Embed) {
        Column() {
          Button('One').onClick(() => {
            this.text = 'One Click'
          }).width('100%')
          Button('Two').onClick(() => {
            this.text = 'Two Click'
          }).width('100%')
          Button('Three').onClick(() => {
            this.text = 'Three Click'
          }).width('100%')
          Button('Four').onClick(() => {
            this.text = 'Four Click'
          }).width('100%')
          Button('Five').onClick(() => {
            this.text = 'Five Click'
          }).width('100%')
          Button('Six').onClick(() => {
            this.text = 'Six Click'
          }).width('100%')
          Text(this.text)
        }.backgroundColor(this.setSideBarColor)
        .width(this.setSideBarWidth)

        RowSplit() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('setSideBarColor')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Column() {
                GetColor({ colorVal: $setSideBarColor })
              }.width(48)
            }
            .width('100%')
            .height(35)
            .padding({ left: 12, right: 12 })
            .borderRadius(14)
            .backgroundColor('#FFF')
            .margin({ top: 8, bottom: 8, left: 12, right: 12 })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('showSideBar')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Toggle({ type: ToggleType.Switch, isOn: this.setShowSideBar })
                .width(35)
                .height(20)
                .selectedColor('#007DFF')
                .switchPointColor(0xe5ffffff)
                .onChange(() => {
                    this.setShowSideBar ? this.setShowSideBar = false : this.setShowSideBar = true
                })
            }
            .width('100%')
            .height(35)
            .padding({ left: 12, right: 12 })
            .borderRadius(14)
            .backgroundColor('#FFF')
            .margin({ top: 8, bottom: 8,left:12,right:12 })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('showControlButton')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Toggle({ type: ToggleType.Switch, isOn: this.setShowControlButton })
                .width(35)
                .height(20)
                .selectedColor('#007DFF')
                .switchPointColor(0xe5ffffff)
                .onChange(() => {
                    this.setShowControlButton ? this.setShowControlButton = false : this.setShowControlButton = true
                })
            }
            .width('100%')
            .height(35)
            .padding({ left: 12, right: 12 })
            .borderRadius(14)
            .backgroundColor('#FFF')
            .margin({ top: 8, bottom: 8,left:12,right:12 })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('sidebarWidth')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431 ')
                .opacity(0.5)
              Column() {
                Text(`${this.setSideBarWidth}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431 ')
              }
              .bindMenu([
                {
                  value: '50',
                  action: () => {
                    this.setSideBarWidth = 50
                  }
                },
                {
                  value: '100',
                  action: () => {
                    this.setSideBarWidth = 100
                  }
                },
                {
                  value: '150',
                  action: () => {
                    this.setSideBarWidth = 150
                  }
                },
                {
                  value: '200',
                  action: () => {
                    this.setSideBarWidth = 200
                  }
                }
              ])
            }
            .width('100%')
            .height(35)
            .padding({ left: 12, right: 12 })
            .borderRadius(14)
            .backgroundColor('#FFF')
            .margin({ top: 8, bottom: 8, left: 12, right: 12 })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('minSideBarWidth')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431 ')
                .opacity(0.5)
              Column() {
                Text(`${this.setMinSideBarWidth}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431 ')
              }
              .bindMenu([
                {
                  value: '50',
                  action: () => {
                    this.setMinSideBarWidth = 50
                  }
                },
                {
                  value: '100',
                  action: () => {
                    this.setMinSideBarWidth = 100
                  }
                },
                {
                  value: '150',
                  action: () => {
                    this.setMinSideBarWidth = 150
                  }
                },
                {
                  value: '200',
                  action: () => {
                    this.setMinSideBarWidth = 200
                  }
                }
              ])
            }
            .width('100%')
            .height(35)
            .padding({ left: 12, right: 12 })
            .borderRadius(14)
            .backgroundColor('#FFF')
            .margin({ top: 8, bottom: 8, left: 12, right: 12 })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('maxSideBarWidth')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431 ')
                .opacity(0.5)
              Column() {
                Text(`${this.setMaxSideBarWidth}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431 ')
                  .opacity(0.5)
              }
              .bindMenu([
                {
                  value: '50',
                  action: () => {
                    this.setMaxSideBarWidth = 50
                  }
                },
                {
                  value: '100',
                  action: () => {
                    this.setMaxSideBarWidth = 100
                  }
                },
                {
                  value: '150',
                  action: () => {
                    this.setMaxSideBarWidth = 150
                  }
                },
                {
                  value: '200',
                  action: () => {
                    this.setMaxSideBarWidth = 200
                  }
                }
              ])
            }
            .width('100%')
            .height(35)
            .padding({ left: 12, right: 12 })
            .borderRadius(14)
            .backgroundColor('#FFF')
            .margin({ top: 8, bottom: 8, left: 12, right: 12 })

          }
        }
      }
      .showSideBar(this.setShowSideBar)
      .showControlButton(this.setShowControlButton)
      .controlButton({
        left: 15,
        top: 400,
        width: 70,
        height: 70,
        icons: { shown: $r("app.media.icon"), hidden: $r("app.media.icon") }
      })
      .sideBarWidth(this.setSideBarWidth)
      .minSideBarWidth(this.setMinSideBarWidth)
      .maxSideBarWidth(this.setMaxSideBarWidth)
      .onChange((value: boolean) => {
        console.info('----sidebar----onChange' + value)
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')

  }
}