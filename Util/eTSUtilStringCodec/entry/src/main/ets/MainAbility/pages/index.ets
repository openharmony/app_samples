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

import util from '@ohos.util'
import { SpecInput } from '../common/specInput.ets'
import { ErrInput } from '../common/errInput.ets'

var resArray

@Entry
@Component
struct StrCodec {

  @State specStrInput_f: string = ''
  @State SpecStrInput_s: string = ''
  @State SpecStrInput_d: string = ''
  @State SpecStrInput_i: string = ''


  @State err_res01:string = ''
  @State err_res02:string = ''
  @State err_res03:string = ''
  @State err_res04:string = ''
  @State err_res05:string = ''

  @State resen:string =''
  @State resdec:string =''
  @State read:string =''
  @State write:string =''

  build() {

    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.StringCodec_title'))
        .width('100%')
        .height(50)
        .backgroundColor("#0D9FFB")
        .textAlign(TextAlign.Start)
        .fontSize(25)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .padding({left:20,top:10})
      Scroll(){
        Column(){
          Row(){
            Text($r('app.string.SpecString'))
              .fontSize(15)
              .width(60)
              .height(50)
              .margin({top:20 })
              .textAlign(TextAlign.Start)
            Text($r('app.string.SpecString_info'))
              .fontSize(15)
              .width(200)
              .height(50)
              .margin({left:5,top:20 })
              .textAlign(TextAlign.Start)
          }
          SpecInput({result_str:$r('app.string.result_f'),specStrInput: this.specStrInput_f})
          SpecInput({result_str:$r('app.string.result_i'),specStrInput: this.SpecStrInput_i})
          SpecInput({result_str:$r('app.string.result_d'),specStrInput: this.SpecStrInput_d})
          SpecInput({result_str:$r('app.string.result_s'),specStrInput: this.SpecStrInput_s})
          Button(){
            Text($r('app.string.SpecFormOutput')).fontSize(15).fontWeight(FontWeight.Bold).fontColor(Color.White)
          }
          .width(300)
          .margin({ top: 20 })
          .onClick(() => {
            this.specStrInput_f = util.printf("%f", "HarmonyOS 3.0");
            this.SpecStrInput_i = util.printf("%i", "HarmonyOS 3.0");
            this.SpecStrInput_d = util.printf("%d", "HarmonyOS 3.0");
            this.SpecStrInput_s = util.printf("%s", "HarmonyOS 3.0");
          })
          .backgroundColor("#0D9FFB")


          Text('').width('100%').height(10).backgroundColor("#0D9FFB").margin({top:20}).border({width:2,color:"#0D9FFB"})

          ErrInput({result_err: $r("app.string.num1"),errStrInput:this.err_res01})
          ErrInput({result_err: $r("app.string.num2"),errStrInput:this.err_res02})
          ErrInput({result_err: $r("app.string.num3"),errStrInput:this.err_res03})
          ErrInput({result_err: $r("app.string.num4"),errStrInput:this.err_res04})
          ErrInput({result_err: $r("app.string.num5"),errStrInput:this.err_res05})

          Button(){
            Text($r('app.string.getErrorInfo')).fontColor(Color.White).fontSize(15).fontWeight(FontWeight.Bold)
          }
          .margin({ top: 20 })
          .onClick(() => {
            var errnum_01 = 10;
            var errnum_02 = 20;
            var errnum_03 = 100;
            var errnum_04 = -10;
            var errnum_05 = 1000;
            this.err_res01 = util.getErrorString(errnum_01);
            this.err_res02 = util.getErrorString(errnum_02);
            this.err_res03 = util.getErrorString(errnum_03);
            this.err_res04 = util.getErrorString(errnum_04);
            this.err_res05 = util.getErrorString(errnum_05);
          })
          .backgroundColor("#0D9FFB")
          .width(300)

          Text('').width('100%').height(10).backgroundColor("#0D9FFB").margin({top:20}).border({width:2,color:"#0D9FFB"})

          Row(){
            Text($r('app.string.SpecString'))
              .fontSize(15)
              .width(60)
              .height(50)
              .margin({top:20 })
              .textAlign(TextAlign.Start)
            Text($r('app.string.StringCodec_info'))
              .fontSize(15)
              .width(240)
              .height(50)
              .margin({left:5,top:20 })
              .textAlign(TextAlign.Start)
          }
          Row() {
            Text($r('app.string.result')).width('20%').height(30).fontSize(15).textAlign(TextAlign.Start)
            Text(this.resen)
              .width('80%')
              .height(60)
              .fontSize(15)
              .maxLines(2)
              .textAlign(TextAlign.Start)
              .border({width:2,radius:5,color:"#0D9FFB"})
          }.margin({ top: 20 }).width(300)
          Row() {
            Text($r('app.string.read')).width('20%').height(30).fontSize(15).textAlign(TextAlign.Start)
            Text(this.read)
              .width('30%')
              .height(30)
              .fontSize(15)
              .textAlign(TextAlign.Start)
              .border({width:2,radius:5,color:"#0D9FFB"})
            Text($r('app.string.write')).width('20%').height(30).fontSize(15).textAlign(TextAlign.Center)
            Text(this.write)
              .width('30%')
              .height(30)
              .fontSize(15)
              .textAlign(TextAlign.Start)
              .border({width:2,radius:5,color:"#0D9FFB"})
          }.margin({ top: 20 }).width(300)

          Button(){
            Text($r('app.string.Text_encoder')).fontColor(Color.White).fontSize(15).fontWeight(FontWeight.Bold)
          }
          .margin({ top: 20 })
          .onClick(() => {
            var textEncoder = new  util.TextEncoder()
            var buffer = new ArrayBuffer(100)
            resArray = new Uint8Array(buffer);
            resArray = textEncoder.encode("HarmonyOS 3.0，未来有迹可循！");
            var resArratNum = textEncoder.encodeInto("HarmonyOS 3.0，未来有迹可循！", resArray)
            this.resen = resArray.toString();
            this.read = JSON.stringify(resArratNum.read)
            this.write = JSON.stringify(resArratNum. written)
          })
          .backgroundColor("#0D9FFB")
          .width(300)

          Row() {
            Text($r('app.string.result')).width('20%').height(30).fontSize(15).textAlign(TextAlign.Start).fontColor(Color.Black)
            Text(this.resdec)
              .width('80%')
              .height(60)
              .fontSize(15)
              .textAlign(TextAlign.Start)
              .maxLines(2)
              .border({width:2,radius:5,color:"#0D9FFB"})
          }.margin({ top: 20 }).width(300)

          Button(){
            Text($r('app.string.Text_decoder')).fontColor(Color.White).fontSize(15).fontWeight(FontWeight.Bold)
          }
          .margin({ top: 20,bottom:50 })
          .onClick(() => {
            var textDecoder = new util.TextDecoder("utf-8",{ignoreBOM:true});
            var retStr = textDecoder.decode( resArray  , {stream:false});
            this.resdec = retStr;
          })
          .backgroundColor("#0D9FFB")
          .width(300)
        }
      }
    }
  }
}