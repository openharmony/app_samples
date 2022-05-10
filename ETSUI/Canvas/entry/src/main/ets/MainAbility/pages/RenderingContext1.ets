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
import router from '@ohos.router';

@Entry
@Component
struct AllRenderingExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context).width('100%').height(300).backgroundColor('#00ffff')
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('strokeStyle')
          .width(130).height(45)
          .onClick(() => {
            this.context.beginPath();
            this.context.lineWidth = 2;
            this.context.strokeStyle = '#0000ff'
            this.context.strokeRect(50, 20, 100, 100)
          })
        Button('lineCap')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.lineWidth = 6;
            this.context.beginPath();
            this.context.lineCap = 'round';
            this.context.moveTo(200, 80);
            this.context.lineTo(240, 80);
            this.context.stroke();
            this.context.save();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('globalAlpha')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(50, 20, 50, 50);
            this.context.globalAlpha = 0.4;
            this.context.fillStyle = 'rgb(0,0,255)';
            this.context.fillRect(100, 70, 50, 50);
            this.context.save();
          })
        Button('textAlign')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.lineWidth = 3;
            this.context.moveTo(300, 120);
            this.context.lineTo(300, 280);
            this.context.stroke();
            this.context.font = '50px sans-serif';
            this.context.textAlign = 'start'
            this.context.fillText('start', 300, 120)
            this.context.textAlign = 'end'
            this.context.fillText('end', 300, 150);
            this.context.textAlign = 'left'
            this.context.fillText('left', 300, 180);
            this.context.textAlign = 'center'
            this.context.fillText('center', 300, 210);
            this.context.textAlign = 'right'
            this.context.fillText('right', 300, 240);
            this.context.save();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('lineJoin')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.beginPath();
            this.context.lineWidth = 2;
            this.context.lineWidth = 2;
            this.context.lineJoin = 'miter';
            this.context.moveTo(240, 40);
            this.context.lineTo(280, 80);
            this.context.lineTo(240, 120);
            this.context.stroke();
            this.context.save();
          })
        Button('miterLimit')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.lineWidth = 6;
            this.context.lineJoin = 'miter';
            this.context.miterLimit = 3;
            this.context.moveTo(50, 230);
            this.context.lineTo(80, 250);
            this.context.lineTo(50, 270);
            this.context.stroke();
            this.context.save();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('globalCompositeOperation')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(20, 140, 50, 50);
            this.context.globalCompositeOperation = 'source-over'
            this.context.fillStyle = 'rgb(0,0,255)';
            this.context.fillRect(40, 160, 50, 50);

            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(100, 140, 50, 50);
            this.context.globalCompositeOperation = 'destination-over'
            this.context.fillStyle = 'rgb(0,0,255)';
            this.context.fillRect(140, 160, 50, 50);
            this.context.save();
          })
        Button('delete')
          .width(130).height(45)
          .onClick(() => {
            this.context.clearRect(0, 0, 950, 950)
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('back')
          .width(130).height(45).backgroundColor(Color.Orange)
          .onClick(() => {
            router.back()
          })
      }.margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
  }
}