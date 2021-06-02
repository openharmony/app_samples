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

package ohos.samples.jstransparent;


import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Component;


/**
 * Displays the button for entering the mode.
 */
public class MainAbility extends Ability {
    private Component modalNormal;

    private Component modalSemimode;

    private Component modalHalf;

    private Component modalPopup;

    @Override
    public void onStart(Intent intent) {
        intent.setParam("window_modal", 1);
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_layout);
    }

    @Override
    protected void onActive() {
        super.onActive();
        initView();
        initClickEvents();
    }

    private void initView() {
        modalNormal = findComponentById(ResourceTable.Id_modalnormal);
        modalSemimode = findComponentById(ResourceTable.Id_modalsemimode);
        modalHalf = findComponentById(ResourceTable.Id_modalhalf);
        modalPopup = findComponentById(ResourceTable.Id_modalpopup);
    }

    private void initClickEvents() {
        modalNormal.setClickedListener(
            component -> startModalAbility(getBundleName(), ModalNormalAbility.class.getName(), 0));
        modalSemimode.setClickedListener(component -> {
            startModalAbility(getBundleName(), ModalSemimodeAbility.class.getName(), 1);
            terminateAbility();
        });
        modalHalf.setClickedListener(
            component -> startModalAbility(getBundleName(), ModalHalfAbility.class.getName(), 2));
        modalPopup.setClickedListener(component -> {
            startModalAbility(getBundleName(), ModalPopupAbility.class.getName(), 3);
            terminateAbility();
        });
    }

    private void startModalAbility(String bundleName, String abilityName, int modal) {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withBundleName(bundleName)
            .withAbilityName(abilityName)
            .build();
        intent.setOperation(operation);
        intent.setParam("window_modal", modal);
        startAbility(intent);
    }
}
