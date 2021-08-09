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

package ohos.timer.slice;

import ohos.timer.ResourceTable;
import ohos.timer.interfaces.TimerEventListener;
import ohos.timer.timerpluginutils.TimeData;
import ohos.timer.timerpluginutils.TimerPlugin;
import ohos.timer.utils.Constant;
import ohos.timer.utils.LogUtil;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.InputAttribute;
import ohos.agp.components.Text;
import ohos.agp.components.TextField;
import ohos.agp.utils.Color;
import ohos.agp.window.dialog.ToastDialog;
import ohos.event.notification.NotificationHelper;
import ohos.event.notification.NotificationRequest;
import ohos.event.notification.NotificationSlot;
import ohos.rpc.RemoteException;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice implements Component.ClickedListener, TimerEventListener {
    private static final String TAG = MainAbilitySlice.class.getName();

    private TextField textFieldHour;

    private TextField textFieldMinute;

    private TextField textFieldSecond;

    private Text textRemainingTime;

    private Text textTimer;

    private Text textRepeatTimer;

    private DirectionalLayout containerTimer;

    private DirectionalLayout containerRepeatTimer;

    private TextField textFieldHourRepeat;

    private TextField textFieldMinuteRepeat;

    private Component btnCancelReminder;

    private Component btnSetReminder;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initRepeatTimerComponents();
        initTimerComponents();
    }

    private void initRepeatTimerComponents() {
        Component btnStartTimer = findComponentById(ResourceTable.Id_btn_start_timer);
        btnStartTimer.setClickedListener(this);
        textTimer = (Text) findComponentById(ResourceTable.Id_text_timer);
        textTimer.setClickedListener(this);
        textRepeatTimer = (Text) findComponentById(ResourceTable.Id_text_repeat_timer);
        textRepeatTimer.setClickedListener(this);
        containerRepeatTimer = (DirectionalLayout) findComponentById(ResourceTable.Id_container_repeat_timer);
        textFieldHourRepeat = (TextField) findComponentById(ResourceTable.Id_tf_hour_repeat);
        textFieldHourRepeat.setTextInputType(InputAttribute.ENTER_KEY_TYPE_GO);
        textFieldMinuteRepeat = (TextField) findComponentById(ResourceTable.Id_tf_minute_repeat);
        textFieldMinuteRepeat.setTextInputType(InputAttribute.ENTER_KEY_TYPE_GO);
        btnSetReminder = findComponentById(ResourceTable.Id_btn_start_repeat_timer);
        btnSetReminder.setClickedListener(this);
        btnCancelReminder = findComponentById(ResourceTable.Id_btn_stop_repeat_timer);
        btnCancelReminder.setClickedListener(this);
    }

    private void initTimerComponents() {
        containerTimer = (DirectionalLayout) findComponentById(ResourceTable.Id_container_timer);
        textFieldHour = (TextField) findComponentById(ResourceTable.Id_tf_hour);
        textFieldHour.setTextInputType(InputAttribute.ENTER_KEY_TYPE_GO);
        textFieldMinute = (TextField) findComponentById(ResourceTable.Id_tf_minute);
        textFieldMinute.setTextInputType(InputAttribute.ENTER_KEY_TYPE_GO);
        textFieldSecond = (TextField) findComponentById(ResourceTable.Id_tf_second);
        textFieldSecond.setTextInputType(InputAttribute.ENTER_KEY_TYPE_GO);
        textRemainingTime = (Text) findComponentById(ResourceTable.Id_text_remaining_time);
    }

    private void startTimer() {
        TimerPlugin.getInstance(this).startTimer(getTimerInput(), this);
    }

    private void startRepeatTimer() {
        TimerPlugin.getInstance(this).startRepeatTimer(getRepeatTimerInput(), this);
    }

    private void stopRepeatTimer() {
        TimerPlugin.getInstance(this).stopRepeatTimer();
    }

    private TimeData getTimerInput() {
        long hours = getTimerInput(textFieldHour);
        long minutes = getTimerInput(textFieldMinute);
        long seconds = getTimerInput(textFieldSecond);
        return new TimeData(hours, minutes, seconds);
    }

    private long getTimerInput(TextField textField) {
        String inputValue = textField.getText();
        if (inputValue.isEmpty()) {
            return Long.parseLong("00");
        } else if (!isNumeric(inputValue)) {
            showToast(" The input param is invalid ");
            textField.setText("");
            textField.clearFocus();
            return Long.parseLong("00");
        } else {
            return Long.parseLong(inputValue);
        }
    }

    private TimeData getRepeatTimerInput() {
        long hours = getTimerInput(textFieldHourRepeat);
        long minutes = getTimerInput(textFieldMinuteRepeat);
        return new TimeData(hours, minutes, 0);
    }

    private void resetTimerInput() {
        textFieldHour.setText(Constant.DEFAULT_TIMER_VALUE);
        textFieldMinute.setText(Constant.DEFAULT_TIMER_VALUE);
        textFieldSecond.setText(Constant.DEFAULT_TIMER_VALUE);
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    @Override
    public void onClick(Component component) {
        switch (component.getId()) {
            case ResourceTable.Id_btn_start_timer:
                startTimer();
                break;
            case ResourceTable.Id_text_timer:
                handleTimerSelected();
                break;
            case ResourceTable.Id_text_repeat_timer:
                handleRepeatTimerSelected();
                break;
            case ResourceTable.Id_btn_start_repeat_timer:
                startRepeatTimer();
                break;
            case ResourceTable.Id_btn_stop_repeat_timer:
                stopRepeatTimer();
                break;
            default:
                LogUtil.error(TAG, "Unhandled click");
                break;
        }
    }

    private void handleTimerSelected() {
        textTimer.setTextColor(new Color(Constant.COLOR_BLUE));
        textRepeatTimer.setTextColor(Color.BLACK);
        containerTimer.setVisibility(Component.VISIBLE);
        containerRepeatTimer.setVisibility(Component.INVISIBLE);
    }

    private void handleRepeatTimerSelected() {
        textTimer.setTextColor(Color.BLACK);
        textRepeatTimer.setTextColor(new Color(Constant.COLOR_BLUE));
        containerTimer.setVisibility(Component.INVISIBLE);
        containerRepeatTimer.setVisibility(Component.VISIBLE);
    }

    private void resetRepeatTimerInput() {
        textFieldHourRepeat.setText(Constant.DEFAULT_TIMER_VALUE);
        textFieldMinuteRepeat.setText(Constant.DEFAULT_TIMER_VALUE);
    }

    @Override
    public void notifyTimeChange(String remainingTime) {
        textRemainingTime.setText(remainingTime);
    }

    @Override
    public void notifyTimerCompleted() {
        textRemainingTime.setText(ResourceTable.String_default_remaining_time);
        resetTimerInput();
        sendNotification(Constant.NOTIFICATION_TITLE_TIMER, Constant.NOTIFICATION_TEXT_TIMER);
    }

    @Override
    public void notifyRepeatTimerStarted() {
        showToast("Water reminder set");
        btnSetReminder.setVisibility(Component.INVISIBLE);
        btnCancelReminder.setVisibility(Component.VISIBLE);
    }

    @Override
    public void notifyRepeatTimerStopped() {
        resetRepeatTimerInput();
        btnSetReminder.setVisibility(Component.VISIBLE);
        btnCancelReminder.setVisibility(Component.INVISIBLE);
    }

    @Override
    public void notifyTimerError() {
        showToast(Constant.TIMER_ERROR);
    }

    private void showToast(String message) {
        new ToastDialog(this).setText(message).show();
    }

    @Override
    public void notifyRepeatTimerEventReceived() {
        sendNotification(Constant.NOTIFICATION_TITLE_REPEAT_TIMER, Constant.NOTIFICATION_TEXT_REPEAT_TIMER);
    }

    private void sendNotification(String title, String text) {
        try {
            NotificationSlot slot = new NotificationSlot(Constant.NOTIFICATION_SLOT_ID, Constant.NOTIFICATION_SLOT_NAME,
                NotificationSlot.LEVEL_HIGH);
            slot.setEnableLight(true);
            slot.setLedLightColor(Color.GREEN.getValue());
            slot.setEnableVibration(true);
            NotificationHelper.addNotificationSlot(slot);
            NotificationRequest.NotificationNormalContent content = new NotificationRequest.NotificationNormalContent();
            content.setTitle(title);
            content.setText(text);
            NotificationRequest.NotificationContent notificationContent = new NotificationRequest.NotificationContent(
                content);
            NotificationRequest request = new NotificationRequest(Constant.NOTIFICATION_ID);
            request.setSlotId(slot.getId());
            request.setContent(notificationContent);
            NotificationHelper.publishNotification(request);
        } catch (RemoteException e) {
            LogUtil.error(TAG, "RemoteException in showNotification");
        }
    }

    private boolean isNumeric(String str) {
        Pattern pattern = Pattern.compile("[0-9]*");
        Matcher isNum = pattern.matcher(str);
        return isNum.matches();
    }
}
