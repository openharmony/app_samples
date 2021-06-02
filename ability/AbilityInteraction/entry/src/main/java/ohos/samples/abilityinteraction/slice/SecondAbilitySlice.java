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

package ohos.samples.abilityinteraction.slice;

import ohos.samples.abilityinteraction.ResourceTable;
import ohos.samples.abilityinteraction.utils.Const;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Text;

/**
 * Second ability slice
 */
public class SecondAbilitySlice extends AbilitySlice {
    private long outputNum;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_second_ability_slice);

        findComponentById(ResourceTable.Id_second_back_first).setClickedListener(component -> {
            Intent backIntent = new Intent();
            backIntent.setParam(Const.MESSAGE_KEY_SQUARED, outputNum);
            getAbility().setResult(Const.RESULT_CODE_FROM_ABILITY_B, backIntent);
            terminate();
        });

        long inputNum = intent.getLongParam(Const.MESSAGE_KEY_SQUARED, 0);
        outputNum = inputNum * inputNum;
        Text displayText = (Text) findComponentById(ResourceTable.Id_number);
        displayText.setText(String.valueOf(outputNum));
    }
}
