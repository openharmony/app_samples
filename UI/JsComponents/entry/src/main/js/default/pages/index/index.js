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

export default {
    data: {
        inputValue: '',
        commentText: false,
        likeImage: '/common/unlike.png',
        isPressed: false,
        total: 20,
        headTitle: 'Capture the Beauty in This Moment',
        paragraphFirst: 'Capture the beauty of light during the transition and fusion of ice and water. At the instant of movement and stillness, softness and rigidity, force and beauty, condensing moving moments.',
        paragraphSecond: 'Reflecting the purity of nature, the innovative design upgrades your visual entertainment and ergonomic comfort. Effortlessly capture what you see and let it speak for what you feel.',
        middleImage: '/common/common.png',
        textList: [{
                       value0: 'JS FA'
                   }, {
                       value1: 'JS AA'
                   }, {
                       value2: 'Java FA'
                   }, {
                       value3: 'Java AA'
                   }],
        tabImage: '/common/ice.png',
        colorParam: '',
        opacityParam: '',
        touchstart: 'touchstart',
        touchmove: 'touchmove',
        touchend: 'touchend',
        touchcancel: 'touchcancel',
        onClick: 'onclick',
        onLongPress: 'onlongpress',
        up: 'up',
        down: 'down',
        text: 'start',
        showState: false
    },
    textClicked (e) {
        this.text = e.detail.text;
    },
    focusUp: function () {
        this.up = 'up focused';
    },
    blurUp: function () {
        this.up = 'up';
    },
    keyUp: function () {
        this.up = 'up keyed';
    },
    focusDown: function () {
        this.down = 'down focused';
    },
    blurDown: function () {
        this.down = 'down';
    },
    keyDown: function () {
        this.down = 'down keyed';
    },
    touchCancel: function () {
        this.touchcancel = 'canceled';
    },
    touchEnd: function () {
        this.touchend = 'ended';
    },
    touchMove: function () {
        this.touchmove = 'moved';
    },
    touchStart: function () {
        this.touchstart = 'touched';
    },
    longPress: function () {
        this.onLongPress = 'longpressed';
    },
    click: function () {
        this.onClick = 'clicked';
    },
    showAnimation: function () {
        this.colorParam = '';
        this.opacityParam = '';
        this.colorParam = 'animation-color';
        this.opacityParam = 'animation-opacity';
    },
    update() {
        this.commentText = !this.commentText;
    },
    updateValue(e) {
        this.inputValue = e.text;
    },
    likeClick() {
        var temp;
        if (!this.isPressed) {
            temp = this.total + 1;
            this.likeImage = '/common/like.png';
        } else {
            temp = this.total - 1;
            this.likeImage = '/common/unlike.png';
        }
        this.total = temp;
        this.isPressed = !this.isPressed;
    },
    launch: function () {
        router.push({
            uri: 'pages/details/details',
        });
    }
}