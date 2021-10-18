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
import ohos.samples.abilityinteraction.SecondAbility;
import ohos.samples.abilityinteraction.utils.Const;
import ohos.samples.abilityinteraction.utils.LogUtil;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.IAbilityContinuation;
import ohos.aafwk.ability.Lifecycle;
import ohos.aafwk.ability.LifecycleStateObserver;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.IntentParams;
import ohos.agp.components.Text;
import ohos.bundle.ElementName;

/**
 * First ability slice
 */
public class FirstAbilitySlice extends AbilitySlice implements LifecycleStateObserver, IAbilityContinuation {
    private static final String TAG = FirstAbilitySlice.class.getSimpleName();

    private static final int REQUEST_CODE_TO_ABILITY_B = 1;

    private static final String CONTINUE_PARAM_KEY_INPUT = "input";

    private long inputNum = Long.MIN_VALUE;

    private Text lifecycleState;

    private Text numberText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_first_ability_slice);
        initInputNum();
        initComponents();
        getLifecycle().addObserver(this);
    }

    private void initComponents() {
        findComponentById(ResourceTable.Id_enter_second).setClickedListener(component -> startSecondAbility());
        findComponentById(ResourceTable.Id_continue_ability).setClickedListener(component -> startContinue());
        numberText = (Text) findComponentById(ResourceTable.Id_number);
        lifecycleState = (Text) findComponentById(ResourceTable.Id_lifecycle_state);
    }

    private void startContinue() {
        try {
            continueAbility();
        } catch (IllegalStateException | UnsupportedOperationException e) {
            LogUtil.error(TAG, "startContinue Exception ");
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        getLifecycle().removeObserver(this);
    }

    private void initInputNum() {
        final int bound = 100;
        if (inputNum == Long.MIN_VALUE) {
            inputNum = System.currentTimeMillis() % bound;
        }
        ((Text) findComponentById(ResourceTable.Id_first_text)).setText("Calculates the square of " + inputNum);
    }

    private void startSecondAbility() {
        Intent intent = new Intent();
        intent.setElement(new ElementName("", getBundleName(), SecondAbility.class.getName()));
        intent.setParam(Const.MESSAGE_KEY_SQUARED, inputNum);
        if (this.getAbility().isTerminating()) {
            startAbilityForResult(intent, REQUEST_CODE_TO_ABILITY_B);
        }
    }

    @Override
    protected void onAbilityResult(int requestCode, int resultCode, Intent resultData) {
         if(requestCode == REQUEST_CODE_TO_ABILITY_B) {
             if (resultCode == Const.RESULT_CODE_FROM_ABILITY_B) {
                 long outputNum = resultData.getLongParam(Const.MESSAGE_KEY_SQUARED, 0);
                 numberText.setText(String.valueOf(outputNum));
             }
        }
    }

    @Override
    public void onStateChanged(Lifecycle.Event event, Intent intent) {
        lifecycleState.setText(lifecycleState.getText() + System.lineSeparator() + event.name());
    }

    @Override
    public boolean onStartContinuation() {
        return true;
    }

    @Override
    public boolean onSaveData(IntentParams intentParams) {
        intentParams.setParam(CONTINUE_PARAM_KEY_INPUT, inputNum);
        return true;
    }

    @Override
    public boolean onRestoreData(IntentParams intentParams) {
        Object object = intentParams.getParam(CONTINUE_PARAM_KEY_INPUT);
        if (object instanceof Long) {
            inputNum = (long) object;
        }
        return true;
    }

    @Override
    public void onCompleteContinuation(int i) {
        terminate();
    }
}