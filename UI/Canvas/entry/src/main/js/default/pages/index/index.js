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
        this.ctx = this.$refs.canvas.getContext('2d');
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
    }
}
