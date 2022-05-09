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
import { BasicDataSource } from '../common/BasicDataSource';
import { ChatModel, EMContact } from './msgBase';
import router from '@system.router';

@Entry
@Component
struct ChatListPage {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
export struct chatListView {
  @State chatListLength: number = 0
  //滑动开始纵坐标
  @State blurStart: number = 0
  //滑动结束纵坐标
  @State blurEnd: number = 0
  //滑动距离
  @State bl: number = 0
  //当前item的索引
  @State blurIndex: number = 0
  //模糊值
  @State blurNum: number = 0
  private ChatListData = new ChatListData()

  build() {
    Column() {
      List() {
        ListItem() {
          Flex() {
            Stack({ alignContent: Alignment.Center }) {
              Text("搜索")
                .fontSize(20)
            }
            .backgroundColor(Color.White)
            .height("100%")
            .width("100%")
            .onClick(() => {
              router.push({ uri: 'pages/searchPage' })
            })
          }
          .height(50)
          .width("100%")
          .backgroundColor("#eeeeee")
          .padding({ top: 5, left: 10, right: 10, bottom: 5 })
        }

        LazyForEach(this.ChatListData, (msg: ChatModel) => {
          ListItem() {
            ChatView({ chatItem: msg })
          }
        }, (msg: ChatModel) => msg.user.userId)
      }
      .listDirection(Axis.Vertical)
      .blur(this.blurNum)
      .divider({ strokeWidth: 1, color: "#f3f3f3", startMargin: 20, endMargin: 20 })
      .height("92%")
      .onScrollIndex((firstIndex: number) => {
        this.blurIndex = firstIndex
      })
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {
          console.log("laheight1:" + event.touches[0].y)
          this.blurStart = event.touches[0].y
        } else if (event.type === TouchType.Move) {
          this.blurEnd = event.touches[0].y
          this.bl = this.blurEnd - this.blurStart
          console.log("滑动距离： " + this.bl)
          //判断第一个item的索引是不是0
          if (this.blurIndex == 0) {
            if (this.bl > 0) {
              this.blurNum = this.bl / 30
              if (this.blurNum >= 96) {
                this.blurNum = 96
              }
            }
          } else {
            this.blurNum = 0
          }
        } else if (event.type === TouchType.Up) {
          this.blurNum = 0
        }
      })
    }
  }

  private aboutToAppear(): void {
    this.makeDataLocal()
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }

  makeDataLocal() {
    for (var i = 0;i < 1000; i++) {
      var tdate = new Date()
      var imagestr = "/resources/images/photo" + (i % 50).toString() + ".jpg"
      var temp1 = new ChatModel(new EMContact(i.toString(), "朋友" + i.toString(), imagestr), "朋友" + i.toString() + "最后的消息")
      this.ChatListData.pushData(temp1)
    }
  }
}

@Component
struct ChatView {
  private chatItem: ChatModel

  build() {
    Stack() {
      Flex() {
        Row() {
          Flex() {
            Image(this.chatItem.user.userImage)
              .width(50)
              .height(50)
              .borderRadius(5)
              .autoResize(false)
          }
          .layoutWeight(1)

          Stack({ alignContent: Alignment.Start }) {
            Column() {
              Text(this.chatItem.user.userName)
                .fontColor(Color.Black)
                .fontSize(15)
              Text(this.chatItem.lastMsg)
                .fontColor("#999999")
                .fontSize(13)
            }
            .padding({ left: 12 })
            .alignItems(HorizontalAlign.Start)
          }
          .padding({ left: 12 })
          .layoutWeight(7)

        }
        .width("100%")
        .onClick(() => {
          router.push({
            uri: 'pages/chatDetailPage',
            params: { data2: this.chatItem.user.userName, data3: this.chatItem.user.userId }
          })
          console.log("onClick" + "click")
        })
      }
      .width("100%")
    }
    .width("100%")
    .height(80)
    .padding({ left: 12, right: 10, top: 10, bottom: 10 })
  }
}

class ChatListData extends BasicDataSource {
  private chatList: Array<ChatModel> = []

  public totalCount(): number {
    return this.chatList.length
  }

  public getData(index: number): any {
    return this.chatList[index]
  }

  public addData(index: number, data: ChatModel): void {
    this.chatList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: ChatModel): void {
    this.chatList.push(data)
    this.notifyDataAdd(this.chatList.length - 1)
  }
}