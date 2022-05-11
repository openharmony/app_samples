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
import { Browser, LoadingStatus, WebObject } from '../model/browser'
import Logger from '../model/logger'

const TAG: string = '[titleBar]'
const BUTTON_WIDTH: number = 22
const BUTTON_RADIUS: number = 4
const DOWN_COLOR: string = '#e4e4e4'
const UP_COLOR: string = '#00000000'
const PAD_USER_AGENT: string = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTMl, like Gecko) Chrome/92.0.4515.105 Safari/537.36'
const PHONE_USER_AGENT: string = 'Mozilla/5.0 (Linux; Android 9; VRD-AL10; HMSCore 6.3.0.331) AppleWebKit/537.36 (KHTMl, like Gecko) Chrome/92.0.4515.105 HuaweiBrowser/12.0.4.1 Mobile Safari/537.36'

@Component
export struct TabletTitle {
  @Link browser: Browser;
  @State inputValue: string = ''
  @State arrayIndex: number = 0
  private addr: string = ''
  private navigationButton: Array<{imageSrc: Resource, id:number}> = [
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
      imageSrc: $r('app.media.ic_public_home'),
      id: 4
    },
  ]
  private actionButton: Array<{imageSrc: Resource, id:number}> = [
    {
      imageSrc: $r('app.media.submit'),
      id: 5
    },
    {
      imageSrc: $r('app.media.ic_public_add'),
      id: 6
    },
  ]

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      ForEach(this.navigationButton, item => {
        Button({ type: ButtonType.Normal }) {
          Image(item.imageSrc)
        }
        .margin(8)
        .width(BUTTON_WIDTH)
        .height(BUTTON_WIDTH)
        .backgroundColor(this.arrayIndex === item.id ? DOWN_COLOR : UP_COLOR)
        .borderRadius(BUTTON_RADIUS)
        .flexShrink(0)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.arrayIndex = item.id
          }

          if (event.type === TouchType.Up) {
            this.arrayIndex = 0
          }
        })
        .onClick((event: ClickEvent) => {
          switch (item.id) {
            case 1:
              this.browser.Back()
              break;
            case 2:
              this.browser.Forward()
              break;
            case 3:
              this.browser.Refresh()
              break;
            case 4:
              this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl({
                url: $rawfile('pad.html')
              })
              break;
          }
        })
      }, item => item.id)

      TextInput({ placeholder: '输入网址...', text: this.browser.inputValue })
        .placeholderFont({ size: 18, weight: 500 })
        .fontSize(18)
        .margin(2)
        .onChange((value: string) => {
          this.addr = value
        })
        .onSubmit((enterKey: EnterKeyType) => {
          Logger.info(TAG, `onSubmit`)
          if (this.addr.length !== 0) {
            this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl({
              url: `https://${this.addr}`
            })
            this.addr = ''
          }
        })

      ForEach(this.actionButton, item => {
        Button({ type: ButtonType.Normal }) {
          Image(item.imageSrc)
        }
        .margin(8)
        .width(BUTTON_WIDTH)
        .height(BUTTON_WIDTH)
        .backgroundColor(this.arrayIndex === item.id ? DOWN_COLOR : UP_COLOR)
        .borderRadius(BUTTON_RADIUS)
        .flexShrink(0)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.arrayIndex = item.id
          } else if (event.type === TouchType.Up) {
            this.arrayIndex = 0
          }
        })
        .onClick((event: ClickEvent) => {
          if (this.arrayIndex === 5) {
            this.browser.loadUrl(this.addr)
            this.addr = ''
          } else if (this.arrayIndex === 6) {
            Logger.info(TAG, `add tab`)
            this.browser.addTab()
          }
        })
      }, item => item.id)
    }
    .width('100%')
    .padding({ right: 5 })
  }
}

@Component
export struct BrowserTabs {
  @Link browser: Browser;
  @State tabButtonIndex: number = -1;

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start }) {
      ForEach(this.browser.webArray, item => {
        Row() {
          Row() {
            Text('主页')
          }.width('100%').flexShrink(1).justifyContent(FlexAlign.Center).height('100%')

          Button({ type: ButtonType.Normal }) {
            Image($r('app.media.ic_public_cancel_filled')).width(24).height(24)
          }
          .backgroundColor(this.tabButtonIndex == item.key ? DOWN_COLOR : '#00000000')
          .margin({ right: 2 })
          .width(33)
          .height(33)
          .borderRadius(5)
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.tabButtonIndex = item.key
            } else if (event.type == TouchType.Up) {
              this.tabButtonIndex = -1
            }
          })
          .onClick((event: ClickEvent) => {
            if (this.browser.webArray.length > 1) {
              this.browser.deleteTab(this.tabButtonIndex)
            }
          })
        }.width(180).height('100%').backgroundColor(this.browser.tabArrayIndex == item.key ? '#ffffff' : '#ececec')
        .onClick((event: ClickEvent) => {
          Logger.info(TAG, `key= ${item.key}`)
          this.browser.setTabArrayIndex(item.key)
          this.browser.tabsController.changeIndex(item.key)
        })

        Divider().vertical(true).color('#c6c6c6')
      }, item => item.timestamp.toString())
    }.height(33).flexShrink(0).backgroundColor('#ececec')
  }
}

@Component
export struct WebTab {
  @Link browser: Browser;
  @Link isPhone: boolean;
  isRegistered: boolean = false
  testObj = {
    test: (addr) => {
      Logger.info(TAG, `addr= ${this.browser.tabArrayIndex}`)
      this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl({ url: `https://${addr}`})
    },
    searchWord: (word: string) => {
      Logger.info(`search word= ${word}`)
      let code = globalThis.encodeURI(word)
      this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl({
        url: `https://www.bing.com/search?q=${code}`
      })
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.Start, controller: this.browser.tabsController }) {
      ForEach(this.browser.webArray, item => {
        TabContent() {
          Web({
            src: this.isPhone ? $rawfile('phone.html') : $rawfile('pad.html'),
            controller: this.browser.webControllerArray[item.key].controller
          })
            .javaScriptAccess(true)
            .fileAccess(true)
            .userAgent(this.isPhone ? PHONE_USER_AGENT : PAD_USER_AGENT)
            .onPageBegin((event) => {
              Logger.info(TAG, `onPageBegin= ${JSON.stringify(event)}`)
              this.browser.loadingStatus = LoadingStatus.LOADING
            })
            .onPageEnd((event) => {
              Logger.info(TAG, `onPageEnd= ${JSON.stringify(event)}`)
              this.browser.webControllerArray[item.key].controller.runJavaScript({ script: 'adapterDevice()' })
              this.browser.loadingStatus = LoadingStatus.END
              this.registerFunc(this.browser.webControllerArray[item.key])
              if (event.url.startsWith('http')) {
                this.browser.inputValue = event.url
              } else {
                this.browser.inputValue = ''
              }
            })
            .onProgressChange((event) => {
              Logger.info(TAG, `onProgressChange`)
              this.browser.progress = event.newProgress
              if (this.browser.progress === 100) {
                this.browser.hideProgress = true
              } else {
                this.browser.hideProgress = false
              }
            })
        }
      }, item => item.timestamp.toString())
    }
    .barHeight(0)
    .scrollable(false)
  }

  registerFunc(webObject: WebObject) {
    if (!webObject.isRegistered) {
      Logger.info(TAG, `registerFunc`)
      webObject.controller.registerJavaScriptProxy({
        object: this.testObj, name: 'etsObj', methodList: ['test', 'searchWord']
      })
      webObject.isRegistered = true
      webObject.controller.refresh()
    }
  }
}