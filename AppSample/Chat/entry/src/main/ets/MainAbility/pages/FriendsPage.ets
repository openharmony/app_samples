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
import router from '@system.router';
import { BasicDataSource } from '../common/BasicDataSource';
import { EMContact } from './MsgBase'

@Entry
@Component
export struct FriendsPage {
  @State friendsListLength: number = 0
  @State butto: string = ''
  private friendListData = new FriendListData()

  build() {
    Flex() {
      Stack({ alignContent: Alignment.Top }) {
        Column() {
          List() {
            ListItem() {
              Column() {
                Stack({ alignContent: Alignment.Center }) {
                  Text("搜索")
                    .fontSize(20)
                }
                .backgroundColor(Color.White)
                .height('50')
                .width('100%')
                .margin({ left: 10, right: 10, top: 5, bottom: 5 })
                .onClick(() => {
                  router.push({ uri: 'pages/SearchPage' })
                })

                Column() {
                  EMContactItemView({ image: $r('app.media.icon_addfriend'), text: "新的好友" })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.icon_group'), text: "群聊" })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.chat_home'), text: "仅聊天的人" })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.label'), text: "标签" })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.public'), text: "公众号" })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.empresa'), text: "企业聊天联系人" })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.icon_public'), text: "订阅号" })
                }
              }
            }

            LazyForEach(this.friendListData, (msg: EMContact) => {
              ListItem() {
                EMContactItemView({ image: msg.userImage, text: msg.userName })
              }
              .onClick(() => {
                router.push({
                  uri: "pages/ChatDetailPage",
                  params: { chatImage: msg.userImage, chatName: msg.userName, chatId: msg.userId } })
              })
            }, (msg: EMContact) => msg.userId)
          }
          .listDirection(Axis.Vertical)
          .height("100%")
        }
      }
      .width('100%')
    }
    .backgroundColor('#e3e3e3')
    .width('100%')
    .height('100%')
  }

  private aboutToAppear(): void {
    this.makeDataLocal()
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }

  makeDataLocal() {
    for (let i = 0;i < 1000; i++) {
      let imageStr = `/resources/images/photo${(i % 50).toString()}.jpg`
      let temp1 = new EMContact(i.toString(), `朋友${i.toString()}`, imageStr);
      this.friendListData.pushData(temp1)
    }
  }
}

@Component
export struct EMContactItemView {
  private image: string
  private text: string
  private callBack: Function
  private height: number = 60

  build() {
    Row() {
      Image(this.image)
        .width(40)
        .height(40)
        .borderRadius(5)
      Text(this.text)
        .fontSize(15)
        .fontColor("#000000")
        .margin({ left: 10 })
    }
    .width('100%')
    .height(this.height)
    .padding({ left: 10, right: 10 })
    .backgroundColor(Color.White)
  }
}

class FriendListData extends BasicDataSource {
  friendList: Array<EMContact> = []

  public totalCount(): number {
    return this.friendList.length
  }

  public getData(index: number): any {
    return this.friendList[index]
  }

  public addData(index: number, data: EMContact): void {
    this.friendList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: EMContact): void {
    this.friendList.push(data)
    this.notifyDataAdd(this.friendList.length - 1)
  }
}