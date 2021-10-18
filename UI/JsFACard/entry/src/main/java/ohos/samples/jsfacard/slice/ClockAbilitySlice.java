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

package ohos.samples.jsfacard.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.samples.jsfacard.ResourceTable;
import ohos.samples.jsfacard.utils.DateUtils;
import ohos.samples.jsfacard.utils.LogUtils;

import java.util.Calendar;
import java.util.Timer;
import java.util.TimerTask;

/**
 * ClockAbilitySlice
 *
 * @since 2021-08-20
 */
public class ClockAbilitySlice extends AbilitySlice {
    private static final String TAG = ClockAbilitySlice.class.getName();

    private static final long SEND_PERIOD = 1000L;

    private Timer timer;

    private MyEventHandler myEventHandler;

    private final Runnable runnable = new Runnable() {
        @Override
        public void run() {
            initHandler();
        }

        private void initHandler() {
            EventRunner eventRunner = EventRunner.getMainEventRunner();
            if (eventRunner == null) {
                return;
            }
            myEventHandler = new MyEventHandler(eventRunner);
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_timer_progress_clock_1x2);
        initComponent();
        startTimer();
    }

    private void initComponent() {
        Calendar now = Calendar.getInstance();
        Component hourComponent = findComponentById(ResourceTable.Id_hour);
        if (hourComponent instanceof Text) {
            Text hourText = (Text) hourComponent;
            int hour = now.get(Calendar.HOUR_OF_DAY);
            hourText.setText(DateUtils.setTextValue(hour));
        }
        Component minComponent = findComponentById(ResourceTable.Id_min);
        if (minComponent instanceof Text) {
            Text minText = (Text) minComponent;
            int min = now.get(Calendar.MINUTE);
            minText.setText(DateUtils.setTextValue(min));
        }
        Component secComponent = findComponentById(ResourceTable.Id_sec);
        if (secComponent instanceof Text) {
            Text secText = (Text) secComponent;
            int sec = now.get(Calendar.SECOND);
            secText.setText(DateUtils.setTextValue(sec));
        }
    }

    private void startTimer() {
        timer = new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                runnable.run();
                myEventHandler.sendEvent(1);
            }
        }, 0, SEND_PERIOD);
    }

    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    @Override
    protected void onStop() {
        LogUtils.info(TAG, " start to destroy slice");
        timer.cancel();
    }

    private class MyEventHandler extends EventHandler {
        MyEventHandler(EventRunner runner) throws IllegalArgumentException {
            super(runner);
        }

        @Override
        protected void processEvent(InnerEvent event) {
            super.processEvent(event);
            int eventId = event.eventId;
            if (eventId == 1) {
                initComponent();
            }
        }
    }
}