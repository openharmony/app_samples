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

@Component
export struct Show {
  @State scale1: number = 1
  @State opacity1: number = 1
  @State active: boolean = false
  private select: number

  pageTransition() {
    if (this.select === 1) {
      PageTransitionEnter({ duration: 1200, curve: Curve.Ease })
        .scale({ x: 0, y: 0 })
        .translate({ x: 200, y: -100 })
      PageTransitionExit({ duration: 1000, curve: Curve.Linear })
        .translate({ x: 0, y: 0 })
        .scale({ x: 2, y: 2 })
    } else if (this.select === 2) {
      PageTransitionEnter({ duration: 1200 })
        .slide(SlideEffect.Left)
        .scale({ x: 0.1, y: 0.2 })
      PageTransitionExit({ delay: 50 })
        .translate({ x: 100.0, y: 100.0 })
        .opacity(0)
    } else if (this.select === 3) {
      PageTransitionEnter({ duration: 1500, curve: Curve.Friction, delay: 5 })
        .slide(SlideEffect.Top)
        .scale({ x: 100, y: 100 })
      PageTransitionExit({ delay: 50 })
        .slide(SlideEffect.Bottom)
        .scale({ x: 0.1, y: 0.2 })
        .opacity(0.4)
    } else if (this.select === 4) {
      // 进场过程中会逐帧触发onEnter回调，入参为动效的归一化进度(0% -- 100%)
      PageTransitionEnter({ duration: 1500, curve: Curve.Linear })
        .scale({ x: this.scale1 })
        .opacity(this.opacity1)
        .onEnter((type: RouteType, progress: number) => {
          this.scale1 = 1
          this.opacity1 = progress
        })
      // 退场过程中会逐帧触发onExit回调，入参为动效的归一化进度(0% -- 100%)
      PageTransitionExit({ duration: 1000, curve: Curve.Ease })
        .scale({ x: 0.1, y: 0.2 })
        .opacity(0.4)
        .onExit((type: RouteType, progress: number) => {
          this.scale1 = 1 - progress
          this.opacity1 = 1
        })
    }
  }

  build() {
  }
}