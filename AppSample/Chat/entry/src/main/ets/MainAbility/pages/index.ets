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
import { chatListView } from './chatListPage';
import { DiscoverPage } from './discoverpage';
import router from '@system.router';
import { ChatModel, EMContact } from './msgBase'
import { SettingPage } from './settingPage'
import { FriendsPage } from './friendsPage'

@Entry
@Component
struct Index {
  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column() {
            topBar()
            chatListView()
          }
        }
        .tabBar({ icon: "/resources/icon/afr.png", text: "聊天" })

        TabContent() {
          FriendsPage()
        }
        .tabBar({ icon: "/resources/icon/contact_list_normal.png", text: "通讯录" })

        TabContent() {
          DiscoverPage()
        }
        .tabBar({ icon: "/resources/icon/find_normal.png", text: "发现" })

        TabContent() {
          SettingPage()
        }
        .tabBar({ icon: "/resources/icon/profile_normal.png", text: "我" })
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
struct topBar {
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
              Image("/resources/images/ic_public_add_filled.png")
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
  private asd = [["/resources/images/pic1.png", "添加好友", "pages/addFriendsPage"], ["/resources/images/pic2.png", "发起群聊", "pages/createGroupChatPage"], ["/resources/images/pic3.png", "扫一扫"], ["/resources/images/pic4.png", "收付款"], ["/resources/images/pic5.png", "帮助与反馈", "page/helpPage"]]
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
          router.push({ uri: item[2] })
        })
      }, (msg, index) => index.toString())
    }
    .backgroundColor("#696969")
    .borderRadius(5)
    .padding({ left: 5, bottom: 5 })
    .width(120)
  }
}