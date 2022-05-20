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
import router from '@ohos.router';
import { Header } from '../components/Header';

@Entry
@Component
struct UserInfo {
  private scroller: Scroller = new Scroller()
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7]
  private str: string[] = ["头像", "名字", "拍一拍", "聊天号", "我的二维码", "更多", "聊天豆", "我的地址"]
  private userInfo: string[] = [$r('app.media.personality3'), "自己", "的额头", "********", $r('app.media.ic_public_code'), "", "", ""]
  @State editFlag: boolean = false

  build() {
    Scroll(this.scroller) {
      Column() {
        Header({ title: "个人信息" })
        List({ space: 0, initialIndex: 0 }) {
          ForEach(this.arr, item => {
            ListItem() {
              Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.SpaceBetween
              }) {
                Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
                  Text(this.str[item])
                    .fontSize(16)
                    .padding({ left: 20 })
                }

                Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
                  if (this.str[item] === '头像') {
                    Image(this.userInfo[item])
                      .width(60)
                      .height(60)
                      .margin({ right: 20 })
                  } else if (this.str[item] === '我的二维码') {
                    Image(this.userInfo[item])
                      .width(30)
                      .height(30)
                      .margin({ right: 20 })
                  } else {
                    Text(`${this.userInfo[item]}`)
                      .fontSize(16)
                      .margin({ right: 20 })
                  }
                  Image($r('app.media.right'))
                    .height(15)
                    .width(15)
                    .opacity(0.5)
                    .margin({ right: 10, top: 2 })
                }
              }
              .height(80)
              .backgroundColor(0xFFFFFF)
            }
          }, item => item)
        }
        .backgroundColor('#ffffff')
        .editMode(true)
        .width("100%")
      }
      .width("100%")
      .backgroundColor(0xDCDCDC)
      .padding({ top: 5 })
    }
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}