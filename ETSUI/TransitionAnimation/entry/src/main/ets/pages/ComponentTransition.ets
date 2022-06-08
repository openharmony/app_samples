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
import TitleBar from '../common/TitleBar'

@Component
struct ComponentItem {
  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Image($r('app.media.component_transition'))
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%')
        .borderRadius(15)
    }
    .width('100%')
    .height('60%')
    // 组件添加时从底部滑出，透明度从0到1.0
    .transition({ type: TransitionType.Insert, translate: { x: 0, y: 500, z: 0 }, opacity: 1.0 })
    // 组件移除时沿x轴旋转180度
    .transition({ type: TransitionType.Delete, rotate: { x: 1, y: 0, z: 0, angle: 180 } })
  }
}

@Entry
@Component
struct ComponentTransition {
  @State isShow: boolean = false

  build() {
    Column() {
      TitleBar({ hasBackPress: true })
      Button(this.isShow ? $r('app.string.hide') : $r('app.string.show'))
        .onClick(() => {
          // 执行动效，动效时长600ms
          animateTo({ duration: 600 }, () => {
            this.isShow = !this.isShow
          })
        })
        .height(45)
        .width(200)
        .fontColor(Color.Black)
        .backgroundColor('#F0FFF0')
        .margin({ top: 20 })
      Stack({ alignContent: Alignment.Bottom }) {
        if (this.isShow) {
          ComponentItem()
        }
      }
      .layoutWeight(1)
      .padding(20)
    }
    .height('100%')
    .width('100%')
  }
}

