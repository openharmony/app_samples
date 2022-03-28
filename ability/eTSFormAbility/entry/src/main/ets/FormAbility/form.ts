/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import dataStorage from '@ohos.data.storage';
import formBindingData from '@ohos.application.formBindingData';
import formInfo from '@ohos.application.formInfo';
import formProvider from '@ohos.application.formProvider';
import Logger from '../model/Logger'

const DATA_STORAGE_PATH = "/data/storage/el2/base/haps/form_store";
const FORM_PARAM_IDENTITY_KEY = "ohos.extra.param.key.form_identity";
const FORM_PARAM_NAME_KEY = "ohos.extra.param.key.form_name";
const FORM_PARAM_TEMPORARY_KEY = "ohos.extra.param.key.form_temporary";
const TAG: string = "[LifecycleForm]";

function getTemperature(formId: string, count: number) {
    const DECIMAL: number = 10;
    const parsedFormId: number = parseInt(formId, DECIMAL);
    const BASE_TEMP_MOD: number = 20;
    const baseTemperature: number = parsedFormId % BASE_TEMP_MOD;
    const RANGE_TEMP_MOD: number = 20;
    return baseTemperature + Math.abs(count % RANGE_TEMP_MOD - RANGE_TEMP_MOD / 2);
}

function padZero(num: number) {
    // trans num to string and pad 0
    if (num < 10) {
        return `0${num}`;
    } else {
        return num.toString();
    }
}

function getTime() {
    const date = new Date();
    const hours = padZero(date.getHours());
    const minutes = padZero(date.getMinutes());
    const seconds = padZero(date.getSeconds());
    return `${hours}:${minutes}:${seconds}`
}

async function storeFormInfo(formId: string, formName: string, tempFlag: boolean) {
    let formInfo = {
        "formName": formName,
        "tempFlag": tempFlag,
        "updateCount": 0
    };
    try {
        const storage = await dataStorage.getStorage(DATA_STORAGE_PATH);
        // put form info
        await storage.put(formId, JSON.stringify(formInfo));
        Logger.log(TAG, `storeFormInfo, put form info successfully, formId: ${formId}`);
        await storage.flush();
    } catch (err) {
        Logger.error(TAG, `failed to storeFormInfo, err: ${JSON.stringify(err)}`);
    }
}

async function updateTempFormInfo(formId: string) {
    let formInfoDefault = {
        "formName": "",
        "tempFlag": false,
        "updateCount": 0
    };
    try {
        const storage = await dataStorage.getStorage(DATA_STORAGE_PATH);
        // get form info
        const data = await storage.get(formId, JSON.stringify(formInfoDefault));
        Logger.log(TAG, `updateTempFormInfo, get form info successfully, formId: ${formId}`);
        const formInfo = JSON.parse(data.toString());
        if (!formInfo.tempFlag) {
            Logger.log(TAG, `updateTempFormInfo, formId: ${formId} is not temporary.`);
            return;
        }

        formInfo.tempFlag = false;
        // update form info
        await storage.put(formId, JSON.stringify(formInfo));
        Logger.log(TAG, `updateTempFormInfo, update form info successfully, formId: ${formId}`);
        await storage.flush();
    } catch (err) {
        Logger.error(TAG, `failed to updateTempFormInfo, err: ${JSON.stringify(err)}`);
    }
}

async function updateForm(formId: string) {
    let formInfoDefault = {
        "formName": "",
        "tempFlag": false,
        "updateCount": 0
    };
    try {
        const storage = await dataStorage.getStorage(DATA_STORAGE_PATH);
        // get form info
        const data = await storage.get(formId, JSON.stringify(formInfoDefault));
        Logger.log(TAG, `updateForm, get form info successfully, formId: ${formId}`);
        const formInfo = JSON.parse(data.toString());
        formInfo.updateCount = formInfo.updateCount + 1;

        let obj = {
            "temperature": getTemperature(formId, formInfo.updateCount).toString(),
            "time": getTime()
        };
        let formData = formBindingData.createFormBindingData(obj);
        formProvider.updateForm(formId, formData).catch((err) => {
            Logger.error(TAG, `updateForm, err: ${JSON.stringify(err)}`);
        });

        // update form info
        await storage.put(formId, JSON.stringify(formInfo));
        Logger.log(TAG, `updateForm, update form info successfully, formId: ${formId}`);
        await storage.flush();
    } catch (err) {
        Logger.error(TAG, `failed to updateForm, err: ${JSON.stringify(err)}`);
    }
}

async function deleteFormInfo(formId: string) {
    try {
        const storage = await dataStorage.getStorage(DATA_STORAGE_PATH);
        // del form info
        await storage.delete(formId);
        Logger.log(TAG, `deleteFormInfo, del form info successfully, formId: ${formId}`);
        await storage.flush();
    } catch (err) {
        Logger.error(TAG, `failed to deleteFormInfo, err: ${JSON.stringify(err)}`);
    }
}

export default {
    onCreate(want) {
        Logger.log(TAG, `FormAbility onCreate, want: ${JSON.stringify(want)}`);

        // get form info
        let formId = want.parameters[FORM_PARAM_IDENTITY_KEY];
        let formName = want.parameters[FORM_PARAM_NAME_KEY];
        let tempFlag = want.parameters[FORM_PARAM_TEMPORARY_KEY];
        storeFormInfo(formId, formName, tempFlag);

        let obj = {
            "temperature": getTemperature(formId, 0).toString(),
            "time": getTime()
        };
        let formData = formBindingData.createFormBindingData(obj);
        return formData;
    },
    onCastToNormal(formId) {
        Logger.log(TAG, `FormAbility onCastToNormal, formId: ${formId}`);
        updateTempFormInfo(formId);
    },
    onUpdate(formId) {
        Logger.log(TAG, `FormAbility onUpdate, formId: ${formId}`);
        updateForm(formId);
    },
    onVisibilityChange(newStatus) {
        Logger.log(TAG, `FormAbility onVisibilityChange`);
    },
    onEvent(formId, message) {
        Logger.log(TAG, `FormAbility onEvent`);
    },
    onDestroy(formId) {
        Logger.log(TAG, `FormAbility onDestroy, formId = ${formId}`);
        deleteFormInfo(formId);
    },
    onAcquireFormState(want) {
        Logger.log(TAG, `FormAbility onAcquireFormState`);
        return formInfo.FormState.READY;
    },
}
