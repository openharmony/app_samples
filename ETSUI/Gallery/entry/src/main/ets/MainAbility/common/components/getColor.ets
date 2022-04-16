// @ts-nocheck
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
/*
 *调用该组件时，需要在当前页面声明颜色变量，用于接收组件传过来的值
 示例代码如下：getColorVal为当前页面的颜色变量，colorVal是颜色选择组件传过来的值
 import {GetColor} from "../../common/components/getColor"
 @State getColorVal: string = 'rgba(0,0,0,1)'
  build() {
    Column() {
      Text('获取颜色')
      GetColor({colorVal: $getColorVal})
    }
  }
 */

import display from '@ohos.display'

@Component
export struct GetColor {
  @Link colorVal: string
  @State cirPositionX: number = 0
  @State cirPositionY: number = 0
  @State colorBar: number = 0
  @State curColor: string = 'rgba(255,0,0,1)'
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      confirm: this.onAccept.bind(this),
      myColor: this.colorVal,
      cirX: this.cirPositionX,
      cirY: this.cirPositionY,
      colorBar: this.colorBar,
      curColor: this.curColor
    }),
    autoCancel: true,
    gridCount: 12
  })

  onAccept(val: string, x: number, y: number, colorBar: number, curColor: string) {
    this.colorVal = val
    this.cirPositionX = x
    this.cirPositionY = y
    this.colorBar = colorBar
    this.curColor = curColor
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
        Row().width('100%').height('100%').backgroundColor(this.colorVal)
          .borderRadius(24)
      }
      .backgroundColor('rgb(229,229,229)')
      .borderWidth(1)
      .borderRadius(24)
      .borderColor(this.colorVal)
      .width(48)
      .height(24)
      .padding(2)
    }.width('100%').onClick(() => {
      this.dialogController.open()
    })
  }
}

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController
  confirm: (val: string, x: number, y: number, colorBar: number, curColor: string) => void
  @Prop myColor: string
  @Prop cirX: number
  @Prop cirY: number
  @Prop colorBar: number
  @Prop curColor: string

  build() {
    Column() {
      SetColor({
        myColor: $myColor,
        onConfirm: this.confirm,
        cirX: $cirX,
        cirY: $cirY,
        outSetValue: $colorBar,
        curColor: $curColor
      })
      Button('CONFIRM').onClick(() => {
        this.controller.close()
        this.confirm(this.myColor, this.cirX, this.cirY, this.colorBar, this.curColor)
      }).margin({ bottom: 20 })
    }
  }
}

@Component
struct SetColor {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private gra: CanvasGradient = new CanvasGradient()
  //p40:170  rk:400 wgr: 844
  @State size: {
    width: number,
    height: number
  } = { width: 844 * 2, height: 500 }
  @State colorVal: string = 'rgb(0,0,0)'
  @Link curColor: string
  @Link outSetValue: number
  @Link cirX: number
  @Link cirY: number
  @Link myColor: string
  private hexColor: string = '#fff'
  onConfirm: (val: string, x: number, y: number, colorBar: number, curColor: string) => void

  aboutToAppear() {
    display.getDefaultDisplay((err, data) => {
      this.comfortStyle(data.width)
    })
  }

  //多端适配
  comfortStyle(width: number) {
    if (width == 360) {
      this.size.width = 170*2
      this.size.height = 170
    } else if (width == 720) {
      this.size.width = 400*2
      this.size.height = 400
    } else if (width = 2560) {
      this.size.width = 844*2
      this.size.height = 300
    }
  }
  //绘制canvas
  colorPannel(curColor) {
    //第一次填充
    var grad = this.context.createLinearGradient(0, 0, this.size.width, 0)
    grad.addColorStop(0, 'white')
    grad.addColorStop(1, curColor)
    this.context.fillStyle = grad
    this.context.fillRect(0, 0, this.size.width, this.size.height)
    //第二次填充
    var myGrad = this.context.createLinearGradient(0, 0, 0, this.size.height)
    myGrad.addColorStop(0, 'rgba(0,0,0,0)')
    myGrad.addColorStop(1, 'rgba(0,0,0,1)')
    this.context.fillStyle = myGrad
    this.context.fillRect(0, 0, this.size.width, this.size.height)
  }

