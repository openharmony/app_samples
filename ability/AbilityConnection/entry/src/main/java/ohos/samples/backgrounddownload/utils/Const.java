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

package ohos.samples.backgrounddownload.utils;


/**
 * const
 */
public class Const {
    /**
     * Test file download link
     */
    public static final String DOWNLOAD_FILE_URL
        = "https://gitee.com/openharmony";

    /**
     * code for start a new task
     */
    public static final int REMOTE_REQUEST_CODE_NEW_TASK = 0x0000002;

    /**
     * code for cancel a new task
     */
    public static final int REMOTE_REQUEST_CODE_CANCEL_TASK = 0x0000003;

    /**
     * EventHandler eventId
     */
    public static final int HANDLER_EVENT_ID = 0x0000004;

    /**
     * EventHandler event param
     */
    public static final int HANDLER_EVENT_PARAM = 0x0000005;

    /**
     * deploy request success
     */
    public static final int SEND_REQUEST_SUCCESS = 0x0000006;
}
