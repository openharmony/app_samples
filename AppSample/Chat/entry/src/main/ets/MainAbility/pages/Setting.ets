// @ts-nocheck
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
import { Header } from "../components/Header"
import router from '@system.router';

@Entry
@Component
struct Setting {
  private scroller: Scroller = new Scroller()

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Header({ title: "设置" })
      Scroll(this.scroller) {
        Column() {
          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            SettingValue({ name: "账号与安全" })
          }
          .margin({ bottom: 10 })

          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            SettingValue({ name: "青少年模式" })
            SettingValue({ name: "关怀模式" })
          }
          .margin({ bottom: 10 })

          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            SettingValue({ name: "新消息通知" })
            SettingValue({ name: "聊天" })
            SettingValue({ name: "隐私" })
            SettingValue({ name: "通用" })
          }
          .margin({ bottom: 10 })

          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            SettingValue({ name: "帮助与反馈" })
            SettingValue({ name: "关于聊天" })
            SettingValue({ name: "插件" })
          }
          .margin({ bottom: 10 })

          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            SettingValue({ name: "负载开关" })
          }
          .margin({ bottom: 10 })
          .onClick(() => {
            router.push({
              uri: "pages/SwitchPage"
            })
          })

          Row() {
            Text('切换账号')
              .width('100%')
              .fontSize(16)
              .padding({ left: 20 })
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .margin({ bottom: 10 })
          .height(55)
          .backgroundColor(0xFFFFFF)

          Row() {
            Text('退出登录')
              .width('100%')
              .fontSize(16)
              .padding({ left: 20 })
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .margin({ bottom: 10 })
          .height(55)
          .backgroundColor(0xFFFFFF)
        }
      }
    }
    .width("100%")
    .height("100%")
    .backgroundColor(0xEEEEEE)
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}

@Component
struct SettingValue {
  @State name: string = ""

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        Text(this.name)
          .fontSize(16)
          .padding({ left: 20 })
          .textAlign(TextAlign.Start)
      }
      .width("50%")
      .alignItems(HorizontalAlign.Start)

      Column() {
        Image($r('app.media.right'))
          .height(15)
          .width(15)
          .opacity(0.5)
          .margin({ left: 10, top: 2 })
      }
      .alignItems(HorizontalAlign.End)
      .width('50%')
      .padding({ right: 10 })
    }
    .width('100%')
    .height(55)
    .backgroundColor(0xFFFFFF)
  }
}