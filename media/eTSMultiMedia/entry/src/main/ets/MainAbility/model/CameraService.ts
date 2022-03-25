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
import featureAbility from '@ohos.ability.featureAbility'
import image from '@ohos.multimedia.image'
import media from '@ohos.multimedia.media'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../model/Logger'
import MediaUtils from '../model/MediaUtils'

const CameraMode = {
    MODE_PHOTO: 0, // 拍照模式
    MODE_VIDEO: 1 // 录像模式
}

const CameraSize = {
    WIDTH: 2048,
    HEIGHT: 1536
}

export default class CameraService {
    private tag: string = 'CameraService'
    private static instance: CameraService = new CameraService()
    private mediaUtil = MediaUtils.getInstance()
    private cameraManager: any = undefined
    private cameras: any = undefined
    private cameraId: number = -1
    private cameraInput: any = undefined
    private previewOutput: any = undefined
    private photoOutPut: any = undefined
    private captureSession: any = undefined
    private mReceiver: any = undefined
    private photoUri: string = ''
    private fileAsset: any = undefined
    private fd: number = -1
    private curMode = CameraMode.MODE_PHOTO
    private videoRecorder: any = undefined
    private videoOutput: any = undefined
    private handleTakePicture: (photoUri: string) => void = () => {}
    private videoProfile = {
        audioBitrate: 48000,
        audioChannels: 2,
        audioCodec: 'audio/mp4a-latm',
        audioSampleRate: 48000,
        durationTime: 60000,
        fileFormat: 'mp4',
        videoBitrate: 48000,
        videoCodec: 'video/mp4v-es',
        videoFrameWidth: CameraSize.WIDTH,
        videoFrameHeight: CameraSize.HEIGHT,
        videoFrameRate: 30
    }
    private videoConfig = {
        audioSourceType: 1,
        videoSourceType: 0,
        profile: this.videoProfile,
        url: '',
        orientationHint: 0,
        location: { latitude: 30, longitude: 130 },
        maxSize: 6000,
        maxDuration: 60000
    }

