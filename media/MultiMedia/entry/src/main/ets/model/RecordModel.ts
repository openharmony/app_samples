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
import media from '@ohos.multimedia.media'
import Logger from '../model/Logger'

let audioConfig = {
    audioSourceType: 1,
    audioEncoder: 3,
    audioEncodeBitRate: 22050,
    audioSampleRate: 22050,
    numberOfChannels: 2,
    format: 6,
    uri: ''
}

export default class RecordModel {
    private tag: string = 'RecordModel'
    private audioRecorder: media.AudioRecorder = undefined

    initAudioRecorder(handleStateChange: () => void) {
        this.release();
        this.audioRecorder = media.createAudioRecorder()
        Logger.info(this.tag, 'create audioRecorder success')
        this.audioRecorder.on('prepare', () => {
            Logger.info(this.tag, 'setCallback  prepare case callback is called')
            this.audioRecorder.start()
        })
        this.audioRecorder.on('start', () => {
            Logger.info(this.tag, 'setCallback start case callback is called')
            handleStateChange()
        })
        this.audioRecorder.on('stop', () => {
            Logger.info(this.tag, 'audioRecorder stop called')
            this.audioRecorder.release()
        })
        this.audioRecorder.on('pause', () => {
            Logger.info(this.tag, 'audioRecorder pause finish')
            handleStateChange()
        })
        this.audioRecorder.on('resume', () => {
            Logger.info(this.tag, 'audioRecorder resume finish')
            handleStateChange()
        })
    }

    release() {
        if (typeof (this.audioRecorder) !== `undefined`) {
            Logger.info(this.tag, 'audioRecorder  release')
            this.audioRecorder.release()
            this.audioRecorder = undefined
        }
    }

    startRecorder(pathName: string) {
        Logger.info(this.tag, `startRecorder, pathName = ${pathName}`)
        if (typeof (this.audioRecorder) !== 'undefined') {
            Logger.info(this.tag, 'start prepare')
            audioConfig.uri = pathName
            this.audioRecorder.prepare(audioConfig)
        } else {
            Logger.error(this.tag, 'case failed, audioRecorder is null')
        }
    }

    pause() {
        Logger.info(this.tag, 'audioRecorder pause called')
        if (typeof (this.audioRecorder) !== `undefined`) {
            this.audioRecorder.pause()
        }
    }

    resume() {
        Logger.info(this.tag, 'audioRecorder resume called')
        if (typeof (this.audioRecorder) !== `undefined`) {
            this.audioRecorder.resume()
        }
    }

    finish() {
        if (typeof (this.audioRecorder) !== `undefined`) {
            this.audioRecorder.stop()
        }
    }
}