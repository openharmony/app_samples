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

package ohos.samples.distributedmusicplayer.utils;

import ohos.app.Context;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.global.resource.BaseFileDescriptor;
import ohos.global.resource.RawFileEntry;
import ohos.media.player.Player;

import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;

/**
 * player manager
 */
public class PlayerManager {
    private static final String TAG = PlayerManager.class.getSimpleName();

    private static final int PLAY_STATE_PLAY = 0x0000001;

    private static final int PLAY_STATE_PAUSE = 0x0000002;

    private static final int PLAY_STATE_FINISH = 0x0000003;

    private static final int PLAY_STATE_PROGRESS = 0x0000004;

    private static final int DELAY_TIME = 1000;

    private static final int PERIOD = 1000;

    private Player musicPlayer;

    private Context context;

    private String currentUri;

    private TimerTask timerTask;

    private Timer timer;

    private PlayerStateListener playerStateListener;

    private boolean isPrepared;

    public PlayerManager(Context context, String currentUri) {
        this.context = context;
        this.currentUri = currentUri;
    }

    /**
     * init media resource
     */
    public void init() {
        musicPlayer = new Player(context);
        musicPlayer.setPlayerCallback(new PlayCallBack());
        setResource(currentUri);
    }

    /**
     * set source
     *
     * @param uri music uri
     */
    public void setResource(String uri) {
        LogUtil.info(TAG, "uri:  " + uri);
        try {
            RawFileEntry rawFileEntry = context.getResourceManager().getRawFileEntry(uri);
            BaseFileDescriptor baseFileDescriptor = rawFileEntry.openRawFileDescriptor();

            if (!musicPlayer.setSource(baseFileDescriptor)) {
                LogUtil.info(TAG, "uri is invalid");
                return;
            }
            isPrepared = musicPlayer.prepare();
            playerStateListener.onUriSet(
                currentUri.substring(currentUri.lastIndexOf("/") + 1, currentUri.lastIndexOf(".")));
        } catch (IOException e) {
            LogUtil.error(TAG, "io exception");
        }
    }

    /**
     * play
     */
    public void play() {
        if (!isPrepared) {
            LogUtil.error(TAG, "prepare fail");
            return;
        }
        if (!musicPlayer.play()) {
            LogUtil.error(TAG, "play fail");
            return;
        }
        startTask();
        handler.sendEvent(PLAY_STATE_PLAY);
    }

    /**
     * pause
     */
    public void pause() {
        if (!musicPlayer.pause()) {
            LogUtil.info(TAG, "pause fail");
            return;
        }
        finishTask();
        handler.sendEvent(PLAY_STATE_PAUSE);
    }

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            switch (event.eventId) {
                case PLAY_STATE_PLAY: {
                    playerStateListener.onPlaySuccess(getTotalTime());
                    break;
                }
                case PLAY_STATE_PAUSE: {
                    playerStateListener.onPauseSuccess();
                    break;
                }
                case PLAY_STATE_FINISH: {
                    playerStateListener.onMusicFinished();
                    break;
                }
                case PLAY_STATE_PROGRESS: {
                    playerStateListener.onPositionChange(musicPlayer.getCurrentTime());
                    break;
                }
                default:
                    break;
            }
        }
    };

    private void startTask() {
        finishTask();
        timerTask = new TimerTask() {
            @Override
            public void run() {
                handler.sendEvent(PLAY_STATE_PROGRESS);
            }
        };
        timer = new Timer();
        timer.schedule(timerTask, DELAY_TIME, PERIOD);
    }

    private void finishTask() {
        if (timer != null && timerTask != null) {
            timer.cancel();
            timer = null;
            timerTask = null;
        }
    }

    /**
     * get duration
     *
     * @return total time
     */
    public int getTotalTime() {
        return musicPlayer.getDuration();
    }

    /**
     * switch music
     *
     * @param uri music uri
     */
    public void switchMusic(String uri) {
        currentUri = uri;
        setResource(currentUri);
        play();
    }

    /**
     * changes the playback position
     *
     * @param currentTime current time
     */
    public void rewindTo(int currentTime) {
        musicPlayer.rewindTo(currentTime * 1000);
    }

    /**
     * release
     */
    public void releasePlayer() {
        if (musicPlayer == null) {
            return;
        }
        musicPlayer.stop();
        musicPlayer.release();
    }

    /**
     * play state
     *
     * @return true:playing , false:pause
     */
    public boolean isPlaying() {
        return musicPlayer.isNowPlaying();
    }

    private class PlayCallBack implements Player.IPlayerCallback {
        @Override
        public void onPrepared() {
            LogUtil.info(TAG, "onPrepared");
        }

        @Override
        public void onMessage(int type, int extra) {
            LogUtil.info(TAG, "onMessage  " + type + "-" + extra);
        }

        @Override
        public void onError(int errorType, int errorCode) {
            LogUtil.info(TAG, "onError  " + errorType + "-" + errorCode);
        }

        @Override
        public void onResolutionChanged(int width, int height) {
            LogUtil.info(TAG, "onResolutionChanged  " + width + "-" + height);
        }

        @Override
        public void onPlayBackComplete() {
            handler.sendEvent(PLAY_STATE_FINISH);
            LogUtil.info(TAG, "onPlayBackComplete");
        }

        @Override
        public void onRewindToComplete() {
            LogUtil.info(TAG, "onRewindToComplete");
        }

        @Override
        public void onBufferingChange(int percent) {
            LogUtil.info(TAG, percent + "");
        }

        @Override
        public void onNewTimedMetaData(Player.MediaTimedMetaData mediaTimedMetaData) {
            LogUtil.info(TAG, "onNewTimedMetaData");
        }

        @Override
        public void onMediaTimeIncontinuity(Player.MediaTimeInfo mediaTimeInfo) {
            LogUtil.info(TAG, "onNewTimedMetaData");
        }
    }

    /**
     * player state listener
     *
     * @param playerStateListener listener
     */
    public void setPlayerStateListener(PlayerStateListener playerStateListener) {
        this.playerStateListener = playerStateListener;
    }
}
