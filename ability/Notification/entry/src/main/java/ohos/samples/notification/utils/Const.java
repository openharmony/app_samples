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

package ohos.samples.notification.utils;

/**
 * Notification Const
 */
public class Const {
    /**
     * bundle name
     */
    public static final String BUNDLE_NAME = "ohos.samples.notification";

    /**
     * notification slot id
     */
    public static final String SLOT_ID = "high";

    /**
     * notification slot name
     */
    public static final String SLOT_NAME = "Order notification";

    /**
     * notification request code
     */
    public static final int REQUEST_CODE = 1000;

    /**
     * notification title
     */
    public static final String NOTIFICATION_TITLE = "Normal Notification";

    /**
     * notification content
     */
    public static final String NOTIFICATION_CONTENT = "There is a normal notification content.";

    /**
     * sound uri
     */
    public static final String SOUND_URI = "ohos.resource://ohos.samples.notification/rawfile/bell2";

    /**
     * notification title
     */
    public static final String NOTIFICATION_TITLE2 = "Custom Notification";

    /**
     * notification content
     */
    public static final String NOTIFICATION_CONTENT2 = "You can enter custom text.";

    /**
     * notification action
     */
    public static final String NOTIFICATION_ACTION = "REPLY_ACTION";

    /**
     * notification action input key
     */
    public static final String NOTIFICATION_INPUT_KEY = "REPLY_KEY";

    /**
     * notification action button title
     */
    public static final String NOTIFICATION_OPER_TITLE = "Reply";

    private Const() {
        /* Do nothing */
    }
}
