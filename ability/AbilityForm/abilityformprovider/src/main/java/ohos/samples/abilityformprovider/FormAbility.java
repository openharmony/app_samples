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

package ohos.samples.abilityformprovider;

import ohos.samples.abilityformprovider.slice.MainAbilitySlice;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.ability.AbilityForm;
import ohos.aafwk.ability.OnClickListener;
import ohos.aafwk.ability.ViewsStatus;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.event.intentagent.IntentAgent;
import ohos.event.intentagent.IntentAgentConstant;
import ohos.event.intentagent.IntentAgentHelper;
import ohos.event.intentagent.IntentAgentInfo;
import ohos.event.intentagent.TriggerInfo;

import java.util.ArrayList;
import java.util.List;

/**
 * FormAbility
 */
public class FormAbility extends Ability {
    private static int clickTimes = 0;

    @Override
    protected AbilityForm onCreateForm() {
        AbilityForm abilityForm = new AbilityForm(ResourceTable.Layout_form_layout, this);
        abilityForm.setText(ResourceTable.Id_content_text, generateFormText());
        abilityForm.registerViewListener(ResourceTable.Id_content_text, new OnClickListener() {
            @Override
            public void onClick(int viewId, AbilityForm form, ViewsStatus viewsStatus) {
                clickTimes++;
                form.setText(viewId, generateFormText());
                if (MainAbilitySlice.text != null) {
                    MainAbilitySlice.text.setText("Client.Counter: " + clickTimes);
                }
            }
        });

        abilityForm.registerViewListener(ResourceTable.Id_container_layout, new OnClickListener() {
            @Override
            public void onClick(int i, AbilityForm abilityForm, ViewsStatus viewsStatus) {
                setIntentAgent();
            }
        });
        return abilityForm;
    }

    private void setIntentAgent() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName("ohos.samples.abilityformprovider")
            .withAbilityName("ohos.samples.abilityformprovider.MainAbility")
            .build();
        intent.setOperation(operation);
        List<Intent> intentList = new ArrayList<>();
        intentList.add(intent);
        int requestCode = 200;
        List<IntentAgentConstant.Flags> flags = new ArrayList<>();
        flags.add(IntentAgentConstant.Flags.UPDATE_PRESENT_FLAG);
        IntentAgentInfo paramsInfo = new IntentAgentInfo(requestCode, IntentAgentConstant.OperationType.START_ABILITY,
            flags, intentList, null);
        IntentAgent agent = IntentAgentHelper.getIntentAgent(this, paramsInfo);

        IntentAgentHelper.triggerIntentAgent(this, agent, null, null, new TriggerInfo(null, null, null, requestCode));
    }

    /**
     * get clickTimes
     *
     * @return clickTimes
     */
    public static String generateFormText() {
        return "Total: " + clickTimes;
    }
}
