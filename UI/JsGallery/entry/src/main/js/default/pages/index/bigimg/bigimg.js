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
export default {
    data:{
        imgsrc: '',
        width:'',
        height:'',
        display:false
    },
    onInit() {
        this.imgsrc=this.url;
    },
    loadComplete(e){
        this.width=e.width;
        this.height=e.height;
    },
    back() {
        router.back();
    },
    showInfo(){
        this.display=true;
    },
    hideInfo(){
        this.display=false;
    },
}