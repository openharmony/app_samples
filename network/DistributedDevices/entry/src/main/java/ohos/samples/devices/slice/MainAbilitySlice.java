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

package ohos.samples.devices.slice;

import ohos.samples.devices.ResourceTable;
import ohos.samples.devices.provider.DeviceProvider;
import ohos.samples.devices.utils.LogUtil;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.ListContainer;
import ohos.agp.components.Text;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.distributedschedule.interwork.DeviceManager;
import ohos.distributedschedule.interwork.IDeviceStateCallback;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;

import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final int EVENT_STATE_CHANGE = 10001;

    private DeviceProvider deviceProvider;

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            deviceProvider.updateData(getDeviceList());
            updateComponents();
        }
    };

    private Text emptyText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_layout);

        initComponents();
        registerCallBack();
    }

    private void initComponents() {
        ListContainer listContainer = (ListContainer) findComponentById(ResourceTable.Id_container_list);
        emptyText = (Text) findComponentById(ResourceTable.Id_empty_text);
        deviceProvider = new DeviceProvider(this, getDeviceList());
        listContainer.setItemProvider(deviceProvider);
        updateComponents();
    }

    private void registerCallBack() {
        DeviceManager.registerDeviceStateCallback(iDeviceStateCallback);
    }

    private final IDeviceStateCallback iDeviceStateCallback = new IDeviceStateCallback() {
        @Override
        public void onDeviceOffline(String deviceId, int deviceType) {
            LogUtil.info(TAG, "DeviceOffline : " + deviceId);
            handler.sendEvent(EVENT_STATE_CHANGE);
        }

        @Override
        public void onDeviceOnline(String deviceId, int deviceType) {
            LogUtil.info(TAG, "DeviceOnline : " + deviceId);
            handler.sendEvent(EVENT_STATE_CHANGE);
        }
    };

    private List<DeviceInfo> getDeviceList() {
        return DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ALL_DEVICE);
    }

    private void updateComponents() {
        emptyText.setVisibility(getDeviceList().size() == 0 ? Component.VISIBLE : Component.HIDE);
    }
}
