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
import router from '@system.router';
import { readFile, writeFile } from './switchControl'

@Entry
@Component
struct SwitchPage {
  //5000类按钮
  @State fiveThousandBtn: string = 'true'
  //5000类左边距
  @State fiveThousandNum: number = 1
  //5000类背景色
  @State fiveThousandColor: string = "#f0f0f0"
  //500类按钮
  @State fiveHundredBtn: string = 'true'
  //500类左边距
  @State fiveHundredNum: number = 1
  //500类背景色
  @State fiveHundredColor: string = "#f0f0f0"
  //线程按钮
  @State workerBtn: string = 'true'
  //线程左边距
  @State workerNum: number = 1
  //线程背景色
  @State workerColor: string = "#f0f0f0"

  private aboutToAppear(): void{
    this.pageStart()
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
        Row() {
          Image('/resources/images/left.png')
            .height(30)
            .width(30)
        }
        .width("10%")
        .onClick(() => {
          router.back()
        })

        Text("负载开关")
          .fontWeight(FontWeight.Bold)
          .fontSize(18)
        Row() {
          Text('   ')
            .fontWeight(FontWeight.Bold)
            .fontSize(18)
        }
        .width('10%')
      }
      .width('100%')
      .padding({ top: 20, bottom: 20, left: 10, right: 10 })
      .backgroundColor("#f5f5f5")
      //5000类处理
      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
          Text('启动加载5000类')
            .fontSize(16)
          Row() {
            Button()
              .width(28)
              .height(28)
              .backgroundColor('#ffffff')
              .borderRadius(14)
              .margin({ left: this.fiveThousandNum })
          }
          .width(60)
          .height(30)
          .backgroundColor(this.fiveThousandColor)
          .borderRadius(15)
          .onClick(() => {
            this.fiveThousandBtn = this.fiveThousandBtn === 'true' ? 'false' : 'true'
            console.log("onClick  " + this.fiveThousandBtn)
            writeFile({ key: "fiveThousand", val: this.fiveThousandBtn })
            if (this.fiveThousandBtn == "false" || this.fiveThousandBtn == 'default') { //第一次读值时会赋值给变量 “default”
              this.fiveThousandColor = "#f0f0f0"
              this.fiveThousandNum = 1
            } else {
              this.fiveThousandColor = "#00cc33"
              this.fiveThousandNum = 31
            }
          })
        }
      }
      .margin({ top: 5 })
      //500类处理
      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
          Text('启动加载500类')
            .fontSize(16)
          Row() {
            Button()
              .width(28)
              .height(28)
              .backgroundColor('#ffffff')
              .borderRadius(14)
              .margin({ left: this.fiveHundredNum })
          }
          .width(60)
          .height(30)
          .backgroundColor(this.fiveHundredColor)
          .borderRadius(15)
          .onClick(() => {
            this.fiveHundredBtn = this.fiveHundredBtn === 'true' ? 'false' : 'true'
            console.log("onClick  " + this.fiveHundredBtn)
            writeFile({ key: "fiveHundred", val: this.fiveHundredBtn })
            if (this.fiveHundredBtn == "false" || this.fiveHundredBtn == 'default') { //第一次读值时会赋值给变量 “default”
              this.fiveHundredColor = "#f0f0f0"
              this.fiveHundredNum = 1
            } else {
              this.fiveHundredColor = "#00cc33"
              this.fiveHundredNum = 31
            }
          })
        }
      }
      .margin({ top: 5 })
      //线程处理
      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
          Text('启动加载线程')
            .fontSize(16)
          Row() {
            Button()
              .width(28)
              .height(28)
              .backgroundColor('#ffffff')
              .borderRadius(14)
              .margin({ left: this.workerNum })
          }
          .width(60)
          .height(30)
          .backgroundColor(this.workerColor)
          .borderRadius(15)
          .onClick(() => {
            this.workerBtn = this.workerBtn === 'true' ? 'false' : 'true'
            console.log("onClick  " + this.workerBtn)
            writeFile({ key: "worker", val: this.workerBtn })
            if (this.workerBtn == "false" || this.workerBtn == 'default') { //第一次读值时会赋值给变量 “default”
              this.workerColor = "#f0f0f0"
              this.workerNum = 1
            } else {
              this.workerColor = "#00cc33"
              this.workerNum = 31
            }
          })
        }
      }
      .margin({ top: 5 })
    }
    .height('100%')
    .width('100%')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
  // 获取按钮当前状态
  public pageStart() {
    console.log("1")
    readFile("fiveThousand").then((value) => {
      this.fiveThousandBtn = value.toString()
      if (this.fiveThousandBtn == "true") {
        this.fiveThousandNum = 31
        this.fiveThousandColor = '#00cc33'
      } else {
        this.fiveThousandNum = 1
        this.fiveThousandColor = '#f0f0f0'
      }
    })

    readFile("fiveHundred").then((value) => {
      this.fiveHundredBtn = value.toString()
      if (this.fiveHundredBtn == "true") {
        this.fiveHundredNum = 31
        this.fiveHundredColor = '#00cc33'
      } else {
        this.fiveHundredNum = 1
        this.fiveHundredColor = '#f0f0f0'
      }
    })
    readFile("worker").then((value) => {
      this.workerBtn = value.toString()
      if (this.workerBtn == "true") {
        this.workerNum = 31
        this.workerColor = '#00cc33'
      } else {
        this.workerNum = 1
        this.workerColor = '#f0f0f0'
      }
    })
  }
}