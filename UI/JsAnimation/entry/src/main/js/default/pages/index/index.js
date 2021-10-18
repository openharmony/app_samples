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
import animatordata from '../../i18n/animators.json'

export default {
    data: {
        video2: 'video2_1',
        video3: 'video3_1',
        img1: 'img1_1',
        img2: 'img2_1',
        img3: 'img3_1',
        img4: 'img4_1',
        img5: 'img5_1',
        img6: 'img6_1',
        img7: 'img7_1',
        img8: 'img8_1',
        img9: 'img9_1',
        img0: 'img0_1',
        video_center: 'video_center1',
        flag1: true,
        flag2: false,
        i: 1,
        video_opa: '',
        pass: false,
        videoopa_1: true,
        videoopa_2: true,
        videoopa_3: true,
        videomove_1: true,
        videomove_2: true,
        videomove_3: true,
        imgflag: [true, true, true, true, true, true, true, true, true, true],
        shadow: true
    },
    onInit() {
        console.info("ssss"+ JSON.stringify(animatordata.videoopa))
        this.pass = this.pass;
        if (this.pass === true) {
            if (this.message[0] == 1) {
                this.videoopa_1 = true;
                this.videoopa_2 = false;
                this.videoopa_3 = false;
            } else if (this.message[0] == 2) {
                this.videoopa_1 = true;
                this.videoopa_2 = true;
                this.videoopa_3 = false;
            } else {
                this.videoopa_1 = true;
                this.videoopa_2 = true;
                this.videoopa_3 = true;
            }
            if (this.message[1] == 1) {
                this.videomove_1 = true;
                this.videomove_2 = false;
                this.videomove_3 = false;
            } else if (this.message[1] == 2) {
                this.videomove_1 = true;
                this.videomove_2 = true;
                this.videomove_3 = false;
            } else {
                this.videomove_1 = true;
                this.videomove_2 = true;
                this.videomove_3 = true;
            }
            for (var i = 9;i >= this.message[2]; i--) {
                this.imgflag[i] = false;
            }
        } else {
            this.videoopa_1 = animatordata.videoopa.videoopa_1;
            this.videoopa_2 = animatordata.videoopa.videoopa_2;
            this.videoopa_3 = animatordata.videoopa.videoopa_3;
            this.videomove_1 = animatordata.videomove.videomove_1;
            this.videomove_2 = animatordata.videomove.videomove_2;
            this.videomove_3 = animatordata.videomove.videomove_3;
            this.imgflag = animatordata.imgmove;
        }
    },
    onReady() {
        setInterval(()=>{
            ++this.i;
            if (this.i % 2 === 0) {
                this.video2 = '';
                this.video3 = '';
                this.img1 = '';
                this.img2 = '';
                this.img3 = '';
                this.img4 = '';
                this.img5 = '';
                this.img6 = '';
                this.img7 = '';
                this.img8 = '';
                this.img9 = '';
                this.img0 = '';
                this.video_center = '';
                this.video2 = 'video2_2';
                this.video3 = 'video3_2';
                this.img1 = 'img1_2';
                this.img2 = 'img2_2';
                this.img3 = 'img3_2';
                this.img4 = 'img4_2';
                this.img5 = 'img5_2';
                this.img6 = 'img6_2';
                this.img7 = 'img7_2';
                this.img8 = 'img8_2';
                this.img9 = 'img9_2';
                this.img0 = 'img0_2';
                this.video_center = 'video_center2';
                this.flag1 = false;
                this.flag2 = true;
            } else {
                this.video2 = '';
                this.video3 = '';
                this.img1 = '';
                this.img2 = '';
                this.img3 = '';
                this.img4 = '';
                this.img5 = '';
                this.img6 = '';
                this.img7 = '';
                this.img8 = '';
                this.img9 = '';
                this.img0 = '';
                this.video_center = '';
                this.video2 = 'video2_1';
                this.video3 = 'video3_1';
                this.img1 = 'img1_1';
                this.img2 = 'img2_1';
                this.img3 = 'img3_1';
                this.img4 = 'img4_1';
                this.img5 = 'img5_1';
                this.img6 = 'img6_1';
                this.img7 = 'img7_1';
                this.img8 = 'img8_1';
                this.img9 = 'img9_1';
                this.img0 = 'img0_1';
                this.video_center = 'video_center1';
                this.flag1 = true;
                this.flag2 = false;
            }
        },5000);
    },
    redirect_setting(){
        router.push({
            uri:'pages/index/setPage/setPage'
        })
    },
    back() {
        router.back();
    },
    playComplete1() {
        this.$element('video1_1').start();
        this.$element('video1_2').start();
        this.$element('video1_3').start();
    },
    playComplete2() {
        this.$element('video2_1').start();
    },
    playComplete3() {
        this.$element('video2_2').start();
    },
    playComplete4() {
        this.$element('video2_3').start();
    },
}