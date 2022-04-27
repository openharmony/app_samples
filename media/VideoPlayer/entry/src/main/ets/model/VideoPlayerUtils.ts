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

const TAG: string = 'VideoPlayerUtils'

export default class VideoPlayerUtils {
    private videoPlayer = undefined
    private playPath: string = ''
    private surfaceID: string = ''
    private finishCallBack: () => void = undefined

    async initVideoPlayer(playSrc, surfaceID) {
        await this.release()
        this.playPath = playSrc
        this.surfaceID = surfaceID
        this.videoPlayer = await media.createVideoPlayer()
        Logger.info(TAG, 'createVideoPlayer')
        this.videoPlayer.url = this.playPath
        this.videoPlayer.on('playbackCompleted', () => {
            Logger.info(TAG, 'play finish')
            this.seek(0)
            if (this.finishCallBack) {
                this.finishCallBack()
            }
        });
        await this.videoPlayer.setDisplaySurface(this.surfaceID)
        Logger.info(TAG, 'setDisplaySurface')
        await this.videoPlayer.prepare()
        await this.videoPlayer.play()
        Logger.info(TAG, 'start play')
    }

    async play() {
        Logger.info(TAG, 'play')
        if (typeof (this.videoPlayer) != 'undefined') {
            await this.videoPlayer.play()
        }
    }

    async seek(time) {
        Logger.info(TAG, 'seek')
        if (typeof (this.videoPlayer) != 'undefined') {
            await this.videoPlayer.seek(time)
        }
    }

    getCurrentTime() {
        if (typeof (this.videoPlayer) != 'undefined') {
            return this.videoPlayer.currentTime
        }
        return 0
    }

    async pause() {
        Logger.info(TAG, 'pause')
        if (typeof (this.videoPlayer) != 'undefined') {
            await this.videoPlayer.pause()
        }
    }

    async stop() {
        Logger.info(TAG, 'stop')
        if (typeof (this.videoPlayer) != 'undefined') {
            await this.videoPlayer.stop()
        }
    }

    async reset(playSrc) {
        if (typeof (this.videoPlayer) != 'undefined') {
            this.playPath = playSrc
            await this.videoPlayer.reset()
            this.videoPlayer.url = this.playPath
            await this.videoPlayer.prepare()
            await this.videoPlayer.play()
        }
    }

    async release() {
        if (typeof (this.videoPlayer) != 'undefined') {
            await this.videoPlayer.release()
            Logger.info(TAG, 'release success')
        }
    }

    setFinishCallBack(callback) {
        this.finishCallBack = callback
    }
}