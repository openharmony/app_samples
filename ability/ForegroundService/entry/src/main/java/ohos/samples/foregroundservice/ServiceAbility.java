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

package ohos.samples.foregroundservice;

import static ohos.samples.foregroundservice.slice.MainAbilitySlice.EVENT_ACTION;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.ability.LocalRemoteObject;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.utils.Color;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.notification.NotificationHelper;
import ohos.event.notification.NotificationRequest;
import ohos.event.notification.NotificationSlot;
import ohos.global.resource.RawFileDescriptor;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.common.Source;
import ohos.media.player.Player;
import ohos.rpc.IRemoteObject;
import ohos.rpc.RemoteException;

import java.io.IOException;

/**
 * Music Play Service
 *
 * @since 2021-05-08
 */
public class ServiceAbility extends Ability {
    /**
     * Music PlayState
     */
    public static final int PLAY_STATE = 0;

    /**
     * Music PauseState
     */
    public static final int PAUSE_STATE = 1;

    /**
     * Music StopState
     */
    public static final int STOP_STATE = 2;

    private static final String TAG = "ServiceAbility";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private int state = STOP_STATE;

    private Player player;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
    }

    @Override
    public void onCommand(Intent intent, boolean isRestart, int startId) {
        super.onCommand(intent, isRestart, startId);
        sendEvent();
    }

    @Override
    public IRemoteObject onConnect(Intent intent) {
        return new MusicRemoteObject(this);
    }

    @Override
    public void onDisconnect(Intent intent) {
        super.onDisconnect(intent);
    }

    @Override
    public void onStop() {
        super.onStop();
        cancelNotification();
        if (player != null) {
            player.release();
            player = null;
        }
    }

    private void sendEvent() {
        try {
            Intent intent = new Intent();
            Operation operation = new Intent.OperationBuilder()
                    .withAction(EVENT_ACTION)
                    .build();
            intent.setOperation(operation);
            intent.setParam("state", state);
            CommonEventData eventData = new CommonEventData(intent);
            CommonEventManager.publishCommonEvent(eventData);
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "Exception occurred during publishCommonEvent invocation.");
        }
    }

    private void sendNotification(String str) {
        String slotId = "foregroundServiceId";
        String slotName = "foregroundServiceName";
        NotificationSlot slot = new NotificationSlot(slotId, slotName, NotificationSlot.LEVEL_MIN);
        slot.setDescription("NotificationSlot Description");
        slot.setEnableVibration(true);
        slot.setLockscreenVisibleness(NotificationRequest.VISIBLENESS_TYPE_PUBLIC);
        slot.setEnableLight(true);
        slot.setLedLightColor(Color.RED.getValue());
        try {
            NotificationHelper.addNotificationSlot(slot);
        } catch (RemoteException ex) {
            HiLog.error(LABEL_LOG, "Exception occurred during addNotificationSlot invocation.");
        }
        int notificationId = 1;
        NotificationRequest request = new NotificationRequest(notificationId);
        request.setSlotId(slot.getId());
        String title = "Music Player";
        String text = "The Music Service is in " + str;
        NotificationRequest.NotificationNormalContent content = new NotificationRequest.NotificationNormalContent();
        content.setTitle(title)
                .setText(text);
        NotificationRequest.NotificationContent notificationContent =
                new NotificationRequest.NotificationContent(content);
        request.setContent(notificationContent);
        keepBackgroundRunning(notificationId, request);
    }

    private void cancelNotification() {
        cancelBackgroundRunning();
    }

    /**
     * Start Play Music
     */
    public void startMusic() {
        if (state != STOP_STATE) {
            return;
        }
        player = new Player(getContext());
        try {
            RawFileDescriptor filDescriptor;
            filDescriptor = getResourceManager().getRawFileEntry("resources/rawfile/Homey.mp3").openRawFileDescriptor();
            Source source = new Source(filDescriptor.getFileDescriptor(), filDescriptor.getStartPosition(),
                    filDescriptor.getFileSize());
            player.setSource(source);
            player.prepare();
            player.play();
            player.enableSingleLooping(true);
            state = PLAY_STATE;
            sendNotification("Playing");
            sendEvent();
        } catch (IOException e) {
            HiLog.error(LABEL_LOG, "Exception occurred during openRawFileDescriptor invocation.");
        }
    }

    /**
     * Stop Play Music
     */
    public void stopMusic() {
        if (state == STOP_STATE) {
            return;
        }
        player.stop();
        player.release();
        player = null;
        state = STOP_STATE;
        cancelNotification();
        sendEvent();
    }

    /**
     * Pause Play Music
     */
    public void pauseMusic() {
        switch (state) {
            case PAUSE_STATE: {
                player.play();
                state = PLAY_STATE;
                sendNotification("Playing");
                sendEvent();
                break;
            }
            case PLAY_STATE: {
                player.pause();
                state = PAUSE_STATE;
                sendNotification("Pausing");
                sendEvent();
                break;
            }
            default:
                break;
        }
    }

    /**
     * LocalRemoteObject Implementation
     *
     * @since 2021-05-08
     */
    public static class MusicRemoteObject extends LocalRemoteObject {
        private final ServiceAbility musicService;

        MusicRemoteObject(ServiceAbility musicService) {
            this.musicService = musicService;
        }

        /**
         * startPlay Music
         */
        public void startPlay() {
            musicService.startMusic();
        }

        /**
         * pausePlay Music
         */
        public void pausePlay() {
            musicService.pauseMusic();
        }

        /**
         * stopPlay Music
         */
        public void stopPlay() {
            musicService.stopMusic();
        }
    }
}