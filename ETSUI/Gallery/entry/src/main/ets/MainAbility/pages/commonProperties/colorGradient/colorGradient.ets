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

enum GradientType {
  LineGradient,
  SweepGradient,
  RadialGradient
}

enum MethodType {
  Angele,
  Direction
}

@Observed
class GradientAttributes {
  public isRepeating: boolean = false
  public angle: number = 0
  public showDirection: GradientDirection= GradientDirection.Left
  public direction: string= 'Left'
  public sweepStart: number = 0
  public sweepEnd: number = 359
  public radius: number = 100
}

@Entry
@Component
struct ColorGradientSample {
  @State Attributes: GradientAttributes = new GradientAttributes()
  @State typeGradient: GradientType = GradientType.LineGradient
  @State getColorVal: string = 'rgba(0,0,0,1)'
  @State gradientMethod: MethodType = MethodType.Angele
  @State sweepCenter: number[] = [100, 100]
  @State center: {
    x: number,
    y: number
  } = { x: 0, y: 0 }
  @State radialRadius: number = 125
  @State showColorList: [string, number][] = [['red', 0], ['#FFB6C1', 0.3], ['black', 0.8]]
  @State offset: {
    x: number,
    y: number
  } = { x: 0, y: 0 }
  @State scale: number = 1
  @State startAngle: number = 0
  @State dValue: number = 359
  @State radialCenter: number[] = [100, 100]

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: '颜色渐变' })
      Scroll() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          if (this.typeGradient == GradientType.LineGradient) {
            ShowLinear({
              startAngle: $startAngle,
              gradientMethod: $gradientMethod,
              linear: this.Attributes,
              showColorList: $showColorList
            })
          } else if (this.typeGradient == GradientType.SweepGradient) {
            ShowSweep({
              sweepCenter: $sweepCenter,
              offset: $offset,
              center: $center,
              dValue: $dValue,
              sweep: this.Attributes,
              showColorList: $showColorList
            })
          } else if (this.typeGradient = GradientType.RadialGradient) {
            ShowRadial({
              radial: this.Attributes,
              radialCenter: $radialCenter,
              scale: $scale,
              offset: $offset,
              radialRadius: $radialRadius,
              center: $center,
              showColorList: $showColorList
            })
          }
        }.width('100%')
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Scroll() {
        Column() {
          TypeShow({ typeGradient: $typeGradient })
          if (this.typeGradient == GradientType.LineGradient) {
            ControlLinear({ gradientMethod: $gradientMethod, linear: this.Attributes })
          } else if (this.typeGradient == GradientType.SweepGradient) {
            ControlSweep({ sweep: this.Attributes })
          } else if (this.typeGradient = GradientType.RadialGradient) {
            ControlRadial({ radial: this.Attributes })
          }
          CommonProperties({
            common: this.Attributes,
            getColorVal: $getColorVal,
            sweepCenter: $sweepCenter,
            radialCenter: $radialCenter,
            typeGradient: $typeGradient,
            showColorList: $showColorList
          })
        }.width('100%')
      }.width('100%').height('55%')
    }
    .width('100%')
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
struct TypeShow {
  @Link typeGradient: GradientType

  build() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
      Badge({
        value: '',
        position: 1,
        style: { badgeSize: this.typeGradient == GradientType.LineGradient ? 8 : 0, badgeColor: Color.Red }
      }) {
        Button('linear   Gradient')
          .onClick(() => {
            this.typeGradient = GradientType.LineGradient
          })
          .fontSize('12fp')
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor('#007DFF')
          .borderRadius(14)
      }.padding(8)

      Badge({
        value: '',
        position: 1,
        style: { badgeSize: this.typeGradient == GradientType.SweepGradient ? 8 : 0, badgeColor: Color.Red }
      }) {
        Button('sweep   Gradient')
          .onClick(() => {
            this.typeGradient = GradientType.SweepGradient
          })
          .fontSize('12fp')
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor('#007DFF')
          .borderRadius(14)
      }.padding(8)

      Badge({
        value: '',
        position: 1,
        style: { badgeSize: this.typeGradient == GradientType.RadialGradient ? 8 : 0, badgeColor: Color.Red }
      }) {
        Button('radial   Gradient')
          .onClick(() => {
            this.typeGradient = GradientType.RadialGradient
            console.log(`${this.typeGradient}`);
          })
          .fontSize('12fp')
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor('#007DFF')
          .borderRadius(14)
      }.padding(8)
    }
  }
}

@Component
struct ShowLinear {
  @Link startAngle: number
  @Link showColorList: [string, number]
  @Link gradientMethod: MethodType
  @ObjectLink linear: GradientAttributes

