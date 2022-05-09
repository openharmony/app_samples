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
import prompt from '@ohos.prompt';

@Entry
@Component
struct DialogSample {
  @State buttonDesc: string = 'one button'
  @State paramObject: any = {
    title: 'title',
    message: 'text content',
    confirm: { value: 'confirm', action: () => {
      AlertDialog.show({ message: 'presseing confirm' })
    } },
    cancel: () => {
      AlertDialog.show({ message: 'close dialog' })
    },
    gridCount: 5,
    alignment: 3
  }
  @State DialogAlignment: string[] = ['Top', 'Center', 'Bottom', 'Default']
  @State AlignmentIndex: number = 3
  @State colorVal: string = 'rgba(0,0,0,1)'
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({ cancel: this.onCancel.bind(this), confirm: this.onAccept.bind(this) }),
    cancel: this.existApp,
    autoCancel: true,
    gridCount: 12
  })

  onCancel() {
    AlertDialog.show({ message: 'pressing cancel' })
  }

  onAccept(colorVal) {
    this.colorVal = colorVal;
    AlertDialog.show({ message: `the colorVal is ${colorVal}` })
  }

  existApp() {
    AlertDialog.show({ message: 'close dialog' })
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      NavigationBar({ title: '弹窗' })

      Column() {
        Column() {
          Text('警告弹窗').fontSize(20)
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('AlertDialog')
              .fontSize(18)
            Column() {
              Text('>')
                .fontSize(18).fontColor('#969799')
            }
          }
          .width('100%')
          .height(35)
          .padding({ left: '3%', right: '3%' })
          .borderRadius(10)
          .backgroundColor('#007DFF')
          .margin({ top: 8, bottom: 8 })
          .onClick(() => {
            AlertDialog.show(
              this.paramObject
            )
          })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .constraintSize({ minHeight: 218, maxHeight: 402 })
        .padding({ left: 12, right: 12, top: 22, bottom: 22 })

        Scroll() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('options')
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .opacity(0.5)

              Text(this.buttonDesc)
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
                .bindMenu([
                  {
                    value: 'one button',
                    action: () => {
                      this.buttonDesc = 'one button'
                      this.paramObject = {
                        title: 'title',
                        message: 'text content',
                        confirm: { value: 'confirm', action: () => {
                          AlertDialog.show({ message: 'pressing confirm' })
                        } },
                        cancel: () => {
                          AlertDialog.show({ message: 'close dialog' })
                        },
                        gridCount: 5,
                        alignment: 3
                      }
                    }
                  },
                  {
                    value: 'two button',
                    action: () => {
                      this.buttonDesc = 'two button'
                      this.paramObject = {
                        title: 'title',
                        message: 'text content',
                        primaryButton: {
                          value: 'cancel',
                          action: () => {
                            AlertDialog.show({ message: 'close dialog' })
                          }
                        },
                        secondaryButton: {
                          value: 'ok',
                          action: () => {
                            AlertDialog.show({ message: ' pressing ok' })
                          }
                        },
                        cancel: () => {
                          AlertDialog.show({ message: 'close dialog' })
                        },
                        gridCount: 5
                      ,
                        alignment: 3
                      }
                    }
                  }
                ])
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('alignment')
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .opacity(0.5)

              Text(this.DialogAlignment[this.paramObject.alignment])
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
                .bindMenu([
                  {
                    value: 'Top',
                    action: () => {
                      this.paramObject.alignment = 0
                    }
                  },
                  {
                    value: 'Center',
                    action: () => {
                      this.paramObject.alignment = 1
                    }
                  },
                  {
                    value: 'Bottom',
                    action: () => {
                      this.paramObject.alignment = 2
                    }
                  },
                  {
                    value: 'Default',
                    action: () => {
                      this.paramObject.alignment = 3
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
              Text('gridCount')
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .opacity(0.5)
              Column() {
                Counter() {
                  Text(this.paramObject.gridCount.toString())
                    .fontSize('10fp')
                    .fontColor('#000000')
                    .fontWeight(FontWeight.Regular)
                }
                .onInc(() => {
                  this.paramObject.gridCount < 12 && this.paramObject.gridCount++
                })
                .onDec(() => {
                  this.paramObject.gridCount > 1 && this.paramObject.gridCount--
                })
              }.width(72).height(24)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })

            Text('列表选择弹窗:').width('100%').fontSize('16fp').margin({ top: 8 })
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('actionSheet')
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .opacity(0.5)

              Text('>')
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
            .onClick(() => {
              ActionSheet.show({
                title: 'ActionSheet title',
                message: 'message',
                alignment: this.AlignmentIndex,
                confirm: {
                  value: 'Confirm button',
                  action: () => {
                    AlertDialog.show({ message: 'pressing Confirm' })
                  }
                },
                cancel: () => {
                  AlertDialog.show({ message: 'close Dialog' })
                },
                sheets: [
                  {
                    title: 'like',
                    icon: '/common/good.png',
                    action: () => {
                      AlertDialog.show({ message: 'like' })
                    }
                  },
                  {
                    title: 'follow',
                    icon: '/common/favor.png',
                    action: () => {
                      AlertDialog.show({ message: 'follow' })
                    }
                  },
                  {
                    title: 'attention',
                    icon: '/common/love.png',
                    action: () => {
                      AlertDialog.show({ message: 'attention' })
                    }
                  }
                ]
              })
            })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('alignment')
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .opacity(0.5)

              Text(this.DialogAlignment[this.AlignmentIndex])
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
                .bindMenu([
                  {
                    value: 'Top',
                    action: () => {
                      this.AlignmentIndex = 0
                    }
                  },
                  {
                    value: 'Center',
                    action: () => {
                      this.AlignmentIndex = 1
                    }
                  },
                  {
                    value: 'Bottom',
                    action: () => {
                      this.AlignmentIndex = 2
                    }
                  },
                  {
                    value: 'Default',
                    action: () => {
                      this.AlignmentIndex = 3
                    }
                  },
                ])
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })

            Text('自定义弹窗:').width('100%').fontSize('16fp').margin({ top: 8 })
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('CustomDialog')
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .opacity(0.5)
              Column() {
                Text('>')
                  .fontColor('#182431')
                  .fontSize('16fp')
                  .fontWeight(FontWeight.Medium)
              }
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
            .onClick(() => {
              this.dialogController.open()
            })
          }
        }
        .height('55%')
        .margin({ top: 12 })
      }
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

