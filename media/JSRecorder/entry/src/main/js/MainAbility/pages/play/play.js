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
import { updateTime } from '../../common/Util'
import { AudioModel } from '../../common/AuidoModel'

const TAG = '[play]'
const MILLISECOND = 1000

export default{
    data:{
        audioModel: new AudioModel(),
        isPlay: false,
        millisecond: 0,
        file: '',
        path: '',
        time: '00:00',
        dataTime: '00:00',
        timer: undefined,
    },

    onInit() {
        this.audioModel.initAudioPlayer(this.path, this.isPlay)
        logger.info(`${TAG} this.path= ${this.path}`)
    },

    play() {
        if(!this.isPlay) {
            this.audioModel.play()
            this.timer = setInterval(() => {
                this.millisecond += MILLISECOND
                this.time = updateTime(this.millisecond)
                this.isPlay = true
                this.audioModel.onFinish(() => {
                    this.time = '00:00'
                    this.millisecond = 0
                    this.isPlay = false
                    clearInterval(this.timer)
                })
            }, MILLISECOND)
        }
    },

    pause() {
        if(this.isPlay) {
            this.audioModel.pause()
            clearInterval(this.timer)
            this.isPlay = false
        }
    },

    stop() {
        clearInterval(this.timer)
        this.audioModel.finish()
        this.millisecond = 0
        this.time = '00:00'
        this.back()
    },

    back() {
        router.back({url: "pages/index/index"})
    },

    onHide() {
      this.stop()
    }
}
