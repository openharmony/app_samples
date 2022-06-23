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
import { keySourceListData, numberSourceListData, symbolSourceListData, keySourceListType, sourceListType
} from './keyboardKeyData'
import vibrator from '@ohos.vibrator';
import media from "@ohos.multimedia.media"
import router from '@system.router';
import inputMethodEngine from '@ohos.inputmethodengine';
import { PromptBox } from "./PromptBox"
import mediaquery from '@ohos.mediaquery';
import { KeySetting } from "./KeySetting"
import { EmoSitting } from "./EmoSitting"

let portraitFunc = null

// 有大小写的按键组件
@Component
struct keyItemNumber {
  private keyValue: keySourceListType
  @StorageLink("isUpper") upper: number = 0;
  @State keyBgc: string = "#fff"
  @State keyFontColor: string = "#000"
  @State handlePopup: boolean = false
  @State isCurrentTouch: boolean = false

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column,
        alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        Text(this.keyValue.title).fontSize(12)
        if (this.upper === 0) {
          // 小写
          Text(this.keyValue.content).fontSize(20).fontColor(this.keyFontColor)
        } else {
          // 大写
          Text(this.keyValue.upperContent).fontSize(20).fontColor(this.keyFontColor)
        }
      }
    }
    .backgroundColor(this.isCurrentTouch ? "#aba665" : this.keyBgc)
    .borderRadius(6)
    .width("8%")
    .height("65%")
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        globalThis.hideState = false;
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.chineseEngine.processKey(this.keyValue.content, true);
      }
      if (event.type === TouchType.Up) {
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.hideState = true;
      }
    })
    .gesture(
    LongPressGesture({ duration: 500 })
      .onAction((event: GestureEvent) => {
        this.handlePopup = !this.handlePopup
      })
      .onActionEnd(() => {
        this.handlePopup = !this.handlePopup
      })
      .onActionCancel(() => {

      })
    )
  }
}

// 无大小写的灰色组件 ？123
@Component
export struct keyItemGray {
  private keyValue: string
  @StorageLink("menuType") menuType: number = 0;
  @State isFunctionalButtons: boolean = false
  @State keyFontColor: string = "#000"
  @State keyBgc: string = "#fff"
  @State symbolColor: string = "#fd94c1dd"
  @State isCurrentTouch: boolean = false

  build() {
    Stack() {
      Text(this.keyValue).fontSize(14).fontColor(this.keyFontColor)
    }
    .backgroundColor(this.isCurrentTouch ? "#aba665" : this.symbolColor)
    .width("13%")
    .borderRadius(6)
    .height(45)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        globalThis.hideState = false;
        this.isCurrentTouch = !this.isCurrentTouch
        if (globalThis.chineseEngine != undefined) {
          globalThis.chineseEngine.resetToIdleState(false);
        }
        if (this.keyValue === "?123") {
          AppStorage.Set("menuType", 1);
        } else if (this.keyValue === "=/\<") {
          AppStorage.Set("menuType", 2)
        } else if (this.keyValue === "ABC") {
          AppStorage.Set("menuType", 0)
        }
      } else if (event.type === TouchType.Up) {
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.hideState = true;
      }
    })
  }
}

// 中英文切换
@Component
export struct changeItem {
  private keyValue: keySourceListType
  @StorageLink("isChinese") isChinese: boolean = true;
  @State keyBgc: string = "#fff"
  @State keyFontColor: string = "#000"
  @State symbolColor: string = "#fd94c1dd"
  @State isCurrentTouch: boolean = false

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      if (this.isChinese) {
        Row() {
          Text("中").fontSize("16lpx").fontColor(this.keyFontColor).fontWeight(500)
          Text("/英").fontSize("14lpx").fontColor(this.keyFontColor).fontWeight(500)
        }
      } else {
        Row() {
          Text("英").fontSize("16lpx").fontColor(this.keyFontColor).fontWeight(500)
          Text("/中").fontSize("14lpx").fontColor(this.keyFontColor).fontWeight(500)
        }
      }
    }
    .backgroundColor(this.isCurrentTouch ? "#aba665" : this.symbolColor)
    .borderRadius(6)
    .width("8%")
    .height("65%")
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        globalThis.hideState = false;
        this.isCurrentTouch = !this.isCurrentTouch
        AppStorage.Set("isChinese",!this.isChinese);
        if (globalThis.chineseEngine != undefined) {
          globalThis.chineseEngine.resetToIdleState(true);
        }
      } else if (event.type === TouchType.Up) {
        globalThis.hideState = true;
        this.isCurrentTouch = !this.isCurrentTouch
      }
    })
  }
}

