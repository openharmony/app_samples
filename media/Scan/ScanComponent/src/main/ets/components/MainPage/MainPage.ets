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
import router from '@ohos.router'
import image from '@ohos.multimedia.image'
import prompt from '@ohos.prompt'
import jsQR from 'jsqr'
import CameraService from '../../model/CameraService'
import Logger from '../../model/Logger'
import MediaUtils from '../../model/MediaUtils'
import mediaquery from '@ohos.mediaquery';

const TAG: string = '[ParasQRCode]'
const QRCODE_SIZE: number = px2vp(250) // 二维码的大小

interface EventHub {
  emit(event: string, ...args: Object[]): void
}

interface AbilityContext {
  terminateSelf(): Promise<void>
  eventHub: EventHub
}

@Entry
@Component
export struct ScanPage {
  private tag: string = 'CameraPage'
  private mXComponentController: XComponentController = new XComponentController()
  private surfaceId: number
  @State imgThumbnail: string = ''
  @State isRecording: boolean = false
  @State showPhoto: boolean = false
  @State showInit: boolean = false
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private defaultQrcodeImage: ImageBitmap = new ImageBitmap("common/media/qrcode.png")
  @State resultInit: string = ''
  @State resultPhoto: string = ''
  @State uploadQrcodeImage: image.PixelMap | undefined = undefined
  @State textContent: string = "扫码"
  @State changeState: boolean = false
  @State multiples: number = 1.3
  @State isPhone: boolean = false
  private contexts: AbilityContext
  contextCaller: any
  listenerIsPhone = mediaquery.matchMediaSync("(orientation:landscape)")

  onPortrait(mediaQueryResult) {
    if (mediaQueryResult.matches) {
      this.isPhone = true
    } else {
      this.isPhone = false
    }
  }

  getDecodeInit = async () => {
    let data = this.context.getImageData(0, 0, QRCODE_SIZE, QRCODE_SIZE)
    let resultInit = jsQR(data.data, data.width, data.height, { inversionAttempts: "dontInvert" })
    if (resultInit === null) {
      this.resultInit = '解析失败！请检查是否为二维码'
    } else {
      this.resultInit = `解析为:${resultInit.data}`
    }
  }
  getDecodePhoto = async () => {
    let data = this.context.getImageData(0, 0, QRCODE_SIZE, QRCODE_SIZE)
    let resultPhoto = jsQR(data.data, data.width, data.height, { inversionAttempts: "dontInvert" })
    if (resultPhoto === null) {
      this.resultPhoto = '扫描失败！请检查是否为二维码'
    } else {
      this.resultPhoto = `解析为:${resultPhoto.data}`
    }
  }

  @Builder
  OperationBtn(Img: Resource, handleClick: () => void) {
    Image($r("app.media.scan_photo")).width(24 * this.multiples).height(24 * this.multiples)
      .onClick(handleClick)
  }

  aboutToAppear() {
    this.contexts = getContext(this) as AbilityContext
    let data = {
      context: null,
      launchWant: null
    }
    this.contexts.eventHub.emit("getAbilityData", data)
    this.contextCaller = data.context // 拿到全局的context，即类似globalThis.mainAbilityContext
    this.onPortrait(this.listenerIsPhone)
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId()
    Logger.info(this.tag, `aboutToAppear,surfaceId=${this.surfaceId}`)
    CameraService.setTakePictureCallback(this.handleTakePicture.bind(this))
  }

  scanInit = async () => {
    setInterval(() => {
      CameraService.takePicture()
      prompt.showToast({ message: $r("app.string.Scan_seconds"), duration: 1000 })
    }, 3000)
    this.uploadQrcodeImage = await MediaUtils.getPixelMap(this.imgThumbnail)
    this.getDecodeInit()
    this.showInit = true
  }
  handleTakePicture = (thumbnail: string) => {
    this.imgThumbnail = thumbnail
    Logger.info(this.tag, `takePicture init end, thumbnail: ${this.imgThumbnail}`)
  }

