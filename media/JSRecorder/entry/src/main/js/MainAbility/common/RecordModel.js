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
import logger from '../common/Logger'
const TAG = '[RecordModel]'

export class RecordModel {
    audioRecorder = undefined
    playPath = ''

    initAudioRecorder() {
        this.release();
        this.audioRecorder = media.createAudioRecorder()
        logger.info(`${TAG} createAudioRecorder success`)
    }

    release() {
        if (typeof (this.audioRecorder) !== `undefined`) {
            logger.info(`${TAG} case RecorderModel  release`)
            this.audioRecorder.release()
            this.audioRecorder = undefined
        }
    }

    startRecorder(config, callback) {
        logger.info(`${TAG} enter the startRecorder`)
        logger.info(`${TAG} this.audiorecorder= ${JSON.stringify(this.audioRecorder)}`)
        logger.info(`${TAG} typeof (this.#audiorecorder)= ${ JSON.stringify(typeof (this.audioRecorder))}`)
        if (typeof (this.audioRecorder) !== 'undefined') {
            logger.info(`${TAG} enter the if`)
            this.audioRecorder.on('prepare', () => {
                logger.info(`${TAG} setCallback  prepare() case callback is called`)
                this.audioRecorder.start()
            })
            this.audioRecorder.on('start', () => {
                logger.info(`${TAG} setCallback start() case callback is called`)
                callback()
            })
            logger.info(`${TAG} start prepare`)
            this.audioRecorder.prepare(config)
            logger.info(`${TAG} end prepare`)
        } else {
            logger.info(`${TAG} case failed, audiorecorder is null`)
        }
    }

    pauseRecorder(callback) {
        logger.info(`${TAG}audioRecorder pause called`)
        if (typeof (this.audioRecorder) !== `undefined`) {
            this.audioRecorder.on('pause', () => {
                console.info(`${TAG}audioRecorder pause finish`)
                callback()
            })
            this.audioRecorder.pause()
        }
    }
    resumeRecorder(callback) {
        console.info(`${TAG}audioRecorder resume called`)
        if (typeof (this.audioRecorder) !== `undefined`) {
            this.audioRecorder.on('resume', () => {
                console.info(`${TAG}audioRecorder resume finish`)
                callback()
            })
            this.audioRecorder.resume()
        }
    }

    stopRecorder(callback) {
        if (typeof (this.audioRecorder) !== 'undefined') {
            this.audioRecorder.on('stop', () => {
                logger.info(`${TAG} setCallback stop() case callback is called`)
                callback()
                this.audioRecorder.release()
            })
            this.audioRecorder.stop()
        } else {
            logger.info(`${TAG} case failed, audiorecorder is null`)
        }
    }
}