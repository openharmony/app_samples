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
import prompt from '@system.prompt'

export default {
    batteryLevel: function () {
        this.getBatteryLevel();
    },
    batterySubscribe: function () {
        this.batteryLevelSubscribe();
    },
    batteryUnSubscribe: function () {
        this.batteryLevelUnSubscribe();
    },
    initAction: function (code) {
        var actionData = {};
        var action = {};
        action.bundleName = "ohos.samples.jscalljava";
        action.abilityName = "BatteryInternalAbility";
        action.messageCode = code;
        action.data = actionData;
        action.abilityType = 1;
        action.syncOption = 0;
        return action;
    },
    getBatteryLevel: async function () {
        try {
            var action = this.initAction(1001);
            var result = await FeatureAbility.callAbility(action);
            console.info(" result = " + result);
            this.showToast(result);
        } catch (pluginError) {
            console.error("getBatteryLevel : Plugin Error = " + pluginError);
        }
    },
    batteryLevelSubscribe: async function () {
        try {
            var action = this.initAction(1002);
            var that = this;
            var result = await FeatureAbility.subscribeAbilityEvent(action,function (batteryLevel) {
                console.info(" batteryLevel info is: " + batteryLevel);
                var batteryData = JSON.parse(batteryLevel).data;
                that.showToast(" batteryState change: " + batteryData.msg);
            });
            this.showToast(" subscribe result " + result);
            console.info(" subscribeCommonEvent result = " + result);
        } catch (pluginError) {
            console.error("subscribeCommonEvent error : result= " + result + JSON.stringify(pluginError));
        }
    },
    batteryLevelUnSubscribe: async function () {
        try {
            var action = this.initAction(1003);
            var result = await FeatureAbility.unsubscribeAbilityEvent(action);
            FeatureAbility.callAbility(action);
            this.showToast("unsubscribe result " + result);
        } catch (pluginError) {
            console.error("batteryLevelUnSubscribe error : " + JSON.stringify(pluginError));
            this.showToast("batteryLevelUnSubscribe error : " + JSON.stringify(pluginError));
        }
    },
    showToast: function (msg) {
        prompt.showToast({
            message: msg
        });
    }
}
