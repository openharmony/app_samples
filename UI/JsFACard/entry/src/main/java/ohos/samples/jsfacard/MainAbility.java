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

package ohos.samples.jsfacard;

import ohos.aafwk.ability.FormBindingData;
import ohos.aafwk.ability.FormException;
import ohos.aafwk.ability.ProviderFormInfo;
import ohos.aafwk.content.Intent;
import ohos.ace.ability.AceAbility;
import ohos.samples.jsfacard.utils.LogUtils;
import ohos.utils.zson.ZSONObject;

/**
 * Main ability
 *
 * @since 2021-08-20
 */
public class MainAbility extends AceAbility {
    private static final String TAG = MainAbility.class.getName();

    private static final String STATUS = "status";

    private static final String PLAY = "play";

    private static final String PAUSE = "pause";

    private static boolean isStatus = true;

    @Override
    public void onStart(Intent intent) {
        LogUtils.info(TAG, "onStart");
        super.onStart(intent);
    }

    @Override
    protected ProviderFormInfo onCreateForm(Intent intent) {
        LogUtils.info(TAG, "onCreateForm");
        return super.onCreateForm(intent);
    }

    @Override
    protected void onUpdateForm(long formId) {
        LogUtils.info(TAG, "onUpdateForm");
        super.onUpdateForm(formId);
    }

    @Override
    protected void onDeleteForm(long formId) {
        LogUtils.info(TAG, "onDeleteForm: formId=" + formId);
        super.onDeleteForm(formId);
    }

    @Override
    protected void onTriggerFormEvent(long formId, String message) {
        LogUtils.info(TAG, "onTriggerFormEvent: formId=" + formId);
        super.onTriggerFormEvent(formId, message);
        ZSONObject zsonObject = new ZSONObject();
        if (isStatus) {
            zsonObject.put(STATUS, PAUSE);
            isStatus = false;
        } else {
            zsonObject.put(STATUS, PLAY);
            isStatus = true;
        }
        FormBindingData formBindingData = new FormBindingData(zsonObject);
        try {
            updateForm(formId, formBindingData);
        } catch (FormException e) {
            LogUtils.info(TAG, "onTriggerFormEvent:" + e.getMessage());
        }
    }
}