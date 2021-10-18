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

package ohos.samples.jsfacard.utils;

import ohos.utils.zson.ZSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Date time util
 *
 * @since 2021-08-20
 */
public class DateUtils {
    private static final int TIME_LENGTH = 2;

    /**
     * current time
     *
     * @param format format
     * @return corresponding format string
     */
    public static String getCurrentDate(String format) {
        DateFormat dateFormat = new SimpleDateFormat(format);
        Date date = new Date();
        return dateFormat.format(date);
    }

    /**
     * get the data that the page needs
     *
     * @return corresponding data
     */
    public static ZSONObject getZsonObject() {
        ZSONObject result = new ZSONObject();
        Calendar now = Calendar.getInstance();
        int hour = now.get(Calendar.HOUR_OF_DAY);
        result.put("hour", setTextValue(hour));
        int min = now.get(Calendar.MINUTE);
        result.put("min", setTextValue(min));
        int sec = now.get(Calendar.SECOND);
        result.put("sec", setTextValue(sec));
        return result;
    }

    /**
     * set text value
     *
     * @param now current time
     * @return corresponding format string
     */
    public static String setTextValue(int now) {
        String text = String.valueOf(now);
        if (text.length() < TIME_LENGTH) {
            text = "0" + text;
        } else {
            text = text + "";
        }
        return text;
    }
}
