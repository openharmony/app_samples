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
import { Browser } from '../model/Browser'
import { WebTab } from './Titlebar'
import Logger from '../model/Logger'

const TAG: string = '[PhoneLayout]'
const BUTTON_WIDTH: number = 22
const BUTTON_RADIUS: number = 4
const DOWN_COLOR: string = '#e4e4e4'
const UP_COLOR: string = '#00000000'

@Component
export struct PhoneLayout {
  @Link browser: Browser;
  @State isPhone: boolean = true;
  @State hasDown: boolean = false;
  @State pageCount: string = '1';
  @State arrayIndex: number = 0;
  private addr: string = ''
  private toolPoneArray: Array<{
    imageSrc: Resource,
    id: number
  }> = [
    {
      imageSrc: $r('app.media.ic_public_back'),
      id: 1
    },
    {
      imageSrc: $r('app.media.ic_public_advance'),
      id: 2
    },
    {
      imageSrc: $r('app.media.ic_public_home'),
      id: 5
    },
    {
      imageSrc: $r('app.media.ic_public_refresh'),
      id: 3
    }
  ]

  @Builder ToolBar() {
    Column() {
      Progress({ value: this.browser.progress, total: 100 })
        .color('#0000ff')
        .visibility(this.browser.hideProgress ? Visibility.None : Visibility.Visible)
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        ForEach(this.toolPoneArray, item => {
          Column() {
            Divider().color('#e9eaec')
            Button({ type: ButtonType.Normal }) {
              Column() {
                if (item.id !== 4) {
                  Image(item.imageSrc)
                } else {
                  Column() {
                    Text(this.pageCount)
                      .fontSize(16)
                  }
                  .border({ width: 2 })
                  .width(22)
                  .height(22)
                  .borderRadius(5)
                  .justifyContent(FlexAlign.Center)
                }
              }
              .width(BUTTON_WIDTH)
              .height(BUTTON_WIDTH)
              .justifyContent(FlexAlign.Center)
            }
            .height('100%')
            .width('100%')
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
                case 5:
                  this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl({
                    url: $rawfile('phone.html')
                  })
                  break;
                default:
                  break;
              }
            })
          }
          .width('20%')
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fdfdfd')
    }.height('100%')
  }

  build() {
    Navigation() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '输入网址...', text: this.browser.inputValue })
            .placeholderFont({ size: 16, weight: 500 })
            .fontSize(16)
            .margin(2)
            .height(30)
            .onChange((value: string) => {
              Logger.info(TAG, `onChange`)
              this.addr = value
            })
            .onSubmit((enterKey: EnterKeyType) => {
              Logger.info(TAG, `onSubmit`)
              this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl({
                url: `https://${this.addr}`
              })
              this.addr = ''
            })
          Button({ type: ButtonType.Normal }) {
            Image($r('app.media.submit'))
          }
          .margin(8)
          .width(BUTTON_WIDTH)
          .height(BUTTON_WIDTH)
          .backgroundColor(this.hasDown ? DOWN_COLOR : UP_COLOR)
          .borderRadius(BUTTON_RADIUS)
          .flexShrink(0)
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.hasDown = true
            } else if (event.type === TouchType.Up) {
              this.hasDown = false
            }
          })
          .onClick((event: ClickEvent) => {
            this.browser.loadUrl(this.addr)
            this.addr = ''
          })
        }

        WebTab({ browser: $browser, isPhone: $isPhone })
      }
    }
    .hideTitleBar(true)
    .toolBar(this.ToolBar) //待手机验证
    .hideBackButton(true)
  }
}