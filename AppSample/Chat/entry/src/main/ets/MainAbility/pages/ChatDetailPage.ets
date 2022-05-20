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
// @ts-nocheck
import { BasicDataSource } from '../common/BasicDataSource';
import { MessageBase, EMContact, MessageBody, TextMessage, ImageMessage } from './MsgBase';
import router from '@ohos.router';

@Entry
@Component
struct ChatDetailPage {
  @State str: string = ""
  @State chatName: string = ''
  @State msgLength: number = 0
  user1 = new EMContact("1", "自己")
  user2= new EMContact("2", "朋友1")
  msg = new TextMessage("我是好友消息1")
  msg2 = new TextMessage("我是好友消息2")
  tdate = new Date()
  megbody = new MessageBase("1", this.user1, this.user2, this.msg2, 1, this.tdate.getSeconds())
  keyboartStr: string
  private chatDetailData = new ChatDetailData()
  private scroller: Scroller = new Scroller()

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        Image($r('app.media.left'))
          .height(30)
          .width(30)
          .onClick(() => {
            router.back()
          })

        Text(router.getParams().chatName)
          .fontSize(15)
        Stack({ alignContent: Alignment.Center }) {
          Image($r('app.media.icon_more'))
            .height(40)
            .width(40)
        }
        .width("10%")
        .onClick(() => {
          router.push({
            url: "pages/ChatNewsPage",
            params: { NAME: router.getParams().chatName, IMAGEID: router.getParams().chatId }
          })
        })
      }
      .height(50)
      .width("100%")
      .backgroundColor("#f5f5f5")
      .padding({ left: 0, right: 10 })

      Stack({ alignContent: Alignment.BottomStart }) {
        List({ scroller: this.scroller, initialIndex: this.msgLength }) {
          LazyForEach(this.chatDetailData, (msg: MessageBase) => {
            ListItem() {
              ChatItemView({ msg: msg })
            }
          }, (msg: MessageBase) => msg.msgId)
        }
        .listDirection(Axis.Vertical)
        .divider({ strokeWidth: 2, color: "#f3f3f3" })
        .margin({ bottom: 60 })
        .padding({ left: 10, right: 10, bottom: 60 })
        .height("100%")
        //底部输入框
        Row({ space: 5 }) {
          Image($r('app.media.chatting_setmode_voice'))
            .height(20)
            .width(20)
          TextInput({ placeholder: "", text: "" })
            .height(40)
            .width('80%')
            .enterKeyType(EnterKeyType.Send)
            .onChange((value: string) => {
              this.keyboartStr = value
            })
            .onSubmit((enterKey) => {
              this.tdate = new Date()
              let msg = new TextMessage(this.keyboartStr)
              let msgBody = new MessageBase(this.chatDetailData.totalCount()
                .toString(), this.user1, this.user2, msg, 1, this.tdate.getSeconds())
              this.chatDetailData.pushData(msgBody)
              this.msgLength = this.chatDetailData.totalCount()
              this.scroller.scrollToIndex(this.msgLength)
            })
          Image($r('app.media.chatting_expression'))
            .height(20)
            .width(20)
            .onClick(() => {
              let imagestr = `/resources/images/photo${((router.getParams().chatId) % 50)}.jpg`
              let msg = new ImageMessage(40, 50, imagestr)
              let msgBody = new MessageBase(this.chatDetailData.totalCount().toString(), this.user1, this.user2, msg, 2)
              this.chatDetailData.pushData(msgBody)
              this.msgLength = this.chatDetailData.totalCount()
              this.scroller.scrollToIndex(this.msgLength)
            })
          Image($r('app.media.type_select'))
            .height(20)
            .width(20)
            .margin({ right: 10 })
        }
        .backgroundColor("#e3e3e3")
        .width("100%")
        .padding(10)
      }
    }
    .backgroundColor("#f3f3f3")
    .height("100%")
    .padding({ bottom: 60 })
  }

  private aboutToAppear(): void {
    this.makeDataLocal()
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }

  makeDataLocal() {
    let tdate = new Date()
    let user1 = new EMContact("1", "自己")
    let user2 = new EMContact("2", `朋友${router.getParams().chatId.toString()}`, `/resources/images/photo${(parseInt(
      router.getParams()
      .chatId) % 50).toString()}.jpg`)
    let sum = 0
    for (let i = 0; i < 1000; i++) {
      let msg2
      let msgBody
      if (sum % 2 === 0) {
        msg2 = new TextMessage(`我是第${i.toString()}条消息`)
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), user2, user1, msg2, 1, tdate.getSeconds())
        } else {
          msgBody = new MessageBase(i.toString(), user1, user2, msg2, 1, tdate.getSeconds())
        }
      } else {
        let imagestr = `/resources/images/photo${(i % 50).toString()}.jpg`
        msg2 = new ImageMessage(40, 50, imagestr)
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), user2, user1, msg2, 2, tdate.getSeconds())
        } else {
          msgBody = new MessageBase(i.toString(), user1, user2, msg2, 2, tdate.getSeconds())
        }
      }
      if (i % 2 === 0) sum++
      this.chatDetailData.pushData(msgBody)
    }
    this.msgLength = this.chatDetailData.totalCount()
  }
}

@Component
struct ChatItemView {
  private msg: MessageBase

  build() {
    if (this.msg.fo.userId != '1') {
      //聊天页面对方的消息
      Row() {
        Image(this.msg.fo.userImage)
          .width(40)
          .height(40)
          .borderRadius(5)
        Column() {
          Text(this.msg.fo.userName)
          if (this.msg.msgType === 1) {
            Text((this.msg.msgBody as TextMessage).msg)
              .fontSize(15)
              .fontColor("#000")
              .backgroundColor(Color.White)
              .padding(10)
          } else if (this.msg.msgType === 2) {
            Image((this.msg.msgBody as ImageMessage).img)
              .width((this.msg.msgBody as ImageMessage).width)
              .height((this.msg.msgBody as ImageMessage).height)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 5 })
      }
      .width("100%")
      .alignItems(VerticalAlign.Top)
      .margin({ top: 15 })
      .padding({ right: 50 })
    } else {
      //聊天页面本人消息
      Row() {
        Image(this.msg.fo.userImage)
          .width(40)
          .height(40)
          .borderRadius(5)
        Column() {
          Text(this.msg.fo.userName)
          if (this.msg.msgType === 1) {
            Text((this.msg.msgBody as TextMessage).msg)
              .fontSize(15)
              .fontColor("#000")
              .backgroundColor("#7fec7d")
              .borderRadius(5)
              .padding(10)
          } else if (this.msg.msgType === 2) {
            Image((this.msg.msgBody as ImageMessage).img)
              .width((this.msg.msgBody as ImageMessage).width)
              .height((this.msg.msgBody as ImageMessage).height)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 5 })
      }
      .width("100%")
      .direction(Direction.Rtl)
      .padding({ left: 50 })
      .margin({ top: 15 })
    }
  }
}

class ChatDetailData extends BasicDataSource {
  msgList: Array<MessageBase> = []

  public totalCount(): number {
    return this.msgList.length
  }

  public getData(index: number): any {
    return this.msgList[index]
  }

  public addData(index: number, data: MessageBase): void {
    this.msgList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: MessageBase): void {
    this.msgList.push(data)
    this.notifyDataAdd(this.msgList.length - 1)
  }
}