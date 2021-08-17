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
import gallerydata from '../../i18n/gallery.json'

var i = 0;

export default {
    data: {
        columns: 8,
        imgsrc: [],
        repeatedlength: 5000,
        tempList: [],
        beginIndex: 0,
        endIndex: 0,
        passValue: false,
        height: '',
    },
    onInit() {
        this.passValue = this.pass;
        if (this.passValue === true) {
            this.columns = this.message[0];
            this.repeatedlength = this.message[1];
            this.height = 375 / this.message[0];
        } else {
            this.imgtype = gallerydata.shrink;
            this.columns = gallerydata.numColumns.orderedByDays;
            this.repeatedlength = gallerydata.itemCount;
            this.height = 375 / gallerydata.numColumns.orderedByDays;
        }
        if (this.imgtype === true) {
            for (var i = 1;i <= 200; i++) {
                this.imgsrc.push({
                    SourceFile: '/common/image/LOADPIC_' + ('0000' + i).slice(-4) + '.png',
                    order: i
                })
            }
        } else {
            for (var j = 1;j <= 200; j++) {
                this.imgsrc.push({
                    SourceFile: '/common/image/LOADPIC_' + ('0000' + j).slice(-4) + '.png',
                    order: j
                })
            }
        }
    },
    redirectSetting(){
        router.push({
            uri:'pages/index/setPage/setPage'
        })
    },
    back() {
        router.back();
    },
    setColumn() {
        i++;
        if (i % 3 === 0) {
            this.columns = gallerydata.numColumns.orderedByDays;
            this.height = 375 / gallerydata.numColumns.orderedByDays;
        } else if (i % 3 === 1) {
            this.columns = gallerydata.numColumns.orderedByMonths;
            this.height = 375 / gallerydata.numColumns.orderedByMonths;
        } else {
            this.columns = gallerydata.numColumns.orderedByYears;
            this.height = 375 / gallerydata.numColumns.orderedByYears;
        }
    },
    redirect(e) {
        var imgsrc = e.target.attr.data;
        router.push({
            uri: 'pages/index/bigimg/bigimg',
            params: {
                url: imgsrc
            }
        });
    },
    buildItem(param) {
        if (this.imgsrc.length == 0) {
            return;
        }
        this.beginIndex = param.begin;
        this.endIndex = param.end;
        let tempArray = [];
        for (let index = this.beginIndex;index < this.endIndex; ++index) {
            let tempIndex = index % this.imgsrc.length;
            let tempValue = JSON.parse(JSON.stringify(this.imgsrc[tempIndex]));
            tempArray.push(tempValue);
        }
        this.tempList = tempArray;
    }
}