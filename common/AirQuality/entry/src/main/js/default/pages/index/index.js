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
import app from '@system.app';

export default {
    data: {
        textColor1: '#00ff00',
        textColor2: '#00ff00',
        bgColor1: '#669966',
        bgColor2: '#669966',
        swiperPage: 0,
        percent1: 40,
        percent2: 90,
        iconcheckedBR: '6px',
        iconcheckedColor: '#ffffff',
        iconUncheckedColor: '#262626',
        src1: '/common/cloud_green.png',
        src2: '/common/cloud_green.png',
        airData: [{
                      location: '东莞',
                      airQuality: '良',
                      detailData: 40
                  }, {
                      location: '深圳',
                      airQuality: '差',
                      detailData: 90
                  }]
    },
    onInit() {
        if (this.airData[0].detailData > 100) {
            this.src1 = '/common/cloud_red.png';
            this.textColor1 = '#ff0000';
            this.bgColor1 = '#9d7462';
        } else if (this.airData[0].detailData > 50 ) {
            this.src1 = '/common/cloud_yellow.png';
            this.textColor1 = '#ecf19a';
            this.bgColor1 = '#9d9d62';
        }
        if (this.airData[1].detailData > 100) {
            this.src2 = '/common/cloud_red.png';
            this.textColor2 = '#ff0000';
            this.bgColor2 = '#9d9d62';
        } else if (50 < this.airData[1].detailData) {
            this.src2 = '/common/cloud_yellow.png'
            this.textColor2 = '#ecf19a';
            this.bgColor2 = '#9d9d62';
        }
        if (this.selectedCityIndex) {
            this.swiperPage = this.selectedCityIntex
            if (this.swiperPage == 0) {
                this.iconcheckedBR = '#ffffff';
                this.iconUncheckedColor = '#262626';
            } else {
                this.iconcheckedColor = '#262626';
                this.iconUncheckedColor = '#ffffff';
            }
        }
    },
    openDetail() {
        router.replace({
            uri: 'pages/second/second',
            params: {
                selectedCityIndex: this.swiperPage
            }
        });
    },
    exitApp() {
        console.log('start exit');
        app.terminate();
        console.log('end exit')
    },
    swiperChange(e) {
        this.swiperPage = e.index;
        if (e.index == 0) {
            this.iconcheckedColor = '#ffffff';
            this.iconUncheckedColor = '#262626';
        } else {
            this.iconcheckedColor = '#262626';
            this.iconUncheckedColor = '#ffffff';
        }
    }
}



