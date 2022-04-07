/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import featureAbility from '@ohos.ability.featureAbility';
import router from '@system.router'
import galleryData from '../../common/gallery'

var i = 0

export default {
    data: {
        columns: 8,
        imgsrc: [],
        repeatedlength: 200,
        tempList: [],
        beginIndex: 0,
        endIndex: 0,
        passValue: false,
        height: '',
        message: [],
        imgtype: false,
        pass: false
    },
    onInit() {
        this.passValue = this.pass
        if (this.passValue === true) {
            this.columns = this.message[0]
            this.repeatedlength = this.message[1]
            this.height = 375 / this.message[0]
            this.imgtype = false
        } else {
            this.imgtype = galleryData.shrink
            this.columns = galleryData.numColumns.orderedByDays
            this.repeatedlength = galleryData.itemCount
            this.height = 375 / galleryData.numColumns.orderedByDays
        }
        this.refreshData()
    },
    redirectSetting() {
        router.push({
            uri: 'pages/setPage/setPage'
        })
    },
    back() {
        featureAbility.terminateSelf()
    },
    setColumn() {
        this.imgtype = galleryData.shrink
        this.refreshData()
        i++
        if (i % 3 === 0) {
            this.columns = galleryData.numColumns.orderedByDays
            this.height = 375 / galleryData.numColumns.orderedByDays
        } else if (i % 3 === 1) {
            this.columns = galleryData.numColumns.orderedByMonths
            this.height = 375 / galleryData.numColumns.orderedByMonths
        } else {
            this.columns = galleryData.numColumns.orderedByYears
            this.height = 375 / galleryData.numColumns.orderedByYears
        }
    },
    redirect(e) {
        var imgsrc = e.target.attr.data
        router.push({
            uri: 'pages/bigimg/bigimg',
            params: {
                url: imgsrc
            }
        })
    },
    buildItem(param) {
        if (this.imgsrc.length == 0) {
            return
        }
        this.beginIndex = param.begin
        this.endIndex = param.end > this.imgsrc.length ? this.imgsrc.length : param.end
        let tempArray = []
        for (let index = this.beginIndex;index < this.endIndex; ++index) {
            let tempIndex = index % this.imgsrc.length
            let tempValue = JSON.parse(JSON.stringify(this.imgsrc[tempIndex]))
            tempArray.push(tempValue)
        }
        this.tempList = tempArray
    },
    refreshData(){
        this.imgsrc = []
        if (this.imgtype === true) {
            for (var i = 1;i <= 200; i++) {
                this.imgsrc.push({
                    SourceFile: '/common/image/LOADPIC_' + ('0000' + i).slice(-4) + '.png',
                    order: i
                })
            }
        } else {
            for (var j = 1;j <= this.repeatedlength; j++) {
                let index = j % 200 === 0 ? 200 : j % 200
                this.imgsrc.push({
                    SourceFile: '/common/image/LOADPIC_' + ('0000' + index).slice(-4) + '.png',
                    order: j
                })
            }
        }
    }
}