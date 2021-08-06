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

package ohos.samples.permissionapp.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.DataAbilityHelper;
import ohos.aafwk.ability.DataAbilityRemoteException;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.bundle.IBundleManager;
import ohos.data.resultset.ResultSet;
import ohos.location.Locator;
import ohos.media.audio.AudioCapturer;
import ohos.media.audio.AudioCapturerInfo;
import ohos.media.audio.AudioStreamInfo;
import ohos.media.photokit.metadata.AVStorage;
import ohos.samples.permissionapp.ResourceTable;
import ohos.samples.permissionapp.utils.Constants;
import ohos.samples.permissionapp.utils.LogUtil;
import ohos.security.SystemPermission;
import ohos.sysappcomponents.calendar.CalendarDataHelper;
import ohos.sysappcomponents.calendar.column.EventsColumns;
import ohos.sysappcomponents.calendar.entity.Events;

import java.util.Timer;
import java.util.TimerTask;

/**
 * Main AbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice implements Component.ClickedListener {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final int AUDIO_SAMPLE_RATE = 44100;

    private static final int AUDIO_RECORDING_TIME = 5000;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        findComponentById(ResourceTable.Id_get_location_permission).setClickedListener(this);
        findComponentById(ResourceTable.Id_get_microphone_permission).setClickedListener(this);
        findComponentById(ResourceTable.Id_get_calendar_permission).setClickedListener(this);
        findComponentById(ResourceTable.Id_get_storage_permission).setClickedListener(this);
    }

    @Override
    public void onClick(Component component) {
        switch (component.getId()) {
            case ResourceTable.Id_get_location_permission:
                accessLocation();
                break;
            case ResourceTable.Id_get_microphone_permission:
                accessMicrophone();
                break;
            case ResourceTable.Id_get_calendar_permission:
                accessCalendar();
                break;
            case ResourceTable.Id_get_storage_permission:
                accessStorage();
                break;
            default:
                LogUtil.warn(TAG, "Ignore click for component: " + component.getId());
        }
    }

    private void accessLocation() {
        try {
            new Locator(this).getCachedLocation();
            showTips(this, "Location access succeeded.");
        } catch (SecurityException e) {
            requestPermission(SystemPermission.LOCATION, Constants.PERM_LOCATION_REQ_CODE);
        }
    }

    private void accessMicrophone() {
        AudioStreamInfo audioStreamInfo = new AudioStreamInfo.Builder().encodingFormat(
            AudioStreamInfo.EncodingFormat.ENCODING_PCM_16BIT)
            .channelMask(AudioStreamInfo.ChannelMask.CHANNEL_IN_STEREO)
            .sampleRate(AUDIO_SAMPLE_RATE)
            .build();
        AudioCapturerInfo audioCapturerInfo = new AudioCapturerInfo.Builder().audioStreamInfo(audioStreamInfo).build();

        final Context context = this;
        try {
            AudioCapturer capturer = new AudioCapturer(audioCapturerInfo);
            capturer.start();
            showTips(this, "Start recording for 5 seconds.");

            new Timer().schedule(new TimerTask() {
                @Override
                public void run() {
                    capturer.stop();
                    context.getUITaskDispatcher().asyncDispatch(() -> showTips(context, "Stopped recording."));
                }
            }, AUDIO_RECORDING_TIME);
        } catch (IllegalArgumentException | SecurityException e) {
            requestPermission(SystemPermission.MICROPHONE, Constants.PERM_RECORD_AUDIO_REQ_CODE);
        }
    }

    private void accessCalendar() {
        CalendarDataHelper calendarDataHelper = CalendarDataHelper.creator(this, Events.class);
        try {
            calendarDataHelper.query(0, new String[] {EventsColumns.ACC_ID, EventsColumns.TITLE});
            showTips(this, "Calendar access succeeded.");
        } catch (DataAbilityRemoteException | SecurityException e) {
            requestPermission(SystemPermission.READ_CALENDAR, Constants.PERM_READ_CALENDAR_REQ_CODE);
        }
    }

    private void accessStorage() {
        DataAbilityHelper helper = DataAbilityHelper.creator(this);
        try {
            ResultSet resultSet = helper.query(AVStorage.Images.Media.EXTERNAL_DATA_ABILITY_URI,
                new String[] {AVStorage.Images.Media.ID}, null);
            int count = resultSet.getRowCount();
            LogUtil.info(TAG, "Images count: " + count);
            if (count == 0) {
                requestPermission(SystemPermission.READ_USER_STORAGE, Constants.PERM_READ_STORAGE_REQ_CODE);
                return;
            }
            showTips(this, "Image access succeeded");
        } catch (DataAbilityRemoteException e) {
            LogUtil.info(TAG, "get images failed: " + e.getLocalizedMessage());
        }
    }

    private void requestPermission(String permission, int requestCode) {
        if (verifySelfPermission(permission) == IBundleManager.PERMISSION_GRANTED) {
            showTips(this, "Permission already obtained");
            return;
        }
        if (!canRequestPermission(permission)) {
            showTips(this, "Cannot request Permission");
            LogUtil.error(TAG, "Cannot request Permission");
            return;
        }
        requestPermissionsFromUser(new String[] {permission}, requestCode);
    }

    private void showTips(Context context, String message) {
        new ToastDialog(context).setText(message).show();
    }
}
