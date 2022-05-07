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
import { NavigationBar } from "../../../common/components/navigationBar"

@Entry
@Component
struct NavigatorSample {
  @State navigationType: number = 1
  @State active: boolean = false
  @State text: string = 'text'
  @State self: string = 'pages/containerComponent/navigator/navigator'

  build() {

    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {

      NavigationBar({ title: 'Navigator' })

      Scroll() {
        Column() {
          Navigator({
            target: this.navigationType == 2 ? 'pages/home' : 'pages/containerComponent/navigator/detailPage',
            type: this.navigationType == 1 ? NavigationType.Push : this.navigationType == 2 ? NavigationType.Back : NavigationType.Replace
          }) {
            Text(`${this.navigationType == 1 ? 'Push deatail' : this.navigationType == 2 ? 'Back home' : 'Replace deatail'} page`)
              .width('100%')
              .textAlign(TextAlign.Center)
              .fontSize(20)
          }.params({ text: this.text, self: this.self }).active(this.active)

        }

      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Scroll() {
        Column() {

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('params')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Text(this.text)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .padding('3%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
          }
          .width('95%')

          TextArea({ placeholder: 'text' })
            .placeholderColor(0xC0C0C0)
            .placeholderFont({ size: 15, weight: 400 })
            .textAlign(TextAlign.Start)
            .caretColor(Color.Black)
            .onChange((value: string) => {
              this.text = value
            })
            .padding('3%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
            .width('95%')

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('type')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Text(this.navigationType == 1 ? 'Push' : this.navigationType == 2 ? 'Back' : 'Replace')
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
                .bindMenu([
                  {
                    value: 'Push',
                    action: () => {
                      this.navigationType = 1
                    }
                  },
                  {
                    value: 'Back',
                    action: () => {
                      this.navigationType = 2
                    }
                  },
                  {
                    value: 'Replace',
                    action: () => {
                      this.navigationType = 3
                    }
                  }
                ])
            }
            .padding('3%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
          .width('95%')

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween , alignItems:ItemAlign.Center}) {
              Text('active')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Toggle({ type: ToggleType.Switch, isOn: this.active })
                .selectedColor('#007DFF')
                .switchPointColor(0xe5ffffff)
                .onChange((isOn: boolean) => {
                  this.active = !this.active
                })
                .margin(0)
                .padding(0)
            }
            .padding('3%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
          .width('95%')

        }

      }
      .margin({ top: 24 })

    }
    .padding({ left: '3%', right: '3%' })
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