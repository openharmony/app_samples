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
struct ButtonSample {
  @State showType: string= 'Capsule'
  @State isStateEffect: boolean = true

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'Button' })

      Column() {
        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceAround
        }) {
          if (this.showType == 'Circle') {
            Button({ type: ButtonType.Circle, stateEffect: this.isStateEffect }) {
              Image($r('app.media.ic_public_arrow_left')).width(60).height(60)
            }.width(100).height(100).backgroundColor('#1989fa')
            .onClick((event: ClickEvent) => {
              this.showType = 'Capsule'
            })

            Button({ type: ButtonType.Circle, stateEffect: this.isStateEffect }) {
              Image($r('app.media.ic_public_arrow_right')).width(60).height(60)
            }.width(100).height(100).backgroundColor('#ee0a24')
            .onClick((event: ClickEvent) => {
              this.showType = 'Normal'
            })
          } else {
            Button({ type: ButtonType[this.showType], stateEffect: this.isStateEffect }) {
              Row() {
                Text('OK')
                  .fontColor(0xffffff)
                  .fontSize('25fp')
              }.height('100%')
            }
            .backgroundColor('#ee0a24')
            .width('40%')
            .height('20%')
            .fontSize('25fp')

            Button({ type: ButtonType[this.showType], stateEffect: this.isStateEffect }) {
              Row() {
                Image($r('app.media.ic_camera_parabar_story_loading')).width(20).height(20).margin({ left: 12 })
                Text('loading')
                  .fontColor(0xffffff)
                  .margin({ left: 5, right: 12 })
                  .fontSize('25fp')
              }.height('100%')
            }
            .backgroundColor(0x317aff)
            .width('40%')
            .height('20%')


            .onClick((event: ClickEvent) => {
              AlertDialog.show({ message: 'The login is successful' })
            })
            .fontSize('25fp')

            Button('Disable', { type: ButtonType[this.showType], stateEffect: this.isStateEffect })
              .border({ color: '#ed6a0c', width: 5, radius: this.showType == 'Capsule' ? 100 : 0 })
              .backgroundColor('rgba(0,0,0,0)')
              .width('40%')
              .height('20%')
              .fontSize('25fp')
              .onClick((event: ClickEvent) => {
                AlertDialog.show({ message: 'The login is successful' })
              })

          }
        }
        .width('100%')
        .constraintSize({ minHeight: 218, maxHeight: 402 })
        .padding({ left: 12, right: 12, top: 22, bottom: 22 })
        .backgroundColor('#FFB6C1')

        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('type')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.showType}`)
                .width('50%')
                .textAlign(TextAlign.End)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .bindMenu([
                  {
                    value: 'Normal',
                    action: () => {
                      this.showType = 'Normal'
                    }
                  },
                  {
                    value: 'Capsule',
                    action: () => {
                      this.showType = 'Capsule'
                    }
                  },
                  {
                    value: 'Circle',
                    action: () => {
                      this.showType = 'Circle'
                    }
                  }
                ])
            }

          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('stateEffect')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Toggle({ type: ToggleType.Switch, isOn: this.isStateEffect })
              .selectedColor('#007DFF ')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.isStateEffect = !this.isStateEffect
                console.log(`${this.isStateEffect}`)
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
        .margin({ top: 24 })
      }
    }
    .padding({ left: '3%', right: '3%', bottom: 10 })
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