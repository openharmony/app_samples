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
export default {
    data: {
        waiting:false,
        imgPath:"/common/images/bg-tv.jpg",
        headTitle: 'Capture the Beauty in This Moment',
        paragraphFirst: '  Capture the beauty of light during the transition and fusion of ice and water. At the instant of movement and stillness, softness and rigidity, force and beauty, condensing moving moments.',
        scrollAmount: 30,
        loop: 3,
        marqueeDir: 'left',
        inputValue:"",
        showValue:"",
        commentText: false,
        first: true,
        second: true,
        toggle_list: [
        { "id":"1001", "name":"Living room", "checked":true },
        { "id":"1002", "name":"Bedroom", "checked":false },
        { "id":"1003", "name":"Second bedroom", "checked":false },
        { "id":"1004", "name":"Kitchen", "checked":false },
        { "id":"1005", "name":"Study", "checked":false },
        { "id":"1006", "name":"Garden", "checked":false },
        { "id":"1007", "name":"Bathroom", "checked":false },
        { "id":"1008", "name":"Balcony", "checked":false },
        ],
        toggles: ["Living room","Bedroom","Kitchen","Study"],
        idx:"",
        showName: "",
        qrcodeMsg:"长按识别二维码",
        piecedMsg:"查阅来信"
    },
    onInit() {
    },

    clickBtn() {
        prompt.showToast({message:"Clicked !"})
    },

    clickBtnLong(){
        prompt.showToast({message:"Long Clicked !"})
    },

    clickBtnLoading(){
        this.waiting = !this.waiting;
    },

    onStartClick () {
        this.$element('customMarquee').start();
    },

    onStopClick () {
        this.$element('customMarquee').stop();
    },

    update() {
        this.commentText = !this.commentText;
        this.inputValue = "";
    },

    updateValue(e) {
        this.inputValue = e.text;
        this.showValue = e.text;
    },

    closeSecond() {
        this.second = false;
    },

    pieceClicked(){
        prompt.showToast({message:this.piecedMsg})
    },

    longPressQrcode(){
        prompt.showToast({message:this.qrcodeMsg})
    },

    switchChanged(e){
        if(e.checked === true){
            prompt.showToast({message:"switch true !"})
        }else{
            prompt.showToast({message:"switch false !"})
        }
    },

    allClick(item_id,item_name) {
        this.showName = item_name;
        this.idx = item_id;
        prompt.showToast({message:this.showName})
    },

    ratingChanged(){
        prompt.showToast({message:"rating changed !"})
    },

    allChange(e) {
        if (e.checked === true) {
            for (var i = 0; i < this.toggle_list.length; i++) {
                if (this.toggle_list[i].id === this.idx) {
                    this.toggle_list[i].checked = true
                } else {
                    this.toggle_list[i].checked = false
                }
            }
        }
    }
}