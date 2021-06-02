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

package ohos.samples.pageability;

import ohos.samples.pageability.slice.SecondAbilityMainSlice;
import ohos.samples.pageability.slice.SecondAbilitySecondSlice;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;

/**
 * SecondAbility
 */
public class SecondAbility extends Ability {
    /**
     * Route action for SecondAbilitySecondSlice
     */
    public static final String ACTION = "SECOND_ABILITY_SECOND_SLICE_ACTION";

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setMainRoute(SecondAbilityMainSlice.class.getName());
        addActionRoute(ACTION, SecondAbilitySecondSlice.class.getName());
    }
}