// 设置按钮
@Component
struct settingItem {
  private keyValue: string
  @State keyBgc: string = "#fff"

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text("设置")
    }
    .backgroundColor(this.keyBgc)
    .borderRadius(6)
    .width("8%")
    .height("65%")
    .onClick(() => {
      router.push({
        uri: "pages/service/keyBoard"
      })
    })
  }
}

// 无大小写的按键组件
@Component
struct keyItem {
  private keyValue: keySourceListType
  @State handlePopup: boolean = false
  @State keyBgc: string = "#fff"
  @State keyFontColor: string = "#000"
  @State symbolColor: string = "#fd94c1dd"
  @State isCurrentTouch: boolean = false

  build() {
    Column() {
      if (this.handlePopup) {
        Row() {
          Text(this.keyValue.content).fontSize(20).fontColor(this.keyFontColor)
        }
        .position({ x: 0, y: -60 })
        .height("95%")
        .backgroundColor(this.symbolColor)
        .margin({ right: 10 })
      }
      Flex({ direction: FlexDirection.Column,
        alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Text(this.keyValue.content).fontSize(20).fontColor(this.keyFontColor)
      }
    }
    .backgroundColor(this.isCurrentTouch ? "#aba665" : this.keyBgc)
    .borderRadius(6)
    .width("8%")
    .height("65%")
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        globalThis.hideState = false;
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.chineseEngine.processKey(this.keyValue.content, true);
      }
      if (event.type === TouchType.Up) {
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.hideState = true
      }
    })
    .gesture(
    LongPressGesture({ duration: 500 })
      .onAction((event: GestureEvent) => {
        this.handlePopup = !this.handlePopup
      })
      .onActionEnd(() => {
        this.handlePopup = !this.handlePopup
      })
    )
  }
}

// 删除组件
@Component
export struct deleteItem {
  @State keyBgc: string = "#fff"
  @State symbolColor: string = "#fd94c1dd"
  @State isCurrentTouch: boolean = false

  build() {
    Stack() {
      Image($rawfile("delete.png")).width(25).height(22)
    }
    .backgroundColor(this.isCurrentTouch ? "#aba665" : this.symbolColor)
    .width("13%")
    .borderRadius(6)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        globalThis.hideState = false;
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.chineseEngine.processKey("KEYCODE_DEL", true);
      }
      if (event.type === TouchType.Up) {
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.hideState = true;
      }
    })

    // 长按删除所有
    .gesture(
    LongPressGesture({ repeat: true, duration: 100 })
      // 长按动作存在连续触发
      .onAction((event: GestureEvent) => {
        if (event.repeat) {
          globalThis.chineseEngine.processKey("KEYCODE_DEL", true);
        }
      })
        // 长按动作一结束触发
      .onActionEnd(() => {
      })
    )
  }
}

// 空格组件
@Component
struct spaceItem {
  private spaceWith: string
  @State keyBgc: string = "#fff"
  @State keyFontColor: string = "#000"
  @State isCurrentTouch: boolean = false

