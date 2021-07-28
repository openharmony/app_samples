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

package ohos.samples.accessibilityservice.utils;

import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;

import java.util.Objects;

/**
 * LogUtils
 *
 * @since 2021-07-23
 */
public class LogUtils {
    private static final String APP_NAME = "AccessibilityService";
    private static final HiLogLabel LABAL_LOG = new HiLogLabel(3, 0xD000f00, APP_NAME);
    private static final String LOG_FORMAT = "%{public}s:%{public}s";

    private LogUtils() {
    }

    /**
     * log info
     *
     * @param className String
     * @param msg String
     */
    public static void info(String className, String msg) {
        HiLog.info(LABAL_LOG, LOG_FORMAT, getLogPrefix(className), msg);
    }

    /**
     * log error
     *
     * @param className String
     * @param msg String
     */
    public static void error(String className, String msg) {
        HiLog.error(LABAL_LOG, LOG_FORMAT, getLogPrefix(className), msg);
    }

    private static String getLogPrefix(String tag) {
        Thread currentThread = Thread.currentThread();
        String threadName = currentThread.getName();
        StackTraceElement[] stackTraceElements = currentThread.getStackTrace();
        int lineNum = 0;
        for (int index = 0; index < stackTraceElements.length; index++) {
            if (Objects.equals(stackTraceElements[index].getClassName(), LogUtils.class.getName())
                    && stackTraceElements.length > index + 1
                    && !Objects.equals(stackTraceElements[index + 1].getClassName(), LogUtils.class.getName())) {
                lineNum = stackTraceElements[index + 1].getLineNumber();
            }
        }
        return "[" + threadName + "]" + "(" + tag + ".java" + lineNum + ")";
    }
}
