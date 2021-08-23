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

package ohos.samples.tictactoegame.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.*;
import ohos.samples.tictactoegame.ResourceTable;
import ohos.samples.tictactoegame.ui.DeviceSelectDialog;
import ohos.samples.tictactoegame.utils.GameRulesUtils;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final int GAME_COM_IS_SLAVE = 301;

    @Override
        public void onStart(Intent intent) {
            super.onStart(intent);
            super.setUIContent(ResourceTable.Layout_ability_main);

            Button button = (Button) findComponentById(ResourceTable.Id_mainButton);
            button.setClickedListener(component -> {
                DeviceSelectDialog dialog = new DeviceSelectDialog(getContext());
                dialog.setListener(deviceInfo -> {
                    Intent myIntent = new Intent();
                    Operation op = new Intent.OperationBuilder()
                            .withDeviceId(deviceInfo.getDeviceId())
                            .withBundleName(getBundleName())
                            .withAbilityName("ohos.samples.tictactoegame.MainAbility")
                            .withFlags(Intent.FLAG_ABILITYSLICE_MULTI_DEVICE)
                            .build();
                    myIntent.setOperation(op);
                    myIntent.setParam("data", GAME_COM_IS_SLAVE);
                    startAbility(myIntent);

                    Intent intent1 = new Intent();
                    intent1.setParam("user", "main");
                    dialog.hide();
                    present(new StartAbilitySlice(), intent1);
                });
                dialog.show();
            });

        Text imgGameRule = (Text) findComponentById(ResourceTable.Id_game_rule);
        imgGameRule.setClickedListener(component -> {
            GameRulesUtils gameRuleDialog = new GameRulesUtils(getContext());
            gameRuleDialog.show();
        });
        }

        @Override
        public void onActive() {
            super.onActive();
        }

        @Override
        public void onForeground(Intent intent) {
            super.onForeground(intent);
        }
}