  build() {
    Stack() {
      Text("space").fontSize("18lpx").fontColor(this.keyFontColor)
    }
    .backgroundColor(this.isCurrentTouch ? "#aba665" : this.keyBgc)
    .width(this.spaceWith)
    .borderRadius(6)
    .height(45)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        globalThis.hideState = false;
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.chineseEngine.processKey("KEYCODE_SPACE", true);
      } else if (event.type === TouchType.Up) {
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.hideState = true
      }
    })
  }
}

// 返回组件
@Component
export struct returnItem {
  @State keyBgc: string = "#fff"
  @State symbolColor: string = "#FD94C1DD"
  @State isCurrentTouch: boolean = false
  @State isFunctionalButtons: boolean = false

  build() {
    Stack() {
      Image($rawfile("return.png")).width(25).height(22)
    }
    .backgroundColor(this.isCurrentTouch ? "#aba665" : this.symbolColor)
    .width("16%")
    .borderRadius(6)
    .height(45)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        globalThis.hideState = false;
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.chineseEngine.processKey("KEYCODE_ENTER", true);
      } else if (event.type === TouchType.Up) {
        this.isCurrentTouch = !this.isCurrentTouch
        globalThis.hideState = true
      }
    })
  }
}

// key键盘
@Component
struct keyMenu {
  private keyList: keySourceListType[]
  @StorageLink("isUpper") isUpper: boolean = false;
  @StorageLink("isChinese") isChinese: boolean = true;
  @State handlePopup: boolean = false
  @State symbolColor: string = "#fd94c1dd"
  @Link switchScreen: boolean

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.keyList.slice(0, 10), (item: keySourceListType) => {
          keyItemNumber({
            keyValue: item
          })
        }, (item: keySourceListType) => item.content)
      }
      .padding({ top: "2%" })
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Stack() {
        }.width("6%").height(0).onTouch((event: TouchEvent) => {
          globalThis.chineseEngine.processKey("a", true)
        })

        ForEach(this.keyList.slice(10, 19), (item: keySourceListType) => {
          keyItemNumber({
            keyValue: item
          })
        }, (item: keySourceListType) => item.content)
        Stack() {
        }.width("6%").height(0).onTouch((event: TouchEvent) => {
          globalThis.chineseEngine.processKey("l", true);
        })
      }
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Stack() {
          Image($rawfile(this.isUpper ? "shift light.png" : "shift.png"))
            .width(25)
            .height(22)
        }.backgroundColor(this.symbolColor).width("13%").borderRadius(6).onClick(() => {
          AppStorage.Set("isUpper",!this.isUpper);
        })

        ForEach(this.keyList.slice(19), (item: keySourceListType) => {
          keyItemNumber({
            keyValue: item
          })
        }, (item: keySourceListType) => item.content)
        deleteItem()
      }
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({ keyValue: "?123" })
        changeItem()
        keyItem({ keyValue: { content: "," } })
        spaceItem({ spaceWith: "45%" })
        keyItem({ keyValue: { content: this.isChinese ? "。" : "." } })
        returnItem()
      }
      .width("96%")
      .height("25%")
    }
  }
}

// 数字键盘
@Component
struct numberMenu {
  private numberList: sourceListType[]
  @StorageLink("menuType") menuType: number = 0;
  @StorageLink("isChinese") isChinese: boolean = true;
  @State keyBgc: string = "#fff"

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.numberList.slice(0, 10), (item: sourceListType) => {
          keyItem({ keyValue: item })
        }, (item: sourceListType) => this.isChinese && item.chineseContent != undefined ? item.chineseContent : item.content);
      }
      .padding({ top: "2%" })
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.numberList.slice(10, 20), (item: sourceListType) => {
          keyItem({ keyValue: item })
        }, (item: sourceListType) => this.isChinese && item.chineseContent != undefined ? item.chineseContent : item.content);
      }
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({
          keyValue: "=/\<"
        })
        ForEach(this.numberList.slice(20), (item: sourceListType) => {
          keyItem({
            keyValue: item
          })
        }, (item: sourceListType) => this.isChinese && (item.chineseContent != undefined) ? item.chineseContent : item.content);
        deleteItem()
      }
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({ keyValue: "ABC" })
        keyItem({ keyValue: { content: "+" } })
        keyItem({ keyValue: { content: this.isChinese ? "，" : "," } })
        spaceItem({ spaceWith: "38%" })
        keyItem({
          keyValue: { content: this.isChinese ? "。" : "." }
        })
        returnItem()
      }
      .width("96%")
      .height("25%")
    }
  }
}

