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

package ohos.samples.devices.provider;

import ohos.agp.components.*;
import ohos.samples.devices.ResourceTable;
import ohos.samples.devices.slice.MainAbilitySlice;

import ohos.agp.utils.Color;
import ohos.app.Context;
import ohos.distributedschedule.interwork.DeviceInfo;

import java.util.List;

/**
 * DeviceProvider
 */
public class DeviceProvider extends BaseItemProvider {
    private static final String STATUS_ONLINE = "online";

    private static final String STATUS_OFFLINE = "offline";

    private static final int SUBSTRING_INDEX = 6;

    private final Context context;

    private List<DeviceInfo> deviceInfoList;

    public DeviceProvider(MainAbilitySlice mainAbilitySlice, List<DeviceInfo> deviceList) {
        this.context = mainAbilitySlice;
        this.deviceInfoList = deviceList;
    }

    @Override
    public int getCount() {
        return deviceInfoList.size();
    }

    @Override
    public Object getItem(int position) {
        return deviceInfoList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public Component getComponent(int position, Component component, ComponentContainer componentContainer) {
        return getItemComponent(position);
    }

    private Component getItemComponent(int position) {
        Component container = LayoutScatter.getInstance(context).parse(ResourceTable.Layout_list_item, null, false);
        Text typeText = (Text) container.findComponentById(ResourceTable.Id_type_text);
        Text nameText = (Text) container.findComponentById(ResourceTable.Id_name_text);
        Text stateText = (Text) container.findComponentById(ResourceTable.Id_state_text);
        DeviceInfo deviceInfo = deviceInfoList.get(position);
        boolean deviceOnline = false;
        if (deviceInfo != null) {
            deviceOnline = deviceInfo.isDeviceOnline();
            if ((deviceInfo.getDeviceType() != null) && (deviceInfo.getDeviceType().toString() != null)) {
                typeText.setText(deviceInfo.getDeviceType().toString().substring(SUBSTRING_INDEX));
            }
            nameText.setText(deviceInfo.getDeviceName());
        }
        stateText.setText(deviceOnline ? STATUS_ONLINE : STATUS_OFFLINE);
        typeText.setTextColor(deviceOnline ? Color.GREEN : Color.GRAY);
        nameText.setTextColor(deviceOnline ? Color.GREEN : Color.GRAY);
        stateText.setTextColor(deviceOnline ? Color.GREEN : Color.GRAY);
        return container;
    }

    /**
     * update provider data
     *
     * @param data deviceInfo list data
     */
    public void updateData(List<DeviceInfo> data) {
        deviceInfoList = data;
        notifyDataChanged();
    }
}