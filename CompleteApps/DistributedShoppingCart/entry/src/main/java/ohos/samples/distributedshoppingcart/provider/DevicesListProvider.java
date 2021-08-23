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

package ohos.samples.distributedshoppingcart.provider;

import ohos.agp.components.*;
import ohos.app.Context;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.samples.distributedshoppingcart.ResourceTable;

import java.util.List;

/**
 * DevicesListProvider
 */
public class DevicesListProvider extends BaseItemProvider {
    private final List<DeviceInfo> deviceInfoList;
    private final Context context;

    /**
     * DevicesListProvider
     *
     * @param listBasicInfo the basic info list
     * @param context the context
     */
    public DevicesListProvider(List<DeviceInfo> listBasicInfo, Context context) {
        this.deviceInfoList = listBasicInfo;
        this.context = context;
    }

    @Override
    public int getCount() {
        return deviceInfoList == null ? 0 : deviceInfoList.size();
    }

    @Override
    public Object getItem(int i) {
        return deviceInfoList.get(i);
    }

    @Override
    public long getItemId(int idx) {
        return idx;
    }

    @Override
    public Component getComponent(int position, Component component, ComponentContainer componentContainer) {
        ViewHolder viewHolder;
        Component temp = component;
        if (temp == null) {
            temp = LayoutScatter.getInstance(context).parse(ResourceTable.Layout_device_list_item, null, false);
            viewHolder = new ViewHolder();
            viewHolder.devicesName = (Text) temp.findComponentById(ResourceTable.Id_item_chlid_textview);
            viewHolder.devicesId = (Text) temp.findComponentById(ResourceTable.Id_item_chlid_textId);
            temp.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) temp.getTag();
        }
        viewHolder.devicesName.setText(deviceInfoList.get(position).getDeviceName());
        viewHolder.devicesId.setText(deviceInfoList.get(position).getDeviceId());
        return temp;
    }

    /**
     * ViewHolder class
     */
    private static class ViewHolder {
        private Text devicesName;
        private Text devicesId;
    }
}
