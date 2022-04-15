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

import { NavigationBar } from "../../../common/components/navigationBar"
import mediaquery from '@ohos.mediaquery'
import http from '@ohos.net.http'

const ButtonWidth: number = 22
const ButtonRadius: number = 4
const downColor: string = "#e4e4e4"
const upColor: string = "#00000000"
const phoneUserAgent: string = "Mozilla/5.0 (Linux; Android 9; VRD-AL10; HMSCore 6.3.0.331) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.105 HuaweiBrowser/12.0.4.1 Mobile Safari/537.36"
const padUserAgent: string = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.105 Safari/537.36"


class WebObject {
  controller:WebController;
  isRegistered:boolean;

  constructor(controller:WebController, isRegistered:boolean) {
    this.controller = controller
    this.isRegistered = isRegistered
  }
}

@Entry
@Component
struct Browser {
  @State isPhone: boolean = false;
  @State arrayIndex: number = 0;
  @State array1Index: number = 0;
  @State pageCount: string = "1"
  @State progress:number = 0;
  @State hideProgress:boolean = true;
  @State tabArrayIndex:number = 0;
  @State webArray:Array<number> = [0]  //浏览器内容区域数组
  @State tabButtonIndex : number = -1
  @State hasDown:boolean = false
  @State inputValue:string = ""
  isRegistered:boolean = false
  listener = mediaquery.matchMediaSync('(orientation: landscape)')
  controller: WebController = new WebController();
  tabsController: TabsController = new TabsController()

  private buttonArray1: Array<Object> = [
    {
      imageSrc: $r('app.media.ic_public_back'),
      id: 1
    },
    {
      imageSrc: $r('app.media.ic_public_advance'),
      id: 2
    },
    {
      imageSrc: $r('app.media.ic_public_refresh'),
      id: 3
    },
    {
      imageSrc: $r('app.media.ic_public_home1'),
      id: 4
    },
  ]
  private buttonArray2: Array<Object> = [
    {
      imageSrc: $r('app.media.submit'),
      id: 5
    },
    {
      imageSrc: $r('app.media.ic_public_add1'),
      id: 6
    },
  ]
  private toolPoneArray: Array<Object> = [
    {
      imageSrc: $r('app.media.ic_public_back'),
      id: 1
    },
    {
      imageSrc: $r('app.media.ic_public_advance'),
      id: 2
    },
    {
      imageSrc: $r('app.media.ic_public_home1'),
      id: 5
    },
    {
      imageSrc: $r('app.media.ic_public_refresh'),
      id: 3
    },
    {
      id: 4
    },
  ]
  private webControllerArray: Array<WebObject> = [new WebObject(this.controller, false)]

