/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import featureAbility from '@ohos.ability.featureability';
import RemoteDeviceModel from '../../../model/RemoteDeviceModel.js';
import PlayerModel from '../../../model/PlayerModel.js';
import KvStoreModel from '../../../model/KvStoreModel.js';

function getShownTimer(ms) {
    var seconds = Math.floor(ms / 1000);
    var sec = seconds % 60;
    var min = (seconds - sec) / 60;
    if (sec < 10) {
        sec = '0' + sec;
    }
    if (min < 10) {
        min = '0' + min;
    }
    return min + ':' + sec;
}

const REMOTE_ABILITY_STARTED = 'remoteAbilityStarted';
var DEVICE_LIST_LOCALHOST;

export default {
    data: {
        title: '',
        currentTimeText: '',
        totalTimeText: '',
        totalMs: 0,
        currentProgress: 0,
        deviceList: [],
        btnPlaySrc: '/common/media/ic_play.svg',
        albumSrc: '/common/media/album.png',
        remoteDeviceModel: new RemoteDeviceModel(),
        playerModel: new PlayerModel(),
        kvStoreModel: new KvStoreModel(),
        isDialogShowing: false,
        isSwitching: false,
    },
    onInit() {
        console.info('MusicPlayer[IndexPage] onInit');
        DEVICE_LIST_LOCALHOST = {
            name: this.$t('strings.localhost'),
            id: 'localhost',
        };
        this.deviceList = [DEVICE_LIST_LOCALHOST];
        let self = this;
        this.playerModel.setOnStatusChangedListener((isPlaying) => {
            console.info('MusicPlayer[IndexPage] on player status changed, isPlaying=' + isPlaying + ', refresh ui');
            self.playerModel.setOnPlayingProgressListener((currentTimeMs) => {
                self.currentTimeText = getShownTimer(currentTimeMs);
                self.currentProgress = Math.floor(currentTimeMs / self.totalMs * 100);
            });
            if (isPlaying) {
                self.btnPlaySrc = '/common/media/ic_pause.svg';
            } else {
                self.btnPlaySrc = '/common/media/ic_play.svg';
            }
        });
        this.playerModel.getPlaylist(() => {
            console.info('MusicPlayer[IndexPage] on playlist generated, refresh ui');

            featureAbility.getWant((error, want) => {
                console.info('MusicPlayer[IndexPage] featureAbility.getWant=' + JSON.stringify(want));
                var status = want.parameters;
                if (status) {
                    self.kvStoreModel.broadcastMessage(REMOTE_ABILITY_STARTED);
                    console.info('MusicPlayer[IndexPage] restorePlayingStatus');
                    self.playerModel.restorePlayingStatus(status, (index) => {
                        console.info('MusicPlayer[IndexPage] restorePlayingStatus finished, index=' + index);
                        if (index >= 0) {
                            self.refreshSongInfo(index);
                        } else {
                            self.playerModel.preLoad(0, () => {
                                self.refreshSongInfo(0);
                            });
                        }
                    });
                } else {
                    self.playerModel.preLoad(0, () => {
                        self.refreshSongInfo(0);
                    });
                }
            });
        });
    },
    onBackPress() {
        console.info('MusicPlayer[IndexPage] onBackPress isDialogShowing=' + this.isDialogShowing);
        if (this.isDialogShowing === true) {
            this.dismissDialog();
            return true;
        }
        return false;
    },
    onDestroy() {
        this.playerModel.release();
        this.remoteDeviceModel.unregisterDeviceListCallback();
    },
    refreshSongInfo(index) {
        console.info('MusicPlayer[IndexPage] refreshSongInfo ' + index + '/'
        + this.playerModel.playlist.audioFiles.length);
        if (index >= this.playerModel.playlist.audioFiles.length) {
            console.warn('MusicPlayer[IndexPage] refreshSongInfo ignored');
            return;
        }
        // update song title
        this.title = this.playerModel.playlist.audioFiles[index].name;
        this.albumSrc = (index % 2 === 0) ? '/common/media/album.png' : '/common/media/album2.png';

        // update duration
        this.totalMs = this.playerModel.getDuration();
        this.totalTimeText = getShownTimer(this.totalMs);
        this.currentTimeText = getShownTimer(this.playerModel.getCurrentMs());
        this.currentProgress = Math.floor(this.playerModel.getCurrentMs() / this.totalMs * 100);

        console.info('MusicPlayer[IndexPage] refreshSongInfo this.title=' + this.title + ' this.totalMs='
        + this.totalMs + ' this.totalTimeText=' + this.totalTimeText + ' this.currentTimeText=' + this.currentTimeText);
    },
    setProgress(e) {
        console.info('MusicPlayer[IndexPage] setProgress ' + e.mode + ', ' + e.value);
        this.currentProgress = e.value;
        if (isNaN(this.totalMs)) {
            this.currentProgress = 0;
            console.info('MusicPlayer[IndexPage] setProgress ignored, totalMs=' + this.totalMs);
            return;
        }
        var currentMs = this.currentProgress / 100 * this.totalMs;
        this.currentTimeText = getShownTimer(currentMs);
        if (e.mode === 'end' || e.mode === 'click') {
            console.info('MusicPlayer[IndexPage] player.seek ' + currentMs);
            this.playerModel.seek(currentMs);
        }
    },
    onPreviousClick() {
        if (this.isSwitching) {
            console.info('MusicPlayer[IndexPage] onPreviousClick ignored, isSwitching');
            return;
        }
        console.info('MusicPlayer[IndexPage] onPreviousClick');
        this.playerModel.index--;
        if (this.playerModel.index < 0 && this.playerModel.playlist.audioFiles.length >= 1) {
            this.playerModel.index = this.playerModel.playlist.audioFiles.length - 1;
        }
        this.currentProgress = 0;
        this.isSwitching = true;
        let self = this;
        this.playerModel.preLoad(this.playerModel.index, () => {
            self.refreshSongInfo(self.playerModel.index);
            self.playerModel.play(0, true);
            self.isSwitching = false;
        });
    },
    onNextClick() {
        if (this.isSwitching) {
            console.info('MusicPlayer[IndexPage] onNextClick ignored, isSwitching');
            return;
        }
        console.info('MusicPlayer[IndexPage] onNextClick');
        this.playerModel.index++;
        if (this.playerModel.index >= this.playerModel.playlist.audioFiles.length) {
            this.playerModel.index = 0;
        }
        this.currentProgress = 0;
        this.isSwitching = true;
        let self = this;
        this.playerModel.preLoad(this.playerModel.index, () => {
            self.refreshSongInfo(self.playerModel.index);
            self.playerModel.play(0, true);
            self.isSwitching = false;
        });
    },
    onPlayClick() {
        if (this.isSwitching) {
            console.info('MusicPlayer[IndexPage] onPlayClick ignored, isSwitching');
            return;
        }
        console.info('MusicPlayer[IndexPage] onPlayClick, isPlaying=' + this.playerModel.isPlaying);
        if (this.playerModel.isPlaying) {
            this.playerModel.pause();
        } else {
            this.playerModel.preLoad(this.playerModel.index, () => {
                this.playerModel.play(-1, true);
            });
        }
    },
    onContinueAbilityClick() {
        console.info('MusicPlayer[IndexPage] onContinueAbilityClick');
        let self = this;
        this.remoteDeviceModel.registerDeviceListCallback(() => {
            console.info('MusicPlayer[IndexPage] registerDeviceListCallback, callback entered');
            var list = [];
            list[0] = DEVICE_LIST_LOCALHOST;
            var deviceList = self.remoteDeviceModel.deviceList;
            console.info('MusicPlayer[IndexPage] on remote device updated, count=' + deviceList.length);
            for (var i = 0; i < deviceList.length; i++) {
                console.info('MusicPlayer[IndexPage] device ' + i + '/' + deviceList.length + ' deviceId='
                + deviceList[i].deviceId + ' deviceName=' + deviceList[i].deviceName + ' deviceType='
                + deviceList[i].deviceType);
                list[i + 1] = {
                    name: deviceList[i].deviceName,
                    id: deviceList[i].deviceId,
                };
            }
            self.deviceList = list;
        });
        this.$element('continueAbilityDialog').show();
        this.isDialogShowing = true;
    },
    startAbilityContinuation(deviceId, deviceName) {
        this.$element('continueAbilityDialog').close();
        var params;
        if (this.playerModel.index >= 0 && this.playerModel.index <= this.playerModel.playlist.audioFiles.length) {
            params = {
                uri: this.playerModel.playlist.audioFiles[this.playerModel.index].fileUri,
                seekTo: this.playerModel.getCurrentMs(),
                isPlaying: this.playerModel.isPlaying
            };
        } else {
            params = {
                uri: '',
                seekTo: 0,
                isPlaying: false
            };
        }
        console.info('MusicPlayer[IndexPage] featureAbility.startAbility deviceId=' + deviceId
        + ' deviceName=' + deviceName);
        var wantValue = {
            bundleName: 'com.ohos.distributedmusicplayer',
            abilityName: 'com.ohos.distributedmusicplayer.MainAbility',
            deviceId: deviceId,
            parameters: params
        };
        featureAbility.startAbility({
            want: wantValue
        }).then((data) => {
            console.info('MusicPlayer[IndexPage] featureAbility.startAbility finished, ' + JSON.stringify(data));
        });
        console.info('MusicPlayer[IndexPage] featureAbility.startAbility want=' + JSON.stringify(wantValue));
        console.info('MusicPlayer[IndexPage] featureAbility.startAbility end');
        this.kvStoreModel.setOnMessageReceivedListener(REMOTE_ABILITY_STARTED, () => {
            console.info('MusicPlayer[IndexPage] OnMessageReceived, terminateAbility');
            featureAbility.terminateAbility();
        });
    },
    onRadioChange(inputValue, e) {
        console.info('MusicPlayer[IndexPage] onRadioChange ' + inputValue + ', ' + e.value);
        if (inputValue === e.value) {
            if (e.value === 'localhost') {
                this.$element('continueAbilityDialog').close();
                return;
            }
            let self = this;
            for (var i = 0; i < this.deviceList.length; i++) {
                if (this.deviceList[i].id === e.value) {
                    this.startAbilityContinuation(this.deviceList[i].id, this.deviceList[i].name);
                }
            }
        }
    },
    cancelDialog(e) {
        this.remoteDeviceModel.unregisterDeviceListCallback();
        this.isDialogShowing = false;
    },
    onDismissDialogClicked(e) {
        this.dismissDialog();
    },
    dismissDialog() {
        this.$element('continueAbilityDialog').close();
        this.remoteDeviceModel.unregisterDeviceListCallback();
        this.isDialogShowing = false;
    }
};
