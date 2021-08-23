/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.All rights reserved.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.samples.tictactoegame;

import ohos.samples.tictactoegame.slice.MainAbilitySlice;
import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.samples.tictactoegame.slice.StartAbilitySlice;

/**
 * MainAbility
 */
public class MainAbility extends Ability {
    private static final int GAME_DEFAULT_VALUE = 0;
    private static final int GAME_COM_IS_SLAVE = 301;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        int recParam = intent.getIntParam("data", GAME_DEFAULT_VALUE);
        if (recParam == GAME_COM_IS_SLAVE) {
            super.setMainRoute(StartAbilitySlice.class.getName());
        } else {
            super.setMainRoute(MainAbilitySlice.class.getName());
            super.addActionRoute("StartAbilitySlice", StartAbilitySlice.class.getName());
        }
        requestPermissionsFromUser(new String[]{
            "ohos.permission.DISTRIBUTED_DATASYNC",
            "ohos.permission.servicebus.ACCESS_SERVICE",
            "com.huawei.hwddmp.servicebus.BIND_SERVICE"}, 0);
    }
}
