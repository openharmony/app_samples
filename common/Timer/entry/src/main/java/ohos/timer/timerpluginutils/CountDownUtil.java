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

import ohos.timer.utils.LogUtil;

/**
 * CountDownUtil class
 */
public class CountDownUtil {
    private static final String TAG = CountDownUtil.class.getSimpleName();

    private final long millisInFuture;

    private final CountDownCallback countDownCallback;

    private final CountDownTimer countDownTimer;

    private boolean isCancel;

    /**
     * CountDownUtil constructor
     *
     * @param countDownCallback callback
     * @param millisInFuture    count down
     */
    public CountDownUtil(CountDownCallback countDownCallback, long millisInFuture) {
        this.countDownCallback = countDownCallback;
        this.millisInFuture = millisInFuture;
        countDownTimer = getCountDownTimer();
        isCancel = false;
    }

    /**
     * Start the count down
     */
    public void startCountDown() {
        if (countDownTimer != null) {
            countDownTimer.start();
            isCancel = false;
        }
        if (countDownCallback != null && !isCancel) {
            countDownCallback.countDownStart();
        }
    }


    private CountDownTimer getCountDownTimer() {
        return new CountDownTimer(millisInFuture) {
            @Override
            public void onTick(long millisUntilFinished) {
                if (countDownCallback != null && !isCancel) {
                    double millis = (double) millisUntilFinished / millisInFuture;
                    int millisCount = (int) Math.round(millis);
                    LogUtil.info(TAG,
                            "timer ticking" + millisUntilFinished + "--" + millisCount);
                    countDownCallback.countDownTick(millisUntilFinished);
                }
            }

            @Override
            public void onFinish() {
                if (countDownCallback != null && !isCancel) {
                    countDownCallback.countDownFinished();
                }
            }
        };
    }

    /**
     * Countdown Callback Interface
     *
     */
    public interface CountDownCallback {
        /**
         * Start the count down
         */
        void countDownStart();

        /**
         * Count down is finished
         */
        void countDownFinished();

        /**
         * Countdown callback data
         *
         * @param millisUntilFinished Remaining time
         */
        void countDownTick(long millisUntilFinished);
    }
}
