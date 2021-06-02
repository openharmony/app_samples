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

package ohos.samples.abilityinteractionex.slice;

import ohos.samples.abilityinteractionex.ResourceTable;
import ohos.samples.abilityinteractionex.utils.Const;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Component;
import ohos.agp.components.Text;

import java.util.HashSet;
import java.util.Set;

/**
 * First Ability Slice
 */
public class FirstAbilitySlice extends AbilitySlice {
    private static final String BUNDLE_NAME = "ohos.samples.abilityinteractionex";

    private static final String ABILITY_B_NAME = "SecondAbility";

    private static final String ABILITY_C_ACTION = "ohos.samples.abilityinteractionex.ACTION";

    private static final String ABILITY_C_ENTITY = "ohos.samples.abilityinteractionex.ENTITY";

    private static final String ABILITY_PARAMETERS = "This param from the first Ability.";

    private static final int ABILITY_B_REQUEST_CODE = 1;

    private static final int ABILITY_C_REQUEST_CODE = 2;

    private Text backValueText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_first_ability_slice);

        // start enter second ability
        Component enterSecondAbilityButton = findComponentById(ResourceTable.Id_enter_second);
        enterSecondAbilityButton.setClickedListener(component -> startEnterSecondAbility());

        // start enter third ability
        Component enterThirdAbilityButton = findComponentById(ResourceTable.Id_enter_third);
        enterThirdAbilityButton.setClickedListener(component -> startEnterThirdAbility());

        backValueText = (Text) findComponentById(ResourceTable.Id_first_text);
    }

    /**
     * Explicit Startup
     */
    private void startEnterSecondAbility() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName(BUNDLE_NAME)
            .withAbilityName(ABILITY_B_NAME)
            .build();
        intent.setOperation(operation);
        intent.setParam(Const.ABILITY_PARAMETER_KEY, ABILITY_PARAMETERS);
        startAbilityForResult(intent, ABILITY_B_REQUEST_CODE);
    }

    /**
     * Implicit Startup
     */
    private void startEnterThirdAbility() {
        Intent intent = new Intent();
        Set<String> entries = new HashSet<>();
        entries.add(ABILITY_C_ENTITY);
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withAction(ABILITY_C_ACTION)
            .withEntities(entries)
            .build();
        intent.setOperation(operation);
        intent.setParam(Const.ABILITY_PARAMETER_KEY, ABILITY_PARAMETERS);
        startAbilityForResult(intent, ABILITY_C_REQUEST_CODE);
    }

    @Override
    protected void onAbilityResult(int requestCode, int resultCode, Intent resultData) {
        if (resultCode != Const.ABILITY_RESULT_CODE || resultData == null) {
            return;
        }
        String result = resultData.getStringParam(Const.ABILITY_PARAMETER_KEY);
        backValueText.setText(result);
    }
}