    constructor() {
        this.mReceiver = image.createImageReceiver(CameraSize.WIDTH, CameraSize.HEIGHT, 4, 8) // 宽高定位成常量
        let buffer = new ArrayBuffer(4096)
        this.mReceiver.on('imageArrival', async () => {
            this.mReceiver.readNextImage((err: any, image: any) => {
                if (err || image === undefined) {
                    Logger.error(this.tag, 'failed to get valid image')
                    return
                }
                image.getComponent(4, async (errMsg: any, img: any) => {
                    if (errMsg || img === undefined) {
                        Logger.log(this.tag, 'failed to get valid buffer')
                        return
                    }
                    if (img.byteBuffer) {
                        buffer = img.byteBuffer
                    } else {
                        Logger.error(this.tag, 'img.byteBuffer is undefined')
                    }
                    await image.release()
                    let dataUri = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.IMAGE)
                    this.photoUri = dataUri.uri
                    this.fileAsset = await this.mediaUtil.queryFile(dataUri)
                    this.fd = await this.mediaUtil.getFdPath(this.fileAsset)
                    await fileio.write(this.fd, buffer)
                    await this.fileAsset.close(this.fd)
                    Logger.log(this.tag, 'save image done')
                    if (this.handleTakePicture != null) {
                        this.handleTakePicture(this.photoUri)
                    }
                })
            })
        })
    }

    public static getInstance(): CameraService{
        if (this.instance === null) {
            this.instance = new CameraService()
        }
        return this.instance
    }

    async initCamera(surfaceId: number) {
        Logger.log(this.tag, 'initCamera')
        if (this.curMode === CameraMode.MODE_VIDEO) {
            await this.releaseCamera()
            this.curMode = CameraMode.MODE_PHOTO
        }
        let context = featureAbility.getContext()
        this.cameraManager = await camera.getCameraManager(context)
        Logger.log(this.tag, 'getCameraManager')
        this.cameras = await this.cameraManager.getCameras()
        Logger.log(this.tag, `get cameras ${this.cameras.length}`)
        if (this.cameras.length === 0) {
            Logger.log(this.tag, 'cannot get cameras')
            return
        }
        this.cameraId = this.cameras[0].cameraId
        this.cameraInput = await this.cameraManager.createCameraInput(this.cameraId)
        Logger.log(this.tag, 'createCameraInput')
        this.previewOutput = await camera.createPreviewOutput(surfaceId)
        Logger.log(this.tag, 'createPreviewOutput')
        let mSurfaceId = await this.mReceiver.getReceivingSurfaceId()
        this.photoOutPut = await camera.createPhotoOutput(mSurfaceId)
        this.captureSession = await camera.createCaptureSession(context)
        Logger.log(this.tag, 'createCaptureSession')
        await this.captureSession.beginConfig()
        Logger.log(this.tag, 'beginConfig')
        await this.captureSession.addInput(this.cameraInput)
        await this.captureSession.addOutput(this.previewOutput)
        await this.captureSession.addOutput(this.photoOutPut)
        await this.captureSession.commitConfig()
        await this.captureSession.start()
        Logger.log(this.tag, 'captureSession start')
    }

    public setTakePictureCallback(callback: () => void) {
        this.handleTakePicture = callback
    }

    public async takePicture() {
        Logger.log(this.tag, 'takePicture')
        let photoSettings = {
            rotation: 0,
            quality: 1,
            location: { // 位置信息，经纬度
                latitude: 12.9698,
                longitude: 77.7500
            },
            mirror: false
        }
        await this.photoOutPut.capture(photoSettings)
        Logger.log(this.tag, 'takePicture done')
    }

    public async startVideo(surfaceId: number) {
        if (this.curMode === CameraMode.MODE_PHOTO) {
            await this.releaseCamera()
            this.curMode = CameraMode.MODE_VIDEO
        }
        Logger.log(this.tag, 'startVideo begin')
        let context = featureAbility.getContext()
        let dataUri = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.VIDEO)
        this.fileAsset = await this.mediaUtil.queryFile(dataUri)
        this.fd = await this.mediaUtil.getFdPath(this.fileAsset)
        this.videoConfig.url = `fd://${this.fd}`
        Logger.log(this.tag, `startVideo, fd=${this.fd}`)
        this.captureSession = await camera.createCaptureSession(context)
        this.cameraInput = await this.cameraManager.createCameraInput(this.cameraId)
        this.previewOutput = await camera.createPreviewOutput(surfaceId)
        Logger.log(this.tag, 'startVideo, createPreviewOutput')
        if (this.videoRecorder) {
            await this.videoRecorder.release()
        }
        this.videoRecorder = await media.createVideoRecorder()
        this.videoConfig.profile.videoFrameWidth = CameraSize.WIDTH
        this.videoConfig.profile.videoFrameHeight = CameraSize.HEIGHT
        await this.videoRecorder.prepare(this.videoConfig)
        let videoId = await this.videoRecorder.getInputSurface()
        this.videoOutput = await camera.createVideoOutput(videoId)
        Logger.log(this.tag, 'startVideo, beginConfig')
        await this.captureSession.beginConfig()
        await this.captureSession.addInput(this.cameraInput)
        await this.captureSession.addOutput(this.previewOutput)
        await this.captureSession.addOutput(this.videoOutput)
        Logger.log(this.tag, 'startVideo, commitConfig')
        await this.captureSession.commitConfig()
        await this.captureSession.start()
        await this.videoOutput.start()
        await this.videoRecorder.start()
        Logger.log(this.tag, 'startVideo end')
    }

    public async stopVideo() {
        Logger.log(this.tag, 'stopVideo called')
        await this.videoRecorder.stop()
        await this.videoOutput.stop()
        await this.fileAsset.close(this.fd)
        Logger.log(this.tag, 'stopVideo called')
    }

    public async releaseCamera() {
        Logger.log(this.tag, 'releaseCamera')
        await this.captureSession.stop()
        await this.cameraInput.release()
        await this.captureSession.release()
    }

    public cameraImageOff() {
        this.mReceiver.off('imageArrival')
    }
}