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

import audio from '@ohos.multimedia.audio'
import PlayerModel from '../../common/PlayerModel.js';

export default {
    data: {
        title: '',
        audioUrl: '',
        index: 0,
        audioPlayer: null,
        isSwitching: false,
        playerModel: new PlayerModel(),
        audioManager: null,
        volume: 0
    },
    onInit() {
        this.audioUrl = 'common/images/pause.png';
        this.playerModel.setOnStatusChangedListener((isPlaying) => {
            console.info('MusicPlayer[IndexPage] on player status changed, isPlaying=' + isPlaying + ', refresh ui');
            if (isPlaying) {
                this.audioUrl = 'common/images/play.png';
            } else {
                this.audioUrl = 'common/images/pause.png';
            }
        });
        this.playerModel.getPlaylist(() => {
            console.info('MusicPlayer[IndexPage] on playlist generated, refresh ui');
        });
        this.title = this.playerModel.playlist.audioFiles[this.index].name;
        this.audioManager = audio.getAudioManager();
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
            this.playerModel.preLoad(this.index, () => {
                this.playerModel.play(-1, true);
            });
        }
    },
    onPreviousClick() {
        if (this.isSwitching) {
            console.info('MusicPlayer[IndexPage] onPreviousClick ignored, isSwitching');
            return;
        }
        console.info('MusicPlayer[IndexPage] onPreviousClick');
        this.index--;
        if (this.index < 0 && this.playerModel.playlist.audioFiles.length >= 1) {
            this.index = this.playerModel.playlist.audioFiles.length - 1;
        }
        this.currentProgress = 0;
        this.isSwitching = true;
        let self = this;
        this.playerModel.preLoad(this.index, () => {
            self.playerModel.play(0, true);
            self.isSwitching = false;
        });
        this.title = this.playerModel.playlist.audioFiles[this.index].name;
    },
    onNextClick() {
        if (this.isSwitching) {
            console.info('MusicPlayer[IndexPage] onNextClick ignored, isSwitching');
            return;
        }
        console.info('MusicPlayer[IndexPage] onNextClick');
        this.index++;
        if (this.index >= this.playerModel.playlist.audioFiles.length) {
            this.index = 0;
        }
        this.currentProgress = 0;
        this.isSwitching = true;
        let self = this;
        this.playerModel.preLoad(this.index, () => {
            self.playerModel.play(0, true);
            self.isSwitching = false;
        });
        this.title = this.playerModel.playlist.audioFiles[this.index].name;
    },
    media(e) {
        this.volume = e.value
        this.audioManager.setVolume(audio.AudioVolumeType.MEDIA, this.volume).then(() => {
            console.log('Promise returned to indicate a successful volume setting.');
        })

    },
    showPanel() {
        this.$element('showPanel').show();
    },
    closePanel() {
        this.$element('showPanel').close();
    }
}



