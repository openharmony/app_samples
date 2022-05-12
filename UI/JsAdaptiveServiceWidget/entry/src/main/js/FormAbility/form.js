
import dataStorage from '@ohos.data.storage';
import formBindingData from '@ohos.application.formBindingData';
import formInfo from '@ohos.application.formInfo';
import formProvider from '@ohos.application.formProvider';
import Logger from './Logger'


const DATA_STORAGE_PATH = "/data/storage/el2/base/haps/form_store";
const FORM_PARAM_IDENTITY_KEY = "ohos.extra.param.key.form_identity";
const FORM_PARAM_NAME_KEY = "ohos.extra.param.key.form_name";
const FORM_PARAM_TEMPORARY_KEY = "ohos.extra.param.key.form_temporary";

function getTemperature(formId, count) {
    const DECIMAL = 10;
    const parsedFormId = parseInt(formId, DECIMAL);
    const BASE_TEMP_MOD = 20;
    const baseTemperature = parsedFormId % BASE_TEMP_MOD;
    const RANGE_TEMP_MOD = 20;
    return baseTemperature + Math.abs(count % RANGE_TEMP_MOD - RANGE_TEMP_MOD / 2);
}

function padZero(num) {
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

async function storeFormInfo(formId, formName, tempFlag) {
    let formInfo = {
        "formName": formName,
        "tempFlag": tempFlag,
        "updateCount": 0
    };
    try {
        const storage = await dataStorage.getStorage(DATA_STORAGE_PATH);
        // put form info
        await storage.put(formId, JSON.stringify(formInfo));
        Logger.info(`storeFormInfo, put form info successfully, formId: ${formId}`);
        await storage.flush();
    } catch (err) {
        Logger.error(`failed to storeFormInfo, err: ${JSON.stringify(err)}`);
    }
}

async function updateTempFormInfo(formId) {
    let formInfoDefault = {
        "formName": "",
        "tempFlag": false,
        "updateCount": 0
    };
    try {
        const storage = await dataStorage.getStorage(DATA_STORAGE_PATH);
        // get form info
        const data = await storage.get(formId, JSON.stringify(formInfoDefault));
        Logger.info(`updateTempFormInfo, get form info successfully, formId: ${formId}`);
        const formInfo = JSON.parse(data.toString());
        if (!formInfo.tempFlag) {
            Logger.info(`updateTempFormInfo, formId: ${formId} is not temporary.`);
            return;
        }

        formInfo.tempFlag = false;
        // update form info
        await storage.put(formId, JSON.stringify(formInfo));
        Logger.info(`updateTempFormInfo, update form info successfully, formId: ${formId}`);
        await storage.flush();
    } catch (err) {
        Logger.error(`failed to updateTempFormInfo, err: ${JSON.stringify(err)}`);
    }
}

async function updateForm(formId) {
    let formInfoDefault = {
        "formName": "",
        "tempFlag": false,
        "updateCount": 0
    };
    try {
        const storage = await dataStorage.getStorage(DATA_STORAGE_PATH);
        // get form info
        const data = await storage.get(formId, JSON.stringify(formInfoDefault));
        Logger.info(`updateForm, get form info successfully, formId: ${formId}`);
        const formInfo = JSON.parse(data.toString());
        formInfo.updateCount = formInfo.updateCount + 1;

        let obj = {
            "temperature": getTemperature(formId, formInfo.updateCount).toString(),
            "time": getTime()
        };
        let formData = formBindingData.createFormBindingData(obj);
        formProvider.updateForm(formId, formData).catch((err) => {
            Logger.error(`updateForm, err: ${JSON.stringify(err)}`);
        });

        // update form info
        await storage.put(formId, JSON.stringify(formInfo));
        Logger.info(`updateForm, update form info successfully, formId: ${formId}`);
        await storage.flush();
    } catch (err) {
        Logger.error(`failed to updateForm, err: ${JSON.stringify(err)}`);
    }
}

async function deleteFormInfo(formId) {
    try {
        const storage = await dataStorage.getStorage(DATA_STORAGE_PATH);
        // del form info
        await storage.delete(formId);
        Logger.info(`deleteFormInfo, del form info successfully, formId: ${formId}`);
        await storage.flush();
    } catch (err) {
        Logger.error(`failed to deleteFormInfo, err: ${JSON.stringify(err)}`);
    }
}

export default {
    onCreate(want) {
        Logger.info(`FormAbility onCreate, want: ${JSON.stringify(want)}`);
        // Called to return a FormBindingData object.

        let formId = want.parameters[FORM_PARAM_IDENTITY_KEY];
        let formName = want.parameters[FORM_PARAM_NAME_KEY];
        let tempFlag = want.parameters[FORM_PARAM_TEMPORARY_KEY];
        storeFormInfo(formId, formName, tempFlag);

        let obj = {
            "temperature": getTemperature(formId, 0).toString(),
            "time": getTime()
        };
        let formData = {};
        return formBindingData.createFormBindingData(formData);
    },

    onCastToNormal(formId) {
        // Called when the form provider is notified that a temporary form is successfully
        // converted to a normal form.
        Logger.info(`FormAbility onCastToNormal, formId: ${formId}`);
        updateTempFormInfo(formId);
    },

    onUpdate(formId) {
        // Called to notify the form provider to update a specified form.
        Logger.info(`FormAbility onUpdate, formId: ${formId}`);
        updateForm(formId);
    },

    onVisibilityChange(newStatus) {
        // Called when the form provider receives form events from the system.
        Logger.info(`FormAbility onVisibilityChange`);
    },

    onEvent(formId, message) {
        // Called when a specified message event defined by the form provider is triggered.
        Logger.info(`FormAbility onEvent, formId = ${formId}, message: ${JSON.stringify(message)}`);
    },

    onDestroy(formId) {
        // Called to notify the form provider that a specified form has been destroyed.
        Logger.info(`FormAbility onDestroy, formId = ${formId}`);
        deleteFormInfo(formId);
    },

    onAcquireFormState(want) {
        // Called to return a {@link FormState} object.
        Logger.info(`FormAbility onAcquireFormState`);
        return formInfo.FormState.READY;
    }
}