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

package ohos.samples.animation.slice;

import ohos.samples.animation.ResourceTable;

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
        Component frameButton = findComponentById(ResourceTable.Id_animator_frame_button);
        Component propertyButton = findComponentById(ResourceTable.Id_animator_property_button);
        Component valueButton = findComponentById(ResourceTable.Id_animator_value_button);
        Component groupButton = findComponentById(ResourceTable.Id_animator_group_button);

        frameButton.setClickedListener(component -> present(new AnimatorFrameSlice(), new Intent()));
        propertyButton.setClickedListener(component -> present(new AnimatorPropertySlice(), new Intent()));
        valueButton.setClickedListener(component -> present(new AnimatorValueSlice(), new Intent()));
        groupButton.setClickedListener(component -> present(new AnimatorGroupAbilitySlice(), new Intent()));
    }
}