  build() {
    Stack() {
      XComponent({
        id: 'componentId',
        type: 'surface',
        controller: this.mXComponentController
      })
        .onLoad(() => {
          this.mXComponentController.setXComponentSurfaceSize({ surfaceWidth: 1920, surfaceHeight: 1080 })
          this.surfaceId = this.mXComponentController.getXComponentSurfaceId()
          CameraService.initCamera(this.surfaceId)
        })
        .height('100%')
        .width('100%')
        .margin({ bottom: 130 })

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Image($r("app.media.scan_border"))
          .width(240 * this.multiples)
          .height(240 * this.multiples)
          .margin({ top: 120 })
        Text($r("app.string.Scan_text")).fontSize(18).fontColor(Color.White).margin({ top: 24 })
        Canvas(this.context)
          .width(QRCODE_SIZE)
          .aspectRatio(1)
          .backgroundColor('#F0F0F0')
          .position({ x: "100%" })
          .onReady(() => {
            this.context.imageSmoothingEnabled = false
            this.context.clearRect(0, 0, QRCODE_SIZE, QRCODE_SIZE)
            if (this.uploadQrcodeImage) {
              this.context.drawImage(this.uploadQrcodeImage, 0, 0, QRCODE_SIZE, QRCODE_SIZE)
            } else {
              this.context.drawImage(this.defaultQrcodeImage, 0, 0, QRCODE_SIZE, QRCODE_SIZE)
            }
          })
      }.width("100%").margin({ top: 20, left: 20 }).height("100%").margin({ right: 20 })

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {

        Image($r("app.media.scan_back")).width(24 * this.multiples).height(24 * this.multiples)
          .onClick(() => {
            router.back()
          })
        Row({ space: 16 * this.multiples }) {
          this.OperationBtn($r("app.media.scan_photo"), () => {
            this.changeState = true
            // 3.2 beta分支abilityName使用com.ohos.filepicker.MainAbility
            this.contextCaller.startAbilityForResult({
              bundleName: "com.ohos.filepicker",
              abilityName: "com.ohos.filepicker.MainAbility",
              parameters: {
                startMode: 'choose'
              }
            }
            ).then(async (data) => {
              let result = data.want.parameters.result
              let images = result.split(';')
              Logger.info(TAG, `this.images = ${JSON.stringify(images)}`)
              this.uploadQrcodeImage = await MediaUtils.getPixelMap(images[0])
              if (this.uploadQrcodeImage === null) {
                prompt.showToast({ message: $r("app.string.Scan_file"), duration: 1000 })
                return
              }
              this.context.clearRect(0, 0, QRCODE_SIZE, QRCODE_SIZE)
              this.context.drawImage(this.uploadQrcodeImage, 0, 0, QRCODE_SIZE, QRCODE_SIZE)
              this.showPhoto = true
              this.getDecodePhoto()
            })
            // 主干master分支abilityName使用MainAbility
            this.contextCaller.startAbilityForResult({
              bundleName: "com.ohos.filepicker",
              abilityName: "MainAbility",
              parameters: {
                startMode: 'choose'
              }
            }
            ).then(async (data) => {
              let result = data.want.parameters.result
              let images = result.split(';')
              Logger.info(TAG, `this.images = ${JSON.stringify(images)}`)
              this.uploadQrcodeImage = await MediaUtils.getPixelMap(images[0])
              if (this.uploadQrcodeImage === null) {
                prompt.showToast({ message: $r("app.string.Scan_file"), duration: 1000 })
                return
              }
              this.context.clearRect(0, 0, QRCODE_SIZE, QRCODE_SIZE)
              this.context.drawImage(this.uploadQrcodeImage, 0, 0, QRCODE_SIZE, QRCODE_SIZE)
              this.showPhoto = true
              this.getDecodePhoto()
            })
          })

          Image($r("app.media.scan_more")).width(24 * this.multiples).height(24 * this.multiples)
        }
      }
      .width("100%")
      .margin({ top: 24 * this.multiples })
      .height("100%")
      .padding({ left: 24 * this.multiples, right: 24 * this.multiples })

      Column() {
        Image($r("app.media.scan_light"))
          .width(40 * this.multiples)
          .height(40 * this.multiples)
          .onClick(async () => {
            prompt.showToast({ message: $r("app.string.Scan_take_Photo"), duration: 1000 })
            CameraService.takePicture()
            this.uploadQrcodeImage = await MediaUtils.getPixelMap(this.imgThumbnail)
            if (this.uploadQrcodeImage === null) {
              prompt.showToast({ message: $r("app.string.Scan_file"), duration: 1000 })
              return
            }
            Logger.info(this.tag, `takePicturessss, imageurl: ${this.imgThumbnail}`)
            this.context.clearRect(0, 0, QRCODE_SIZE, QRCODE_SIZE)
            this.context.drawImage(this.uploadQrcodeImage, 0, 0, QRCODE_SIZE, QRCODE_SIZE)
            this.getDecodeInit()
            this.showInit = true
          })
        Text($r("app.string.Scan_light")).fontSize(20).fontColor(Color.White).margin({ top: 4 * this.multiples })
      }.margin({ top: 350 })

      // 扫一扫 文本翻译 字体设置
      FunctionSet({isPhone: $isPhone})

      // 初始化扫描弹窗
      PanelInit({ showInit: $showInit, result: $resultInit })

      // 相册扫描弹窗
      Panel(this.showPhoto) {
        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Text($r("app.string.Scan_read_content"))
              .fontSize(25)
              .width('90%')
            Image($r("app.media.scan_close")).width(50).height(50).onClick(() => {
              this.showPhoto = false
              this.changeState = false
            })
          }.padding(20)

          Text(this.resultPhoto.length === 0 ? $r("app.string.Scan_read_fail") : this.resultPhoto).fontSize(25)

        }
      }
      .type(PanelType.Foldable)
      .mode(PanelMode.Half)
      .dragBar(true) // 默认开启
      .halfHeight(500) // 默认一半
      .onChange((width: number, height: number, mode: PanelMode) => {
        console.info(`width:${width},height:${height},mode:${mode}`)
      })

    }.width("100%")
    .height("100%")
    .layoutWeight(1)
    .backgroundColor(Color.Grey)
  }
}

