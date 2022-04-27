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
export default struct NextVideo {
  private handleClick: () => void = null

  build() {
    Button({ type: ButtonType.Normal, stateEffect: true }) {
      Row() {
        Polyline({ width: 30, height: 30 })
          .points([[0, 0], [30, 15], [0, 30]])
          .fill(Color.White)
        Rect({ width: 5, height: 30 })
          .margin({ left: 5 })
          .fill(Color.White)
      }.width(35).height(30)
    }
    .size({ width: 60, height: 60 })
    .backgroundColor('#88000000')
    .margin({ left: '30%' })
    .onClick(this.handleClick)
  }
}