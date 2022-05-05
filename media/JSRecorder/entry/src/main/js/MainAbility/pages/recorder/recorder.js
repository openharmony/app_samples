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
import logger from '../../common/Logger'
import { prepareFdNumber } from '../../common/Util'
import { Util, updateTime } from '../../common/Util'
import { RecordModel } from '../../common/RecordModel'

const TAG = '[recorde]'
const MILLISECOND = 1000

export default {
    timer: undefined,
    data: {
        dataTime: '00:00',
        file: '',
        date: '',
        fileNum: 0,
        millisecond: 0,
        isRecord: false,
        path: '',
        util: new Util(),
        recordModel: new RecordModel(),
        recordList: new Array(),
        audioConfig: {
            audioSourceType: 1,
            audioEncoder: 3,
            audioEncodeBitRate: 22050,
            audioSampleRate: 22050,
            numberOfChannels: 2,
            format: 2,
            uri: ''
        },
        mainData: {
            file: '',
            path: '',
            date: '',
            dataTime: '',
            isLongPress: false
        },
    },

    onShow() {
        logger.info(`${TAG} enter onShow`)
        this.click()
    },

    click() {
        if (!this.isRecord) {
            logger.info(`${TAG} enter click`)
            //开始录音
            let fdPath = prepareFdNumber(this.mainData.path)
            fdPath.then((fdNumber) => {
                logger.info(`${TAG} fdNumber= ${fdNumber}`)
                this.startRecorder(fdNumber)
                logger.info(`${TAG} startRecorder end`)
            })
        }
    },

    pause() {
        if (this.isRecord) {
            clearInterval(this.timer)
            //暂停录音
            this.recordModel.pauseRecorder(() => {
                this.isRecord = false
            })
        }
    },

    resume() {
        if (!this.isRecord) {
            this.timer = setInterval(() => {
                this.millisecond += MILLISECOND
                this.dataTime = updateTime(this.millisecond)
            }, MILLISECOND)
            this.recordModel.resumeRecorder(() => {
                this.isRecord = true
            })
        }
    },

    Stop() {
        clearInterval(this.timer)
        //停止录音
        this.recordModel.stopRecorder(() => {
            logger.info(`${TAG} enter callback isRecord= ${this.isRecord}`)
            if (this.isRecord) {
                this.isRecord = false
                logger.info(`${TAG} pause isRecord= ${this.isRecord}`)
                this.mainData.dataTime = this.dataTime
                logger.info(`${TAG} mainData = ${JSON.stringify(this.mainData)}`)
                this.util.put(this.mainData)
                logger.info(`${TAG} put end`)
                this.millisecond = 0
                router.back()
            }
        })
        logger.info(`${TAG} back success`)
    },

    startRecorder(pathNumber) {
        this.audioConfig.uri = pathNumber
        logger.info(`${TAG} uri= ${this.audioConfig.uri}`)
        this.recordModel.initAudioRecorder()
        // 开始录音
        this.recordModel.startRecorder(this.audioConfig, ()=>{
            logger.info(`${TAG} enter the callback`)
            this.isRecord = true
            this.timer = setInterval(() => {
                logger.info(`${TAG} enter the setInterval`)
                this.millisecond += MILLISECOND
                this.dataTime = updateTime(this.millisecond)
            }, MILLISECOND)
        })
    },

    onHide() {
        this.Stop()
    }
}