  build() {
    if (this.gradientMethod == MethodType.Angele) {
      Row()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: this.linear.angle,
          repeating: this.linear.isRepeating,
          colors: this.showColorList
        })
        .gesture(
        GestureGroup(GestureMode.Parallel,
        RotationGesture({ fingers: 2, angle: 1.0 })
          .onActionStart(() => {
            this.startAngle = this.linear.angle
          })
          .onActionUpdate((event: GestureEvent) => {
            this.linear.angle = (this.startAngle + event.angle) % 360
          })
        ))
    } else if (this.gradientMethod == MethodType.Direction) {
      Row()
        .width('100%')
        .height('100%')
        .linearGradient({
          repeating: this.linear.isRepeating,
          direction: this.linear.showDirection,
          colors: this.showColorList
        })
    }
  }
}

@Component
struct ControlLinear {
  @Link gradientMethod: MethodType
  @ObjectLink linear: GradientAttributes

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('angle/direction')
          .fontSize('16fp')
          .opacity(0.5)
          .fontColor('#182431')
          .fontWeight(FontWeight.Medium)
        Column() {
          Text(this.gradientMethod == MethodType.Angele ? 'angle' : 'direction')
            .fontSize('16fp')
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
            .width('50%')
            .textAlign(TextAlign.End)
        }
        .bindMenu([
          {
            value: 'angle',
            action: () => {
              this.gradientMethod = MethodType.Angele
            }
          },
          {
            value: 'direction',
            action: () => {
              this.gradientMethod = MethodType.Direction
            }
          },
        ])
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })

      if (this.gradientMethod == MethodType.Angele) {
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('angle').fontSize('20')
          Row() {
            Text(this.linear.angle.toFixed(0)).fontSize(16)
          }
        }.margin({ top: 10 })
      } else if (this.gradientMethod == MethodType.Direction) {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text('direction ')
            .fontSize('16fp')
            .opacity(0.5)
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
          Column() {
            Text(`${this.linear.direction}`)
              .fontSize('16fp')
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
          }
          .bindMenu([
            {
              value: 'Left',
              action: () => {
                this.linear.showDirection = GradientDirection.Left, this.linear.direction = 'Left'
              }
            },
            {
              value: 'Top',
              action: () => {
                this.linear.showDirection = GradientDirection.Top, this.linear.direction = 'Top'
              }
            },
            {
              value: 'Right',
              action: () => {
                this.linear.showDirection = GradientDirection.Right, this.linear.direction = 'Right'
              }
            },
            {
              value: 'Bottom',
              action: () => {
                this.linear.showDirection = GradientDirection.Bottom, this.linear.direction = 'Bottom'
              }
            },
            {
              value: 'LeftTop',
              action: () => {
                this.linear.showDirection = GradientDirection.LeftTop, this.linear.direction = 'LeftTop'
              }
            },
            {
              value: 'LeftBottom',
              action: () => {
                this.linear.showDirection = GradientDirection.LeftBottom, this.linear.direction = 'LeftTop'
              }
            },
            {
              value: 'RightTop',
              action: () => {
                this.linear.showDirection = GradientDirection.RightTop, this.linear.direction = 'RightTop'
              }
            },
            {
              value: 'RightBottom',
              action: () => {
                this.linear.showDirection = GradientDirection.RightBottom, this.linear.direction = 'RightBottom'
              }
            },
          ])
        }
        .width('100%')
        .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
        .borderRadius(24)
        .backgroundColor('#FFFFFF')
        .margin({ top: 8 })
      }
    }
  }
}

@Component
struct ShowSweep {
  @Link sweepCenter: number[]
  @Link showColorList: [string, number]
  @ObjectLink sweep: GradientAttributes
  @Link offset: {
    x: number,
    y: number
  }
  @Link center: {
    x: number,
    y: number
  }
  @Link dValue: number

  build() {
    Row()
      .width('100%')
      .height('100%')
      .sweepGradient({
        repeating: this.sweep.isRepeating,
        center: this.sweepCenter,
        start: this.sweep.sweepStart,
        end: this.sweep.sweepEnd,
        colors: this.showColorList
      })
      .gesture(
      GestureGroup(GestureMode.Parallel,
      PanGesture({ fingers: 1, direction: PanDirection.All, distance: 5.0 })
        .onActionUpdate((event: GestureEvent) => {
          this.offset.y = event.offsetY
          this.offset.x = event.offsetX
          this.sweepCenter[0] = this.center.x + vp2px(event.offsetX)
          this.sweepCenter[1] = this.center.y + vp2px(event.offsetY)
        }),
      PinchGesture({ fingers: 2, distance: 3.0 })
        .onActionStart(() => {
          if (this.sweep.sweepStart < this.sweep.sweepEnd) {
            this.dValue = this.sweep.sweepEnd - this.sweep.sweepStart
          } else {
            this.dValue = this.sweep.sweepStart - this.sweep.sweepEnd
          }
        })
        .onActionUpdate((event: GestureEvent) => {
          this.sweep.sweepEnd = (this.sweep.sweepStart + this.dValue * event.scale) % 360
        }),
      RotationGesture()
        .onActionUpdate((event: GestureEvent) => {
          this.sweep.sweepStart = this.sweep.sweepStart + event.angle
          if (this.sweep.sweepStart > 360) {
            this.sweep.sweepStart = this.sweep.sweepStart % 360
          } else if (this.sweep.sweepStart < -360) {
            this.sweep.sweepStart = this.sweep.sweepStart % 360
          }
          this.sweep.sweepEnd = this.sweep.sweepEnd + event.angle
        })
      )
      )
  }
}

