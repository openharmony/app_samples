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

package ohos.samples.multimodalevent.slice;

import ohos.agp.components.Component;
import ohos.samples.multimodalevent.ResourceTable;
import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;

/**
 * MainAbilitySlice
 *
 * @since 2021-05-24
 */
public class MainAbilitySlice extends AbilitySlice {
    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
    }

    private void initComponents() {
        Component componentTouch = findComponentById(ResourceTable.Id_touch_event);
        componentTouch.setClickedListener(listener -> present(new TouchEventAbilitySlice(), new Intent()));
        Component componentKey = findComponentById(ResourceTable.Id_key_event);
        componentKey.setClickedListener(listener -> present(new KeyEventAbilitySclice(), new Intent()));
        Component componentMedia = findComponentById(ResourceTable.Id_media_event);
        componentMedia.setClickedListener(listener -> present(new MediaEventAbilitySlice(), new Intent()));
        Component componentSystem = findComponentById(ResourceTable.Id_system_event);
        componentSystem.setClickedListener(listener -> present(new SystemEventAbilitySlice(), new Intent()));
        Component componentCommon = findComponentById(ResourceTable.Id_common_event);
        componentCommon.setClickedListener(listener -> present(new CommonEventAbilitySlice(), new Intent()));
        Component componentTel = findComponentById(ResourceTable.Id_telephone_event);
        componentTel.setClickedListener(listener -> present(new TelephoneEventAbilitySlice(), new Intent()));
    }

}
