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
import deviceInfo from '@ohos.deviceInfo';

export default {
    data: {
        serial: '',
        bootloaderVersion: '',
        abiList: '',
        securityPatchTag: '',
        displayVersion: '',
        osReleaseType: '',
        osFullName: '',
        majorVersion: '',
        seniorVersion: '',
        featureVersion: '',
        buildVersion: '',
        sdkApiVersion: '',
        firstApiVersion: '',
        versionId: '',
        data1: ''
    },
    onInit() {
        this.deviceInfo();
    },
    deviceInfo() {
        this.serial = deviceInfo.serial;
        this.bootloaderVersion = deviceInfo.bootloaderVersion;
        this.securityPatchTag = deviceInfo.securityPatchTag;
        this.displayVersion = deviceInfo.displayVersion;
        this.osReleaseType = deviceInfo.osReleaseType;
        this.osFullName = deviceInfo.osFullName;
        this.majorVersion = deviceInfo.majorVersion;
        this.seniorVersion = deviceInfo.seniorVersion;
        this.featureVersion = deviceInfo.featureVersion;
        this.buildVersion = deviceInfo.buildVersion;
        this.sdkApiVersion = deviceInfo.sdkApiVersion;
        this.firstApiVersion = deviceInfo.firstApiVersion;
        this.versionId = deviceInfo.versionId;
    },
    back() {
        router.back();
    }
}