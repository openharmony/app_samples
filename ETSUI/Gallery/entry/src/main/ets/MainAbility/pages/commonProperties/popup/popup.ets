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
struct PopupSample {
  @State textMessage: string = 'I am the content'
  @State showPopup: boolean = false
  @State placementOnTop: boolean = false
  @State customPopup: boolean = false
  @State customList: object[] = [{ image: $r('app.media.favor'), desc: '选项一' }, {
    image: $r('app.media.good'),
    desc: '选项二'
  }, { image: $r('app.media.love'), desc: '选项三' }]
  @State placement: string = 'Bottom'
  @State maskColor: string = 'rgba(51,0,0,0)'
  @State popupColor: string = 'rgba(255,255,255,1)'
  @State enableArrow: boolean = false
  @State autoCancel: boolean = false

  @Builder popupBuilder() {
    Column() {
      ForEach(this.customList, (item) => {
        Row() {
          Column() {
            Image(item.image).width(20).height(20)
          }.width(40)

          Text(item.desc).fontSize(20)
        }.onClick(() => {
          AlertDialog.show({ message: item.desc })
          this.customPopup = false
        })
      })
    }.width(100).backgroundColor(Color.White)
  }

  build() {
    Column() {
      NavigationBar({ title: 'Popup控制' })
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text('Clike Me')
          .width('20%')
          .height('20%')
          .backgroundColor('#B0E0E6')
          .textAlign(TextAlign.Center)
          .fontSize('18fp')
          .margin({ right: '10%' })
          .onClick(() => {
            this.showPopup = true
          })
          .bindPopup(this.showPopup, {
            message: this.textMessage,
            placementOnTop: this.placementOnTop,
            primaryButton: {
              value: 'cancle',
              action: () => {
                this.showPopup = false
                AlertDialog.show({ message: 'you have pressed the cancle button' })
              }
            },
            secondaryButton: {
              value: 'confirm',
              action: () => {
                this.showPopup = false
                AlertDialog.show({ message: 'you have pressed the confirm button' })
              }
            },
            onStateChange: (e) => {
              if (!e.isVisible) {
                this.showPopup = false
              }
            }
          })
        Text('Custom Content')
          .width('20%')
          .height('20%')
          .backgroundColor('#B0E0E6')
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .onClick(() => {
            this.customPopup = true
          })
          .bindPopup(this.customPopup, {
            builder: this.popupBuilder,
            placement: Placement[this.placement],
            maskColor: this.maskColor,
            popupColor: this.popupColor,
            enableArrow: this.enableArrow,
            autoCancel: this.autoCancel,
            onStateChange: (e) => {
              if (!e.isVisible) {
                this.customPopup = false
              }
            }
          })
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .backgroundColor('#FFB6C1')
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Text('message')
              .fontSize(18)
            TextInput({ placeholder: this.textMessage })
              .width('30%')
              .onChange((value: string) => {
                this.textMessage = value
              })
              .flexGrow(1)
              .onSubmit((enterKey) => {
                this.showPopup = true
              })
              .margin({ left: 10 })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('placementOnTop')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Toggle({ type: ToggleType.Switch, isOn: this.placementOnTop })
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.placementOnTop = !this.placementOnTop
                this.showPopup = true
                console.log(this.placementOnTop.toString())
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('placement')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)

            Text(`${this.placement}`)
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
              .bindMenu([
                {
                  value: 'Left',
                  action: () => {
                    this.placement = "Left"
                    this.customPopup = true
                  }
                },
                {
                  value: 'Right',
                  action: () => {
                    this.placement = 'Right'
                    this.customPopup = true
                  }
                },
                {
                  value: 'Top',
                  action: () => {
                    this.placement = 'Top'
                    this.customPopup = true
                  }
                },
                {
                  value: 'Bottom',
                  action: () => {
                    this.placement = 'Bottom'
                    this.customPopup = true
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
            Text('maskColor')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Column() {
              GetColor({ colorVal: $maskColor })
            }.width(48)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('popupColor')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Column() {
              GetColor({ colorVal: $popupColor })
            }.width(48)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('enableArrow')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Toggle({ type: ToggleType.Switch, isOn: this.enableArrow })
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.enableArrow = !this.enableArrow
                this.customPopup = true
              }).width(48)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('autoCancel')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Toggle({ type: ToggleType.Switch, isOn: this.autoCancel })
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.autoCancel = !this.autoCancel
                this.customPopup = true
              }).width(48)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8, bottom: 8 })
        }
      }
      .margin({ top: 24 })
      .height('56%')
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 15 })
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
