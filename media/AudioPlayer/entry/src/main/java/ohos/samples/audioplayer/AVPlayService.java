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

package ohos.samples.audioplayer;

import ohos.samples.audioplayer.model.AVElementManager;
import ohos.samples.audioplayer.utils.LogUtil;

import ohos.aafwk.content.Intent;
import ohos.event.notification.NotificationRequest;
import ohos.media.common.AVDescription;
import ohos.media.common.AVMetadata;
import ohos.media.common.Source;
import ohos.media.common.sessioncore.AVBrowserResult;
import ohos.media.common.sessioncore.AVBrowserRoot;
import ohos.media.common.sessioncore.AVPlaybackState;
import ohos.media.common.sessioncore.AVSessionCallback;
import ohos.media.player.Player;
import ohos.media.sessioncore.AVBrowserService;
import ohos.media.sessioncore.AVSession;
import ohos.utils.PacMap;
import ohos.utils.net.Uri;

import java.util.Timer;
import java.util.TimerTask;

/**
 * The service of the player, that base on AVBrowserService.
 */
public class AVPlayService extends AVBrowserService {
    private static final String TAG = AVPlayService.class.getSimpleName();

    /**
     * parent media id 1
     */
    public static final String PARENT_MEDIA_ID_1 = "PARENT_MEDIA_ID_1";

    /**
     * parent media id 2
     */
    public static final String PARENT_MEDIA_ID_2 = "PARENT_MEDIA_ID_2";

    private static final int NOTIFICATION_ID = 1005;

    private static final String NOTIFICATION_TITLE = "audioPlayer";

    private static final String NOTIFICATION_TEXT = "audioPlayer is running";

    private static final int TIME_DELAY = 500;

    private static final int TIME_LOOP = 1000;

    private AVElementManager avElementManager;

    private AVSession avSession;

    private Player player;

    private final Timer timer = new Timer();

    private ProgressTimerTask progressTimerTask;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        LogUtil.info(TAG, "onStart");
        avElementManager = new AVElementManager(getApplicationContext());

        AVPlaybackState avPlaybackState = new AVPlaybackState.Builder().setAVPlaybackState(
            AVPlaybackState.PLAYBACK_STATE_NONE, 0, 1.0f).build();

        avSession = new AVSession(getApplicationContext(), AVPlayService.class.getName());
        avSession.setAVSessionCallback(avSessionCallback);
        avSession.setAVPlaybackState(avPlaybackState);
        setAVToken(avSession.getAVToken());

