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

import router from "@system.router";

export default {
    data: {
        loginStatus: false,
        lastSelectedColor: "",
        isChecked: false
    },
    onInit() {
        var that = this;
        that.getBackgroundColor();
        that.checkLoginStatus();
    },
/**
   * Fetch the previously selected background color
   * from Preference
   */
    getBackgroundColor: async function() {
        try {
            var that = this;
            var action = that.setAction(1003);
            var result = await FeatureAbility.callAbility(action);
            console.info("Splash : result for getBackgroundColor : " + result);
            var resultJson = JSON.parse(result);
            if (resultJson.code == 0) {
                that.lastSelectedColor = resultJson.data;
                that.checkShowSplash();
            } else {
                console.error("Splash : Error while fetching backgroundColor");
            }
        } catch (pluginError) {
            console.error("Splash : getBackgroundColor : Plugin Error : " + pluginError);
        }
    },

/**
   * check if the user has logged in before
   * using Preference
   */
    checkLoginStatus: async function() {
        try {
            var that = this;
            var action = that.setAction(1001);
            var result = await FeatureAbility.callAbility(action);
            console.info("Splash : result for login : " + result);
            var resultJson = JSON.parse(result);
            if (resultJson.code == 0) {
                that.loginStatus = resultJson.data == 1;
            } else {
                console.error("Splash : error while getting login status");
            }
        } catch (pluginError) {
            console.error("Splash : checkLoginStatus Plugin Error" + pluginError);
        }
    },

/**
   * Timer to show the splash screen for the duration of 1.5s
   * to fetch the user login status and previosuly selected
   * background color
   */
    startTimer: async function() {
        var that = this;
        try {
            console.info("Splash : Timer started");
            var action = that.setAction(1002);
            var result = await FeatureAbility.subscribeAbilityEvent(action, function (timerResult) {
                console.info("Splash : Timer completed timerResult = " + timerResult);
                this.eventData = JSON.stringify(timerResult.data);
            });
            var cbResultJson = JSON.parse(result);

            if (cbResultJson.code == 0) {
                that.gotoNextScreen();
            } else {
                that.gotoLoginScreen();
            }
            console.info("Splash : Timer completed " + result);
        } catch (pluginError) {
            console.error("Splash : startTimer Plugin Error" + pluginError);
        }
    },

/**
   * set action
   */
    setAction: function (value) {
        var actionData = {};
        var action = {};
        action.bundleName = "ohos.samples.preferences";
        action.abilityName = "PreferencesInternalAbility";
        action.messageCode = value;
        action.data = actionData;
        action.abilityType = 1;
        action.syncOption = 0;
        return action;
    },

/**
   * If the user has logged In before, show the main scren
   * else show the login screen
   */
    gotoNextScreen: function () {
        var that = this;
        if (that.loginStatus) {
            that.gotoMain();
        } else {
            console.info("Splash : Login required");
            that.gotoLoginScreen();
        }
    },
    gotoLoginScreen: function () {
        var that = this;
        console.info("Splash : Login Screen invoked");
        router.replace({
            uri: that.$t("Strings.login_screen_uri")
        });
    },
    gotoMain: function () {
        var that = this;
        console.info("Splash : gotoMain that.lastSelectedColor = " + that.lastSelectedColor);
        router.replace({
            uri: that.$t("Strings.main_screen_uri"),
            params: {
                lastSelectedColor: that.lastSelectedColor
            }
        });
    },
    checkShowSplash: async function() {
        try {
            var that = this;
            var action = that.setAction(1007);
            var result = await FeatureAbility.callAbility(action);
            console.info("Splash :checkShowSplash : " + result);
            var resultJson = JSON.parse(result);
            if (resultJson.code == 0) {
                that.isChecked = resultJson.data == 1;
                if (that.isChecked) {
                    that.gotoNextScreen();
                } else {
                    setTimeout(function () {
                        //your codes
                        that.startTimer();
                    }, 3000);
                }
            } else {
                console.error("Splash : error while getting login status");
            }
        } catch (pluginError) {
            console.error("Splash : checkShowSplash Plugin Error" + pluginError);
        }
    },
    onChanged: async function (checked) {
        try {
            var actionData = {};
            actionData.checkState = checked ? 1 : 0;
            var action = {};
            action.bundleName = "ohos.samples.preferences";
            action.abilityName = "PreferencesInternalAbility";
            action.messageCode = 1008;
            action.data = actionData;
            action.abilityType = 1;
            action.syncOption = 0;
            var result = await FeatureAbility.callAbility(action);
            console.info("Splash : onChanged result = " + result);
            var resultJson = JSON.parse(result);
            if (resultJson.code == 0) {
                console.error("Splash : success while save check status");
            } else {
                console.error("Splash : error while save check status");
            }
        } catch (pluginError) {
            console.error("Splash : onChanged Plugin Error" + pluginError);
        }
    }
};
