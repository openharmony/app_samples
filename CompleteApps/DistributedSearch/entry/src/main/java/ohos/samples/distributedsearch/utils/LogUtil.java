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

package ohos.samples.distributedsearch.utils;

import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;

import java.util.Locale;

/**
 * Log util function
 *
 * @since 2019-10-15
 */
public class LogUtil {
    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, "");

    private static final String LOG_FORMAT = "%{public}s: %{public}s";

    private static final String NULL_STR = "null";

    private LogUtil() {
        /* Do nothing */
    }

    /**
     * print device info to log
     *
     * @param className The prefix to log
     * @param device The device into to print
     * @param msg log message
     */
    public static void printDevice(String className, DeviceInfo device, String msg) {
        if (device == null) {
            HiLog.error(LABEL_LOG, LOG_FORMAT, className, "DeviceInfo is null");
        } else {
            HiLog.info(LABEL_LOG,
                "%{public}s: %{public}s: { deviceId: %{public}s, deviceName: %{public}s, deviceType: %{public}s }",
                className, msg, device.getDeviceId(), device.getDeviceName(), device.getDeviceType());
        }
    }

    /**
     * Print debug log
     *
     * @param className class name
     * @param msg log message
     */
    public static void debug(String className, String msg) {
        HiLog.debug(LABEL_LOG, LOG_FORMAT, className, msg);
    }

    /**
     * Print debug log
     *
     * @param classType class name
     * @param format format
     * @param args args
     */
    public static void debug(Class<?> classType, final String format, Object... args) {
        String buffMsg = String.format(Locale.ROOT, format, args);
        HiLog.debug(LABEL_LOG, LOG_FORMAT, classType == null ? NULL_STR : classType.getSimpleName(), buffMsg);
    }

    /**
     * Print info log
     *
     * @param className class name
     * @param msg log message
     */
    public static void info(String className, String msg) {
        HiLog.info(LABEL_LOG, LOG_FORMAT, className, msg);
    }

    /**
     * Print info log
     *
     * @param className class name
     * @param format format
     * @param args args
     */
    public static void info(String className, final String format, Object... args) {
        String buffMsg = String.format(Locale.ROOT, format, args);
        HiLog.info(LABEL_LOG, LOG_FORMAT, className, buffMsg);
    }

    /**
     * Print info log
     *
     * @param classType class name
     * @param format format
     * @param args args
     */
    public static void info(Class<?> classType, final String format, Object... args) {
        String buffMsg = String.format(Locale.ROOT, format, args);
        HiLog.info(LABEL_LOG, LOG_FORMAT, classType == null ? NULL_STR : classType.getSimpleName(), buffMsg);
    }

    /**
     * Print warn log
     *
     * @param classType class name
     * @param format format
     * @param args args
     */
    public static void warn(Class<?> classType, final String format, Object... args) {
        String buffMsg = String.format(Locale.ROOT, format, args);
        HiLog.warn(LABEL_LOG, LOG_FORMAT, classType == null ? NULL_STR : classType.getSimpleName(), buffMsg);
    }

    /**
     * Print error log
     *
     * @param className class name
     * @param msg log message
     */
    public static void warn(String className, String msg) {
        HiLog.warn(LABEL_LOG, LOG_FORMAT, className, msg);
    }

    /**
     * Print error log
     *
     * @param className class name
     * @param msg log message
     */
    public static void error(String className, String msg) {
        HiLog.error(LABEL_LOG, LOG_FORMAT, className, msg);
    }

    /**
     * Print error log
     *
     * @param classType class name
     * @param format format
     * @param args args
     */
    public static void error(Class<?> classType, final String format, Object... args) {
        String buffMsg = String.format(Locale.ROOT, format, args);
        HiLog.error(LABEL_LOG, LOG_FORMAT, classType == null ? NULL_STR : classType.getSimpleName(), buffMsg);
    }

    /**
     * Print error log
     *
     * @param tag log tag
     * @param format format
     * @param args args
     */
    public static void error(String tag, final String format, Object... args) {
        String buffMsg = String.format(Locale.ROOT, format, args);
        HiLog.error(LABEL_LOG, LOG_FORMAT, tag, buffMsg);
    }
}
