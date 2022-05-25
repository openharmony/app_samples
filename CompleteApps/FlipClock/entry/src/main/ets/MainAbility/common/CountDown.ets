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
import display from '@ohos.display'
import mediaquery from '@ohos.mediaquery'

let passSec : number = 0
let pickerH : number = 0
let pickerM : number = 0
let pickerS : number = 0
let countInSec : number = 0

@Component
export struct CountDown {
  @State width: number= 0
  @State timer: number= 0
  @State height: number= 0
  @State centerY: number= 0
  @State rotates: number= 0
  @State hoursTime: number= 0
  @State clockWidth: number= 0
  @State densityDPI: number= 0
  @State minuteTime: number= 0
  @State secondTime: number= 0
  @State clockHeight: number= 0
  @State progressVal: number= 0
  @State densityPixels: number= 0
  @State scaledDensity: number= 0
  @State clockDialWidth: number= 0
  @State clockDialHeight: number= 0
  @State pickerItemHeight: number= 60
  @State isRunning: boolean= false
  @State isPausing: boolean= false
  @State startImg: Resource= $r('app.media.start')
  @State resetImg: Resource= $r('app.media.resetccc')
  private settings: RenderingContextSettings= new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D= new CanvasRenderingContext2D(this.settings)
  @State lineLength: number= undefined
  @State pickerHeight: number= undefined
  @State pointerHeight: number= undefined
  scroller: Scroller= new Scroller()
  listener= mediaquery.matchMediaSync('(orientation:landscape)')

  onPortrait(mediaQueryResult) {
    if (mediaQueryResult.matches) {
      this.pointerHeight = 310
      this.lineLength = 345
      this.clockDialHeight = 212
      this.clockDialWidth = 212
      this.clockHeight = 188
      this.clockWidth = 188
      this.centerY = 99
    } else {
      this.clockDialHeight = 280
      this.clockDialWidth = 280
      this.clockHeight = 250
      this.clockWidth = 250
      this.pickerHeight = 128
      this.pointerHeight = 375
      this.lineLength = 410
      this.centerY = 125
    }
  }

  aboutToAppear() {
    let portraitFunc = this.onPortrait.bind(this)
    this.listener.on('change', portraitFunc)
    display.getDefaultDisplay().then((disp) => {
      this.width = disp.width
      this.height = disp.height
      this.densityDPI = undefined
      this.densityPixels = disp.densityPixels
      this.scaledDensity = disp.scaledDensity
    })
  }

  timerCountDown() {
    this.secondTime--
    if (this.secondTime < 0) {
      this.minuteTime--
      this.secondTime = 59
    }
    if (this.minuteTime < 0) {
      this.minuteTime = 59
      this.hoursTime--
    }
    if (this.hoursTime < 0) {
      this.Reset()
      return
    }
    passSec++
    this.progressVal = 100 - passSec * 100 / countInSec
    this.rotates = passSec * 360 / countInSec
  }

  Start() {
    if (!this.isPausing) {
      this.hoursTime = pickerH
      this.minuteTime = pickerM
      this.secondTime = pickerS
    }
    countInSec = pickerH * 3600 + pickerM * 60 + pickerS
    this.isRunning = true
    this.isPausing = false
    this.startImg = $r('app.media.pause')
    this.resetImg = $r('app.media.reset')
    this.timer = setInterval(this.timerCountDown.bind(this), 1000)
  }

  Pause() {
    clearInterval(this.timer)
    this.isRunning = true
    this.isPausing = true
    this.startImg = $r('app.media.start')
  }

