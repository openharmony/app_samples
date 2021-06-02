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

package ohos.samples.autoreplynotificationsample.utils;

/**
 * Constant class
 */
public class Constants {
    /**
     * Marking text of start notification in java side
     */
    public static final int START_NOTIFICATION_TEXT = 1001;

    /**
     * Marking image of start notification in java side
     */
    public static final int START_NOTIFICATION_IMG = 1002;

    /**
     * Marking text of cancel notification in java side
     */
    public static final int CANCEL_NOTIFICATION = 1003;

    /**
     * Marking subscribeMsg notification in java side
     */
    public static final int SUBSCRIBE_MSG = 1004;

    /**
     * Marking subscribeMsg notification in java side
     */
    public static final int UN_SUBSCRIBE_MSG = 1005;

    /**
     * Action of self-define common event
     */
    public static final String COMMON_EVENT_ACTION = "SEND_MESSAGE";

    /**
     * Notification title
     */
    public static final String NOTIFICATION_TITLE = "Notification";

    /**
     * Notification text
     */
    public static final String NOTIFICATION_TEXT = "This is an auto-reply notification";

    /**
     * Key string in user input, using for set and get text in notification
     */
    public static final String USE_INPUT_KEY = "QUICK_NOTIFICATION_REPLY";

    /**
     * Tag string in user input, using for hint text shown in notification
     */
    public static final String USE_INPUT_TAG = "input text";

    /**
     * Button text shown in notification
     */
    public static final String USE_INPUT_REPLY = "reply";

    /**
     * Start notification fail information
     */
    public static final String START_NOTIFICATION_FAIL_INFORMATION = "start notification fail";

    /**
     * Information shown in Text
     */
    public static final String CLICK_INFORMATION = "Clicked button in notification!";

    /**
     * Notification id
     */
    public static final int NOTIFICATION_ID = 100;

    /**
     * Request code
     */
    public static final int REQUEST_CODE = 200;

    private Constants() {
        /* Do nothing */
    }
}
