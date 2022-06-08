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
import TitleBar from '../../common/TitleBar'

@Entry
@Component
struct CustomTransition2 {
  @State myProgress: number = 1

  build() {
    Column() {
      TitleBar({ hasBackPress: true })
      Image($r('app.media.custom_transition2'))
        .width('100%')
        .layoutWeight(1)
        .objectFit(ImageFit.Contain)
        .opacity(this.myProgress)
        .scale({ x: this.myProgress, y: this.myProgress })
        .rotate({ x: 0, y: 0, z: 1, angle: 360 * this.myProgress })
    }
    .width('100%')
    .height('100%')
  }

  // 页面转场通过全局transition方法进行配置转场参数
  pageTransition() {
    // 页面入场组件： 进场过程中会逐帧触发onEnter回调，入参为动效的归一化进度(0% -- 100%)
    PageTransitionEnter({ duration: 800, curve: Curve.Smooth })
      .onEnter((type: RouteType, progress: number) => {
        this.myProgress = progress // 页面入场时myProgress从0变化到1
      })

    // 页面退场组件： 进场过程中会逐帧触发onExit回调，入参为动效的归一化进度(0% -- 100%)
    PageTransitionExit({ duration: 1000, curve: Curve.Smooth })
      .onExit((type: RouteType, progress: number) => {
        this.myProgress = 1 - progress // 页面退场式myProgress从1变化到0
      })
  }
}