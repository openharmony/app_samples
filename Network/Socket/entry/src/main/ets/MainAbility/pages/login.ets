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
import wifi from '@ohos.wifi';
import router from '@system.router';
import { resolveIP } from '../Utils/util'
import socket from '@ohos.net.socket';

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

let udp = socket.constructUDPSocketInstance()

@Entry
@Component
struct Login{
  @State login_feng : boolean = false
  @State login_wen : boolean = false
  @State user : string = ''
  @State roomDialog : boolean = false
  @State confirmDialog : boolean = false
  @State ipDialog:boolean = true
  @State warnDialog : boolean = false
  @State warnText : string = ''
  @State roomNumber : string = ''
  @State receiveMsg : string = ''

  bindOption(){
    let bindOption = udp.bind(localAddr);
    bindOption.then(() => {
      console.log('[fengzi]bind success');
    }).catch(err => {
      console.log('[fengzi]bind fail');
    });
    udp.on('message',data => {
      console.log('[fengzi]data:' + JSON.stringify(data))
      let buffer = data.message
      let dataView = new DataView(buffer)
      console.log('[fengzi] length = ' + dataView.byteLength)
      let str = ""
      for (let i = 0;i < dataView.byteLength; ++i) {
        let c = String.fromCharCode(dataView.getUint8(i))
        if (c != "\n") {
          str += c
        }
      }
      if(str === '确认'){
        router.push({
          uri:'pages/index',
          params: {address: oppositeAddr.address, port: oppositeAddr.port }
        })
      }
      else if(str!=='' && str !== '确认'){
        this.receiveMsg = str
        this.confirmDialog = true
      }
    })
  }

  aboutToAppear(){
    console.log('[fengzi]OboutToAppear 1')
    while (!this.ipDialog) {
      console.log('[fengzi]OboutToAppear 2')
      this.bindOption()
      console.log('[fengzi]OboutToAppear 3')
    }
    console.log('[fengzi]OboutToAppear 4')
  }

  build(){
    Stack({ alignContent: Alignment.Center }){
      Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center,justifyContent:FlexAlign.Start}){
        Text($r('app.string.MainAbility_label'))
          .width('100%').height(50)
          .backgroundColor('#0D9FFB')
          .textAlign(TextAlign.Start)
          .fontSize(25)
          .padding({ left: 10 })
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
        if (!this.ipDialog) {
          Column(){

            Image(this.login_feng ? $r('app.media.fengziOn') : $r('app.media.wenziOn'))
              .width(100)
              .height(100)
              .objectFit(ImageFit.Fill)
            Text('用户名：'+this.user).fontSize(25).margin({top:50})

            Button(){
              Text($r('app.string.create_room')).fontSize(25).fontColor(Color.White)
            }
            .width('150')
            .height(50)
            .margin({top:30})
            .type(ButtonType.Capsule)
            .onClick(()=>{
              this.roomDialog = true
              this.bindOption()
            })
          }.width('90%').margin({top:100})
        }

      }.width('100%').height('100%')
      if(this.confirmDialog){
        Column(){
          Text('确认码：'+this.receiveMsg).fontSize(25)
          Flex({ justifyContent: FlexAlign.SpaceAround }) {
            Button($r('app.string.cancel'))
              .onClick(() => {
                this.confirmDialog = false
              }).backgroundColor(0xffffff).fontColor(Color.Black)
            Button($r('app.string.confirm'))
              .onClick(() => {
                udp.send({
                  data:'确认',
                  address:oppositeAddr
                }).then(function(data){
                  console.info("[fengzi]send"+JSON.stringify(data))
                }).catch(function(err){
                  console.info("[fengzi]send"+JSON.stringify(err))
                })
                router.push({
                  uri:'pages/index',
                  params: {address: oppositeAddr.address, port: oppositeAddr.port }
                })
              }).backgroundColor(0xffffff).fontColor(Color.Red)
          }.margin({ bottom: 10 })
        }.width('80%').height(150).margin({top:'10%'}).backgroundColor(Color.White).border({radius:10,width:3})
      }
      if(this.ipDialog){
        Column(){
          Text('本地IP：'+localAddr.address).fontSize(25).margin({top:10})
          Text('用户：'+this.user).fontSize(20).margin({top:10})
            .bindMenu([{
              value:'风子',
              action:()=>{
                this.user = '风子'
                this.login_feng = true
                this.login_wen = false
                localAddr.port = 8080
                oppositeAddr.port = 9090
              }
                       },
            {
            value:'蚊子',
            action:()=>{
              this.user = '蚊子'
              this.login_wen = true
              this.login_feng = false
              localAddr.port = 9090
              oppositeAddr.port = 8080
            }
            }
            ])
          TextInput({placeholder:'请输入对端ip'})
            .width(200)
            .fontSize(25)
            .margin({top:10})
            .onChange((value:string)=>{
              oppositeAddr.address = value
            })

          if(this.warnDialog){
            Text(this.warnText).fontSize(10).fontColor(Color.Red).margin({top:5})
          }
          Button($r('app.string.confirm')).fontColor(Color.Black).height(30)
            .margin({ bottom: 10 })
            .onClick(() => {
              if (this.user == '') {
                this.warnDialog = true
                this.warnText = '请先选择用户'
              } else if (oppositeAddr.address === '') {
                this.warnDialog = true
                this.warnText = '请先输入对端IP'
              } else {
                this.bindOption()
                this.ipDialog = false
                console.log('[fengzi]对端ip=' + oppositeAddr.address)
                console.log('[fengzi]对端port=' + oppositeAddr.port);
                console.log('[fengzi]本端port=' + localAddr.port);
              }
            }).backgroundColor(0xffffff)
        }.width('80%').height(200).margin({top:'10%'}).backgroundColor(Color.White).border({radius:10,width:3})
      }
      if(this.roomDialog){
        Column() {
          Text($r('app.string.input_roomNumber')).fontSize(25).margin({top:10})
          TextInput()
            .width(100)
            .fontSize(25)
            .margin({top:10})
            .onChange((value:string)=>{
              this.roomNumber = value
            })
          Flex({ justifyContent: FlexAlign.SpaceAround }) {
            Button($r('app.string.cancel'))
              .onClick(() => {
                this.roomDialog = false
              }).backgroundColor(0xffffff).fontColor(Color.Black)
            Button($r('app.string.confirm'))
              .onClick(() => {
                console.info('[fengzi]address='+oppositeAddr.address)
                console.info('[fengzi]port='+oppositeAddr.port)
                /*点击确定后发送房间号，另一端开始监听*/
                this.bindOption()
                udp.send({
                  data:this.roomNumber,
                  address:oppositeAddr
                }).then(function(data){
                  console.info("[fengzi]send"+JSON.stringify(data))
                }).catch(function(err){
                  console.info("[fengzi]send"+JSON.stringify(err))
                })
                this.roomDialog = false
              }).backgroundColor(0xffffff).fontColor(Color.Red)
          }.margin({ bottom: 10 })
        }.width('80%').height(150).margin({top:'10%'}).backgroundColor(Color.White).border({radius:10,width:3})
      }
    }
  }
}