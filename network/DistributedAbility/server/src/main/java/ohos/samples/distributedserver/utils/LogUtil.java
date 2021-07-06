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

package ohos.samples.distributedserver.utils;

import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;

import java.util.Locale;

/**
 * Custom log util.
 */
public class LogUtil {
    private static final String TAG_LOG = "DistributedServer";

    private static final int DOMAIN_ID = 0xD000F00;

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, DOMAIN_ID, LogUtil.TAG_LOG);

    private static final String LOG_FORMAT = "%s: %s";

    private static final String HI_LOG_FORMAT = "%{public}s";

    private LogUtil() {
        /* Do nothing */
    }

    /**
     * Print info log message
     *
     * @param className class name
     * @param msg info log message
     */
    public static void info(String className, String msg) {
        HiLog.info(LABEL_LOG, HI_LOG_FORMAT, String.format(Locale.ROOT, LOG_FORMAT, className, msg));
    }

    /**
     * Print error log message
     *
     * @param className class name
     * @param msg error log message
     */
    public static void error(String className, String msg) {
        HiLog.error(LABEL_LOG, HI_LOG_FORMAT, String.format(Locale.ROOT, LOG_FORMAT, className, msg));
    }
}