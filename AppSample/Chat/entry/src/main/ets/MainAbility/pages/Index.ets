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
import router from '@ohos.router'
import { ChatListView } from './ChatListPage'
import { DiscoverPage } from './DiscoverPage'
import { SettingPage } from './SettingPage'
import { FriendsPage } from './FriendsPage'

@Entry
@Component
struct Index {
  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column() {
            TopBar()
            ChatListView()
          }
        }
        .tabBar({ icon: $r('app.media.afr'), text: "聊天" })

        TabContent() {
          FriendsPage()
        }
        .tabBar({ icon: $r('app.media.contact_list_normal'), text: "通讯录" })

        TabContent() {
          DiscoverPage()
        }
        .tabBar({ icon: $r('app.media.find_normal'), text: "发现" })

        TabContent() {
          SettingPage()
        }
        .tabBar({ icon: $r('app.media.profile_normal'), text: "我" })
      }
      .barWidth(400)
      .barHeight(50)
      .animationDuration(0)
    }
    .width('100%')
    .height('100%')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}

@Component
struct TopBar {
  @State num: number = 0
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    autoCancel: true,
    alignment: DialogAlignment.TopEnd,
    offset: { dx: "-5", dy: "40" },
    customStyle: true
  })

  build() {
    Flex() {
      Column() {
        Stack({ alignContent: Alignment.Center }) {
          Stack({ alignContent: Alignment.Center }) {
            Text("聊天")
              .fontSize(20)
              .fontColor(Color.Black)
          }
          .height(50)
          .width("100%")

          Stack({ alignContent: Alignment.End }) {
            Stack({ alignContent: Alignment.End }) {
              Image($r('app.media.ic_public_add_filled'))
                .height(30)
                .width(30)
            }
            .height("100%")
            .width("100%")
            .onClick(() => {
              this.dialogController.open()
            })
          }
          .height(50)
          .width("100%")
          .padding(10)
        }
        .backgroundColor('#eeeeee')
        .height(50)
        .width("100%")
      }
    }
    .width('100%')
    .padding(5)
    .height(50)
  }
}

@CustomDialog
struct CustomDialogExample {
  private asd = [[$r('app.media.pic1'), "添加好友", "pages/AddFriendsPage"], [$r('app.media.pic2'), "发起群聊", "pages/CreateGroupChatPage"], [$r('app.media.pic3'), "扫一扫"], [$r('app.media.pic4'), "收付款"], [$r('app.media.pic5'), "帮助与反馈",]]
  controller: CustomDialogController

  build() {
    Column() {
      ForEach(this.asd, (item) => {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
          Image(item[0])
            .height(20)
            .width(20)
            .margin({ top: 5 })
          Text(item[1])
            .fontSize(16)
            .fontColor("#ffffff")
            .margin({ top: 5 })
        }
        .onClick(() => {
          this.controller.close()
          router.push({ url: item[2] })
        })
      }, (msg, index) => index.toString())
    }
    .backgroundColor("#696969")
    .borderRadius(5)
    .padding({ left: 5, bottom: 5 })
    .width(120)
  }
}