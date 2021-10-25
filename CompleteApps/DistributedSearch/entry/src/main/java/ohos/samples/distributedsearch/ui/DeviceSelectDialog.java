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

package ohos.samples.distributedsearch.ui;

import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_CONTENT;
import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_PARENT;

import ohos.aafwk.ability.AbilitySlice;
import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.ListContainer;
import ohos.agp.components.Text;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.distributedschedule.interwork.DeviceManager;
import ohos.samples.distributedsearch.ResourceTable;
import ohos.samples.distributedsearch.data.DeviceData;
import ohos.samples.distributedsearch.provider.DeviceDataProvider;
import ohos.samples.distributedsearch.utils.LogUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * The type Device select dialog.
 *
 * @since 2021-04-27
 */
public class DeviceSelectDialog extends CommonDialog {
    private static final String TAG = DeviceSelectDialog.class.getSimpleName();

    private static final int CORNER_RADIUS = 10;

    private final AbilitySlice context;





    /**
     * Instantiates a new Device select dialog.
     *
     * @param context the context
     */
    public DeviceSelectDialog(AbilitySlice context) {
        super(context);
        this.context = context;
    }

    @Override
    protected void onCreate() {
        super.onCreate();
        List<DeviceData> deviceList = initDeviceData();
        Component rootView =
            LayoutScatter.getInstance(context).parse(ResourceTable.Layout_dialog_layout_device, null, false);
        ListContainer listContainer =
            (ListContainer) rootView.findComponentById(ResourceTable.Id_list_container_device);
        setItemProvider(listContainer, deviceList);
        configChoiceButton(rootView);
        configStyle(rootView);
    }

    private List<DeviceData> initDeviceData() {

        LogUtil.info(TAG, "begin to initDeviceData");
        List<DeviceInfo> deviceInfoList = DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ONLINE_DEVICE);
        List<DeviceData> deviceList = new ArrayList<>();
        for (DeviceInfo deviceInfo : deviceInfoList) {
            deviceList.add(new DeviceData(false, deviceInfo));
        }
        LogUtil.info(TAG, "get " + deviceInfoList.size() + " devices");
        return deviceList;
    }

    private void setItemProvider(ListContainer listContainer, List<DeviceData> deviceList) {
        LogUtil.info(TAG, "begin to setItemProvider");
        DeviceDataProvider deviceDataProvider =
            new DeviceDataProvider(context, deviceList, ResourceTable.Layout_dialog_device_item);
        listContainer.setItemProvider(deviceDataProvider);
    }

    private void configChoiceButton(Component rootView) {
        LogUtil.info(TAG, "begin to configChoiceButton");
        Text operateYes = (Text) rootView.findComponentById(ResourceTable.Id_operate_yes);
        operateYes.setClickedListener(component -> destroy());
        Text operateNo = (Text) rootView.findComponentById(ResourceTable.Id_operate_no);
        operateNo.setClickedListener(component -> destroy());
    }

    private void configStyle(Component rootView) {
        LogUtil.info(TAG, "begin to configStyle");
        setSize(MATCH_PARENT, MATCH_CONTENT);
        setAlignment(LayoutAlignment.BOTTOM);
        setCornerRadius(CORNER_RADIUS);
        setAutoClosable(true);
        setContentCustomComponent(rootView);
        setTransparent(true);
    }
}
