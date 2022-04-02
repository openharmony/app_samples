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
struct ShadowOffsetExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Row() {
      Column() {
        Canvas(this.context)
          .width('100%').height('40%').backgroundColor('#00ffff')
        Flex({ justifyContent: FlexAlign.SpaceAround }) {
          Button('shadowOffsetY')
            .width(130).height(45)
            .onClick(() => {
              this.context.restore();
              this.context.shadowBlur = 30;
              this.context.shadowOffsetY = 20;
              this.context.shadowColor = 'rgb(0,0,0)'
              this.context.fillStyle = 'rgb(255,0,0)';
              this.context.fillRect(10, 150, 100, 100);
              this.context.save();
            })
          Button('shadowOffsetX')
            .width(130).height(45)
            .onClick(() => {
              this.context.restore();
              this.context.shadowBlur = 30;
              this.context.shadowOffsetX = 20;
              this.context.shadowColor = 'rgb(0,0,0)'
              this.context.fillStyle = 'rgb(255,0,0)';
              this.context.fillRect(120, 50, 100, 100);
              this.context.save();
            })
          Button('shadowBlur')
            .width(130).height(45)
            .onClick(() => {
              this.context.restore();
              this.context.shadowBlur = 50;
              this.context.shadowColor = 'rgb(0,0,0)'
              this.context.fillStyle = 'rgb(255,0,0)';
              this.context.fillRect(220, 170, 100, 100);
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
      }
      .width('100%')
    }
    .height('100%')
  }
}