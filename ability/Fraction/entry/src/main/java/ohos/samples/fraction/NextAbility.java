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

import ohos.aafwk.ability.fraction.Fraction;
import ohos.aafwk.ability.fraction.FractionAbility;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;

import java.util.Optional;

/**
 * NextAbility
 *
 * @since 2021-06-15
 */
public class NextAbility extends FractionAbility {
    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, "NextAbility");
    private Button hideButton;
    private Button pushButton;
    private MainFraction mainFraction;


    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_next);
        NextFraction nextFraction;
        mainFraction = new MainFraction();
        nextFraction = new NextFraction();
        getFractionManager().startFractionScheduler().add(ResourceTable.Id_next_fraction,
                nextFraction, "nextFraction").submit();
        Component componentHide = findComponentById(ResourceTable.Id_hide_button);
        if (componentHide instanceof Button) {
            hideButton = (Button) componentHide;
            hideButton.setClickedListener(this::hide);
        }
        Component componentPush = findComponentById(ResourceTable.Id_push_button);
        if (componentPush instanceof Button) {
            pushButton = (Button) componentPush;
            pushButton.setClickedListener(this::push);
        }
    }

    private void push(Component component) {
        if ((getApplicationContext().getString(ResourceTable.String_push_into_stack)).equals(pushButton.getText())) {
            getFractionManager().startFractionScheduler().add(ResourceTable.Id_next_fraction,
                    mainFraction, "mainFraction").pushIntoStack("stack").submit();
            pushButton.setText(getApplicationContext().getString(ResourceTable.String_pop_from_stack));
        } else {
            getFractionManager().popFromStack();
            pushButton.setText(getApplicationContext().getString(ResourceTable.String_push_into_stack));
        }
    }

    private void hide(Component component) {
        Fraction fraction = new Fraction();
        Optional<Fraction> optional = getFractionManager().getFractionByTag("nextFraction");
        if (optional.isPresent()) {
            fraction = optional.get();
        }
        if ((getApplicationContext().getString(ResourceTable.String_hide_fraction)).equals(hideButton.getText())) {
            hideButton.setText(getApplicationContext().getString(ResourceTable.String_show_fraction));
            getFractionManager().startFractionScheduler().hide(fraction).submit();
            HiLog.info(LABEL_LOG, "hide fraction");
        } else {
            hideButton.setText(getApplicationContext().getString(ResourceTable.String_hide_fraction));
            getFractionManager().startFractionScheduler().show(fraction).submit();
            HiLog.info(LABEL_LOG, "show fraction");
        }
    }

}
