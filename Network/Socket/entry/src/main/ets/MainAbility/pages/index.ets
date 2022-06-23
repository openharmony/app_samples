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

import wifi from '@ohos.wifi';
import router from '@ohos.router';
import socket from '@ohos.net.socket';
import Logger from '../model/Logger'
import { ChatBox } from '../model/ChatBox'
import { resolveIP } from '../Utils/Util'

let udp = socket.constructUDPSocketInstance()
const TAG: string = '[Index]'

let localAddr = {
  address: resolveIP(wifi.getIpInfo().ipAddress),
  family: 1,
  port: 0
}

let oppositeAddr = {
  address: '',
  family: 1,
  port: 0
}

@Entry
@Component
struct Index {
  private address: string = <string> router.getParams()['address']
  private port: number = <number> router.getParams()['port']
  private loginCount: number = <number> router.getParams()['loginCount']
  @State user: string = ''
  @State userImg: Resource = $r('app.media.fengzi')
  @State otherImg: Resource = $r('app.media.wenzi')
  @State chats: Array<ChatBox> = []
  @State loginState: boolean = true
  @State message: string = ''
  @State afterSend: boolean = false
  @State onlineState: boolean = true

  aboutToAppear() {
    oppositeAddr.address = this.address
    oppositeAddr.port = this.port + this.loginCount
    localAddr.port = (this.port === 8080 ? 9090 : 8080) + this.loginCount
    this.user = localAddr.port === (9090 + this.loginCount) ? 'wenzi' : 'fengzi'
    Logger.info(TAG, `this.port=${this.port}`)
    Logger.info(TAG, `oppositeAddr.port=${oppositeAddr.port}`)
    Logger.info(TAG, `localAddr.port=${localAddr.port}`)
    this.userImg = this.user === 'fengzi' ? $r('app.media.fengzi') : $r('app.media.wenzi')
    this.otherImg = this.user === 'fengzi' ? $r('app.media.wenzi') : $r('app.media.fengzi')
    this.bindOption()
  }