        player = new Player(getApplicationContext());
        // create notification and 1005 is notificationId
        NotificationRequest request = new NotificationRequest(NOTIFICATION_ID);
        NotificationRequest.NotificationNormalContent content = new NotificationRequest.NotificationNormalContent();
        content.setTitle(NOTIFICATION_TITLE).setText(NOTIFICATION_TEXT);
        NotificationRequest.NotificationContent notificationContent = new NotificationRequest.NotificationContent(
            content);
        request.setContent(notificationContent);
        keepBackgroundRunning(NOTIFICATION_ID, request);
    }

    @Override
    public void onStop() {
        super.onStop();
        // this service will be cancel background running after this is called
        cancelBackgroundRunning();
        LogUtil.info(TAG, "onDestroy");
        if (player != null) {
            player.release();
            player = null;
        }
        if (avSession != null) {
            avSession.setAVSessionCallback(null);
            avSession.release();
            avSession = null;
        }
        if (progressTimerTask != null) {
            progressTimerTask.cancel();
            progressTimerTask = null;
        }
    }

    @Override
    public AVBrowserRoot onGetRoot(String clientPackageName, int clientUid, PacMap rootHints) {
        LogUtil.info(TAG, "onGetRoot");
        return new AVBrowserRoot(PARENT_MEDIA_ID_1, null);
    }

    @Override
    public void onLoadAVElementList(String parentId, AVBrowserResult result) {
        LogUtil.info(TAG, "onLoadAVElementList");
        result.detachForRetrieveAsync();
        switch (parentId) {
            case PARENT_MEDIA_ID_1: {
                result.sendAVElementList(avElementManager.getAvQueueElements());
                break;
            }
            case PARENT_MEDIA_ID_2:
            default:
                break;
        }
    }

    @Override
    public void onLoadAVElementList(String parentId, AVBrowserResult avBrowserResult, PacMap pacMap) {
        LogUtil.info(TAG, "onLoadAVElementList-2");
    }

    @Override
    public void onLoadAVElement(String parentId, AVBrowserResult avBrowserResult) {
        LogUtil.info(TAG, "onLoadAVElement");
    }

    private final AVSessionCallback avSessionCallback = new AVSessionCallback() {
        @Override
        public void onPlay() {
            super.onPlay();
            LogUtil.info(TAG + "-AVSessionCallback", "onPlay");
            if (avSession.getAVController().getAVPlaybackState().getAVPlaybackState()
                == AVPlaybackState.PLAYBACK_STATE_PAUSED) {
                player.play();
                AVPlaybackState avPlaybackState = new AVPlaybackState.Builder().setAVPlaybackState(
                    AVPlaybackState.PLAYBACK_STATE_PLAYING, player.getCurrentTime(), player.getCurrentTime()).build();
                avSession.setAVPlaybackState(avPlaybackState);
                startProgressTaskTimer();
            }
        }

        @Override
        public void onPause() {
            super.onPause();
            LogUtil.info(TAG + "-AVSessionCallback", "onPause");
            if (avSession.getAVController().getAVPlaybackState().getAVPlaybackState()
                == AVPlaybackState.PLAYBACK_STATE_PLAYING) {
                player.pause();
                AVPlaybackState avPlaybackState = new AVPlaybackState.Builder().setAVPlaybackState(
                    AVPlaybackState.PLAYBACK_STATE_PAUSED, player.getCurrentTime(), player.getPlaybackSpeed()).build();
                avSession.setAVPlaybackState(avPlaybackState);
            }
        }

        @Override
        public void onPlayNext() {
            super.onPlayNext();
            LogUtil.info(TAG + "-AVSessionCallback", "onPlayNext");
            AVDescription next = avElementManager.getNextAVElement().get().getAVDescription();
            play(next);
        }

        @Override
        public void onPlayPrevious() {
            super.onPlayPrevious();
            LogUtil.info(TAG + "-AVSessionCallback", "onPlayPrevious");
            AVDescription previous = avElementManager.getPreviousAVElement().get().getAVDescription();
            play(previous);
        }

        private void play(AVDescription description) {
            if (player == null) {
                player = new Player(getApplicationContext());
            }
            player.reset();
            player.setSource(new Source(description.getMediaUri().toString()));
            player.prepare();
            player.rewindTo(0);
            player.play();

            AVPlaybackState avPlaybackState = new AVPlaybackState.Builder().setAVPlaybackState(
                    AVPlaybackState.PLAYBACK_STATE_PLAYING, player.getCurrentTime(),
                    player.getPlaybackSpeed()).build();
            avSession.setAVPlaybackState(avPlaybackState);
            avSession.setAVMetadata(getAVMetadata(description));
            startProgressTaskTimer();
        }

        private AVMetadata getAVMetadata(AVDescription description) {
            PacMap extrasPacMap = description.getExtras();
            return new AVMetadata.Builder().setString(AVMetadata.AVTextKey.TITLE, description.getTitle().toString())
                .setLong(AVMetadata.AVLongKey.DURATION, extrasPacMap.getLongValue(AVMetadata.AVLongKey.DURATION))
                .setString(AVMetadata.AVTextKey.META_URI, description.getMediaUri().toString())
                .build();
        }

        private void startProgressTaskTimer() {
            if (progressTimerTask != null) {
                progressTimerTask.cancel();
            }
            progressTimerTask = new ProgressTimerTask();
            timer.schedule(progressTimerTask, TIME_DELAY, TIME_LOOP);
        }

        @Override
        public void onPlayByUri(Uri uri, PacMap extras) {
            LogUtil.info(TAG + "-AVSessionCallback", "onPlayByUri");
            switch (avSession.getAVController().getAVPlaybackState().getAVPlaybackState()) {
                case AVPlaybackState.PLAYBACK_STATE_PAUSED:
                case AVPlaybackState.PLAYBACK_STATE_NONE: {
                    avElementManager.setCurrentAVElement(uri);
                    AVDescription current = avElementManager.getCurrentAVElement().getAVDescription();
                    play(current);
                    break;
                }
                default:
                    break;
            }
        }

        @Override
        public void onPlayBySearch(String query, PacMap extras) {
            LogUtil.info(TAG + "-AVSessionCallback", "onPlayBySearch");
        }

        @Override
        public void onSetAVPlaybackCustomAction(String action, PacMap extras) {
            super.onSetAVPlaybackCustomAction(action, extras);
            LogUtil.info(TAG + "-AVSessionCallback", "onSetAVPlaybackCustomAction");
        }
    };

    // used to get the playing status in period
    class ProgressTimerTask extends TimerTask {
        @Override
        public void run() {
            if (avSession.getAVController().getAVPlaybackState().getAVPlaybackState()
                == AVPlaybackState.PLAYBACK_STATE_PLAYING) {
                AVPlaybackState avPlaybackState = new AVPlaybackState.Builder().setAVPlaybackState(
                    AVPlaybackState.PLAYBACK_STATE_PLAYING, player.getCurrentTime(), player.getPlaybackSpeed()).build();
                avSession.setAVPlaybackState(avPlaybackState);
            }
        }
    }
}