// 符号键盘
@Component
export struct symbolMenu {
  private symbolList: sourceListType[]
  @StorageLink("menuType") menuType: number = 0;
  @State keyBgc: string = "#fff"

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.symbolList.slice(0, 10), (item: sourceListType) => {
          keyItem({ keyValue: item })
        }, (item: sourceListType) => item.content);
      }
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.symbolList.slice(10, 20), (item: sourceListType) => {
          keyItem({ keyValue: item })
        }, (item: sourceListType) => item.content);
      }
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({ keyValue: "?123" })
        ForEach(this.symbolList.slice(20), (item: sourceListType) => {
          keyItem({ keyValue: item })
        }, (item: sourceListType) => item.content);
        deleteItem()
      }
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({ keyValue: "ABC" })
        keyItem({ keyValue: { content: "<" } })
        keyItem({ keyValue: { content: ">" } })
        spaceItem({ spaceWith: "38%" })
        keyItem({ keyValue: { content: "." } })
        returnItem()
      }
      .width("96%")
      .height("25%")
    }
  }
}

@Entry
@Component
struct Index {
  private keyList: keySourceListType[] = keySourceListData
  private numberList: sourceListType[] = numberSourceListData
  private symbolList: sourceListType[] = symbolSourceListData
  @StorageLink("menuType") menuType: number = 0;
  @StorageLink("isHardKeyPressed") isHardKeyPressed: boolean = false;
  @State keyBgc: string = "#fff"
  @State switchScreen: boolean = false;
  @State isClickShow: boolean = false;
  @State isClickEmo: boolean = false;
  listener = mediaquery.matchMediaSync("(orientation:landscape)")

  onPortrait(mediaQueryResult) {
    if (mediaQueryResult.matches) {
      this.switchScreen = true;
    } else {
      this.switchScreen = false;
    }
  }

  aboutToAppear() {
    portraitFunc = this.onPortrait.bind(this)
    this.listener.on("change", portraitFunc)
  }

  build() {
    Stack() {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.End
      }) {
        if (!this.isClickEmo) {
          // 输入提示框
          PromptBox({ switchScreen: $switchScreen, isClickShow: $isClickShow, isClickEmo: $isClickEmo })
          if (!this.isHardKeyPressed) {
            Flex({
              direction: FlexDirection.Column,
              alignItems: ItemAlign.Center,
              justifyContent: FlexAlign.SpaceBetween
            }) {
              if (this.menuType === 0) {
                if (!this.isClickShow) {
                  keyMenu({
                    keyList: this.keyList,
                    switchScreen: $switchScreen
                  })
                } else {
                  KeySetting({ isClickShow: $isClickShow })
                }

              } else if (this.menuType === 1) {
                numberMenu({
                  numberList: this.numberList
                })
              }
              else {
                symbolMenu({
                  symbolList: this.symbolList
                })
              }
            }
            .align(Alignment.End)
            .width("100%")
            .height("75%")
            .padding({ top: `${this.switchScreen ? "10lpx" : "20lpx"}` })
          }
        } else {
          Flex({
            direction: FlexDirection.Column,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.SpaceBetween
          }) {
            EmoSitting({ isClickEmo: $isClickEmo })
          }
          .align(Alignment.End)
          .width("100%")
          .height("100%")
        }
      }
      .height("100%").align(Alignment.End).backgroundColor("#cdd0d7")
    }
    .position({ x: 0, y: 0 }).zIndex(99999)
  }
}

