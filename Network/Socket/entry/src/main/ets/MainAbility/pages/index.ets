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

import prompt from '@system.prompt';
import router from '@system.router';
import socket from '@ohos.net.socket';
import { ChatBox } from '../model/ChatBox'
import { resolveIP } from '../Utils/util'
import wifi from '@ohos.wifi';


let udp = socket.constructUDPSocketInstance()

let localAddr = {
  address:resolveIP(wifi.getIpInfo().ipAddress),
  family:1,
  port:0
}

let oppositeAddr = {
  address:'',
  family:1,
  port:0
}

@Entry
@Component
struct Index {


  @State address : string = <string> router.getParams().address
  @State port : number = <number> router.getParams().port
  @State user : string = ''
  @State userImg: Resource = $r('app.media.fengzi')
  @State otherImg: Resource = $r('app.media.wenzi')
  @State chats: Array<ChatBox> = []
  @State loginState : boolean = true
  @State message : string = ''


  aboutToAppear() {
    console.info('[fengzi]push sucess!')
    oppositeAddr.address = this.address
    console.log('[fengzi*index]oppositeAddr.address = '+oppositeAddr.address)
    oppositeAddr.port = this.port === 8080 ? 8888 : 9999
    console.log('[fengzi]oppositeAddr.port = '+oppositeAddr.port)
    localAddr.port = oppositeAddr.port == 8888 ? 9999 : 8888
    console.log('[fengzi]localAddr.port = '+localAddr.port)
    this.user = localAddr.port == 9999 ? 'fengzi' : 'wenzi'
    console.log('[fengzi]user = '+this.user)
//    this.user = this.oppositeAddr == 9090 ?
    this.userImg = this.user === 'fengzi' ? $r('app.media.fengzi') : $r('app.media.wenzi')
    this.otherImg = this.user === 'fengzi' ? $r('app.media.wenzi') : $r('app.media.fengzi')
//    localAddr.port = this.port === 8080 ? 8090 : 8080
    console.log('[fengzi]user = '+this.user)
    this.bindOption()
  }

  bindOption(){

    //绑定，开始监听消息
    let promise = udp.bind(localAddr);
    promise.then(() => {
      console.log('[fengzi] udp bind success')
    }).catch(err => {
      console.log('[fengzi] udp bind fail' + err)
    })
    udp.on('message',  data => {
      console.log('[fengzi]udp on 已启动')
      if (data.message instanceof ArrayBuffer) {
        let dataView = new DataView(data.message)
        console.log("[fengzi]【length】 length = " + dataView.byteLength)
        let str = ""
        for (let i = 0;i < dataView.byteLength; ++i) {
          let c = String.fromCharCode(dataView.getUint8(i))
          if (c !== "\n") {
            str += c
          }
        }
        console.log("[fengzi] message aray buffer:" + str)
        //        if (str !== '') {
        let date = new Date().getMonth() + '.' + new Date().getDay() + '-' + new Date().getHours() + ':' + new Date().getMinutes()
        //          let receiveMessage = new ChatBox(false, str, date)
        this.chats.push(new ChatBox(false, str, date))
        console.info('[fengzi](on)chats=' + JSON.stringify(this.chats))
        str = ''
        //        }
      } else {
        console.log("[fengzi] message:" + data.message)
      }
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.MainAbility_label'))
        .width('100%')
        .height(50)
        .backgroundColor('#0D9FFB')
        .textAlign(TextAlign.Start)
        .fontSize(25)
        .padding({ top: 10, left: 10 })
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
      Text(this.user === 'fengzi' ? $r('app.string.classmate_wenzi') : $r('app.string.classmate_fengzi'))
        .width('100%')
        .fontSize(20)
        .padding({top:5})
        .backgroundColor('#e5e5e5')
        .textAlign(TextAlign.Center)
      Text(this.loginState === true ? $r('app.string.online') : $r('app.string.offline'))
        .width('100%')
        .fontSize(15)
        .backgroundColor('#e5e5e5')
        .textAlign(TextAlign.Center)
        .bindMenu([
          {
            value:'在线',
            action:()=>{
              //设置为在线后，绑定本地的地址和端口
              this.loginState = true
//              localAddr.port = this.user === 'fengzi' ? 8090 : 8080
              this.bindOption()
            }
          },
          {
            value:'离线',
            action:()=>{
              //设置为离线后，关闭udp
              this.loginState = false
              udp.close()
            }
          }
        ])

      Column() {
        Scroll() {
          Column() {
            ForEach(this.chats, (item, index) => {
              if (item.isSend) {
                Row() {
                  Column() {
                    Text(item.date).width('100%').textAlign(TextAlign.End).fontSize(15) //时间
                    Text(item.message)
                      .fontSize(20)
                      .maxLines(5)
                      .padding(10)
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
        .height('90%')

        Row() {
          TextInput()
            .height(50)
            .fontSize(20)
            .layoutWeight(3)
            .type(InputType.Normal)
            .margin({ left: 2, right: 2 })
            .backgroundColor(Color.White)
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
            let sendMessage = new ChatBox(true,this.message,date)

            if (this.message !== '') {
              this.chats.push(sendMessage)
              console.info('[fengzi](send)chats=' + JSON.stringify(this.chats))
              console.info('[fengzi](send)opposite_address='+oppositeAddr.address)
              console.info('[fengzi](send)opposite_port='+oppositeAddr.port)
              console.info('[fengzi](send)this.message='+this.message)
              //通过udp发送this.message文本
//              udp.bind(localAddr)
              this.bindOption()
              udp.send({
                data:this.message,
                address:oppositeAddr
              }).then(data => {
                console.info("[fengzi]send sucess")
                console.info("[fengzi]send"+data)
              }).catch(function(err){
                console.info("[fengzi]send"+JSON.stringify(err))
              })
            }
          })
        }.width('100%').height(70).backgroundColor('#f5f5f5')
      }
      .width('100%').layoutWeight(1)
    }.width('100%')
    .height('100%')
  }
}