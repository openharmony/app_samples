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

package ohos.samples.intent;

import ohos.samples.intent.slice.MainAbilitySlice;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Component;
import ohos.agp.components.Text;

/**
 * MainAbility
 */
public class MainAbility extends Ability {
    private static final String RESULT_KEY = "ohos.samples.intent.RESULT_KEY";

    private static final int REQ_CODE_START = 0;

    private Text resultText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setMainRoute(MainAbilitySlice.class.getName());
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
    }

    private void initComponents() {
        Component startByNameButton = findComponentById(ResourceTable.Id_start_by_name_button);
        Component startByAttributeButton = findComponentById(ResourceTable.Id_start_by_attribute_button);
        resultText = (Text) findComponentById(ResourceTable.Id_result_text);
        startByNameButton.setClickedListener(component -> startByName());
        startByAttributeButton.setClickedListener(component -> query());
    }

    private void startByName() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName("ohos.samples.secondapp")
            .withAbilityName("ohos.samples.secondapp.MainAbility")
            .build();
        intent.setOperation(operation);
        startAbility(intent);
    }

    private void query() {
        Intent intent = new Intent();
        String ACTION_START = "ability.intent.START";
        Operation operation = new Intent.OperationBuilder().withAction(ACTION_START).build();
        intent.setOperation(operation);
        startAbilityForResult(intent, REQ_CODE_START);
    }

    @Override
    protected void onAbilityResult(int requestCode, int resultCode, Intent resultData) {
        if (requestCode == REQ_CODE_START && resultData != null) {
            resultText.setText(resultData.getStringParam(RESULT_KEY));
        }
    }
}