  Reset() {
    clearInterval(this.timer)
    this.isRunning = false
    this.isPausing = false
    this.progressVal = 0
    this.rotates = 0
    passSec = 0
    this.hoursTime = 0
    this.minuteTime = 0
    this.secondTime = 0
    pickerH = 0
    pickerM = 0
    pickerS = 0
    this.startImg = $r('app.media.start')
    this.resetImg = $r('app.media.resetccc')
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Column({ space: 20 }) {
          Stack() {
            Image($r('app.media.clock_bg_out'))
              .width(280)
              .height(280)
            Progress({ value: this.progressVal, style: ProgressStyle.ScaleRing })
              .width(250)
              .height(250)
              .circularStyle({ strokeWidth: 10, scaleCount: 80, scaleWidth: 2 })
            Canvas(this.context)
              .onReady(() => {
                this.context.lineWidth = 8
                this.context.strokeStyle = '#f2400a'
                this.context.beginPath()
                this.context.moveTo(15, 0)
                this.context.arc(15, this.pointerHeight, 10, 3.14 * 1.5, 3.14 * 0.5)
                this.context.lineTo(15, this.lineLength)
                this.context.arc(15, this.pointerHeight, 10, 3.14 * 0.5, 3.14 * 1.5)
                this.context.stroke()
              })
              .width(10)
              .height(250)
              .position({
                x: '48.5%',
                y: 15
              })
              .rotate({
                x: 0,
                y: 0,
                z: 1,
                angle: this.rotates,
                centerX: '50%',
                centerY: 125
              })
              .animation({
                curve: Curve.Linear
              })
            Image($r('app.media.seconds'))
              .width('25%')
              .height('92%')
              .objectFit(ImageFit.Contain)
              .rotate({ z: 1, angle: -this.rotates })
          }
          .margin({ top: 35 })

          Text(FormatTime(this.hoursTime) + ':' + FormatTime(this.minuteTime) + ':' + FormatTime(this.secondTime))
            .fontSize(20)
            .fontWeight(500)
            .fontColor('#000000')
            .fontFamily('HarmonyHeiTi-Medium')
          if (this.isRunning) {
            Blank()
              .height(180)
          } else {
            Time()
          }
          Row() {
            Image(this.resetImg)
              .width(48)
              .height(48)
              .margin({ right: 100 })
              .objectFit(ImageFit.Fill)
              .onClick(() => {
                this.Reset()
              })
            Image(this.startImg)
              .width(48)
              .height(48)
              .onClick(() => {
                if (pickerH + pickerM + pickerS == 0) {
                  return
                }
                if (!this.isRunning || this.isPausing) {
                  this.Start()
                } else {
                  this.Pause()
                }
              })
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
    }
  }
}

@Component
struct Time {
  PickerArrayGen(num) {
    return Array.from({ length: num }, (_, i) => (i < 10) ? ('0' + i) : ('' + i))
  }

  build() {
    Column({ space: 15 }) {
      Row() {
        TextPicker({ range: this.PickerArrayGen(24) })
          .width(60)
          .onChange((value: string, index: number) => {
            pickerH = index
          })
        Text(':')
          .fontSize(24.75)
          .fontWeight(400)
          .fontFamily('HarmonyHeiTi')
          .margin({ left: 15, right: 15 })
        TextPicker({ range: this.PickerArrayGen(60) })
          .width(60)
          .onChange((value: string, index: number) => {
            pickerM = index
          })
        Text(':')
          .fontSize(24.75)
          .fontWeight(400)
          .fontFamily('HarmonyHeiTi')
          .margin({ left: 15, right: 15 })
        TextPicker({ range: this.PickerArrayGen(60) })
          .width(60)
          .onChange((value: string, index: number) => {
            pickerS = index
          })
      }
      .height(128)

      Row() {
        Text('时')
          .fontSize(14)
          .fontWeight(500)
          .fontColor('#000000')
          .fontFamily('HarmonyHeiTi')
        Text('分')
          .fontSize(14)
          .fontWeight(500)
          .fontColor('#000000')
          .fontFamily('HarmonyHeiTi')
          .margin({ left: 83, right: 83 })
        Text('秒')
          .fontSize(14)
          .fontWeight(500)
          .fontColor('#000000')
          .fontFamily('HarmonyHeiTi')
      }
    }
    .height('30%')
  }
}

function FormatTime(num) {
  if (num > 99 || num < 0) {
    return '**'
  }
  return (num < 10) ? ('0' + num).toString() : num.toString()
}