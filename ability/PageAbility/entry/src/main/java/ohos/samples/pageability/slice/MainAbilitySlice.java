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

package ohos.samples.pageability.slice;

import ohos.samples.pageability.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String BUNDLE_NAME = "ohos.samples.pageability";

    private static final String FIRST_ABILITY_NAME = "ohos.samples.pageability.FirstAbility";

    private static final String CONTINUATION_ABILITY_NAME = "ohos.samples.pageability.ContinuationAbility";

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
    }

    private void initComponents() {
        findComponentById(ResourceTable.Id_navigation_button).setClickedListener(
            component -> startAbility(FIRST_ABILITY_NAME));
        findComponentById(ResourceTable.Id_continuation_button).setClickedListener(
            component -> startAbility(CONTINUATION_ABILITY_NAME));
    }

    private void startAbility(String abilityName) {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName(BUNDLE_NAME)
            .withAbilityName(abilityName)
            .build();
        intent.setOperation(operation);
        startAbility(intent);
    }
}
