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

package ohos.samples.positionlayout.slice;

import ohos.samples.positionlayout.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;

/**
 * Position Layouts
 */
public class PositionLayouts extends AbilitySlice {
    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_layout);
    }

    @Override
    protected void onActive() {
        super.onActive();
        /* start slice code */
        Component codeButtonComponent = findComponentById(ResourceTable.Id_start_code);
        codeButtonComponent.setClickedListener(component1 -> present(new PositionLayoutCodeSlice(), new Intent()));

        /* start slice xml */
        Component xmlButtonComponent = findComponentById(ResourceTable.Id_start_xml);
        xmlButtonComponent.setClickedListener(component1 -> present(new PositionLayoutXmlSlice(), new Intent()));
    }
}
