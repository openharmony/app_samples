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
struct PathExample {
  private path2Da: Path2D = new Path2D()
  private path2Dc: Path2D = new Path2D()
  private path2Df: Path2D = new Path2D()
  private path2De: Path2D = new Path2D()
  private path2Db: Path2D = new Path2D("M250 190 L150 350 L350 350 Z")
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context)
        .width('90%')
        .height(300)
        .backgroundColor('#00ffff')

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('arc')
          .width(130)
          .height(45)
          .onClick(() => {
            this.path2Da.arc(155, 150, 100, 0, 6.28);
            this.context.stroke(this.path2Da);
            this.context.save();
          })
        Button('quadraticCurveTo')
          .width(150)
          .height(45)
          .onClick(() => {
            this.context.restore()
            this.path2Da.moveTo(20, 20)
            this.path2Da.quadraticCurveTo(155, 285, 300, 20);
            this.context.stroke(this.path2Da)
            this.context.save()
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('bezierCurveTo')
          .width(130)
          .height(45)
          .onClick(() => {
            this.path2Da.moveTo(100, 30);
            this.path2Da.bezierCurveTo(50, 100, 250, 100, 200, 30);
            this.context.stroke(this.path2Da)
            this.context.save()
          })
        Button('arcTo')
          .width(130)
          .height(45)
          .onClick(() => {
            this.path2Dc.arcTo(100, 80, 120, 50, 50)
            this.context.stroke(this.path2Dc)
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('ellipse')
          .width(130)
          .height(45)
          .onClick(() => {
            this.context.restore();
            this.path2De.ellipse(100, 150, 50, 100, Math.PI * 0.25, Math.PI * 0.5, Math.PI)
            this.context.stroke(this.path2De);
            this.context.save();

          })
        Button('rect')
          .width(130)
          .height(45)
          .onClick(() => {
            this.context.save();
            this.path2Df.rect(20, 240, 100, 100)
            this.context.stroke(this.path2Df);
            this.context.restore();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('closePath')
          .width(130)
          .height(45)
          .onClick(() => {
            this.path2Da.moveTo(160, 150);
            this.path2Da.lineTo(110, 220);
            this.path2Da.lineTo(210, 220);
            this.path2Da.closePath();
            this.context.stroke(this.path2Da);
          })
        Button('delete')
          .width(130)
          .height(45)
          .onClick(() => {
            this.context.clearRect(0, 0, 950, 950)
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('addPath')
          .width(130)
          .height(45)
          .onClick(() => {
            this.path2Da.addPath(this.path2Db)
            this.context.stroke(this.path2Da)
          })
        Button('back')
          .width(130)
          .height(45)
          .backgroundColor(Color.Orange)
          .onClick(() => {
            router.back()
          })
      }.margin({ top: 10 })
    }
  }
}