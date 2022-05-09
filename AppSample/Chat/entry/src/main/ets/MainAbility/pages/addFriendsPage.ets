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
import router from '@system.router';

@Entry
@Component
struct AddFriendsPage {
  @State changevalue: string = ''
  @State submitvalue: string = ''
  @State explain: string = ''
  scroller: Scroller = new Scroller()
  private expl = [["添加身边的好友", "/resources/images/radar.png", "雷达加好友"], ["与身边的朋友进入一个群聊", "/resources/images/face.png", "面对面建群"], ["扫描二维码名片", "/resources/images/scan.png", "扫一扫"], ["添加邀请通讯录中的好友", "/resources/images/add.png", "手机联系人"], ["获取更多资讯和服务", "/resources/images/public.png", "公众号"], ["通过手机号搜索企业聊天用户", "/resources/images/empresa.png", "企业聊天联系人"]]

  build() {
    Scroll(this.scroller) {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
          Row() {
            Image("/resources/images/left.png")
              .height(30)
              .width(30)
          }
          .width("10%")
          .onClick(() => {
            router.back()
          })

          Text("添加好友")
            .fontWeight(FontWeight.Bold)
            .fontSize(18)
          Row() {
            Text("  ")
              .fontWeight(FontWeight.Bold)
              .fontSize(18)
          }
          .width("10%")
        }
        .width("100%")
        .padding({ top: 20, bottom: 20, left: 10, right: 10 })

        Column() {
          Search({ value: '', placeholder: '搜索' })
            .placeholderColor(Color.Black)
            .placeholderFont({ size: 16, weight: 10, family: 'serif', style: FontStyle.Normal })
            .onSubmit((value: string) => {
              this.submitvalue = value
            })
            .onChange((value: string) => {
              this.changevalue = value
            })
        }

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text("我的聊天号：*********")
            .fontSize(14)
            .opacity(0.5)
          Image("/resources/images/ic_public_code.png")
            .height(16)
            .width(16)
        }
        .padding(10)

        ForEach(this.expl, (item) => {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Image(item[1])
              .height(40)
              .width(40)
              .margin({ top: 10, left: 5, bottom: 20 })
            Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
              Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.SpaceBetween
              }) {
                Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
                  Text(item[2])
                    .fontSize(16)
                    .padding({ top: 10, left: 5, right: 5 })
                  Text(item[0])
                    .fontSize(12)
                    .padding(5)
                    .opacity(0.5)
                    .margin({ bottom: 5 })
                }

                Image("/resources/images/right.png")
                  .height(15)
                  .width(15)
                  .margin({ top: 2 })
                  .opacity(0.5)
              }
              .width("90%")

              Row() {
              }
              .height(1)
              .width("80%")
              .backgroundColor("#f4f4f4")
            }
          }
          .height(70)
          .backgroundColor("#ffffff")
        }, (msg, index) => index.toString())
      }
      .backgroundColor("#f5f5f5")
      .width('100%')
    }
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}