  //点击获取颜色
  getColor(event) {
    let data = this.context.getImageData(Math.round(event.x), Math.round(event.y), 2, 2)
    return `rgb(${data.data[0]},${data.data[1]},${data.data[2]})`
  }

  //色相颜色
  colorBar(getPosition) {
    let colorWidth = 1 / 6
    if (getPosition < 1 / 6) {
      return `rgba(255,${Number((255 * getPosition / colorWidth).toFixed(0))},0,1)` //红 - 黄
    } else if (getPosition < 2 / 6) {
      return `rgba(${255 - Number((255 * (getPosition - colorWidth) / colorWidth).toFixed(0))},255,0,1)` //黄 - 绿
    } else if (getPosition < 3 / 6) {
      return `rgba(0,255,${Number((255 * (getPosition - colorWidth * 2) / colorWidth).toFixed(0))},1)` //绿 -青
    } else if (getPosition < 4 / 6) {
      return `rgba(0,${255 - Number((255 * (getPosition - colorWidth * 3) / colorWidth).toFixed(0))},255,1)` //青 - 蓝
    } else if (getPosition < 5 / 6) {
      return `rgba(${Number((255 * (getPosition - colorWidth * 4) / colorWidth).toFixed(0))},0,255,1)` //蓝 - 紫
    } else {
      return `rgba(255,0,${255 - Number((255 * (getPosition - colorWidth * 5) / colorWidth).toFixed(0))},1)` //紫 - 红
    }
  }

  //rgb2hex
  rgbToHex(rgb) {
    let arr = rgb.split(/\D+/);
    let r = arr[1]
    let g = arr[2]
    let b = arr[3]
    return '#' + ((r << 16) | (g << 8) | b).toString(16)
  }

  build() {
    Column() {
      Canvas(this.context)
        .width('100%')
        .height(this.size.height)
        .onReady(() => {
          this.colorPannel(this.curColor)
          this.context.stroke();
        })
        .onClick((event: ClickEvent) => {
          this.colorVal = this.getColor(event)
          this.hexColor = this.rgbToHex(this.colorVal)
          this.myColor = this.colorVal
          this.cirX = event.x - 10
          this.cirY = event.y - 10
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Move) {
            this.colorVal = this.getColor(event.touches[0])
            this.hexColor = this.rgbToHex(this.colorVal)
            this.myColor = this.colorVal
            this.cirX = event.touches[0].x - 10
            this.cirY = event.touches[0].y - 10
          }
        })
      //ColorBlock
      Row()
        .width(20)
        .height(20)
        .borderRadius(20)
        .borderColor('#000')
        .backgroundColor('#fff')
        .borderWidth(3)
        .position({ x: this.cirX, y: this.cirY })
      //colorBar
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        Row()
          .width(50)
          .height(50)
          .borderColor('#000')
          .borderWidth(2)
          .borderRadius(50)
          .backgroundColor(this.myColor)
        Slider({
          value: this.outSetValue,
          min: 0,
          max: 100,
          step: 1,
          style: SliderStyle.OutSet,
        })
          .width('100%')
          .trackColor('#182431')
          .selectedColor('#007DFF')
          .showSteps(true)
          .showTips(true)
          .linearGradient({
            angle: 90,
            direction: GradientDirection.Left,
            colors: [[0xff0000, 0.0], [0xffff00, 1 / 6], [0x00ff00, 2 / 6], [0x00ffff, 0.5], [0x0000ff, 4 / 6], [0xff00ff, 5 / 6], [0xff0000, 1.0]]
          })
          .selectedColor('rgba(0,0,0,0)')
          .onChange((value: number, mode: SliderChangeMode) => {
            this.outSetValue = value
            let getPosition = this.outSetValue / 100
            this.curColor = this.colorBar(getPosition)
            this.colorPannel(this.curColor)
            this.myColor = this.getColor({ x: this.cirX, y: this.cirY })
            this.hexColor = this.rgbToHex(this.myColor)
          })
          .width('80%')
          .height(50)
      }.width('100%').height(50).margin({ top: 20, bottom: 20 })
      //colorVal
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        Text(`RGB:  ${this.myColor}`).fontSize('16fp')
        Text(`十六进制:  ${this.hexColor}`).fontSize('16fp')
      }.width('100%').margin({ bottom: 20 })
    }.width('100%')
  }
}