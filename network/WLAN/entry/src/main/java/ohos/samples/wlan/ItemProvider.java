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

package ohos.samples.wlan;

import ohos.agp.components.BaseItemProvider;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.app.Context;
import ohos.wifi.p2p.WifiP2pDevice;

import java.util.List;

/**
 * ItemProvider
 */
public class ItemProvider extends BaseItemProvider {
    private final Context context;

    private final List<WifiP2pDevice> wifiP2pDevices;

    public ItemProvider(Context abilitySliceContext, List<WifiP2pDevice> devices) {
        context = abilitySliceContext;
        wifiP2pDevices = devices;
    }

    @Override
    public int getCount() {
        return wifiP2pDevices.size();
    }

    @Override
    public WifiP2pDevice getItem(int index) {
        return wifiP2pDevices.get(index);
    }

    @Override
    public long getItemId(int index) {
        return index;
    }

    @Override
    public Component getComponent(int index, Component component, ComponentContainer componentContainer) {
        Text text = (Text) LayoutScatter.getInstance(context).parse(ResourceTable.Layout_item_layout, null, false);
        text.setText(wifiP2pDevices.get(index).getDeviceName());
        return text;
    }
}
