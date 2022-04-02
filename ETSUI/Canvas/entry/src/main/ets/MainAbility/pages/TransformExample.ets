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
import router from '@system.router';

@Entry
@Component
struct TransformExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private Scroller = new Scroller()

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context)
        .width('100%').height('50%').backgroundColor('#00ffff')
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('translate')
          .width(130).height(45)
          .onClick(() => {
            this.context.fillRect(90, 90, 100, 100);
            this.context.translate(90, 90)
            this.context.fillRect(90, 90, 100, 100);
          })
        Button('transform')
          .width(130).height(45)
          .onClick(() => {
            this.context.fillStyle = 'rgb(0,0,0)';
            this.context.fillRect(0, 0, 100, 100);
            this.context.transform(1, 0.5, -0.5, 1, 10, 10);
            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(0, 0, 100, 100);
            this.context.transform(1, 0.5, -0.5, 1, 10, 10);
            this.context.fillStyle = 'rgb(0,0,255)';
            this.context.fillRect(0, 0, 100, 100);
          })
        Button('setTransform')
          .width(130).height(45)
          .onClick(() => {
            this.context.fillStyle = 'rgb(0,0,255)';
            this.context.fillRect(20, 20, 100, 100);
            this.context.setTransform(1, 0.5, -0.5, 1, 10, 10);
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('rotate').width(130).height(45)
          .onClick(() => {
            this.context.rotate(45 * Math.PI / 180);
            this.context.fillRect(300, 100, 100, 100);
          })
        Button('back')
          .width(130).height(45).backgroundColor(Color.Orange)
          .onClick(() => {
            router.back()
          })
      }.margin({ top: 10 })

    }
  }
}