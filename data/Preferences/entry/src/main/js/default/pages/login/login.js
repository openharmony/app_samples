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

export default {
    data: {
        userID: "",
        password: ""
    },
    updateUserID: function (e) {
        var that = this;
        that.userID = e.value;
    },
    updatePassword: function (e) {
        var that = this;
        that.password = e.value;
    },
    login: function () {
        var that = this;
        if (that.userID && that.password) {
            that.saveLoginStatus();
        } else {
            console.info("Login : Invalid userID and Password");
            that.showToast("Please enter a valid userID and Password");
        }
    },
    showToast: function (msg) {
        prompt.showToast({
            message: msg,
            duration: "3000"
        });
    },

/**
   * save the login status in preference
   */
    saveLoginStatus: async function() {
        try {
            var that = this;
            var actionData = {};
            actionData.userId = that.userID;
            actionData.password = that.password;
            actionData.loginState = 1;

            var action = {};
            action.bundleName = "ohos.samples.preferences";
            action.abilityName = "PreferencesInternalAbility";
            action.messageCode = 1004;
            action.data = actionData;
            action.abilityType = 1;
            action.syncOption = 0;
            var result = await FeatureAbility.callAbility(action);
            console.info("Login : result for login : " + result);
            var resultJson = JSON.parse(result);
            if (resultJson.code == 0) {
                that.gotoMain();
            } else {
                console.error("Login : error while login");
                that.showToast(
                    "Something went wrong. Please try again."
                );
            }
        } catch (pluginError) {
            console.error("Login : Plugin Error : " + pluginError);
        }
    },
    gotoMain: function () {
        var that = this;
        router.replace({
            uri: that.$t("Strings.main_screen_uri")
        });
    }
};
