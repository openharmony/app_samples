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

package ohos.samples.secondapp;

import ohos.samples.secondapp.slice.MainAbilitySlice;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;

/**
 * MainAbility
 */
public class MainAbility extends Ability {
    private static final String RESULT_KEY = "ohos.samples.intent.RESULT_KEY";

    @Override
    public void onStart(Intent intent) {
        String ACTION_START = "ability.intent.START";
        super.onStart(intent);
        super.setMainRoute(MainAbilitySlice.class.getName());
        addActionRoute(ACTION_START, MainAbilitySlice.class.getName());
    }

    @Override
    protected void onActive() {
        Intent resultIntent = new Intent();
        resultIntent.setParam(RESULT_KEY, "Start second app succeeded");
        setResult(0, resultIntent);
    }
}
