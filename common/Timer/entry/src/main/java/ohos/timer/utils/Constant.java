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

package ohos.timer.utils;

/**
 * Constants class
 */
public class Constant {
    /**
     * Time in milliseconds
     */
    public static final int ONE_HOUR = 60 * 60 * 1000;

    /**
     * Time in milliseconds
     */
    public static final int ONE_MINUTE = 60 * 1000;

    /**
     * Time in milliseconds
     */
    public static final int ONE_SECOND = 1000;

    /**
     * unit to convert millisecond to min
     */
    public static final int UNIT = 60;

    /**
     * unit to convert millisecond to hour
     */
    public static final int DAY = 24;

    /**
     * time format
     */
    public static final String TIME_FORMAT = "%02d";

    /**
     * timer error message
     */
    public static final String TIMER_ERROR = "Timer is running...";

    /**
     * Default input value
     */
    public static final String DEFAULT_TIMER_VALUE = "";

    /**
     * Event received after interval completes in repeat timer
     */
    public static final String REPEAT_TIMER_EVENT = "Repeat Timer Event";

    /**
     * Custom color for button
     */
    public static final int COLOR_BLUE = 0xff007dff;

    /**
     * notification params
     */
    public static final String NOTIFICATION_SLOT_ID = "timer_notification_slot_001";

    /**
     * notification params
     */
    public static final String NOTIFICATION_SLOT_NAME = "timer_notification_slot";

    /**
     * notification params
     */
    public static final String NOTIFICATION_TITLE_REPEAT_TIMER = "Water Reminder";

    /**
     * notification params
     */
    public static final String NOTIFICATION_TEXT_REPEAT_TIMER = "It's time for some water";

    /**
     * notification params
     */
    public static final String NOTIFICATION_TITLE_TIMER = "Timer";

    /**
     * notification params
     */
    public static final String NOTIFICATION_TEXT_TIMER = "Timer Completed";

    /**
     * notification params
     */
    public static final int NOTIFICATION_ID = 9999;

    private Constant() {
    }
}
