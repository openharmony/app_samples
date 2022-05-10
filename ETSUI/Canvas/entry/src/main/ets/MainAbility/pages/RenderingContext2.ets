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
struct RenderingExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private img: ImageBitmap = new ImageBitmap("/common/images/icon.png")

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context)
        .width('100%').height('50%').backgroundColor('#00ffff')
        .onReady(() => {
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('arcTo').width(130).height(45)
          .onClick(() => {
            this.context.arcTo(150, 50, 250, 150, 250);
            this.context.lineWidth = 1;
            this.context.stroke();
            this.context.save();
          })
        Button('bezierCurveTo').width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.beginPath();
            this.context.moveTo(30, 20);
            this.context.bezierCurveTo(100, 150, 180, 150, 220, 20);
            this.context.stroke();
            this.context.save()
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('ellipse').width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.beginPath();
            this.context.lineWidth = 1;
            this.context.ellipse(100, 300, 100, 50, Math.PI * 0.25, Math.PI * 0.5, Math.PI)
            this.context.stroke();
            this.context.save();
          })
        Button('rect').width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.rect(80, 250, 100, 100);
            this.context.fill();
            this.context.save();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('createPattern').width(130).height(45)
          .onClick(() => {
            this.context.restore();
            var pattern = this.context.createPattern(this.img, 'repeat');
            this.context.fillStyle = pattern;
            this.context.fillRect(190, 200, 150, 150);
            this.context.save();

          })
        Button('lineDashOffset')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.arc(250, 100, 40, 0, 6.28);
            this.context.setLineDash([10, 20]);
            this.context.lineWidth = 3;
            this.context.stroke();
            this.context.save();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('scale').width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.strokeRect(10, 10, 25, 25);
            this.context.scale(2, 2);
            this.context.strokeRect(10, 10, 25, 25);
            this.context.save();
          })
      }.margin({ top: 10 })

      Button('back')
        .width(130)
        .height(45)
        .backgroundColor(Color.Orange)
        .onClick(() => {
          router.back()
        })
        .margin({ top: 10 })
    }.width('100%').height('100%')
  }
}