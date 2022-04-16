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

import rpc from "@ohos.rpc"
import wantAgent from '@ohos.wantAgent';
import backgroundTaskManager from '@ohos.backgroundTaskManager';
import featureAbility from '@ohos.ability.featureAbility';
import media from '@ohos.multimedia.media'
import fileIO from '@ohos.fileio'
import logger from '../MainAbility/utils/logger'

const TAG: string = '[flybirdDebug.ServiceAbility]'

class FirstServiceAbilityStub extends rpc.RemoteObject {
    private audioPlayer;
    constructor(des: any) {
        if (typeof des === 'string') {
            super(des)
        } else {
            return
        }
    }

    onRemoteRequest(code: number, data: any, reply: any, option: any) {
        logger.log(`${TAG}onRemoteRequest called`)
        if (code === 1) {
            let dataStr = data.readString()
            logger.log(`${TAG} string=${dataStr}`)
            if (dataStr === 'start_game') {
                this.startContinousTask();
                let result = 'ok start game'
                logger.log(`${TAG} result=${result}`)
                reply.writeString(result)
            } else if (dataStr === 'disconnect_service') {
                this.stopContinousTask();
                let result = 'ok disconnect service'
                logger.log(`${TAG} result=${result}`)
                reply.writeString(result)
            } else if (dataStr === 'restart_music') {
                this.audioPlayer.pause();
                this.audioPlayer.release();
                this.startContinousTask();
                let result = 'ok restart music'
                logger.log(`${TAG} result=${result}`)
                reply.writeString(result)
            } else {
                logger.log(`${TAG} error string}`)
            }
        } else {
            logger.log(`${TAG} unknown request code`)
        }
        return true;
    }

    stopContinousTask() {
        backgroundTaskManager.stopBackgroundRunning(featureAbility.getContext()).then((data) => {
            logger.info(TAG + "stop backgroundRunning promise success");
            this.audioPlayer.pause();
            this.audioPlayer.release();
        }).catch((error) => {
            logger.error(TAG + " stop backgroundRunning failed because: " + JSON.stringify(error));
        })
    }

    startContinousTask() {
        logger.info(TAG + " start background continousTask api");

        let wantAgentInfo = {
            wants: [
                {
                    bundleName: "com.example.flybird",
                    abilityName: "com.example.flybird.MainAbility"
                }
            ],
            operationType:wantAgent.OperationType.START_ABILITY,
            requestCode: 0,
            wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
        };

        wantAgent.getWantAgent(wantAgentInfo).then((data) => {
            logger.info(TAG + " start background continousTask api begin");
            backgroundTaskManager.startBackgroundRunning(featureAbility.getContext(), backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, data, this.callback);

            this.audioPlayer = media.createAudioPlayer();
            this.SetCallback();
            let path = 'data/12664.mp3';
            fileIO.open(path).then((number) => {
                 let fdpath = 'fd://'
                 fdpath = fdpath + '' + number;
                 this.audioPlayer.src = fdpath;
                logger.info('open fd sucess fd is' + fdpath);
            }).catch((err) => {
                logger.info("err:" + err);
            });
            //audioPlayer.setVolume(0.5);
            this.audioPlayer.loop = true;
        });
    }

    SetCallback() {
        this.audioPlayer.on('dataLoad', () => {
            logger.info(TAG + ' audio set source success');
            this.audioPlayer.play();
        });
        this.audioPlayer.on('play', () => {
            logger.info(TAG + ' audio play success');
        })
        this.audioPlayer.on('finish', () => {
            logger.info(TAG + ' audio play finish');
            this.audioPlayer.release();
            this.audioPlayer.undefined;
        })
    }

     callback(err, data) {
        if (err) {
            logger.error(TAG + "Operation failed Cause: " + err);
        } else {
            logger.info(TAG + "Operation succeeded");
        }
    }

}

export default {
    onStart() {
        logger.info(`${TAG} onStart`)
    },
    onStop() {
        logger.info(`${TAG} onStop`)
    },
    onConnect(want) {
        logger.log(`${TAG} onConnect, want:${JSON.stringify(want)}`)
        return new FirstServiceAbilityStub("first ts service stub")
    },
    onDisconnect(want) {
        logger.log(`${TAG} onDisconnect, want:${JSON.stringify(want)}`)
    },
    onCommand(want, startId) {
        logger.log(`${TAG} onCommand, want:${JSON.stringify(want)},startId:${startId}`)
    }
};