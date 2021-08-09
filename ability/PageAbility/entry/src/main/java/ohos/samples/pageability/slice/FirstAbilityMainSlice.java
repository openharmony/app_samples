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

import static ohos.samples.pageability.SecondAbility.ACTION;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.samples.pageability.ResourceTable;
import ohos.samples.pageability.SecondAbility;

/**
 * FirstAbilityMainSlice
 */
public class FirstAbilityMainSlice extends AbilitySlice {
    private static final int REQUEST_CODE = 0;

    private Text messageText;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_first_ability_main_slice);
        initComponents();
    }

    private void initComponents() {
        Component backButton = findComponentById(ResourceTable.Id_back_button);
        Component presentButton = findComponentById(ResourceTable.Id_present_button);
        Component presentSecondButton = findComponentById(ResourceTable.Id_present_second_ability_button);
        Component startSecondButton = findComponentById(ResourceTable.Id_start_second_ability_button);

        backButton.setClickedListener(component -> terminate());
        presentButton.setClickedListener(
            component -> presentForResult(new FirstAbilitySecondSlice(), new Intent(), REQUEST_CODE));
        presentSecondButton.setClickedListener(this::startAbilitySlice);
        startSecondButton.setClickedListener(this::startSecondAbilitySlice);

        messageText = (Text) findComponentById(ResourceTable.Id_message_text);
    }

    private void startAbilitySlice(Component component) {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("").withAction(ACTION)
            .withBundleName(getBundleName())
            .withAbilityName(SecondAbility.class.getName())
            .build();
        intent.setOperation(operation);
        startAbility(intent);
    }

    private void startSecondAbilitySlice(Component component) {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName(getBundleName())
            .withAbilityName(SecondAbility.class.getName())
            .build();
        intent.setOperation(operation);
        startAbility(intent);
    }

    @Override
    protected void onResult(int requestCode, Intent resultIntent) {
        if (requestCode == REQUEST_CODE && resultIntent != null) {
            messageText.setText(resultIntent.getStringParam(FirstAbilitySecondSlice.RESULT_KEY));
        }
    }
}