@Component
struct FunctionSet {
  @State changeTextOne: boolean = false
  @State changeTextTwo: boolean = false
  @State multiples: number = 1.3
  @Link  isPhone: boolean

  build() {
    Row({ space: 32 * this.multiples }) {
      Column() {
        if (this.changeTextOne) {
          Image(this.changeTextOne ? $r("app.media.scan_trans") : $r("app.media.scans"))
            .width(60 * this.multiples)
            .height(60 * this.multiples)
        } else if (this.changeTextTwo) {
          Image(this.changeTextTwo ? $r("app.media.scan_size") : $r("app.media.scans"))
            .width(60 * this.multiples)
            .height(60 * this.multiples)
        } else {
          Image($r("app.media.scans")).width(60 * this.multiples).height(60 * this.multiples)
        }
        if (this.changeTextOne) {
          Text(this.changeTextOne ? $r("app.string.Scan_translate") : $r("app.string.Scan_code")).fontColor(Color.White).fontSize(20).margin({ top: 20 })
        } else if (this.changeTextTwo) {
          Text(this.changeTextTwo ? $r("app.string.Scan_fonts") : $r("app.string.Scan_code")).fontColor(Color.White).fontSize(20).margin({ top: 20 })
        } else {
          Text($r("app.string.Scan_code")).fontColor(Color.White).fontSize(20).margin({ top: 20 })
        }
      }.margin({ top: 30 })

      Image(this.changeTextOne ? $r("app.media.scans") : $r("app.media.scan_trans"))
        .width(24 * this.multiples)
        .height(24 * this.multiples)
        .onClick(() => {
          this.changeTextOne = !this.changeTextOne
          if (this.changeTextTwo) {
            this.changeTextTwo = false
          }
        })
      Image(this.changeTextTwo ? $r("app.media.scans") : $r("app.media.scan_size"))
        .width(24 * this.multiples)
        .height(24 * this.multiples)
        .onClick(() => {
          this.changeTextTwo = !this.changeTextTwo
          if (this.changeTextOne) {
            this.changeTextOne = false
          }
        })
    }.position({ x:this.isPhone ?"47%":"42%", y: "78%" })
  }
}

@Component
struct PanelInit {
  @Link showInit: boolean
  @Link result: string

  build() {
    Panel(this.showInit) {
      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
          Text($r("app.string.Scan_result"))
            .fontSize(25)
            .width('90%')
          Image($r("app.media.scan_close")).width(50).height(50).onClick(() => {
            this.showInit = false
          })
        }.padding(20)

        Text(this.result.length === 0 ? $r("app.string.Scan_choice") : this.result).fontSize(25)

      }
    }
    .type(PanelType.Foldable)
    .mode(PanelMode.Half)
    .dragBar(true) // 默认开启
    .halfHeight(500) // 默认一半
    .onChange((width: number, height: number, mode: PanelMode) => {
      console.info(`width:${width},height:${height},mode:${mode}`)
    })
  }
}
