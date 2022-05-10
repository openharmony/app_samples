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
struct IndexExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context).width('90%').height(300).backgroundColor('#00ffff')
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('arc')
          .width(130).height(45)
          .onClick(() => {
            this.context.beginPath();
            this.context.arc(185, 140, 50, 0, 6.28);
            this.context.lineWidth = 2;
            this.context.stroke();
          })
        Button('strokeText')
          .width(130).height(45)
          .onClick(() => {
            this.context.font = '100px sans-serif';
            this.context.strokeText("hello World!", 100, 150);
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('closePath')
          .width(130).height(45)
          .onClick(() => {
            this.context.beginPath();
            this.context.lineWidth = 2;
            this.context.moveTo(100, 140);
            this.context.lineTo(130, 190);
            this.context.lineTo(70, 190);
            this.context.closePath();
            this.context.stroke();
          })
        Button('quadraticCurveTo')
          .width(130).height(45)
          .onClick(() => {
            this.context.beginPath();
            this.context.moveTo(20, 20);
            this.context.quadraticCurveTo(185, 185, 290, 20);
            this.context.stroke();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('textBaseline')
          .width(130).height(45)
          .onClick(() => {
            this.context.moveTo(50, 260);
            this.context.lineTo(290, 260);
            this.context.stroke();
            this.context.font = '50px sans-serif';
            this.context.textBaseline = 'top';
            this.context.fillText('Top', 60, 260)
            this.context.textBaseline = 'bottom';
            this.context.fillText('Bottom', 90, 260);
            this.context.textBaseline = 'middle';
            this.context.fillText('Middle', 150, 260);
            this.context.textBaseline = 'alphabetic';
            this.context.fillText('Alphabetic', 200, 260);
          })
        Button('delete')
          .width(130).height(45)
          .onClick(() => {
            this.context.clearRect(20, 20, 950, 950)
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('OtherContext')
          .width(130).height(45)
          .onClick(() => {
            router.push({ url: 'pages/context' })
          })
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