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

package ohos.samples.adaptiveservicewidget;

import ohos.aafwk.ability.ProviderFormInfo;
import ohos.aafwk.content.Intent;
import ohos.ace.ability.AceAbility;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;

/**
 * MyApplication
 *
 * @since 2021-08-09
 */
public class MainAbility extends AceAbility {
    private static final HiLogLabel TAG = new HiLogLabel(HiLog.DEBUG, 0x0, MainAbility.class.getName());

    @Override
    public void onStart(Intent intent) {
        HiLog.info(TAG, "onStart");
        super.onStart(intent);
    }

    @Override
    protected ProviderFormInfo onCreateForm(Intent intent) {
        HiLog.info(TAG, "onCreateForm");
        return super.onCreateForm(intent);
    }

    @Override
    protected void onUpdateForm(long formId) {
        HiLog.info(TAG, "onUpdateForm");
        super.onUpdateForm(formId);
    }

    @Override
    protected void onDeleteForm(long formId) {
        HiLog.info(TAG, "onDeleteForm: formId=" + formId);
        super.onDeleteForm(formId);
    }

    @Override
    protected void onTriggerFormEvent(long formId, String message) {
        HiLog.info(TAG, "onTriggerFormEvent: " + message);
        super.onTriggerFormEvent(formId, message);
    }
}