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

package ohos.samples.distributedsearch.provider;

import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.components.Text;
import ohos.app.Context;
import ohos.samples.distributedsearch.ResourceTable;
import ohos.samples.distributedsearch.data.DeviceData;

import java.util.List;

/**
 * The type Device data provider.
 *
 * @since 2021-04-27
 */
public class DeviceDataProvider extends ListComponentProvider<DeviceData> {

    /**
     * Instantiates a new Device data provider.
     *
     * @param context the context
     * @param listBean the list bean
     * @param resourceId the resource id
     */
    public DeviceDataProvider(Context context, List<DeviceData> listBean, int resourceId) {
        super(context, listBean, resourceId);
    }

    @Override
    public void onItemDataBind(ComponentViewHolder componentViewHolder, DeviceData deviceData, int position) {

        // 1 Set the name of the device
        Text deviceText = (Text) componentViewHolder.getChildComponent(ResourceTable.Id_item_image_title);
        deviceText.setText(deviceData.getDeviceInfo().getDeviceName());
        Text infoText = (Text) componentViewHolder.getChildComponent(ResourceTable.Id_item_image_info);
        infoText.setText(deviceData.getDeviceInfo().getDeviceId());

        // 2 Set icon for device
        setDeviceImg(componentViewHolder, deviceData);
    }

    private void setDeviceImg(ComponentViewHolder componentViewHolder, DeviceData deviceData) {
        int imageTypeId = -1;
        switch (deviceData.getDeviceInfo().getDeviceType()) {
            case SMART_PHONE:
                imageTypeId = ResourceTable.Media_dv_phone;
                break;
            case SMART_PAD:
                imageTypeId = ResourceTable.Media_dv_pad;
                break;
            case SMART_WATCH:
                imageTypeId = ResourceTable.Media_dv_watch;
                break;
            default:
                break;
        }
        if (imageTypeId != -1) {
            Image image = (Image) componentViewHolder.getChildComponent(ResourceTable.Id_item_type);
            image.setPixelMap(imageTypeId);
        }
    }

    @Override
    public void onItemClick(Component component, DeviceData checkDeviceData, int position) {
        for (DeviceData deviceData : listBean) {
            deviceData.setChecked(false);
        }
        listBean.get(position).setChecked(true);

        // Notify data changes
        notifyDataChanged();
    }
}
