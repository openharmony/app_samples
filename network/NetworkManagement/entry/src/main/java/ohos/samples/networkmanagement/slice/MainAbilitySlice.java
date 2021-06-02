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

package ohos.samples.networkmanagement.slice;

import ohos.samples.networkmanagement.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);

        initComponents();
    }

    private void initComponents() {
        Component netButton = findComponentById(ResourceTable.Id_net_layout);
        Component socketClientButton = findComponentById(ResourceTable.Id_socket_client_layout);
        Component socketServerButton = findComponentById(ResourceTable.Id_socket_server_layout);
        Component cacheButton = findComponentById(ResourceTable.Id_cache_layout);
        netButton.setClickedListener(component -> present(new NetRequestSlice(), new Intent()));
        socketClientButton.setClickedListener(component -> present(new SocketClientSlice(), new Intent()));
        socketServerButton.setClickedListener(component -> present(new SocketServerSlice(), new Intent()));
        cacheButton.setClickedListener(component -> present(new HttpCacheSlice(), new Intent()));
    }
}
