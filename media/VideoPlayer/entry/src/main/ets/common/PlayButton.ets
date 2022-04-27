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
export default struct PlayButton {
  @Link isPlaying: boolean

  build() {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      if (this.isPlaying) {
        Row() {
          Rect({ width: 6, height: 35 })
            .fill(Color.White)
          Rect({ width: 6, height: 35 })
            .margin({ left: 10 })
            .fill(Color.White)
        }.width(22).height(35)
      } else {
        Polyline({ width: 30, height: 35 })
          .points([[0, 0], [30, 17.5], [0, 35]])
          .margin({ left: 5 })
          .fill(Color.White)
      }
    }
    .size({ width: 80, height: 80 })
    .backgroundColor('#88000000')
    .onClick(() => {
      this.isPlaying = !this.isPlaying
    })
  }
}