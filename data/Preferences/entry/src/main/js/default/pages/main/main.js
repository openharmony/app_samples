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

export default {
    data: {
        lastSelectedColor:null,
        selectedColor: "#ffffff",
        appliedColor: "#ffffff",
        tempVar: true,
        colorsList: [
            {
                colorName: "",
                backgroundcolor: "#ff6666",
                textColor: "#ff0000"
            },
            {
                colorName: "",
                backgroundcolor: "#c1ff80",
                textColor: "#336600"
            },
            {
                colorName: "",
                backgroundcolor: "#9999ff",
                textColor: "#1a1aff"
            },
            {
                colorName: "",
                backgroundcolor: "#ff99ff",
                textColor: "#e600e6"
            },
            {
                colorName: "",
                backgroundcolor: "#ffcc80",
                textColor: "#ff9900"
            }
        ]
    },
    onInit() {
        var that = this;
        var arr = [that.$t('Strings.red'), that.$t('Strings.green'), that.$t('Strings.blue'), that.$t('Strings.pink'), that.$t('Strings.orange')];
        for (var k = 0; k < this.colorsList.length; k++) {
            this.colorsList[k].colorName = arr[k];
        }
        if (that.lastSelectedColor) {
            that.appliedColor = that.lastSelectedColor;
            console.info("Main : onInit : backgroundColor updated to " + that.lastSelectedColor);
        }
    },

/**
   * save the selected backckground color
   * @param e : selected color code
   */
    selectColor: function (e) {
        var that = this;
        that.selectedColor = e;
        that.appliedColor = that.selectedColor;
    },
    showToast: function (msg) {
        prompt.showToast({
            message: msg,
            duration: "3000"
        });
    },

/**
   * apply the selected backckground color
   * and save in Preference
   * @param e : selected color code
   */
    applyBackgroundColor: async function() {
        try {
            var that = this;
            var actionData = {};
            actionData.appliedColor = that.selectedColor;

            var action = {};
            action.bundleName = "ohos.samples.preferences";
            action.abilityName = "PreferencesInternalAbility";
            action.messageCode = 1005;
            action.data = actionData;
            action.abilityType = 1;
            action.syncOption = 0;
            var result = await FeatureAbility.callAbility(action);
            console.info("Main : applyBackgroundColor : result for applyBackgroundColor : " +
            result);
            var resultJson = JSON.parse(result);
            if (resultJson.code == 0) {
                that.showToast("Apply Background Color Success");
            } else {
                console.error("Main : Error while applying color");
                that.showToast("Error while applying the background color. Please try again.");
            }
        } catch (pluginError) {
            console.error("Main : applyBackgroundColor : Plugin Error : " + pluginError);
        }
    },

/**
   * clear preferences
   * @param e : selected color code
   */
    clearPreferences: async function() {
        try {
            var that = this;
            var actionData = {};

            var action = {};
            action.bundleName = "ohos.samples.preferences";
            action.abilityName = "PreferencesInternalAbility";
            action.messageCode = 1006;
            action.data = actionData;
            action.abilityType = 1;
            action.syncOption = 0;
            var result = await FeatureAbility.callAbility(action);
            console.info("Main :  result for clearPreferences : " +
            result);
            var resultJson = JSON.parse(result);
            if (resultJson.code == 0) {
                that.appliedColor = resultJson.data;
                that.showToast("Clear Preferences Success");
            } else {
                console.error("Main : Clear Preferences Error ");
                that.showToast("Error while Clear Preferences. Please try again.");
            }
        } catch (pluginError) {
            console.error("Main : clearPreferences : Plugin Error : " + pluginError);
        }
    }
};
