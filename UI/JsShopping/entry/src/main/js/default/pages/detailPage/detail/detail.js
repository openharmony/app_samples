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
import prompt from '@system.prompt';
import router from '@system.router';
import detailData from '../../../common/detailData.js'

let timer;

export default {
    data: {
        listData: [],
        tempList: [],
        beginIndex: 0,
        endIndex: 0,
        display: false,
        playBar: false,
        smallVideoTime: 0,
        bigVideoTime: 0,
        passValue: 0,
        flag: true,
        isCollect: false,
        commonimg:detailData.commonimg,
        goodsimgs:detailData.goodsimgs,
        specficlist:detailData.specficlist,
        comment:detailData.comment,
        recommendgood:detailData.recommendgood,
        goodintroduced:detailData.goodintroduced,
    },
    onInit() {
    },
    back() {
        router.back();
    },
    stickyPage(e) {
        if (e.state === true) {
            this.showVideo();
        } else {
            this.hideVideo();
        }
    },
    playComplete() {
        this.$element('smallVideo').start();
    },
    closeVideo() {
        this.show = false;
        this.$element('smallVideo').pause();
    },
    showVideo() {
        this.show = true;
        this.$broadcast('smallVideoTime', {
            params: '额外参数'
        });
    },
    receiveBigVideoTime(e) {
        this.smallVideoTime = e.detail.params;
        this.settime();
    },
    settime() {
        this.$element('smallVideo').setCurrentTime({
            currenttime: this.smallVideoTime
        });
        this.$element('smallVideo').start();
    },
    getSmallVideoTime(e) {
        this.passValue = e.currenttime;
    },
    hideVideo() {
        this.bigVideoTime = this.passValue;
        this.show = false;
        this.$element('smallVideo').pause();
        this.$broadcast('videoTime', {
            params: this.bigVideoTime
        });
    },
    collectItem(type) {
        if (type === 'true') {
            prompt.showToast({
                message: '收藏成功'
            });
            this.isCollect = true;
        } else {
            prompt.showToast({
                message: '取消收藏成功'
            });
            this.isCollect = false;
        }
    },
    addCart() {
        prompt.showToast({
            message: '成功加入购物车'
        });
    },
    redirect() {
        router.push({
            uri: 'pages/performance/performance',
        });
    },
    buildItem(param) {
        if (this.goodintroduced.length == 0) {
            return;
        }
        this.beginIndex = param.begin;
        this.endIndex = param.end;
        let tempArray = [];
        for (let index = this.beginIndex;index < this.endIndex; ++index) {
            let tempIndex = index % this.goodintroduced.length;
            let tempValue = JSON.parse(JSON.stringify(this.goodintroduced[tempIndex]));
            tempValue.index = index + 1;
            tempArray.push(tempValue);
        }
        this.tempList = tempArray;
    },
    showPlayBar() {
        clearTimeout(timer);
        this.playBar = true;
        timer = setTimeout(()=>{
            this.playBar = false;
            clearTimeout(timer);
        },3000);
    },
};