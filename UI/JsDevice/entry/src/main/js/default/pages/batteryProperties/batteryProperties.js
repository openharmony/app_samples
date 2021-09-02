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

import router from '@system.router';
import batteryInfo from '@ohos.batteryInfo';

export default {
    data: {
        batterySOC: '',
        chargingStatus: '',
        healthStatus: '',
        pluggedType: '',
        voltage: '',
        technology: '',
        batteryTemperature: ''
    },
    onInit() {
        this.batteryInfo();
    },
    batteryInfo() {
        this.batterySOC = batteryInfo.batterySOC;
        switch (batteryInfo.chargingStatus) {
            case 0:
            this.chargingStatus = this.$t('strings.none');
            break;
            case 1:
            this.chargingStatus = this.$t('strings.enable');
            break;
            case 2:
            this.chargingStatus = this.$t('strings.disable');
            break;
            case 3:
            this.chargingStatus = this.$t('strings.full');
            break;
            default:
                break;
        }
        switch (batteryInfo.healthStatus) {
            case 0:
            this.healthStatus = this.$t('strings.unknown');
            break;
            case 1:
            this.healthStatus = this.$t('strings.good');
            break;
            case 2:
            this.healthStatus = this.$t('strings.overheat');
            break;
            case 3:
            this.healthStatus = this.$t('strings.overVoltage');
            break;
            case 4:
            this.healthStatus = this.$t('strings.cold');
            break;
            case 5:
            this.healthStatus = this.$t('strings.dead');
            break;
            default:
                break;
        }
        switch (batteryInfo.pluggedType) {
            case 0:
            this.pluggedType = this.$t('strings.none');
            break;
            case 1:
            this.pluggedType = this.$t('strings.ac');
            break;
            case 2:
            this.pluggedType = this.$t('strings.usb');
            break;
            case 3:
            this.pluggedType = this.$t('strings.wireless');
            break;
            default:
                break;
        }
        this.voltage = batteryInfo.voltage;
        this.technology = batteryInfo.technology;
        this.batteryTemperature = batteryInfo.batteryTemperature;
    },
    back() {
        router.back();
    }
}