  bindOption() {
    //绑定，开始监听消息
    let promise = udp.bind(localAddr);
    promise.then(() => {
      Logger.info(TAG, 'udp bind success')
    }).catch(err => {
      Logger.info(TAG, `udp bind fail ${err}`)
    })
    udp.on('message', data => {
      if (data.message instanceof ArrayBuffer) {
        let dataView = new DataView(data.message)
        Logger.info(TAG, `length = ${dataView.byteLength}`)
        let str = ""
        for (let i = 0;i < dataView.byteLength; ++i) {
          let c = String.fromCharCode(dataView.getUint8(i))
          if (c !== "\n") {
            str += c
          }
        }
        Logger.info(TAG, `message aray buffer:${str}`)

        if (str == 'online') {
          this.onlineState = true
          udp.close()
        }
        else if (str == 'offline') {
          this.onlineState = false
          udp.close()
        } else if (str == 'exit') {
          udp.off('message', () => {
          })
          udp.close()
          Logger.info(TAG, 'receive udp exit 2')
          router.back()
          Logger.info(TAG, 'receive udp exit 3')
        } else {
          Logger.info(TAG, `receive in Chat sucess`)
          let date = new Date().getMonth() + '.' + new Date().getDay() + '-' + new Date().getHours() + ':' + new Date().getMinutes()
          Logger.info(TAG, `pre:this.chats=${JSON.stringify(this.chats)}`)
          this.chats[this.chats.length] = new ChatBox(false, str, date)
          Logger.info(TAG, `after:this.chats=${JSON.stringify(this.chats)}`)
        }
        str = ''
      } else {
        Logger.info(TAG, `message:${data.message}`)
      }
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Row() {
        Text($r('app.string.MainAbility_label'))
          .fontSize(25)
          .fontColor(Color.White)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
        Blank()
        Button() {
          Image($r('app.media.exit'))
            .width(35)
            .height(35)
            .objectFit(ImageFit.Fill)
        }
        .width(100)
        .type(ButtonType.Capsule)
        .backgroundColor('#ff50afea')
        .onClick(() => {
          udp.send({
            data: 'exit',
            address: oppositeAddr
          }).then(data => {
            Logger.info(TAG, `send sucess : ${data}`)
            this.chats = []
            udp.off('message', () => {
            })
            udp.close()
            router.back()
          }).catch(function (err) {
            Logger.info(TAG, `TAG,send : ${JSON.stringify(err)}`)
          })
        })
      }
      .height(50)
      .width('100%')
      .backgroundColor('#0D9FFB')
      .padding({ left: 10, right: 10 })

      Column() {
        Text(this.user === 'fengzi' ? $r('app.string.classmate_wenzi') : $r('app.string.classmate_fengzi'))
          .fontSize(20)
          .width('100%')
          .padding({ top: 5 })
          .textAlign(TextAlign.Center)
        Row() {
          Image(this.onlineState ? $r('app.media.online') : $r('app.media.offline'))
            .width(15)
            .height(15)
            .margin({ top: 3 })
            .objectFit(ImageFit.Fill)
            .alignSelf(ItemAlign.Start)
          Text(this.onlineState === true ? $r('app.string.online') : $r('app.string.offline'))
            .fontSize(15)
            .margin({ left: 5 })
            .textAlign(TextAlign.Center)
        }.padding({ top: 5 })
      }
      .width('100%').height(55)
      .backgroundColor(this.onlineState ? '#ffcae4f5' : '#e5e5e5')
      .bindMenu([
        {
          value: '在线',
          action: () => {
            //设置为在线后，绑定本地的地址和端口，并向对方发送在线指令
            this.onlineState = true
            this.bindOption()
            udp.send({
              data: 'online',
              address: oppositeAddr
            }).then(data => {
              Logger.info(TAG, `send sucess : ${data}`)
            }).catch(function (err) {
              Logger.info(TAG, `TAG,send : ${JSON.stringify(err)}`)
            })
          }
        },
        {
          value: '离线',
          action: () => {
            //设置为离线后，先向对方发送发送离线信息，然后关闭udp
            this.onlineState = false
            udp.send({
              data: 'offline',
              address: oppositeAddr
            }).then(data => {
              Logger.info(TAG, `send sucess : ${data}`)
            }).catch(function (err) {
              Logger.info(TAG, `TAG,send : ${JSON.stringify(err)}`)
            })
            udp.close()
          }
        }
      ])


        Column(){
          Scroll() {
            Column() {
              ForEach(this.chats, (item, index) => {
                if (item.isSend) {
                  Row() {
                    Column() {
                      Text(item.date)
                        .fontSize(15) //时间
                        .width('100%')
                        .textAlign(TextAlign.End)
                      Text(item.message)
                        .maxLines(5)
                        .padding(10)
                        .fontSize(20)
                        .borderRadius(10)
                        .alignSelf(ItemAlign.End)
                        .backgroundColor('#ff78dd4d')
                    }.width('70%').margin({ right: 5 })

                    Image(item.isSend ? this.userImg : this.otherImg).width(50).height(50).objectFit(ImageFit.Fill)
                  }.margin({ top: 5, bottom: 10 }).alignSelf(ItemAlign.End)
                } else {
                  Row() {
                    Image(item.isSend ? this.userImg : this.otherImg).width(50).height(50).objectFit(ImageFit.Fill)
                    Column() {
                      Text(item.date).width('100%').textAlign(TextAlign.Start).fontSize(15) //时间
                      Text(item.message)
                        .fontSize(20)
                        .maxLines(5)
                        .padding(10)
                        .borderRadius(10)
                        .alignSelf(ItemAlign.Start)
                        .backgroundColor('#ff78dd4d')
                    }.width('70%').margin({ left: 5 })
                  }.margin({ top: 5, bottom: 10 }).alignSelf(ItemAlign.Start)
                }

              }, item => item.message)
            }.width('100%').height('100%').backgroundColor(Color.White).padding(5)
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Auto)
          .scrollBarColor(Color.Gray)
          .scrollBarWidth(30)
          .width('100%')
          .height('100%')
        }.width('100%').layoutWeight(1)

        Row() {
          TextInput({ placeholder: this.message, text: this.message })
            .height(50)
            .fontSize(20)
            .layoutWeight(3)
            .type(InputType.Normal)
            .backgroundColor(Color.White)
            .margin({ left: 2, right: 2 })
            .onChange((value: string) => {
              this.message = value
            })

          Button() {
            Text($r('app.string.send_message')).fontSize(23).fontColor(Color.White)
          }
          .height(50)
          .layoutWeight(1)
          .borderRadius(10)
          .type(ButtonType.Normal)
          .margin({ left: 2, right: 2 })
          .backgroundColor('#ffadf58e')
          .onClick(() => {
            let date = new Date().getMonth() + '.' + new Date().getDay() + '-' + new Date().getHours() + ':' + new Date().getMinutes()
            let sendMessage = new ChatBox(true, this.message, date)
            this.chats[this.chats.length] = sendMessage
            if (this.message !== '' && this.loginState && this.onlineState) {
              //通过udp发送this.message文本
              //udp.bind(localAddr)
              this.bindOption()
              udp.send({
                data: this.message,
                address: oppositeAddr
              }).then(data => {
                Logger.info(TAG, 'send sucess')
                Logger.info(TAG, `send ${data}`)
                Logger.info(TAG, `this.chats=${JSON.stringify(this.chats)}`)
                Logger.info(TAG, `(send)opposite_address=${oppositeAddr.address}`)
                Logger.info(TAG, `(send)opposite_port=${oppositeAddr.port}`)
                Logger.info(TAG, `(send)this.message=${this.message}`)
                Logger.info(TAG, `this.chats=${JSON.stringify(this.chats)}`)
              }).catch(function (err) {
                Logger.info(TAG, `send ${JSON.stringify(err)}`)
              })
            }
            this.message = ''
          })
        }.width('100%').height(70).backgroundColor('#f5f5f5')

    }
    .width('100%')
    .height('100%')
  }
}