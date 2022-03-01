/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
export struct CustomBtn {
  private text:Resource = $r('app.string.btn_fullscreen')
  private onClickAction:()=>void
  build() {
    Button() {
      Text(this.text)
        .fontColor(Color.White)
        .fontSize(20)
    }
    .type(ButtonType.Capsule)
    .backgroundColor('#0D9FFB')
    .size({ width: '90%', height: 50 })
    .margin(10)
    .backgroundColor('#0D9FFB')
    .onClick(() => {
      console.info('[Screenshot] onClick,screenshot')
      this.onClickAction()
    })
  }
}