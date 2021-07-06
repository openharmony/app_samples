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

package ohos.samples.fraction;

import ohos.aafwk.ability.fraction.FractionAbility;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Component;
import ohos.aafwk.content.Intent;

/**
 * MainAbility
 *
 * @since 2021-06-15
 */
public class MainAbility extends FractionAbility {
    private MainFraction mainFraction;
    private NextFraction nextFraction;
    private boolean isReplace;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_main);
        initComponents();
    }

    private void initComponents() {
        mainFraction = new MainFraction();
        nextFraction = new NextFraction();
        getFractionManager().startFractionScheduler().add(
                ResourceTable.Id_main_fraction, mainFraction, "mainFraction").submit();
        findComponentById(ResourceTable.Id_next_button).setClickedListener(this::startByName);
        findComponentById(ResourceTable.Id_replace_button).setClickedListener(this::replace);
    }

    private void replace(Component component) {
        if (!isReplace) {
            getFractionManager().startFractionScheduler().replace(
                    ResourceTable.Id_main_fraction, nextFraction).submit();
            isReplace = true;
        } else {
            getFractionManager().startFractionScheduler().replace(
                    ResourceTable.Id_main_fraction, mainFraction).submit();
            isReplace = false;
        }
    }

    private void startByName(Component component) {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
                .withBundleName("ohos.samples.fraction")
                .withAbilityName("ohos.samples.fraction.NextAbility")
                .build();
        intent.setOperation(operation);
        startAbility(intent);
    }

}
