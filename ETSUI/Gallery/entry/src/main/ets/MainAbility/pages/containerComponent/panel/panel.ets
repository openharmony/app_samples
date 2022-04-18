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

@Entry
@Component
struct PanelSample {
  @State show: boolean = true;
  @State type: PanelType = PanelType.Foldable;
  @State panelTypeString: string = 'Foldable';
  @State mode: PanelMode = PanelMode.Half;
  @State panelModeString: string = 'Half';
  @State dragBar: boolean = true;
  @State isOn: boolean = true;
  @State isOnDragBar: boolean = true;
  @State fullHeight: number = 1000;
  @State halfHeight: number = 500;
  @State miniHeight: number = 150;

  build() {
    Column() {
      NavigationBar({ title: 'Panel' })
      Scroll() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('Click for details')
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .height(40)
            .fontSize(18)
            .textAlign(TextAlign.Center)
            .borderRadius(24)
            .backgroundColor(0xFFFFFF)
            .padding({ left: 20 })
            .onClick(() => {
              this.show = !this.show
            })
        }
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Panel(this.show) {
        Column() {
          Text('change attribute').fontSize(18)
          Divider()

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('show')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Toggle({ type: ToggleType.Switch, isOn: this.isOn })
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn)
                this.show = !this.show
              })
          }
          .width('97%')
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('type')
              .fontSize('16fp')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.panelTypeString}`)
                .bindMenu([
                  {
                    value: 'Minibar',
                    action: () => {
                      this.type = PanelType.Minibar;
                      this.panelTypeString = 'Minibar'
                      this.mode = PanelMode.Full
                      this.panelModeString = 'Full'
                    }
                  },
                  {
                    value: 'Temporary',
                    action: () => {
                      this.type = PanelType.Temporary;
                      this.panelTypeString = 'Temporary'
                    }
                  },
                  {
                    value: 'Foldable',
                    action: () => {
                      this.type = PanelType.Foldable;
                      this.panelTypeString = 'Foldable'
                    }
                  },
                ])
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }

          }
          .width('97%')
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            if (this.type === PanelType.Minibar) {
              Text('mode')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Column() {
                Text(`${this.panelModeString}`)
                  .bindMenu([
                    {
                      value: 'Full',
                      action: () => {
                        this.mode = PanelMode.Full
                        this.panelModeString = 'Full'
                      }
                    },
                    {
                      value: 'Mini',
                      action: () => {
                        this.mode = PanelMode.Mini
                        this.panelModeString = 'Mini'
                      }
                    },
                    {
                      value: 'Half',
                      action: () => {
                        this.mode = PanelMode.Half
                        this.panelModeString = 'Half'
                      }
                    }
                  ])
                  .fontSize('16fp')
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                  .width('50%')
                  .textAlign(TextAlign.End)
              }

            } else if (this.type === PanelType.Temporary) {
              Text('mode')
                .fontSize(18)
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Column() {
                Text(`${this.panelModeString}`)
                  .bindMenu([
                    {
                      value: 'Half',
                      action: () => {
                        this.mode = PanelMode.Half
                        this.panelModeString = 'Half'
                      }
                    },
                    {
                      value: 'Full',
                      action: () => {
                        this.mode = PanelMode.Full
                        this.panelModeString = 'Full'
                      }
                    },
                    {
                      value: 'Mini',
                      action: () => {
                        this.mode = PanelMode.Mini
                        this.panelModeString = 'Mini'
                      }
                    },
                  ])
                  .fontSize('16fp')
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                  .width('50%')
                  .textAlign(TextAlign.End)
              }

            } else {
              Text('mode')
                .fontSize(18)
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Column() {
                Text(`${this.panelModeString}`)
                  .bindMenu([
                    {
                      value: 'Half',
                      action: () => {
                        this.mode = PanelMode.Half
                        this.panelModeString = 'Half'
                      }
                    },
                    {
                      value: 'Mini',
                      action: () => {
                        this.mode = PanelMode.Mini
                        this.panelModeString = 'Mini'
                      }
                    },
                    {
                      value: 'Full',
                      action: () => {
                        this.mode = PanelMode.Full
                        this.panelModeString = 'Full'
                      }
                    }
                  ])
                  .fontSize('16fp')
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                  .width('50%')
                  .textAlign(TextAlign.End)
              }

            }
          }
          .width('97%')
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('dragBar')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Toggle({ type: ToggleType.Switch, isOn: this.isOnDragBar })
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOnDragBar: boolean) => {
                console.info('Component status:' + isOnDragBar)
                this.dragBar = !this.dragBar
                this.isOnDragBar = !this.isOnDragBar
              })
          }
          .width('97%')
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }.width('95%')
      }
      .height('75%')
      .type(this.type)
      .mode(this.mode)
      .dragBar(this.dragBar)
      .halfHeight(this.halfHeight)
      .fullHeight(this.fullHeight)
      .miniHeight(this.miniHeight)
      .onChange((value: any) => {
        console.info(`width:${value.width},height:${value.height},mode:${value.mode}`)
      })
    }
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({left: '3%', right: '3%', bottom: 10 })
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