/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.All rights reserved.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.samples.tictactoegame.utils;

import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.distributedschedule.interwork.DeviceManager;

import java.util.List;

/**
 * DeviceUtils
 */
public class DeviceUtils {
    private DeviceUtils() {}

    /**
     * Get remote device info
     *
     * @return Remote device info list.
     */
    public static List<DeviceInfo> getRemoteDevice() {
        return DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ONLINE_DEVICE);
    }

    /**
     * getDeviceId
     *
     * @return java.lang.String
     */
    public static String getDeviceId() {
        String deviceId = "";
        List<DeviceInfo> list = getRemoteDevice();
        if (list == null || list.size() == 0) {
            return deviceId;
        }

        deviceId = list.get(0).getDeviceId();

        return deviceId;
    }
}