@Component
struct ControlSweep {
  @ObjectLink sweep: GradientAttributes

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('start')
          .fontSize('16fp')
          .opacity(0.5)
          .fontColor('#182431')
          .fontWeight(FontWeight.Medium)
        Column() {
          Text(this.sweep.sweepStart.toFixed(0))
            .fontSize('16fp')
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
            .width('50%')
            .textAlign(TextAlign.End)
        }
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('end')
          .fontSize('16fp')
          .opacity(0.5)
          .fontColor('#182431')
          .fontWeight(FontWeight.Medium)
        Column() {
          Text(this.sweep.sweepEnd.toFixed(0))
            .fontSize('16fp')
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
            .width('50%')
            .textAlign(TextAlign.End)
        }
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })
    }
  }
}

@Component
struct ShowRadial {
  @ObjectLink radial: GradientAttributes
  @Link showColorList: [string, number]
  @Link radialCenter: number[]
  @Link scale: number
  @Link offset: {
    x: number,
    y: number
  }
  @Link radialRadius: number
  @Link center: {
    x: number,
    y: number
  }

  build() {
    Row()
      .width('100%')
      .height('100%')
      .radialGradient({
        repeating: this.radial.isRepeating,
        center: this.radialCenter,
        radius: this.radial.radius,
        colors: this.showColorList
      })
      .scale({ x: this.scale, y: this.scale, z: this.scale })
      .gesture(
      GestureGroup(GestureMode.Parallel,
      PinchGesture({ fingers: 2, distance: 3.0 })
        .onActionUpdate((event: GestureEvent) => {
          this.radial.radius = this.radialRadius * event.scale
        }),
      PanGesture({ fingers: 1, direction: PanDirection.All, distance: 5.0 })
        .onActionUpdate((event: GestureEvent) => {
          this.offset.y = event.offsetY
          this.offset.x = event.offsetX
          this.radialCenter[0] = this.center.x + vp2px(event.offsetX)
          this.radialCenter[1] = this.center.y + vp2px(event.offsetY)
        })
      )
      )
  }
}

@Component
struct ControlRadial {
  @ObjectLink radial: GradientAttributes

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Text('radius')
        .fontSize('16fp')
        .opacity(0.5)
        .fontColor('#182431')
        .fontWeight(FontWeight.Medium)
      Column() {
        Text(this.radial.radius.toFixed(0))
          .fontSize('16fp')
          .fontColor('#182431')
          .fontWeight(FontWeight.Medium)
          .width('50%')
          .textAlign(TextAlign.End)
      }
    }
    .width('100%')
    .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
    .borderRadius(24)
    .backgroundColor('#FFFFFF')
    .margin({ top: 8 })
  }
}

@Component
struct CommonProperties {
  @ObjectLink common: GradientAttributes
  @Link getColorVal: string
  @Link sweepCenter: number[]
  @Link radialCenter: number[]
  @Link typeGradient: GradientType
  @Link showColorList: [string, number][]

  build() {
    Column() {
      if (this.typeGradient !== GradientType.LineGradient) {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text('center x')
            .fontSize('16fp')
            .opacity(0.5)
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
          Column() {
            if (this.typeGradient == GradientType.SweepGradient) {
              Text(this.sweepCenter[0].toFixed(0))
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            } else if (this.typeGradient == GradientType.RadialGradient) {
              Text(this.radialCenter[0].toFixed(0))
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
          }
        }
        .width('100%')
        .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
        .borderRadius(24)
        .backgroundColor('#FFFFFF')
        .margin({ top: 8 })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text('center y')
            .fontSize('16fp')
            .opacity(0.5)
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
          Column() {
            if (this.typeGradient == GradientType.SweepGradient) {
              Text(this.sweepCenter[1].toFixed(0))
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            } else if (this.typeGradient == GradientType.RadialGradient) {
              Text(this.radialCenter[1].toFixed(0))
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
          }
        }
        .width('100%')
        .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
        .borderRadius(24)
        .backgroundColor('#FFFFFF')
        .margin({ top: 8 })
      }
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('repeating')
          .fontSize('16fp')
          .opacity(0.5)
          .fontColor('#182431')
          .fontWeight(FontWeight.Medium)
        Toggle({ type: ToggleType.Switch, isOn: this.common.isRepeating })
          .size({ width: 35, height: 20 })
          .selectedColor(0x317aff)
          .switchPointColor(0xe5ffffff)
          .onChange((isOn: boolean) => {
            this.common.isRepeating = !this.common.isRepeating
            console.log(`${this.common.isRepeating}`)
          })
      }
      .width('100%')
      .padding({ left: '3%', right: '3%' })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('colorType').align(Alignment.Bottom).width('28%').fontSize(20).textAlign(TextAlign.Center)
        Text('colorStep').width('40%').fontSize(20).textAlign(TextAlign.Center).padding({ left: '20%' })
        Text('edit').width('35%').fontSize(20).textAlign(TextAlign.Center).padding({ left: '5%' })
      }.width('96%').margin({ top: 15 })