  testObj = {
    test: (addr) => {

      this.webControllerArray[this.tabArrayIndex].controller.loadUrl({ url: "https://www.baidu.com"})
    },
    isPhone:()=>{
      return this.isPhone;
    }
  }


  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }){
      Row(){
        NavigationBar({ title: 'web' })
      }
      .padding({ left: '3%', right: '3%', bottom: 10 })
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        if (!this.isPhone) {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            ForEach(this.buttonArray1, item => {
              Button({ type: ButtonType.Normal }) {
                Image(item.imageSrc)
              }
              .margin(8)
              .width(ButtonWidth)
              .height(ButtonWidth)
              .backgroundColor(this.array1Index == item.id ? downColor : upColor)
              .borderRadius(ButtonRadius)
              .flexShrink(0)
              .onTouch((event: TouchEvent) => {
                if (event.type == TouchType.Down) {
                  this.array1Index = item.id
                }

                if (event.type == TouchType.Up) {
                  this.array1Index = 0
                }
              })
              .onClick((event: ClickEvent) => {
                switch (item.id) {
                  case 1:
                    this.Back()
                    break;
                  case 2:
                    this.Forward()
                    break;
                  case 3:
                    this.Refresh()
                    break;
                  case 4:
                    this.webControllerArray[this.tabArrayIndex].controller.loadUrl({ url: "https://www.baidu.com/" })
                    break;
                }
              })
            }, item => item.id)
            TextInput({ placeholder: '输入网址...', text: this.inputValue})
              .placeholderFont({ size: 18, weight: 500 })
              .fontSize(18)
              .margin(2)
              .onChange((value: string) => {

                this.inputValue = value
              })
              .onSubmit((enterKey: EnterKeyType) => {
                this.controller.loadUrl({url: this.inputValue})
              })
            //        跳转按钮和添加标签按钮
            ForEach(this.buttonArray2, item => {
              Button({ type: ButtonType.Normal }) {
                Image(item.imageSrc)
              }
              .margin(8)
              .width(ButtonWidth)
              .height(ButtonWidth)
              .backgroundColor(this.array1Index == item.id ? downColor : upColor)
              .borderRadius(ButtonRadius)
              .flexShrink(0)
              //            屏幕触摸事件，控制两个按钮按下和松开的颜色
              .onTouch((event: TouchEvent) => {
                if (event.type == TouchType.Down) {
                  this.array1Index = item.id
                }

                if (event.type == TouchType.Up) {
                  this.array1Index = 0
                }
              })
              //            点击事件
              .onClick((event: ClickEvent) => {
                //              点击增加标签按钮
                if (item.id == 6) {
                  let webController: WebController = new WebController();
                  let object = new WebObject(webController, false)
                  this.webControllerArray.push(object)
                  this.webArray.push(this.webArray.length)
                  this.tabArrayIndex = this.webArray[this.webArray.length - 1]
                  this.tabsController.changeIndex(this.tabArrayIndex)
                }
                //              点击跳转按钮
                if (item.id == 5) {
                  let addr: string = "https://" + this.inputValue
                  this.webControllerArray[this.tabArrayIndex].controller.loadUrl({url:  addr})
                }
              })
            }, item => item.id)
          }
          .width('100%')
          .padding({ right: 5 })

          Progress({ value: this.progress, total: 100 })
            .color('#0000ff')
            .visibility(this.hideProgress ? Visibility.None : Visibility.Visible)
          //      标签框
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start }) {
            ForEach(this.webArray, item => {
              Row() {
                Row() {
                  Text('主页')
                }.width('100%').flexShrink(1).justifyContent(FlexAlign.Center).height('100%')
                //              删除标签框按钮
                Button({ type: ButtonType.Normal }) {
                  Image($r('app.media.ic_public_cancel_filled')).width(12).height(12)
                }
                .backgroundColor(this.tabButtonIndex == item ? downColor : '#00000000')
                .margin({ right: 2 })
                .width(33)
                .height(33)
                .borderRadius(5)
                .onTouch((event: TouchEvent) => {
                  if (event.type == TouchType.Down) {
                    this.tabButtonIndex = item
                  }
                  if (event.type == TouchType.Up) {
                    this.tabButtonIndex = -1
                  }
                })
                .onClick((event: ClickEvent) => {
                  if (this.webArray.length > 1) {
                    this.deleteTab()
                    this.tabsController.changeIndex(this.tabArrayIndex)
                  }
                })
              }.width(180).height('100%').backgroundColor(this.tabArrayIndex == item ? '#ffffff' : '#ececec')
              .onClick((event: ClickEvent) => {
                this.tabArrayIndex = item
                this.tabsController.changeIndex(this.tabArrayIndex)
              })

              Divider().vertical(true).color('#c6c6c6')
            })
          }.height(33).flexShrink(0).backgroundColor('#ececec')
          //        Button('点击')

          Divider().color('#c6c6c6').width('100%').flexShrink(0)

          //        html内容展示区，Tabs组件做容器，ForEach循环遍历webArray，TabContent做内容切换
          Tabs({ barPosition: BarPosition.Start, controller: this.tabsController }) {
            ForEach(this.webArray, item => {
              TabContent() {
                Web({ src: $rawfile('index2.html'), controller: this.webControllerArray[this.tabArrayIndex].controller })
                  .javaScriptAccess(true)    //设置是否允许执行JavaScript脚本，默认允许执行
                  .fileAccess(true)          //设置是否开启Web中通过FILE方式访问应用中的本地文件， 默认启用。
                  .userAgent(this.isPhone ? phoneUserAgent : padUserAgent)
                  .onPageEnd(e => {
                    // test() 在 index.html 中已定义
                    this.controller.runJavaScript({script: 'test()'});
                  })
                  .onProgressChange((event) => {
                    this.progress = event.newProgress
                    if (this.progress == 100) {
                      this.hideProgress = true
                    } else {
                      this.hideProgress = false
                    }
                  })
              }
            })
          }
          .barHeight(0)
          .scrollable(false)
        }else {
          Navigation() {
            Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
              Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
                TextInput({ placeholder: '输入网址...' })
                  .placeholderFont({ size: 18, weight: 500 })
                  .fontSize(18)
                  .margin(2)
                  .onChange((value: string) => {
                    this.inputValue = value

                  })
                  .onSubmit((enterKey: EnterKeyType) => {
                    this.controller.loadUrl({url: this.inputValue})
                  })
                Button({ type: ButtonType.Normal }) {
                  Image($r('app.media.submit'))
                }
                .margin(8)
                .width(ButtonWidth)
                .height(ButtonWidth)
                .backgroundColor(this.hasDown ? downColor : upColor)
                .borderRadius(ButtonRadius)
                .flexShrink(0)
                .onTouch((event: TouchEvent) => {
                  if (event.type == TouchType.Down) {
                    this.hasDown = true
                  }

                  if (event.type == TouchType.Up) {
                    this.hasDown = false
                  }
                })
                .onClick((event: ClickEvent) => {
                  console.info("jyj input value " + this.inputValue)
                  let addr: string = "https://" + this.inputValue
                  this.webControllerArray[this.tabArrayIndex].controller.loadUrl({ url: addr })
                })

              }
              Tabs({ barPosition: BarPosition.Start, controller: this.tabsController }) {
                ForEach(this.webArray, item => {
                  TabContent() {
                    Web({ src: $rawfile('index.html'), controller: this.webControllerArray[this.tabArrayIndex].controller })
                      .javaScriptAccess(true)
                      .fileAccess(true)
                      .userAgent(this.isPhone ? phoneUserAgent : padUserAgent)
                      .onPageEnd((event) => {

                        this.controller.runJavaScript({script: 'test()'});
                      })
                      .onProgressChange((event) => {
                        this.progress = event.newProgress
                        if (this.progress == 100) {
                          this.hideProgress = true
                        } else {
                          this.hideProgress = false
                        }
                      })
                  }
                })
              }
              .barHeight(0)
              .scrollable(false)
            }
          }
          .hideTitleBar(true)
          .hideBackButton(true)
        }
      }
    }

  }
  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }

  aboutToAppear() {
    //    this.HttpRequest()
    this.listener.on('change', this.orientationCallback.bind(this))
  }

  orientationCallback(result) {
    if (result.matches) {
      this.isPhone = false
    } else {
      this.isPhone = true
    }
  }

  Back() {

    if (this.webControllerArray[this.tabArrayIndex].controller.accessBackward()) {
      this.webControllerArray[this.tabArrayIndex].controller.backward()
    }
  }

  Forward() {

    if (this.webControllerArray[this.tabArrayIndex].controller.accessForward()) {
      this.webControllerArray[this.tabArrayIndex].controller.forward()
    }
  }

  Refresh() {
    this.webControllerArray[this.tabArrayIndex].controller.refresh()
  }


  onBackPress():boolean {

    if (this.webControllerArray[this.tabArrayIndex].controller.accessBackward()) {
      this.webControllerArray[this.tabArrayIndex].controller.backward()
      return true
    }
    return false
  }

  deleteTab() {
    this.webArray.splice(this.tabArrayIndex, 1);
    this.webControllerArray.splice(this.tabArrayIndex, 1)

    if (this.tabArrayIndex == this.webArray.length) {
      this.tabArrayIndex -= 1;
      return
    }
    for (let i = this.tabArrayIndex; i < this.webArray.length; ++i) {
      this.webArray[i] -= 1
    }
  }

  registerFunc() {

    if (!this.webControllerArray[this.tabArrayIndex].isRegistered) {

      this.webControllerArray[this.tabArrayIndex].isRegistered = true
      this.webControllerArray[this.tabArrayIndex].controller.registerJavaScriptProxy({
        //        注入ArkUI对象到HTML中，并在HTML中调用该对象的方法，参数不支持更新。
        object: this.testObj,                 //      -obj: 参与注册的对象。
        name: "etsObj",                    //      -name: 注册对象的名称，与HTML中调用的对象名一致。
        methodList: ["test", "isPhone"]    //      -methodList: 参与注册的方法。
        //      -controller: 控制器。
      })
      this.webControllerArray[this.tabArrayIndex].controller.refresh();
    }
  }
}
