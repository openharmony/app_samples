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

package ohos.samples.distributedclient.provider;

import ohos.samples.distributedclient.DevicePlugin;
import ohos.samples.distributedclient.ResourceTable;
import ohos.samples.distributedclient.slice.MainAbilitySlice;

import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.RecycleItemProvider;
import ohos.agp.components.Text;
import ohos.app.Context;
import ohos.distributedschedule.interwork.DeviceInfo;

import java.util.List;

/**
 * DeviceProvider
 */
public class DeviceProvider extends RecycleItemProvider {
    private Context context;

    private List<DeviceInfo> deviceInfoList;

    private DevicePlugin devicePlugin;

    public DeviceProvider(MainAbilitySlice mainAbilitySlice, List<DeviceInfo> deviceInfoList,
        DevicePlugin devicePlugin) {
        this.context = mainAbilitySlice;
        this.deviceInfoList = deviceInfoList;
        this.devicePlugin = devicePlugin;
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
        DeviceInfo item = deviceInfoList.get(position);
        Component container = LayoutScatter.getInstance(context).parse(ResourceTable.Layout_list_item, null, false);
        Text deviceName = (Text) container.findComponentById(ResourceTable.Id_device_name);
        Text deviceId = (Text) container.findComponentById(ResourceTable.Id_device_id);
        deviceName.setText(item.getDeviceName() == null ? "Unknown" : item.getDeviceName());
        deviceId.setText(item.getDeviceId());
        container.setClickedListener(component -> devicePlugin.connectAbility(context, item));
        return container;
    }

    /**
     * update provider data
     *
     * @param data deviceInfo list data
     */
    public void updateData(List<DeviceInfo> data) {
        this.deviceInfoList = data;
        notifyDataChanged();
    }
}


