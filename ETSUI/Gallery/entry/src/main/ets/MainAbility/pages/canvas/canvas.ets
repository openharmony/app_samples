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

@Entry
@Component
struct CanvasExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private img: ImageBitmap = new ImageBitmap("/common/test2.jpg")
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

  adjustBrightness(value) {
    let imageData = this.ctx.getImageData(this.clipOffsetx, this.clipOffsety, this.clipWidth, this.clipHeight)
    this.ctx.putImageData(this.changeBrightness(imageData, value), 25, 25)
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
    return imageData
  }

  adjustContrast(value) {
    let imageData = this.ctx.getImageData(this.clipOffsetx, this.clipOffsety, this.clipWidth, this.clipHeight)
    this.ctx.putImageData(this.changeContrast(imageData, value), 25, 25)
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

  adjustSaturation(value) {
    let imageData = this.ctx.getImageData(this.clipOffsetx, this.clipOffsety, this.clipWidth, this.clipHeight)
    this.ctx.putImageData(this.changeSaturation(imageData, value), 25, 25)
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
      Row() {
        NavigationBar({ title: 'Canvas' })
      }
      .width('100%')
      .height('5%')
      .zIndex(999)

      Column() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Column() {
            Canvas(this.ctx)
              .width(350)
              .height(300)
              .backgroundColor(Color.Pink)
              .onReady(() => {
                this.dWidth = 300
                this.dHeight = 250
                //绘制原始图片
                this.ctx.drawImage(this.img, 25, 25, 300, 250)
                this.adjustBrightness(this.adjustValue)
              })
          }
        }.width('100%')
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
        Row({ space: 10 }) {
          Button('原图')
            .onClick(() => {
              this.clipState = 'original'
              //裁剪框等于图片大小
              this.clipWidth = this.dWidth
              this.clipHeight = this.dHeight
              this.clipOffsetx = 25
              this.clipOffsety = 25
              this.ctx.lineWidth = 3
              this.ctx.strokeStyle = "#ffff00"
              this.ctx.save()
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
          Button('1:1')
            .onClick(() => {
              this.clipState = 'sameProportion'
              //裁剪框左边框(1:1)
              this.cropBoxLeftTwo = (this.dWidth - this.dHeight) / 2 + 25
              this.clipOffsetx = this.cropBoxLeftTwo
              this.clipOffsety = 25
              this.clipWidth = this.dHeight
              this.clipHeight = this.dHeight
              this.ctx.lineWidth = 5
              this.ctx.strokeStyle = "#ffff00"
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
          Button('16:9')
            .onClick(() => {
              this.clipState = 'HighProportion'
              this.clipHeight = (this.dWidth * 9 / 19)
              this.clipWidth = this.dWidth
              //裁剪框左边框(16:9)
              this.cropBoxLeftThr = (this.dWidth - this.clipWidth) / 2 + 25
              //裁剪框上边距（16:9 ； 图片相对于画布）
              this.cropBoxTopThr = (this.dHeight - this.clipHeight) / 2 + 25
              this.clipOffsetx = this.cropBoxLeftThr
              this.clipOffsety = this.cropBoxTopThr
              this.ctx.lineWidth = 5
              this.ctx.strokeStyle = "#ffff00"
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
          Button('9:16')
            .onClick(() => {
              this.clipState = 'LowProportion'
              this.clipWidth = (this.dHeight * 9 / 16)
              this.clipHeight = this.dHeight
              //裁剪框左边框(9:16)
              this.cropBoxLeftFou = (this.dWidth - this.dHeight * 9 / 16) / 2 + 25
              //裁剪框上边距（9:16 ；图片相对于画布）
              this.cropBoxTopFou = 25
              this.clipOffsetx = (this.dWidth - this.clipWidth) / 2 + 25
              this.clipOffsety = this.cropBoxTopFou
              this.ctx.lineWidth = 5
              this.ctx.strokeStyle = "#ffff00"
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
        }
        .padding({ bottom: 5, top: 5, left: 30 })
        .visibility(Visibility[this.visibility1])


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
                  this.ctx.putImageData(this.brightnessImgData, 25, 25)
                } else {
                  const adjust = value / this.oldBrightnessValue
                  this.adjustValue = adjust
                  //                  this.adjustBrightness(this.adjustValue)
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
                  this.ctx.putImageData(this.contrastImgData, 25, 25)
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
                  this.ctx.putImageData(this.saturationImgData, 25, 25)
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
          Button('确认剪切')
            .fontSize(18)
            .onClick(() => {
              if (this.clipState == 'original') {
                this.ctx.save()
              }
              if (this.clipState == 'sameProportion') {
                this.ctx.clearRect(25, this.clipOffsety, this.cropBoxLeftTwo - 25, this.clipHeight)
                this.ctx.clearRect(this.cropBoxLeftTwo + this.clipWidth,
                  this.clipOffsety, this.cropBoxLeftTwo - 25, this.clipHeight)
                this.brightnessImgData = this.ctx.getImageData(25, 25, 250, 250)
                this.contrastImgData = this.ctx.getImageData(25, 25, 250, 250)
                this.saturationImgData = this.ctx.getImageData(25, 25, 250, 250)
                this.ctx.scale(25, 25)
                this.ctx.save()
              }
              if (this.clipState == 'HighProportion') {
                this.ctx.clearRect(25, 25, this.clipWidth, this.clipOffsety - 25)
                this.ctx.clearRect(25, this.cropBoxTopThr + this.clipHeight,
                  this.clipWidth, this.cropBoxTopThr - 25)
                this.brightnessImgData = this.ctx.getImageData(25, 25, 300, 300 * 9 / 16)
                this.contrastImgData = this.ctx.getImageData(25, 25, 300, 300 * 9 / 16)
                this.saturationImgData = this.ctx.getImageData(25, 25, 300, 300 * 9 / 16)
                this.ctx.scale(25, 25)
                this.ctx.save()
              }
              if (this.clipState == 'LowProportion') {
                this.ctx.clearRect(25, this.clipOffsety, this.cropBoxLeftFou - 25, this.clipHeight)
                this.ctx.clearRect(this.clipOffsetx + this.clipWidth,
                  this.clipOffsety, this.cropBoxLeftFou - 25, this.clipHeight)
                this.brightnessImgData = this.ctx.getImageData(25, 25, 250 * 9 / 16, 250)
                this.contrastImgData = this.ctx.getImageData(25, 25, 250 * 9 / 16, 250)
                this.saturationImgData = this.ctx.getImageData(25, 25, 250 * 9 / 16, 250)
                this.ctx.scale(25, 25)
                this.ctx.save()
              }
            })
            .fontSize('12fp')
            .borderRadius(14)
            .fontWeight(FontWeight.Medium)
            .visibility(Visibility[this.visibility1])
          Button('裁剪')
            .fontSize(18)
            .onClick(() => {
              this.visibility1 = 'Visible'
              this.visibility2 = 'None'
              this.clipState = 'original'
              //绘制图片 赋值裁剪框宽高
              this.clipWidth = this.dWidth
              this.clipHeight = this.dHeight
              this.clipOffsetx = 25
              this.clipOffsety = 25
              //绘制裁剪框
              this.ctx.fillStyle = "#0344ee"
              this.ctx.lineWidth = 5
              //裁剪框左边距(原图)-++-
              this.cropBoxLeftOne = (this.dWidth - this.clipWidth) / 2 + 25

              //裁剪框上边距(原图；图片相对于画布)
              this.cropBoxTopOne = 25
              //裁剪框上边距（1:1 ；图片相对于画布）
              this.cropBoxTopTwo = 25
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
      .width('100%')
      .backgroundColor('#FFFFFF')
      .borderRadius(24)
      .padding(12)
      .margin({ top: 24 })
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