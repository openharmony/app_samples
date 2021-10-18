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

import ohos.aafwk.ability.Ability;
import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.FormBindingData;
import ohos.aafwk.ability.ProviderFormInfo;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.data.DatabaseHelper;
import ohos.data.orm.OrmContext;
import ohos.samples.jsfacard.database.Form;
import ohos.samples.jsfacard.database.FormDatabase;
import ohos.samples.jsfacard.slice.ClockAbilitySlice;
import ohos.samples.jsfacard.utils.DatabaseUtils;
import ohos.samples.jsfacard.utils.DateUtils;
import ohos.samples.jsfacard.utils.LogUtils;
import ohos.utils.zson.ZSONObject;

/**
 * ClockAbility
 *
 * @since 2021-08-20
 */
public class ClockAbility extends Ability {
    private static final String TAG = ClockAbility.class.getName();

    private static final int INVALID_FORM_ID = -1;

    private static final String EMPTY_STRING = "";

    private static final int DEFAULT_DIMENSION_1x2 = 1;

    private OrmContext connect;

    private final DatabaseHelper helper = new DatabaseHelper(this);

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        startTimerAbility();
        connect = helper.getOrmContext("FormDatabase", "FormDatabase.db", FormDatabase.class);
        super.setMainRoute(ClockAbilitySlice.class.getName());
    }

    private void startTimerAbility(){
        Intent intentService = new Intent();
        Operation operation = new Intent.OperationBuilder()
                .withDeviceId("")
                .withBundleName(getBundleName())
                .withAbilityName(TimerAbility.class.getName())
                .build();
        intentService.setOperation(operation);
        startAbility(intentService);
    }

    @Override
    protected ProviderFormInfo onCreateForm(Intent intent) {
        startTimerAbility();
        ProviderFormInfo providerFormInfo = new ProviderFormInfo();
        LogUtils.info(TAG, "onCreateForm()");
        if (intent == null) {
            return providerFormInfo;
        }

        long formId;
        if (intent.hasParameter(AbilitySlice.PARAM_FORM_IDENTITY_KEY)) {
            formId = intent.getLongParam(AbilitySlice.PARAM_FORM_IDENTITY_KEY, INVALID_FORM_ID);
        } else {
            return providerFormInfo;
        }

        String formName = EMPTY_STRING;
        if (intent.hasParameter(AbilitySlice.PARAM_FORM_NAME_KEY)) {
            formName = intent.getStringParam(AbilitySlice.PARAM_FORM_NAME_KEY);
        }

        int dimension = DEFAULT_DIMENSION_1x2;
        if (intent.hasParameter(AbilitySlice.PARAM_FORM_DIMENSION_KEY)) {
            dimension = intent.getIntParam(AbilitySlice.PARAM_FORM_DIMENSION_KEY, DEFAULT_DIMENSION_1x2);
        }

        if (connect == null) {
            connect = helper.getOrmContext("FormDatabase", "FormDatabase.db", FormDatabase.class);
        }
        Form form = new Form(formId, formName, dimension);
        DatabaseUtils.insertForm(form, connect);

        ZSONObject zsonObject = DateUtils.getZsonObject();
        LogUtils.info(TAG, "onCreateForm()" + zsonObject);
        providerFormInfo.setJsBindingData(new FormBindingData(zsonObject));
        return providerFormInfo;
    }

    @Override
    protected void onDeleteForm(long formId) {
        LogUtils.info(TAG, "onDeleteForm():formId=" + formId);
        super.onDeleteForm(formId);
        DatabaseUtils.deleteFormData(formId, connect);
    }
}
