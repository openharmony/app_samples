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

let result = ''
export default {
    data: {
        results: ''
    },
    setKey() {
        try {
            var promise = systemParameter.set("test.parameter.key", "testValue");
            promise.then(function (data) {
                result = "setKey pass";
                console.log("set test.parameter.key success" + data);
            }).catch(function (err) {
                result = "set test.parameter.key error" + err.code;
                console.log("set test.parameter.key error" + err.code);
            });
            this.results = result;
        } catch (e) {
            this.results = "set unexpected error:" + e;
            console.log("set unexpected error:" + e);
        }
    },
    getKey() {
        try {
            var promise = systemParameter.get("test.parameter.key", "default");
            promise.then(function (data) {
                result = "getKey pass";
                console.log("get test.parameter.key success:" + JSON.stringify(data));
            }).catch(function (err) {
                result = "get test.parameter.key error:" + err.code;
                console.log("get test.parameter.key error:" + err.code);
            });
            this.results = result;
        } catch (e) {
            this.results = "get unexpected error:" + e;
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
                if (err = "undefined") {
                    result = "setASyncCallback pass"
                    console.log("set test.parameter.key value success:" + data);
                } else {
                    result = "set test.parameter.key value err:" + err.code;
                    console.log("set test.parameter.key value err:" + err.code);
                }
            });
            this.results = result;
        } catch (e) {
            this.results = "set unexpected error:" + e;
            console.log("set unexpected error:" + e);
        }
    },
    getAsyncCallback() {
        try {
            systemParameter.get("test.parameter.key", function (err, data) {
                if (err == "undefined") {
                    result = "getAsyncCallback pass";
                    console.log("get test.parameter.key value success:" + data);
                } else {
                    result = "get test.parameter.key value err:" + err.code;
                    console.log("get test.parameter.key value err:" + err.code);
                }
            });
            this.results = result;
        } catch (e) {
            this.results = "getSync unexpected error:" + e;
            console.log("getSync unexpected error:" + e);
        }
    },
    getDefAsyncCallback() {
        try {
            systemParameter.get("test.parameter.key", "default", function (err, data) {
                if (err == "undefined") {
                    result = "getDefAsyncCallback pass";
                    console.log("get test.parameter.key value success:" + data);
                } else {
                    result = "get test.parameter.key value err:" + err.code;
                    console.log("get test.parameter.key value err:" + err.code);
                }
            });
            this.results = result;
        } catch (e) {
            this.results = "get test.parameter.key value err:" + e;
            console.log("get test.parameter.key value err:" + e);
        }
    },
    back() {
        router.back();
    }
}