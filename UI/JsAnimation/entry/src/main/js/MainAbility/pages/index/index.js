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

import router from '@ohos.router'

export default {
  data: {
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
    flag1: true,
    flag2: false,
    i: 1,
    pass: false,
    imgflag: [true, true, true, true, true, true, true, true, true, true],
    shadow: true,
    message: []
  },
  onReady() {
    setInterval(() => {
      ++this.i;
      if (this.i % 2 === 0) {
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
        this.flag1 = false;
        this.flag2 = true;
      } else {
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
        this.flag1 = true;
        this.flag2 = false;
      }
    }, 5000);
  },
  back() {
    router.back();
  },
}