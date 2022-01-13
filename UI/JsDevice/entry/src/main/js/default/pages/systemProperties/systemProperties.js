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

import router from '@system.router'
import systemParameter from '@ohos.systemParameter';

let self = null
export default {
    data: {
        results: ''
    },
    onInit(){
        self = this
    },
    setKey() {
        try {
            var promise = systemParameter.set("test.parameter.key", "testValue");
            promise.then(function (data) {
                self.results = "setKey pass";
                console.log("set test.parameter.key success" + data);
            }).catch(function (err) {
                self.results = "set test.parameter.key error" + err.code;
                console.log("set test.parameter.key error" + err.code);
            });
        } catch (e) {
            self.results = "set unexpected error:" + e;
            console.log("set unexpected error:" + e);
        }
    },
    getKey() {
        try {
            var promise = systemParameter.get("test.parameter.key", "default");
            promise.then(function (data) {
                self.results = "getKey pass";
                console.log("get test.parameter.key success:" + JSON.stringify(data));
            }).catch(function (err) {
                self.results = "get test.parameter.key error:" + err.code;
                console.log("get test.parameter.key error:" + err.code);
            });
        } catch (e) {
            self.results = "get unexpected error:" + e;
            console.log("get unexpected error:" + e);
        }
    },
    setSync() {
        try {
            systemParameter.setSync("test.parameter.key", "testValue");
            this.results = "setSync pass";
        } catch (e) {
            this.results = "setSync unexpected error:" + e;
            console.log("setSync unexpected error:" + e);
        }
    },
    getSync() {
        try {
            var getSync = systemParameter.getSync("test.parameter.key", "default");
            console.log("getSync test.parameter.key value success:" + JSON.stringify(getSync));
            this.results = "getSync pass";
        } catch (e) {
            this.results = "getSync unexpected error:" + e;
            console.log("getSync unexpected error");
        }
    },
    setASyncCallback() {
        try {
            systemParameter.set("test.parameter.key", "testValue", function (err, data) {
                if (err == undefined) {
                    self.results = "setASyncCallback pass"
                    console.log("set test.parameter.key value success:" + data);
                } else {
                    self.results = "set test.parameter.key value err:" + err.code;
                    console.log("set test.parameter.key value err:" + err.code);
                }
            });
        } catch (e) {
            self.results = "set unexpected error:" + e;
            console.log("set unexpected error:" + e);
        }
    },
    getAsyncCallback() {
        try {
            systemParameter.get("test.parameter.key", function (err, data) {
                if (err == undefined) {
                    self.results = "getAsyncCallback pass";
                    console.log("get test.parameter.key value success:" + data);
                } else {
                    self.results = "get test.parameter.key value err:" + err.code;
                    console.log("get test.parameter.key value err:" + err.code);
                }
            });
        } catch (e) {
            self.results = "getSync unexpected error:" + e;
            console.log("getSync unexpected error:" + e);
        }
    },
    getDefAsyncCallback() {
        try {
            systemParameter.get("test.parameter.key", "default", function (err, data) {
                if (err == undefined) {
                    self.results = "getDefAsyncCallback pass";
                    console.log("get test.parameter.key value success:" + data);
                } else {
                    self.results = "get test.parameter.key value err:" + err.code;
                    console.log("get test.parameter.key value err:" + err.code);
                }
            });
        } catch (e) {
            self.results = "get test.parameter.key value err:" + e;
            console.log("get test.parameter.key value err:" + e);
        }
    },
    back() {
        router.back();
    }
}