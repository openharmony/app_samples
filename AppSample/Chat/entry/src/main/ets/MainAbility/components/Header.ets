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
export struct Header {
  @State title: string = ''

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Image($r('app.media.left'))
        .height(30)
        .width(30)
        .margin({ left: 10, top: 2 })
        .onClick(() => {
          router.back()
        })
      Text(this.title)
        .fontSize(18)

      Text('')
        .fontSize(30)
        .height(40).width(50)
        .padding({ right: 10 })
    }
    .width('100%')
    .height(60)
    .backgroundColor(0xEEEEEE)
  }
}

@Component
export struct InLine {
  @State name: string = ''

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
      Text(this.name)
        .fontSize(16)
      Image($r('app.media.right'))
        .height(15)
        .width(15)
    }
    .padding({ left: 20, right: 10, top: 15, bottom: 15 })
    .backgroundColor("#ffffff")
  }
}

@Component
export struct Swit {
  @State name: string = ""
  @State btn: boolean = true
  @State num: number = 1
  @State color: string = "#f0f0f0"

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
      Text(this.name)
        .fontSize(16)
      Row() {
        Button()
          .width(28)
          .height(28)
          .backgroundColor("#ffffff")
          .borderRadius(14)
          .margin({ left: this.num })
      }
      .width(60)
      .height(30)
      .backgroundColor(this.color)
      .borderRadius(15)
      .onClick(() => {
        if (this.btn) {
          this.num = 31
          this.color = "#00cc33"
          this.btn = false
        } else {
          this.num = 1;
          this.color = "#f0f0f0"
          this.btn = true
        }
      })
    }
    .padding({ left: 20, right: 10, top: 15, bottom: 15 })
    .backgroundColor("#ffffff")
  }
}

@Component
export struct FunctionRow {
  //显示的文字
  @State title: string = ''

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Text(this.title)
        .fontSize(16)
      Image($r('app.media.right'))
        .height(15)
        .width(15)
        .opacity(0.5)
        .margin({ left: 10, top: 2 })
    }
    .width("100%")
    .height(70)
    .backgroundColor(0xffffff)
    .padding({ left: 20, right: 20 })
  }
}

@Component
export struct MySearchComponent {
  @State changeValue: string = ''
  @State submitValue: string = ''

  build() {
    Column() {
      Search({ value: '', placeholder: '搜索' })
        .placeholderColor(0x999999)
        .placeholderFont({ size: 18, weight: 10, family: 'serif', style: FontStyle.Normal })
        .onSubmit((value: string) => {
          this.submitValue = value
        })
        .onChange((value: string) => {
          this.changeValue = value
        })
        .backgroundColor(0xffffff)
    }
  }
}