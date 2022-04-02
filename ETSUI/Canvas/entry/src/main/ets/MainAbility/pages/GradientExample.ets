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
struct GradientExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context)
        .width('100%')
        .height('40%')
        .backgroundColor('#00ffff')
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('createLinearGradient').width(130).height(45)
          .onClick(() => {
            var grad = this.context.createLinearGradient(150, 0, 250, 300)
            grad.addColorStop(0.0, 'red');
            grad.addColorStop(0.5, 'white');
            grad.addColorStop(1.0, 'green');
            this.context.fillStyle = grad;
            this.context.fillRect(200, 0, 150, 200);
          })
        Button('createRadialGradient').width(130).height(45)
          .onClick(() => {
            var grad = this.context.createRadialGradient(100, 100, 30, 100, 100, 60)
            grad.addColorStop(0.0, 'red');
            grad.addColorStop(0.5, 'white');
            grad.addColorStop(1.0, 'green');
            this.context.fillStyle = grad;
            this.context.fillRect(0, 0, 150, 200);
          })
      }.margin({ top: 20 })

      Button('back')
        .width(130)
        .height(45)
        .backgroundColor(Color.Orange)
        .onClick(() => {
          router.back()
        })
        .margin({ top: 10 })
    }
  }
}