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
@Entry
@Component
struct MsgBase {
  build() {
    Row() {
      Column() {
        Text('Hello World')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }.width('100%')
    }.height('100%')
  }
}
/**
 * 聊天list中item对象
 * @param user 用户名
 * @param lastMsg 最后一天信息
 * @param time 时间
 */

export class ChatModel {
  user: EMContact
  lastMsg: string;
  constructor(user: EMContact, lastMsg: string) {
    this.user = user
    this.lastMsg = lastMsg
  }

  toString(): string {
    return this.user.toString() + "  " + this.lastMsg + "  "
  }
}

//聊天信息
export class MessageBase {
  msgId: string
  fo: EMContact
  to: EMContact
  msgBody: MessageBody
  msgType: number
  msgTime: number
  constructor(id: string, fo: EMContact, to: EMContact, msg: MessageBody, ty: number, time: number) {
    this.msgId = id
    this.fo = fo
    this.to = to
    this.msgBody = msg
    this.msgType = ty
    this.msgTime = time
  }

  toString(): string {
    return this.msgId + "  " + this.fo + "  " + this.to + "  " + this.msgBody + "  " +
    this.msgType + "  " + this.msgTime
  }
}

export class MessageBody {
  toString(): string{
    return ""
  }
}

//文本消息
export class TextMessage extends MessageBody {
  toString(): string {
    return this.msg
  }

  constructor(msg: string) {
    super()
    this.msg = msg
  }

  msg: string
}

//图片消息
export class ImageMessage extends MessageBody {
  toString(): string {
    return this.height + "  " + this.width + "  " + this.img
  }

  constructor(hei: number, wid: number, img: string) {
    super()
    this.height = hei
    this.width = wid
    this.img = img
  }

  height: number
  width: number
  img: string
}

//user消息
export class EMContact {
  userId: string
  userName: string
  userImage: string
  toString(): string {
    return this.userId + "  " + this.userName + "  " + this.userImage
  }

  constructor(id: string, name: string, image?: string) {
    this.userId = id
    this.userName = name
    this.userImage = "/resources/images/personality3.jpg"
    if (image != null) {
      this.userImage = image
    }
  }
}

export class FriendMoment {
  id: string
  user: EMContact
  text: string
  time: string
  imageList: Array<string>
  constructor(id: string, user: EMContact, text: string, time: string, List?: Array<string>) {
    this.id = id
    this.user = user
    this.time = time
    this.text = text
    if (List != null) {
      this.imageList = List
    }
  }

  toString(): string {
    return this.id + "  " + this.user.toString() + "  " + this.text + "  " + this.time + "  " // +this.imageList.toString()
  }
}