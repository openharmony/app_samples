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

/**
 * FirstAbilitySecondSlice
 */
public class FirstAbilitySecondSlice extends AbilitySlice {
    /**
     * Result key
     */
    public static final String RESULT_KEY = "ohos.samples.pageability.RESULT_KEY";

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ohos.samples.pageability.ResourceTable.Layout_first_ability_second_slice);
        initComponents();
        setResult();
    }

    private void initComponents() {
        findComponentById(ResourceTable.Id_back_button).setClickedListener(component -> terminate());
    }

    private void setResult() {
        Intent intent = new Intent();
        intent.setParam(RESULT_KEY, "I'm a message from first ability second slice");
        setResult(intent);
    }
}
