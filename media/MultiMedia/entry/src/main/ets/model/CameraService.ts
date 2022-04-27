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
    private curMode = CameraMode.MODE_PHOTO
    private videoRecorder: media.VideoRecorder = undefined
    private videoOutput: camera.VideoOutput = undefined
    private handleTakePicture: (photoUri: string) => void = () => {}
    private videoProfile: media.VideoRecorderProfile = {
        audioBitrate: 48000,
        audioChannels: 2,
        audioCodec: media.CodecMimeType.AUDIO_AAC,
        audioSampleRate: 48000,
        fileFormat: media.ContainerFormatType.CFT_MPEG_4,
        videoBitrate: 48000,
        videoCodec: media.CodecMimeType.VIDEO_MPEG4,
        videoFrameWidth: CameraSize.WIDTH,
        videoFrameHeight: CameraSize.HEIGHT,
        videoFrameRate: 30
    }
    private videoConfig: media.VideoRecorderConfig = {
        audioSourceType: 1,
        videoSourceType: 0,
        profile: this.videoProfile,
        url: '',
        location: { latitude: 30, longitude: 130 }
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
                        Logger.info(this.tag, 'failed to get valid buffer')
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
                    Logger.info(this.tag, 'save image done')
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
        Logger.info(this.tag, 'initCamera')
        if (this.curMode === CameraMode.MODE_VIDEO) {
            await this.releaseCamera()
            this.curMode = CameraMode.MODE_PHOTO
        }
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

    public setTakePictureCallback(callback) {
        this.handleTakePicture = callback
    }

    public async takePicture() {
        Logger.info(this.tag, 'takePicture')
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
        Logger.info(this.tag, 'takePicture done')
    }

    public async startVideo(surfaceId: number) {
        if (this.curMode === CameraMode.MODE_PHOTO) {
            await this.releaseCamera()
            this.curMode = CameraMode.MODE_VIDEO
        }
        Logger.info(this.tag, 'startVideo begin')
        let dataUri = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.VIDEO)
        this.fileAsset = await this.mediaUtil.queryFile(dataUri)
        this.fd = await this.mediaUtil.getFdPath(this.fileAsset)
        this.videoConfig.url = `fd://${this.fd}`
        Logger.info(this.tag, `startVideo, fd=${this.fd}`)
        this.captureSession = await camera.createCaptureSession(globalThis.abilityContext)
        this.cameraInput = await this.cameraManager.createCameraInput(this.cameraId)
        this.previewOutput = await camera.createPreviewOutput(surfaceId.toString())
        Logger.info(this.tag, 'startVideo, createPreviewOutput')
        if (this.videoRecorder) {
            await this.videoRecorder.release()
        }
        this.videoRecorder = await media.createVideoRecorder()
        await this.videoRecorder.prepare(this.videoConfig)
        let videoId = await this.videoRecorder.getInputSurface()
        this.videoOutput = await camera.createVideoOutput(videoId)
        Logger.info(this.tag, 'startVideo, beginConfig')
        await this.captureSession.beginConfig()
        await this.captureSession.addInput(this.cameraInput)
        await this.captureSession.addOutput(this.previewOutput)
        await this.captureSession.addOutput(this.videoOutput)
        Logger.info(this.tag, 'startVideo, commitConfig')
        await this.captureSession.commitConfig()
        await this.captureSession.start()
        await this.videoOutput.start()
        await this.videoRecorder.start()
        Logger.info(this.tag, 'startVideo end')
    }

    public async stopVideo() {
        Logger.info(this.tag, 'stopVideo called')
        await this.videoRecorder.stop()
        await this.videoOutput.stop()
        await this.fileAsset.close(this.fd)
        Logger.info(this.tag, 'stopVideo called')
    }

    public async releaseCamera() {
        Logger.info(this.tag, 'releaseCamera')
        await this.captureSession.stop()
        await this.cameraInput.release()
        await this.captureSession.release()
    }
}