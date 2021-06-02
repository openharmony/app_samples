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

import prompt from "@system.prompt";
import router from "@system.router";

const injectRef = Object.getPrototypeOf(global) || global;

injectRef.regeneratorRuntime = require('@babel/runtime/regenerator');

export default {
    onInit() {
    },
    data: {
        textFromNotification: "",
    },
    clickStartInputNotification: function () {
        console.info("AutoReplyNotificationSample, clickStartNotification button clicked in JS");
        this.startNotification(1001);
    },
    clickStartButtonNotification: function () {
        console.info("AutoReplyNotificationSample, clickStartButtonNotification button clicked in JS");
        this.startNotification(1002);
    },
    clickCancelNotification: function () {
        console.info("AutoReplyNotificationSample, clickCancelNotification button clicked in JS");
        this.cancelNotification(1003);
    },
    clickSubscribeCommonEvent: async function() {
        console.info("AutoReplyNotificationSample, clickSubscribeCommonEvent button clicked in JS");
        this.subscribeCommonEvent(1004);
    },
    clickUnsubscribeCommonEvent: function () {
        console.info("AutoReplyNotificationSample, clickUnsubscribeCommonEvent button clicked in JS");
        this.unsubscribeCommonEvent(1005);
    },
    initAction: function (code) {
        var actionData = {};
        actionData.notify = "this actionData form JS ";
        var action = {};
        action.bundleName = "ohos.samples.autoreplynotificationsample";
        action.abilityName = "NotificationAbility";
        action.messageCode = code;
        action.data = actionData;
        action.abilityType = 1;
        action.syncOption = 0;
        return action;
    },
    startNotification: async function(code) {
        try {
            var action = this.initAction(code);
            var result = await FeatureAbility.callAbility(action);
            console.info(" result = " + result);
            this.showToast(result);
        } catch (pluginError) {
            console.error("startNotification : Plugin Error = " + pluginError);
        }
    },
    cancelNotification: async function(code) {
        try {
            var action = this.initAction(code);
            var result = await FeatureAbility.callAbility(action);
            this.showToast(result);
        } catch (pluginError) {
            console.error("Plugin error : " + JSON.stringify(pluginError));
        }
    },
    subscribeCommonEvent: async function(code) {
        try {
            var action = this.initAction(code);
            var that = this;
            var result = await FeatureAbility.subscribeAbilityEvent(action,function (notificationInfo) {
                var notificationInfoJson = JSON.parse(notificationInfo);
                console.info(" notification info is: " + notificationInfoJson.data);
                that.textFromNotification = notificationInfoJson.data;
            });
            this.showToast(" subscribe result " + result);
            console.info(" subscribeCommonEvent result = " + result);
        } catch (pluginError) {
            console.error("subscribeCommonEvent error : result= " + result + JSON.stringify(pluginError));
        }
    },
    unsubscribeCommonEvent: async function(code) {
        try {
            var action = this.initAction(code);
            var result = await FeatureAbility.unsubscribeAbilityEvent(action);
            FeatureAbility.callAbility(action);
            this.showToast("unsubscribe result " + result);
        } catch (pluginError) {
            console.error("Plugin error : " + JSON.stringify(pluginError));
        }
    },
    showToast: function (msg) {
        prompt.showToast({
            message: msg,
            duration: 2000
        });
    }
}