@CustomDialog
struct CustomDialogExample {
  @State colorVal: string = 'rgba(255,255,255,1)'
  @State circlePosition: {
    x: number,
    y: number,
    width: number,
    height: number
  } = { x: 0, y: 0, width: px2vp(lpx2px(720)), height: 200 }
  @State opacityVal: number = 100
  @State colorR: string = '255'
  @State colorG: string = '255'
  @State colorB: string = '255'
  @State arrColor: string[] = ['255', '255', '255']
  /* 获取颜色值
   *@params event{object} 点击元素的事件对象
   *        opacityVal{Number} 透明度
  */
  private getColor(event, opacityVal) {

    let getPosition = event.x / event.target.area.width //点击位置占被点击元素的百分比
    let colorWidth = 1 / 6 //每个色阶占比
    let opacityColor = opacityVal / 100 //透明度
    if (getPosition < 1 / 6) {
      return `rgba(255,${Number((255 * getPosition / colorWidth).toFixed(0))},0,${opacityColor})` //红 - 黄
    } else if (getPosition < 2 / 6) {
      return `rgba(${255 - Number((255 * (getPosition - colorWidth) / colorWidth).toFixed(0))},255,0,${opacityColor})` //黄 - 绿
    } else if (getPosition < 3 / 6) {
      return `rgba(0,255,${Number((255 * (getPosition - colorWidth * 2) / colorWidth).toFixed(0))},${opacityColor})` //绿 -青
    } else if (getPosition < 4 / 6) {
      return `rgba(0,${255 - Number((255 * (getPosition - colorWidth * 3) / colorWidth).toFixed(0))},255,${opacityColor})` //青 - 蓝
    } else if (getPosition < 5 / 6) {
      return `rgba(${Number((255 * (getPosition - colorWidth * 4) / colorWidth).toFixed(0))},0,255,${opacityColor})` //蓝 - 紫
    } else {
      return `rgba(255,0,${255 - Number((255 * (getPosition - colorWidth * 5) / colorWidth).toFixed(0))},${opacityColor})` //紫 - 红
    }
  }

  controller: CustomDialogController
  cancel: () => void
  confirm: (colorVal) => void

  build() {
    Column() {
      //色板
      Shape() {
        Circle()
          .width(10)
          .height(10)
          .borderWidth(5)
          .borderColor(0x000000)
          .borderRadius(10)
      }
      .viewPort(this.circlePosition)
      .fill('rgba(0,0,0,0)')
      .stroke(0xffffff)
      .strokeWidth(3)
      .strokeLineJoin(LineJoinStyle.Round)
      .width('720lpx')
      .height(200)
      .linearGradient({
        angle: 90,
        direction: GradientDirection.Left,
        colors: [[0xff0000, 0.0], [0xffff00, 1 / 6], [0x00ff00, 2 / 6], [0x00ffff, 0.5], [0x0000ff, 4 / 6], [0xff00ff, 5 / 6], [0xff0000, 1.0]]
      })
      .borderRadius(25)
      .onClick((event: ClickEvent) => {
        this.colorVal = this.getColor(event, this.opacityVal)
        //颜色数组
        this.arrColor = this.colorVal.substr(5, this.colorVal.length - 6).split(',')
        this.colorR = this.arrColor[0]
        this.colorG = this.arrColor[1]
        this.colorB = this.arrColor[2]

        this.circlePosition.x = -event.x + 10
        this.circlePosition.y = -event.y + 10 + 510
      })

      //透明度 色值
      Column() {
        Column() {
          Text(`Opacity:${(this.opacityVal / 100).toFixed(2)}`).fontSize(30)
          Slider({
            value: this.opacityVal,
            min: 0,
            max: 100,
            step: 1,
            style: SliderStyle.OutSet
          })
            .blockColor(Color.Blue)
            .trackColor(Color.Gray)
            .selectedColor(Color.Blue)
            .showSteps(true)
            .showTips(true)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.opacityVal = value
              this.colorVal = `${this.colorVal.substr(0, this.colorVal.lastIndexOf(','))},${this.opacityVal / 100})`
            })
        }.alignItems(HorizontalAlign.Start).padding(5)

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
          Row() {
            Text('R:').fontSize(30)
            Text(this.colorR)
              .fontSize(30).margin({ left: 5 })
          }

          Divider().vertical(true).color('#bbb').height('80%')
          Row() {
            Text('G:').fontSize(30)
            Text(this.colorG)
              .fontSize(30).margin({ left: 5 })
          }

          Divider().vertical(true).color('#bbb').height('80%')
          Row() {
            Text('B:').fontSize(30)
            Text(this.colorB)
              .fontSize(30).margin({ left: 5 })
          }
        }.height(80).padding({ top: 10, bottom: 10 })
      }

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            this.controller.close()
            this.confirm(this.colorVal)
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }.backgroundColor(this.colorVal).borderRadius(20).width('100%').height(420)
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