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

export default {
    data: {
        componentName: 'Image',
        srcImage: 'common/test.png',
        width:'',
        height:'',
        scaleX:'',
        rotate:'',
        rotateX:'',
        rotateY:'',
    },

    onInit: function() {
        var img = new Image();
        img.src = this.srcImage;
        img.onload = function () {
            console.info("load img ok");
        };
        img.onerror = function () {
            console.info("load img fail");
        };
    },

    onload: function(data) {
        this.width = data.width;
        this.height = data.height;
    },

    onScalex: function() {
        this.scaleX = "";
        this.scaleX = "scaleX";
    },

    onRotate: function() {
        this.rotate = "";
        this.rotate = "rotate";
    },

    onRotateX: function() {
        this.rotateX = "";
        this.rotateX = "rotateX";
    },

    onRotateY: function() {
        this.rotateY = "";
        this.rotateY = "rotateY";
    },
}
