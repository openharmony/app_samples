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

enum Type {
  brightness,
  saturate,
  contrast
}

import { NavigationBar } from "../../common/components/navigationBar"
import prompt from '@ohos.prompt';

@Entry
@Component
struct CanvasExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private img: ImageBitmap = new ImageBitmap("/common/test5.jpg")
  @State visibility1: string = 'Visible'
  @State visibility2: string = 'None'
  @State brightnessValue: number = 10
  @State oldBrightnessValue: number = 10
  @State saturateValue: number = 10
  @State oldSaturateValue: number = 10
  @State contrastValue: number = 10
  @State oldContrastValue: number = 10
  @State typeProperties: Type = Type.brightness
  @State clipOffsetx: number = 100
  @State clipOffsety: number = 100
  @State clipWidth: number = 100
  @State clipHeight: number = 100
  @State dWidth: number = 0
  @State dHeight: number = 0
  @State cropBoxLeftOne: number = 0
  @State cropBoxLeftTwo: number = 0
  @State cropBoxLeftThr: number = 0
  @State cropBoxLeftFou: number = 0
  @State cropBoxTopOne: number = 0
  @State cropBoxTopTwo: number = 0
  @State cropBoxTopThr: number = 0
  @State cropBoxTopFou: number = 0
  private brightnessImgData: any = null
  private contrastImgData: any = null
  private saturationImgData: any = null
  @State clipState: string = 'original'
  @State sliderChangeMode: SliderChangeMode = SliderChangeMode.Begin
  @State adjustValue: number = 0
  @State sliderNumber: string = ''
  @State scaleX: number = 0
  @State scaleY: number = 0
  //亮度
  adjustBrightness(value) {
    let imageData = this.ctx.getImageData
    (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
    this.ctx.putImageData((this.changeBrightness(imageData, value)), this.clipOffsetx, this.clipOffsety)
  }

  changeBrightness(imageData, value) {
    let data = imageData.data
    for (let i = 0; i < data.length; i += 4) {
      const hsv = this.rgb2hsv([data[i], data[i + 1], data[i+2]])
      hsv[2] *= value
      const rgb = this.hsv2rgb([...hsv])
      data[i] = rgb[0]
      data[i+1] = rgb[1]
      data[i+2] = rgb[2]
    }
    console.info('image:')
    return imageData
  }
  //对比度
  adjustContrast(value) {
    let imageData = this.ctx.getImageData
    (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
    this.ctx.putImageData((this.changeContrast(imageData, value)), this.clipOffsetx, this.clipOffsety)
  }

  changeContrast(imageData, value) {
    const data = imageData.data
    for (let i = 0;i < data.length; i += 4) {
      const hsv = this.rgb2hsv([data[i], data[i+1], data[i+2]])
      hsv[0] *= value
      const rgb = this.hsv2rgb([...hsv])
      data[i] = rgb[0]
      data[i+1] = rgb[1]
      data[i+2] = rgb[2]
    }
    return imageData
  }
  //饱和度
  adjustSaturation(value) {
    let imageData = this.ctx.getImageData
    (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
    this.ctx.putImageData((this.changeSaturation(imageData, value)), this.clipOffsetx, this.clipOffsety)
  }

  changeSaturation(imageData, value) {
    const data = imageData.data
    for (let i = 0;i < data.length; i += 4) {
      const hsv = this.rgb2hsv([data[i], data[i+1], data[i+2]])
      hsv[1] *= value
      const rgb = this.hsv2rgb([...hsv])
      data[i] = rgb[0]
      data[i+1] = rgb[1]
      data[i+2] = rgb[2]
    }
    return imageData
  }
  //RGB转HSV
  rgb2hsv(arr) {
    let rr
    let gg
    let bb
    const r = arr[0] / 255
    const g = arr[1] / 255
    const b = arr[2] / 255
    let h
    let s
    const v = Math.max(r, g, b)
    const diff = v - Math.min(r, g, b)
    const diffc = function (c) {
      return (v - c) / 6 / diff + 1 / 2
    }
    if (diff === 0) {
      h = s = 0
    } else {
      s = diff / v
      rr = diffc(r)
      gg = diffc(g)
      bb = diffc(b)
      if (r === v) {
        h = bb - gg
      } else if (g === v) {
        h = 1 / 3 + rr - bb
      } else if (b === v) {
        h = 2 / 3 + gg - rr
      }
      if (h < 0) {
        h += 1
      } else if (h > 1) {
        h -= 1
      }
    }
    return [Math.round(h * 360), Math.round(s * 100), Math.round(v * 100)]
  }
  //HSV转RGB
  hsv2rgb(hsv) {
    let _l = hsv[0]
    let _m = hsv[1]
    let _n = hsv[2]
    let newR
    let newG
    let newB
    if (_m === 0) {
      _l = _m = _n = Math.round(255 * _n / 100)
      newR = _l
      newG = _m
      newB = _n
    } else {
      _m = _m / 100
      _n = _n / 100
      const p = Math.floor(_l / 60) % 6
      const f = _l / 60 - p
      const a = _n * (1 - _m)
      const b = _n * (1 - _m * f)
      const c = _n * (1 - _m * (1 - f))
      switch (p) {
        case 0:
          newR = _n;
          newG = c;
          newB = a;
          break;
        case 1:
          newR = b;
          newG = _n;
          newB = a;
          break;
        case 2:
          newR = a;
          newG = _n;
          newB = c;
          break;
        case 3:
          newR = a;
          newG = b;
          newB = _n;
          break;
        case 4:
          newR = c;
          newG = a;
          newB = _n;
          break;
        case 5:
          newR = _n;
          newG = a;
          newB = b;
          break;
      }
      newR = Math.round(255 * newR)
      newG = Math.round(255 * newG)
      newB = Math.round(255 * newB)
    }
    return [newR, newG, newB]
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: 'Canvas' })

      Column() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Column() {
            Canvas(this.ctx)
              .width(300)
              .height(300)
              .onAppear(() => {
                this.dWidth = 300
                this.dHeight = 250
                //绘制原始图片
                this.ctx.drawImage(this.img, 0, 0, 300, 250)
              })
          }
        }.width('100%')
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Column() {
        Row({ space: 10 }) {
          Button('原图')
            .onClick(() => {
              this.clipState = 'original'
              //原图裁剪大小与原图一致
              this.clipWidth = this.dWidth
              this.clipHeight = this.dHeight
              this.clipOffsetx = (this.dWidth - this.clipWidth) / 2
              this.clipOffsety = (this.dHeight - this.clipHeight) / 2
              this.ctx.save()
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
          //1:1裁剪
          Button('1:1')
            .onClick(() => {
              this.clipState = 'sameProportion'
              this.clipWidth = this.dHeight
              this.clipHeight = this.dHeight
              this.cropBoxLeftTwo = (this.dHeight - this.clipHeight) / 2
              this.cropBoxTopTwo = (this.dHeight - this.clipHeight) / 2
              this.clipOffsetx = this.dHeight - this.clipWidth
              this.clipOffsety = this.dHeight - this.clipHeight
              this.scaleX = this.dWidth / this.clipWidth
              this.scaleY = this.scaleX
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
          //16:9裁剪
          Button('16:9')
            .onClick(() => {
              this.clipState = 'HighProportion'
              this.clipHeight = (this.dWidth * 9 / 19)
              this.clipWidth = this.dWidth
              this.cropBoxLeftThr = (this.dWidth - this.clipWidth) / 2
              this.cropBoxTopThr = (this.dHeight - this.clipHeight) / 2
              this.clipOffsetx = (this.dWidth - this.clipWidth) / 2
              this.clipOffsety = (300 - this.clipHeight) / 2
              this.scaleX = this.dWidth / this.clipWidth
              this.scaleY = this.scaleX
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
          //9:16裁剪
          Button('9:16')
            .onClick(() => {
              this.clipState = 'LowProportion'
              this.clipWidth = (this.dHeight * 9 / 16)
              this.clipHeight = this.dHeight
              this.cropBoxLeftFou = (300 - this.dHeight * 9 / 16) / 2
              this.cropBoxTopFou = (this.dHeight - this.clipHeight) / 2
              this.clipOffsetx = (300 - this.clipWidth) / 2
              this.clipOffsety = this.cropBoxTopFou
              this.scaleX = this.dHeight / this.clipHeight
              this.scaleY = this.dWidth / this.clipHeight
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
        }
        .padding({ bottom: 5, top: 10 })
        .visibility(Visibility[this.visibility1])

        Row() {
          Button('确认剪切')
            .fontSize(18)
            .onClick(() => {
              if (this.clipState == 'original') {
                this.ctx.save()
              }
              //1：1剪切
              if (this.clipState == 'sameProportion') {
                let imageData = this.ctx.getImageData
                (this.cropBoxLeftOne, this.cropBoxTopOne, this.clipWidth, this.clipHeight)
                this.ctx.clearRect(0, 0, 300, 300)
                this.ctx.scale(this.scaleX, this.scaleY)
                this.ctx.putImageData(imageData, 0, 0)
                this.brightnessImgData = this.ctx.getImageData
                (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
                this.contrastImgData = this.ctx.getImageData
                (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
                this.saturationImgData = this.ctx.getImageData
                (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
                this.ctx.save()
              }
              //16:9剪切
              if (this.clipState == 'HighProportion') {
                let imageData = this.ctx.getImageData
                (this.cropBoxLeftThr, this.cropBoxTopThr, this.clipWidth, this.clipHeight)
                this.ctx.clearRect(0, 0, 300, 300)
                this.ctx.scale(this.scaleX, this.scaleY)
                this.ctx.putImageData(imageData, this.clipOffsetx, this.clipOffsety)
                this.brightnessImgData = this.ctx.getImageData
                (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
                this.contrastImgData = this.ctx.getImageData
                (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
                this.saturationImgData = this.ctx.getImageData
                (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
                this.ctx.save()
              }
              //9：16剪切
              if (this.clipState == 'LowProportion') {
                let dx = (300 - 250 * 9 / 16) / 2
                let imageData = this.ctx.getImageData
                (dx, this.cropBoxTopFou, this.clipWidth, this.clipHeight)
                this.ctx.clearRect(0, 0, 300, 300)
                this.ctx.scale(this.scaleX, this.scaleY)
                this.ctx.putImageData(imageData, this.clipOffsetx, this.clipOffsety)
                this.brightnessImgData = this.ctx.getImageData
                (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
                this.contrastImgData = this.ctx.getImageData
                (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
                this.saturationImgData = this.ctx.getImageData
                (this.clipOffsetx, this.clipOffsety, this.clipWidth * this.scaleX, this.clipHeight * this.scaleY)
                this.ctx.save()
              }
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
            .visibility(Visibility[this.visibility1])
        }
        .margin({ top: 5, bottom: 5 })
        //判断调节中选中亮度，对比度，饱和度三者中的哪一个

        if (this.typeProperties == Type.brightness) {
          Slider({
            value: this.brightnessValue,
            min: 0,
            max: 10,
            step: 1.0,
            style: SliderStyle.OutSet
          })
            .onChange((value: number, mode: SliderChangeMode) => {
              this.sliderNumber = mode.toString()
              if (this.sliderNumber === '2') {
                this.brightnessValue = value
                if (value == 10) {
                  this.ctx.restore()
                  this.ctx.putImageData(this.brightnessImgData, this.clipOffsetx, this.clipOffsety)
                } else {
                  const adjust = value / this.oldBrightnessValue
                  this.adjustValue = adjust
                  this.adjustBrightness(this.adjustValue)
                }
              }
            })
            .visibility(Visibility[this.visibility2])
        } else if (this.typeProperties == Type.contrast) {
          Slider({
            value: this.contrastValue,
            min: 0,
            max: 10,
            step: 1.0,
            style: SliderStyle.OutSet
          })
            .onChange((value: number, mode: SliderChangeMode) => {
              this.sliderNumber = mode.toString()
              if (this.sliderNumber === '2') {
                this.contrastValue = value
                if (value == 10) {
                  this.ctx.restore()
                  this.ctx.putImageData(this.contrastImgData, this.clipOffsetx, this.clipOffsety)
                } else {
                  const adjust = value / this.oldContrastValue
                  this.adjustValue = adjust
                  this.adjustContrast(this.adjustValue)
                }
              }
            })
        } else {
          Slider({
            value: this.saturateValue,
            min: 0,
            max: 10,
            step: 1.0,
            style: SliderStyle.OutSet
          })
            .onChange((value: number, mode: SliderChangeMode) => {
              this.sliderNumber = mode.toString()
              if (this.sliderNumber === '2') {
                this.saturateValue = value
                if (value == 10) {
                  this.ctx.restore()
                  this.ctx.putImageData(this.saturationImgData, this.clipOffsetx, this.clipOffsety)
                } else {
                  const adjust = value / this.oldSaturateValue
                  this.adjustValue = adjust
                  this.adjustSaturation(this.adjustValue)
                }
              }
            })
        }

        Row({ space: 10 }) {
          Button('亮度')
            .onClick(() => {
              this.typeProperties = Type.brightness
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
          Button('对比度')
            .onClick(() => {
              this.typeProperties = Type.contrast
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
          Button('饱和度')
            .onClick(() => {
              this.typeProperties = Type.saturate
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
        }
        .padding({ bottom: 5, top: 5 })
        .visibility(Visibility[this.visibility2])

        Row({ space: 6 }) {
          Button('裁剪')
            .fontSize(18)
            .onClick(() => {
              this.visibility1 = 'Visible'
              this.visibility2 = 'None'
              this.clipState = 'original'
              //绘制图片 赋值裁剪框宽高
              this.clipWidth = this.dWidth
              this.clipHeight = this.dHeight
              this.clipOffsetx = 0
              this.clipOffsety = 0
              //绘制裁剪框
              this.ctx.fillStyle = "#0344ee"
              this.ctx.lineWidth = 5
              this.cropBoxLeftOne = (this.dWidth - this.clipWidth) / 2
              this.cropBoxTopOne = (this.dHeight - this.clipHeight) / 2
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
          Button('调节')
            .fontSize(18)
            .onClick(() => {
              this.visibility1 = 'None'
              this.visibility2 = 'Visible'
              this.typeProperties = Type.brightness
              this.ctx.restore()
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
        }
        .padding({ bottom: 5, top: 5 })
      }
      .padding(10)
      .borderRadius(20)
      .backgroundColor('#FFFFFF')
      .margin({ top: 30 })
    }
    .width('100%')
    .backgroundColor('#F1F1F5')
    .padding({ left: '3%', right: '3%' })
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