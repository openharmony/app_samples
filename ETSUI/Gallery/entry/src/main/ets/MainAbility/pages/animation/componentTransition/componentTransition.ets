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
struct ComponentTransitionSample {
  @State isShow: boolean = false
  @State scale: {
    x: number,
    y: number
  } = { x: 0, y: 0 }
  @State opcity: number= 0

  build() {
    Column() {
      NavigationBar({ title: '组件内转场' })
      Stack({ alignContent: Alignment.Center }) {
        Button('Show Dailog')
          .width(120)
          .onClick(() => {
            animateTo({
              duration: 1000,
              tempo: 2,
              curve: Curve.Friction,
              delay: 0,
              onFinish: () => {
                animateTo({
                  duration: 1000,
                  tempo: 2,
                  curve: Curve.Friction,
                  delay: 0,
                  onFinish: () => {
                  }
                }, () => {
                  this.scale = ({ x: 1, y: 1 })
                  this.opcity = 1
                })
              }
            }, () => {
              this.isShow = !this.isShow
              this.scale = ({ x: 1.25, y: 1.25 })
              this.opcity = 1
            })
          })
          .backgroundColor(0x317aff)
          .width(200)
          .height(80)
        ShowDialog({ isShow: $isShow, scale: $scale, opcity: $opcity })
      }
      .width('100%').height('100%').backgroundColor(this.isShow ? 'rgba(0,0,0,0.1)' : 'white')
      .onClick(() => {
        if (this.isShow) {
          animateTo({
            duration: 1000,
            tempo: 2,
            curve: Curve.Friction,
            delay: 0,
            onFinish: () => {
              this.isShow = false
            }
          }, () => {
            this.isShow = !this.isShow
            this.opcity = 0
          })
        }
      })
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

@Component
struct ShowDialog {
  @Link isShow: boolean
  @Link scale: {
    x: number,
    y: number
  }
  @Link opcity: number

  private eixtAnimateTo() {
    animateTo({
      duration: 1000,
      tempo: 2,
      curve: Curve.Friction,
      delay: 0,
      onFinish: () => {
        this.isShow = false
      }
    }, () => {
      this.isShow = !this.isShow
      this.opcity = 0
    })
  }

  build() {
    if (this.isShow) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text('Software uninstall').width('70%').fontSize(20).margin({ top: 10, bottom: 10, left: 20 })
        Image($r('app.media.icon')).width(80).height(80)
        Text('Whether to uninstall a software?').fontSize(16).margin({ bottom: 10 })
        Flex({ justifyContent: FlexAlign.SpaceAround }) {
          Button('cancel')
            .onClick(() => {
              this.eixtAnimateTo()
            }).backgroundColor(0xffffff).fontColor(Color.Black)
          Button('confirm')
            .onClick(() => {
              this.eixtAnimateTo()
            }).backgroundColor(0xffffff).fontColor(Color.Red)
        }.margin({ bottom: 10 })
      }
      .width(300)
      .height(200)
      .backgroundColor(0xc1cbac)
      .scale(this.scale)
      .opacity(this.opcity)
      .borderRadius(40)
      .transition({
        type: TransitionType.Delete,
        scale: { x: 1.25, y: 1.25, centerX: '0%', centerY: '50%' },
        //        translate: {x: 100, y: 100, z: 30 }
      })
      .transition({ type: TransitionType.Insert, scale: { x: 0, y: 0, centerX: '50%', centerY: '50%' },
        rotate: {
          x: 1,
          y: 1,
          z: 1,
          centerX: '50%',
          centerY: '50%',
          angle: 300
        },
      })
    }
  }
}
