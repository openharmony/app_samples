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
        ctx: null
    },
    onShow() {
        const cav = this.$refs.canvas;
        this.ctx = cav.getContext('2d');
    },
    imageClick() {
        this.ctx.clearRect(0, 0, 300, 300);
        var ctx1 = this.$element('drawImage').getContext('2d');
        var img = new Image();
        img.src = 'common/images/like_yellow.png';
        img.onload = function () {
            console.log('Image load success');
            ctx1.drawImage(img, 50, 50, 200, 200);
        };
        img.onerror = function () {
            console.log('Image load fail');
        };
    },
    handleClick() {
        this.ctx.beginPath();
        this.ctx.arc(150, 150, 50, 0, 6.28);
        this.ctx.stroke();
    },
    strokeClick() {
        this.ctx.beginPath();
        this.ctx.font = '25px sans-serif';
        this.ctx.strokeText("Hello World!", 80, 60);
        this.ctx.stroke();
    },
    closeClick() {
        this.ctx.beginPath();
        this.ctx.lineJoin = 'miter';
        this.ctx.moveTo(150, 200);
        this.ctx.lineTo(120, 150);
        this.ctx.lineTo(150, 100);
        this.ctx.lineTo(180, 150);

        this.ctx.closePath();
        this.ctx.stroke();
    },
    bezierCurve() {
        this.ctx.beginPath();
        this.ctx.moveTo(10, 10);
        this.ctx.bezierCurveTo(90, 100, 200, 100, 290, 10);
        this.ctx.stroke();
    },
    clearRect() {
        this.ctx.fillStyle = '#000000'
        this.ctx.clearRect(0, 0, 300, 300);
    },
    textBase() {
        this.ctx.beginPath();
        this.ctx.moveTo(0, 220);
        this.ctx.lineTo(300, 220);

        this.ctx.stroke();

        this.ctx.font = '20px sans-serif';
        this.ctx.strokeStyle = '#100f0f';
        this.ctx.textBaseline = 'top';
        this.ctx.fillText('Top', 10, 220);
        this.ctx.textBaseline = 'bottom';
        this.ctx.fillText('Bottom', 55, 220);
        this.ctx.textBaseline = 'middle';
        this.ctx.fillText('Middle', 125, 220);
        this.ctx.textBaseline = 'alphabetic';
        this.ctx.fillText('Alphabetic', 195, 220);
    },
    offScreen() {
        var offscreen = new OffscreenCanvas(360, 500);
        var offCanvas2 = offscreen.getContext("2d");
        var img = new Image();
        img.src = 'common/images/ai.png';
        offCanvas2.drawImage(img, 0, 0, 100, 100);
        offCanvas2.filter = 'blur(5px)';
        offCanvas2.drawImage(img, 100, 0, 100, 100);

        offCanvas2.filter = 'grayscale(50%)';
        offCanvas2.drawImage(img, 200, 0, 100, 100);

        offCanvas2.filter = 'hue-rotate(90deg)';
        offCanvas2.drawImage(img, 0, 100, 100, 100);

        offCanvas2.filter = 'invert(100%)';
        offCanvas2.drawImage(img, 100, 100, 100, 100);

        offCanvas2.filter = 'drop-shadow(8px 8px 10px green)';
        offCanvas2.drawImage(img, 200, 100, 100, 100);

        offCanvas2.filter = 'brightness(0.4)';
        offCanvas2.drawImage(img, 0, 200, 100, 100);

        offCanvas2.filter = 'opacity(25%)';
        offCanvas2.drawImage(img, 100, 200, 100, 100);

        offCanvas2.filter = 'saturate(30%)';
        offCanvas2.drawImage(img, 200, 200, 100, 100);

        offCanvas2.filter = 'sepia(60%)';
        offCanvas2.drawImage(img, 0, 300, 100, 100);

        offCanvas2.filter = 'contrast(200%)';
        offCanvas2.drawImage(img, 100, 300, 100, 100);
        var bitmap = offscreen.transferToImageBitmap();
        this.ctx.transferFromImageBitmap(bitmap);
    },
    linearGradient() {
        var gradient = this.ctx.createLinearGradient(50, 0, 300, 100);
        gradient.addColorStop(0.0, 'red');
        gradient.addColorStop(0.5, 'white');
        gradient.addColorStop(1.0, 'green');
        this.ctx.fillStyle = gradient;
        this.ctx.fillRect(0, 0, 500, 500);
    },
    radialGradient() {
        var gradient = this.ctx.createRadialGradient(150, 150, 50, 150, 150, 150);
        gradient.addColorStop(0.0, 'red');
        gradient.addColorStop(0.5, 'white');
        gradient.addColorStop(1.0, 'green');
        this.ctx.fillStyle = gradient;
        this.ctx.fillRect(0, 0, 500, 500);
    }
}
