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

package ohos.samples.bluetooth.adapter;

import ohos.samples.bluetooth.BluetoothPlugin;
import ohos.samples.bluetooth.ResourceTable;
import ohos.samples.bluetooth.model.BluetoothDevice;

import ohos.agp.components.BaseItemProvider;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.app.AbilityContext;
import ohos.bluetooth.BluetoothRemoteDevice;

import java.util.List;

/**
 * BluetoothItemProvider extends BaseItemProvider
 */
public class BluetoothItemProvider extends BaseItemProvider {
    private final AbilityContext context;

    private List<BluetoothDevice> bluetoothDeviceList;

    public BluetoothItemProvider(AbilityContext context, List<BluetoothDevice> itemList) {
        this.context = context;
        bluetoothDeviceList = itemList;
    }

    @Override
    public int getCount() {
        return bluetoothDeviceList.size();
    }

    @Override
    public Object getItem(int position) {
        return bluetoothDeviceList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public Component getComponent(int position, Component component, ComponentContainer componentContainer) {
        return getRootComponent(position);
    }

    private Component getRootComponent(int position) {
        Component rootComponent = LayoutScatter.getInstance(context)
            .parse(ResourceTable.Layout_list_item, null, false);

        Text deviceName = (Text) rootComponent.findComponentById(ResourceTable.Id_bluetooth_device_name);

        BluetoothDevice bluetoothDevice = bluetoothDeviceList.get(position);
        deviceName.setText(bluetoothDevice.getName());

        rootComponent.setClickedListener(component -> {
            if (bluetoothDevice.getPairState() == BluetoothRemoteDevice.PAIR_STATE_NONE) {
                BluetoothPlugin.getInstance(context).startPair(bluetoothDevice.getAddress());
            }
        });

        return rootComponent;
    }

    /**
     * updates available Bluetooth devices in UI
     *
     * @param devices list of Bluetooth devices
     */
    public void updateDeviceList(List<BluetoothDevice> devices) {
        bluetoothDeviceList = devices;
        notifyDataChanged();
    }
}
