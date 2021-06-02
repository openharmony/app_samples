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

package ohos.samples.abilityinteractionex;

import ohos.samples.abilityinteractionex.slice.ThirdAbilitySlice;
import ohos.samples.abilityinteractionex.utils.Const;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;

/**
 * Third Ability
 */
public class ThirdAbility extends Ability {
    private static final String ABILITY_C2A_VALUE = "This param is returned by the third Ability.";

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setMainRoute(ThirdAbilitySlice.class.getName());
    }

    @Override
    protected void onActive() {
        super.onActive();
        Intent intent = new Intent();
        intent.setParam(Const.ABILITY_PARAMETER_KEY, ABILITY_C2A_VALUE);
        setResult(Const.ABILITY_RESULT_CODE, intent);
    }
}
