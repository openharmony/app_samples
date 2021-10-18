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

import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.eventhandler.NativeException;
import ohos.miscservices.timeutility.Time;

/**
 * CountdownTimer class
 */

public abstract class CountDownTimer {
    private static final int DELAY = 1000;

    private final long millisInFuture;

    private long stopTimeInFuture;

    private boolean isCancelled = false;

    private InnerEvent innerEvent;

    /**
     * Constructor for CountDownTimer
     *
     * @param millis The number of millis in the future from the call to
     *               {@link #start()} until the countdown is done and {@link #onFinish()} is called.
     **/
    public CountDownTimer(long millis) {
        millisInFuture = millis;
    }

    /**
     * Start the countdown.
     *
     * @return CountDownTimer instance
     */
    public final synchronized CountDownTimer start() {
        isCancelled = false;
        if (millisInFuture <= 0) {
            onFinish();
            return this;
        }
        stopTimeInFuture = Time.getRealTime() + millisInFuture;
        EventRunner runner = EventRunner.create(true);
        if (runner == null) {
            return this;
        }
        Handler handler = new Handler(runner);
        int eventId = 0;
        long param = 0L;

        Object object = EventRunner.current();
        innerEvent = InnerEvent.get(eventId, param, object);
        handler.sendEvent(innerEvent);
        return this;
    }

    /**
     * Callback fired on regular interval. * * @param millisUntilFinished The amount of time until finished.
     *
     * @param millisUntilFinished time elapsed
     */
    public abstract void onTick(long millisUntilFinished);

    /**
     * Callback fired when the time is up.
     */
    public abstract void onFinish();

    /**
     * Handler EventHandler
     *
     */
    private class Handler extends EventHandler {
        /**
         * Handler for timer
         */
        private Handler(EventRunner runner) throws IllegalArgumentException, NativeException {
            super(runner);
        }

        @Override
        protected void processEvent(InnerEvent event) {
            super.processEvent(event);
            synchronized (CountDownTimer.this) {
                if (isCancelled || event == null) {
                    return;
                }
                final long millisLeft = stopTimeInFuture - Time.getRealTime();
                if (millisLeft <= 0) {
                    onFinish();
                } else {
                    onTick(millisLeft);
                    sendEvent(innerEvent.eventId, DELAY);
                }
            }
        }
    }
}

