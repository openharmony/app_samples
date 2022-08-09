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
import camera from '@ohos.multimedia.camera'
import fileio from '@ohos.fileio'
import image from '@ohos.multimedia.image'
import media from '@ohos.multimedia.media'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../model/Logger'
import MediaUtils from '../model/MediaInit'


const CameraSize = {
  WIDTH: 1920,
  HEIGHT: 1080
}

class CameraService {
  private tag: string = 'CameraService'
  private static instance: CameraService = new CameraService()
  private mediaUtil = MediaUtils.getInstance()
  private cameraManager: camera.CameraManager = undefined
  private cameras: Array<camera.Camera> = undefined
  private cameraId: string = ''
  private cameraInput: camera.CameraInput = undefined
  private previewOutput: camera.PreviewOutput = undefined
  private photoOutPut: camera.PhotoOutput = undefined
  private captureSession: camera.CaptureSession = undefined
  private mReceiver: image.ImageReceiver = undefined
  private photoUri: string = ''
  private fileAsset: mediaLibrary.FileAsset = undefined
  private fd: number = -1
  private handleTakePicture: (photoUri: string) => void = undefined

  constructor() {
    this.mReceiver = image.createImageReceiver(CameraSize.WIDTH, CameraSize.HEIGHT, 4, 8)
    Logger.info(this.tag, 'createImageReceiver')
    this.mReceiver.on('imageArrival', () => {
      Logger.info(this.tag, 'imageArrival')
      this.mReceiver.readNextImage((err, image) => {
        Logger.info(this.tag, 'readNextImage')
        if (err || image === undefined) {
          Logger.error(this.tag, 'failed to get valid image')
          return
        }
        image.getComponent(4, (errMsg, img) => {
          Logger.info(this.tag, 'getComponent')
          if (errMsg || img === undefined) {
            Logger.info(this.tag, 'failed to get valid buffer')
            return
          }
          let buffer = new ArrayBuffer(4096)
          if (img.byteBuffer) {
            buffer = img.byteBuffer
          } else {
            Logger.error(this.tag, 'img.byteBuffer is undefined')
          }
          this.savePicture(buffer, image)
        })
      })
    })
  }

  async savePicture(buffer: ArrayBuffer, img: image.Image) {
    Logger.info(this.tag, 'savePicture')
    this.fileAsset = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.IMAGE)
    this.photoUri = this.fileAsset.uri
    Logger.info(this.tag, `this.photoUri = ${this.photoUri}`)
    this.fd = await this.mediaUtil.getFdPath(this.fileAsset)
    Logger.info(this.tag, `this.fd = ${this.fd}`)
    await fileio.write(this.fd, buffer)
    await this.fileAsset.close(this.fd)
    await img.release()
    Logger.info(this.tag, 'save image done')
    Logger.info(this.tag, `protouriissuccess ${this.photoUri}`)
    if (this.handleTakePicture) {
      this.handleTakePicture(this.photoUri)
    }
  }

  async initCamera(surfaceId: number) {
    Logger.info(this.tag, 'initCamera')
    this.cameraManager = await camera.getCameraManager(globalThis.abilityContext)
    Logger.info(this.tag, 'getCameraManager')
    this.cameras = await this.cameraManager.getCameras()
    Logger.info(this.tag, `get cameras ${this.cameras.length}`)
    if (this.cameras.length === 0) {
      Logger.info(this.tag, 'cannot get cameras')
      return
    }
    this.cameraId = this.cameras[0].cameraId
    this.cameraInput = await this.cameraManager.createCameraInput(this.cameraId)
    Logger.info(this.tag, 'createCameraInput')
    this.previewOutput = await camera.createPreviewOutput(surfaceId.toString())
    Logger.info(this.tag, 'createPreviewOutput')
    let mSurfaceId = await this.mReceiver.getReceivingSurfaceId()
    this.photoOutPut = await camera.createPhotoOutput(mSurfaceId)
    this.captureSession = await camera.createCaptureSession(globalThis.abilityContext)
    Logger.info(this.tag, 'createCaptureSession')
    await this.captureSession.beginConfig()
    Logger.info(this.tag, 'beginConfig')
    await this.captureSession.addInput(this.cameraInput)
    await this.captureSession.addOutput(this.previewOutput)
    await this.captureSession.addOutput(this.photoOutPut)
    await this.captureSession.commitConfig()
    await this.captureSession.start()
    Logger.info(this.tag, 'captureSession start')
  }

  setTakePictureCallback(callback) {
    this.handleTakePicture = callback
  }

  async takePicture() {
    Logger.info(this.tag, 'takePicture')
    let photoSettings = {
      rotation: camera.ImageRotation.ROTATION_0,
      quality: camera.QualityLevel.QUALITY_LEVEL_MEDIUM,
      location: { // 位置信息，经纬度
        latitude: 12.9698,
        longitude: 77.7500,
        altitude: 1000
      },
      mirror: false
    }
    await this.photoOutPut.capture(photoSettings)
    Logger.info(this.tag, 'takePicture done')
  }

  async releaseCamera() {
    Logger.info(this.tag, 'releaseCamera')
    await this.captureSession.stop()
    if (this.cameraInput) {
      await this.cameraInput.release()
    }
    if (this.previewOutput) {
      await this.previewOutput.release()
    }
    if (this.photoOutPut) {
      await this.photoOutPut.release()
    }
    await this.cameraInput.release()
    await this.captureSession.release()
  }
}

export default new CameraService()