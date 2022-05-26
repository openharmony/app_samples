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

import animator from '@ohos.animator';
import Logger from '../../common/Logger'

const TAG = '[index]'

export default {
    data: {
        sunLeft: 0,
        sunBottom: 0,
        divLeft: 600,
        divBottom: 0,
        isPlay: false
    },
    sunAnimator: null,
    moonAnimator: null,

    onInit() {
        this.sunAnimator = animator.createAnimator({
            duration: 5000,
            delay: 0,
            easing: 'cubic-bezier(0.5,0.8,0.5,0.2)',
            fill: 'none',
            direction: 'normal',
            iterations: 1,
            begin: 0.0,
            end: 600.0
        });

        this.moonAnimator = animator.createAnimator({
            duration: 5000,
            delay: 5000,
            easing: 'cubic-bezier(0.5,0.8,0.5,0.2)',
            fill: 'none',
            direction: 'normal',
            iterations: 1,
            begin: 600.0,
            end: 0.0
        })
    },
    rise() {
        Logger.info(TAG, `rise onclick the rise`)
        this.sunAnimator.onframe = (value) => {
            if (value > 300) {
                this.sunBottom = 600 - value
            } else {
                this.sunBottom = value
            }
            this.sunLeft = value
        };
        this.sunAnimator.play();
        Logger.info(TAG, `rais play`)
    },
    fall() {
        Logger.info(TAG, `onclick the fall`)
        this.moonAnimator.onframe = (value) => {
            if (parseInt(value) < 300) {
                this.divBottom = -value
            } else {
                this.divBottom = value - 600
            }
            this.divLeft = value
        }
        this.moonAnimator.play()
        Logger.info(TAG, `fall play`)
    },

    start() {
        Logger.info(TAG, `this.isPlay=${this.isPlay}`)
        if (!this.isPlay) {
            this.isPlay = true
            this.rise()
            this.fall()
        }
        this.moonAnimator.onfinish = () => {
            this.isPlay = false
        }
    },

    pause() {
        if (this.isPlay) {
            this.sunAnimator.pause()
            Logger.info(TAG, `isPlay=${this.isPlay}`)
            this.moonAnimator.pause()
            this.isPlay = false
        }
    },

    stop() {
        if (this.isPlay) {
            this.sunAnimator.finish()
            this.moonAnimator.finish()
            this.isPlay = false
        }
    },

    reverse() {
        this.sunAnimator.reverse()
        this.moonAnimator.reverse()
        this.sunAnimator.play()
        this.moonAnimator.play()
        this.isPlay = true
        this.moonAnimator.onfinish = () => {
            this.isPlay = false
        }
    }
}
