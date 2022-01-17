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

import util from '@ohos.util';

@Entry
@Component
struct Index {
  @State resultEncode: string = ''
  @State resultDecode: string = ''
  @State input: string = 'harmony'
  private strToAscii: number[] = []
  private asciiToStr: string = ''

  build() {
    Scroll() {
      Column() {
        Text($r("app.string.change_str") + this.input)
          .width('90%')
          .height('10%')
          .textAlign(TextAlign.Center)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.resultEncode)
          .width('90%')
          .height('10%')
          .margin({ top: 20 })
          .padding({left:10})
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, radius: 10, color: Color.Black })

        Button() {
          Text($r("app.string.encode"))
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }
        .width('80%')
        .height('10%')
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          for (let i = 0;i < this.input.length; i++) {
            this.strToAscii.push(this.input.charCodeAt(i))
          }
          let that = new util.Base64();
          let encodeNum = new Uint8Array(this.strToAscii);
          this.resultEncode = that.encodeToStringSync(encodeNum)
        })

        Text(this.resultDecode)
          .width('90%')
          .height('10%')
          .fontSize(20)
          .padding({left:10})
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, radius: 10, color: Color.Black })
          .margin({ top: 50 })

        Button() {
          Text($r("app.string.decode"))
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }
        .width('80%')
        .height('10%')
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          let that = new util.Base64();
          let decodeNum = that.decodeSync(this.resultEncode);
          for (let i = 0; i < decodeNum.length; i++) {
            this.asciiToStr += String.fromCharCode(decodeNum[i])
          }
          this.resultDecode = this.asciiToStr
        })
      }
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
  }
}