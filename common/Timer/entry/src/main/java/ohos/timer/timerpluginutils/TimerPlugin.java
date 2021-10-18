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

package ohos.timer.timerpluginutils;

import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.event.commonevent.*;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.miscservices.timeutility.Time;
import ohos.miscservices.timeutility.Timer;
import ohos.rpc.RemoteException;
import ohos.timer.interfaces.TimerEventListener;
import ohos.timer.slice.MainAbilitySlice;
import ohos.timer.utils.Constant;
import ohos.timer.utils.LogUtil;

import java.util.Locale;

import static ohos.miscservices.timeutility.Timer.*;

/**
 * TimerPlugin implements CountDownUtil.CountDownCallback
 */
public class TimerPlugin implements CountDownUtil.CountDownCallback {
    private static final String TAG = TimerPlugin.class.getSimpleName();

    private static final int EVENT_CODE = 0X01;

    private static volatile TimerPlugin timerPluginInstance = null;

    private long millisInFuture;

    private long timeLeftInMilSec = 0L;

    private final MainAbilitySlice mainSliceContext;

    private TimerEventListener timerEventListener;

    private Timer.RepeatTimer repeatTimer;

    private String remainingTime;

    private TimerPlugin(MainAbilitySlice sliceContext) {
        mainSliceContext = sliceContext;
    }

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            if (event.eventId == EVENT_CODE) {
                timerEventListener.notifyTimeChange(remainingTime);
            }
        }
    };

    /**
     * start timer
     *
     * @param timeData time data
     * @param listener callback
     */
    public void startTimer(TimeData timeData, TimerEventListener listener) {
        if (checkPrerequisite(timeData, listener)) {
            startCountDownTimer();
            startOneShortTimer();
        }
    }

    private boolean checkPrerequisite(TimeData timeData, TimerEventListener listener) {
        setTimerData(timeData, listener);
        if (timeLeftInMilSec < Constant.ONE_SECOND) {
            return millisInFuture > 0;
        } else {
            timerEventListener.notifyTimerError();
        }
        return false;
    }

    private void startCountDownTimer() {
        CountDownUtil countDownUtil = new CountDownUtil(this, millisInFuture);
        countDownUtil.startCountDown();
    }

    /**
     * start repeat timer
     *
     * @param timeData time data
     * @param listener callback
     */
    public void startRepeatTimer(TimeData timeData, TimerEventListener listener) {
        setTimerData(timeData, listener);

        if (millisInFuture == 0) {
            return;
        }

        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withBundleName(Constant.REPEAT_TIMER_EVENT).build();
        intent.setOperation(operation);
        Timer.TimerIntent timerIntent = new Timer.TimerIntent(intent, ABILITY_TYPE_COMMON_EVENT);
        repeatTimer = Timer.RepeatTimer.getTimer(mainSliceContext, timerIntent);

        repeatTimer.start(TIMER_TYPE_EXACT | TIMER_TYPE_WAKEUP, Time.getCurrentTime() + millisInFuture, millisInFuture);
        timerEventListener.notifyRepeatTimerStarted();

        MatchingSkills intentFilter = new MatchingSkills();
        intentFilter.addEvent(Constant.REPEAT_TIMER_EVENT);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(intentFilter);
        CommonEventSubscriber commonEventSubscriber = new CommonEventSubscriber(subscribeInfo) {
            @Override
            public void onReceiveEvent(CommonEventData commonEventData) {
                Intent intent = commonEventData.getIntent();
                if (intent == null) {
                    return;
                }
                String action = intent.getAction();
                if (Constant.REPEAT_TIMER_EVENT.equals(action)) {
                    timerEventListener.notifyRepeatTimerEventReceived();
                }
            }
        };
        try {
            CommonEventManager.subscribeCommonEvent(commonEventSubscriber);
        } catch (RemoteException e) {
            LogUtil.error(TAG, "subscribe error in startRepeatTimer");
        }
    }

    /**
     * stop repeat Timer
     */
    public void stopRepeatTimer() {
        if (repeatTimer != null) {
            repeatTimer.stop();
            timerEventListener.notifyRepeatTimerStopped();
        }
    }

    private void setTimerData(TimeData timeData, TimerEventListener listener) {
        timerEventListener = listener;

        millisInFuture = timeData.getHour() * Constant.ONE_HOUR + timeData.getMinute() * Constant.ONE_MINUTE
            + timeData.getSeconds() * Constant.ONE_SECOND;
    }

    private void startOneShortTimer() {
        Timer.OneShotTimer oneShotTimer = Timer.OneShotTimer.getTimer(mainSliceContext, () -> timerEventListener.notifyTimerCompleted());
        oneShotTimer.start(TIMER_TYPE_WAKEUP, Time.getCurrentTime() + millisInFuture);
    }

    /**
     * return instance of TimerPlugin
     *
     * @param sliceContext sliceContext
     * @return instance of TimerPlugin
     */
    public static TimerPlugin getInstance(MainAbilitySlice sliceContext) {
        if (timerPluginInstance == null) {
            synchronized (TimerPlugin.class) {
                if (timerPluginInstance == null) {
                    timerPluginInstance = new TimerPlugin(sliceContext);
                }
            }
        }
        return timerPluginInstance;
    }

    @Override
    public void countDownStart() {
        LogUtil.info(TAG, "countdown start");
    }

    @Override
    public void countDownFinished() {
        LogUtil.info(TAG, "countdown finished");
    }

    @Override
    public void countDownTick(long millisUntilFinished) {
        timeLeftInMilSec = millisUntilFinished;

        long remainingSeconds = (millisUntilFinished / Constant.ONE_SECOND) % Constant.UNIT;
        long remainingMinutes = (millisUntilFinished / Constant.ONE_MINUTE) % Constant.UNIT;
        long hoursRemaining = (millisUntilFinished / Constant.ONE_HOUR) % Constant.DAY;

        remainingTime = String.format(Locale.ENGLISH, Constant.TIME_FORMAT, hoursRemaining) + ":" + String.format(
            Locale.ENGLISH, Constant.TIME_FORMAT, remainingMinutes) + ":" + String.format(Locale.ENGLISH,
            Constant.TIME_FORMAT, remainingSeconds);
        handler.sendEvent(EVENT_CODE);
    }
}