      Scroll() {
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
          Column() {
            Flex({
              direction: FlexDirection.Row,
              justifyContent: FlexAlign.SpaceBetween,
              alignItems: ItemAlign.Center
            }) {
              Text('Color')
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Text('+').fontColor('#ffffff').fontSize('16fp').fontWeight(FontWeight.Medium)
              }
              .width(22)
              .height(22)
              .backgroundColor('#000000')
              .onClick(() => {
                let randomR = Math.floor(Math.random() * 255)
                let randomG = Math.floor(Math.random() * 255)
                let randomB = Math.floor(Math.random() * 255)
                let rgb = `rgb(${randomR},${randomG},${randomB})`
                this.showColorList.push([rgb, 1])
              })
            }
            .width('100%')
            .height(24)

            Divider().color('#f2f2f2').margin({ top: 6, bottom: 6 })
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
              ForEach(this.showColorList, (item, index) => {
                Button() {
                  Row() {
                    Flex({ direction: FlexDirection.RowReverse, alignItems: ItemAlign.Center }) {
                      Text('X')
                        .fontSize('10fp')
                        .width(11)
                        .lineHeight(11)
                        .borderRadius(11)
                        .backgroundColor('rgba(0,0,0,0.2)')
                        .textAlign(TextAlign.Center)
                        .fontColor('#ffffff')
                        .onClick(() => {
                          if (this.showColorList.length != 1) {
                            this.showColorList.splice(index, 1)
                          } else {
                            AlertDialog.show({ message: 'at least one' })
                          }
                        })
                    }
                    .padding({ right: 2 })
                    .width('100%')
                    .height('100%')
                    .borderWidth(2)
                    .borderColor('#ffffff')
                    .borderRadius(24)
                  }
                  .width('100%')
                  .height('100%')
                  .borderWidth(2)
                  .borderColor(item[0])
                  .borderRadius(24)
                }
                .backgroundColor(item[0])
                .fontColor('#ffffff')
                .width(48)
                .height(24)
                .margin(2)
              })
            }
            .width('100%')
          }
          .width('100%')
          .padding(12)
          .borderRadius(24)
          .backgroundColor('#fff')
          .margin({ top: 8, bottom: 8 })

          ForEach(this.showColorList, (item, index) => {
            Row() {
              Row().align(Alignment.Start).backgroundColor(item[0]).width('30%').height(24)
              Row() {
                Column() {
                  Counter() {
                    Text(item[1].toString()).fontSize('18')
                  }.height(24).width(90)
                  .onInc(() => {
                    if (item[1] < 1) {
                      if (index + 1 < this.showColorList.length && this.showColorList[index+1][1] > item[1] || index + 1 == this.showColorList.length) {
                        item[1] = (item[1] * 10 + 1) / 10
                        this.showColorList.splice(index, 1, [item[0], item[1]])
                      }
                    }
                  })
                  .onDec(() => {
                    if (item[1] > 0) {
                      if (index == 0 || this.showColorList[index-1][1] < item[1]) {
                        item[1] = (item[1] * 10 - 1) / 10
                        this.showColorList.splice(index, 1, [item[0], item[1]])
                      }
                    }
                  })
                }.width('100%')
              }.align(Alignment.Start).width('50%').height(70)

              Column() {
                Button({ type: ButtonType.Circle, stateEffect: true }) {
                  Text('-').fontColor('#ffffff').fontSize('16fp').fontWeight(FontWeight.Medium)
                }
                .width(22)
                .height(22)
                .backgroundColor('#000000')
                .fontSize(35)
                .onClick((event: ClickEvent) => {
                  this.showColorList.splice(index, 1)
                })
              }.align(Alignment.End).width('20%').height(22)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 8, bottom: 8 })
            .margin({ bottom: 12 })

            Divider().color(0xCCCCCC).width('96%')
          })
        }.width('100%')
      }.width('100%')
    }
    .width('100%')
    .margin({ bottom: 16 })
  }
}