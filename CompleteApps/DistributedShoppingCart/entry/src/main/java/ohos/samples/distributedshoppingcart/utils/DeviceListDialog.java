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

package ohos.samples.distributedshoppingcart.utils;

import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.ListContainer;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.app.Context;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.distributedschedule.interwork.DeviceManager;
import ohos.samples.distributedshoppingcart.ResourceTable;
import ohos.samples.distributedshoppingcart.provider.DevicesListProvider;

import java.util.ArrayList;
import java.util.List;

/**
 * DeviceListDialog
 */
public class DeviceListDialog {
    private static final int DIALOG_WIDTH = 840;
    private static final int DIALOG_HEIGHT = 900;

    private CommonDialog commonDialog;
    private final List<DeviceInfo> devices = new ArrayList<>();

    /**
     * DeviceListDialog
     *
     * @param context the context
     * @param opt the opt string
     * @param listener the listener event
     */
    public DeviceListDialog(Context context, String opt,SelectResultListener listener) {
        initDevices();
        initView(context, opt, listener);
    }

    private void initDevices() {
        if (devices.size() > 0) {
            devices.clear();
        }
        List<DeviceInfo> deviceInfos =
                DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ONLINE_DEVICE);
        devices.addAll(deviceInfos);
    }

    /**
     * SelectResultListener event
     */
    public interface SelectResultListener {
        /**
         * callBack
         *
         * @param devId the device id
         * @param opt the opt string
         */
        void callBack(String devId,String opt);
    }

    private void initView(Context context, String opt, SelectResultListener listener) {
        commonDialog = new CommonDialog(context);
        commonDialog.setAlignment(LayoutAlignment.CENTER);
        commonDialog.setSize(DIALOG_WIDTH, DIALOG_HEIGHT);
        commonDialog.setAutoClosable(true);
        Component dialogLayout = LayoutScatter.getInstance(context)
                .parse(ResourceTable.Layout_device_list_dialog, null, false);
        commonDialog.setContentCustomComponent(dialogLayout);
        ListContainer devicesListContainer = (ListContainer) dialogLayout.findComponentById(
            ResourceTable.Id_dev_container);
        DevicesListProvider devicesListProvider = new DevicesListProvider(devices, context);
        devicesListContainer.setItemProvider(devicesListProvider);
        devicesListContainer.setItemClickedListener(
            (listContainer, component, position, id) -> {
                commonDialog.destroy();
                listener.callBack(devices.get(position).getDeviceId(),opt);
            });
        devicesListProvider.notifyDataChanged();
        dialogLayout.findComponentById(ResourceTable.Id_dev_dialog).setClickedListener(
            component -> commonDialog.destroy());
        dialogLayout.findComponentById(ResourceTable.Id_dev_icon_cancel).setClickedListener(
            component -> commonDialog.destroy());
    }

    /**
     * show the dialog
     */
    public void show() {
        commonDialog.show();
    }
}

