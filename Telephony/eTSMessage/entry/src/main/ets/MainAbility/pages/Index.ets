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

import router from '@system.router'
import Contact from '../model/Contact'
import HiLog from '../model/HiLogUtil'
import { grantPermission } from '../model/PermissionUtils'
import { TitleBar } from '../common/TitleBar'

const TAG = '[Index]'

@Extend(Text) function fancyText (width: string, textAlign: number) {
  .width(width)
  .fontSize(20)
  .textAlign(textAlign)
}

@Extend(TextInput) function fancyInput () {
  .width('60%')
  .fontSize(20)
  .maxLength(20)
  .fontWeight(FontWeight.Bold)
}

@Entry
@Component
struct Index {
  @State editable: boolean = false
  @State name: string = 'zhangsan'
  @State destinationHost: string= '18712345678'
  @State contacts: Array<Contact> = []
  @State deleteContact: Resource = $r('app.string.delete')

  aboutToAppear() {
    grantPermission()
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar()
      Row() {
        Text($r('app.string.full_name'))
          .fancyText('30%', TextAlign.Center)
        TextInput({ placeholder: $r('app.string.full_name') })
          .fancyInput()
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .onChange((value: string) => {
            this.name = value
          })
      }
      .height(60)
      .margin({ top: 10 })

      Row() {
        Text($r('app.string.telephone'))
          .fancyText('30%', TextAlign.Center)
        TextInput({ placeholder: $r('app.string.telephone') })
          .fancyInput()
          .type(InputType.Number)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .onChange((value: string) => {
            this.destinationHost = value
          })
      }
      .height(60)

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button() {
          Text($r('app.string.save'))
            .fancyText('40%', TextAlign.Center)
            .fontColor(Color.White)
        }
        .height(40)
        .type(ButtonType.Capsule)
        .backgroundColor('#0D9FFB')
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          if (this.name == '' || this.destinationHost == '') {
            AlertDialog.show(
              {
                title: $r('app.string.title_dialog'),
                message: $r('app.string.message_dialog'),
                confirm: {
                  value: $r('app.string.value_dialog'),
                  action: () => {
                    HiLog.info(TAG, `AlertDialog confirm`)
                  }
                },
                cancel: () => {
                  HiLog.info(TAG, `AlertDialog cancel`)
                }
              }
            )
          } else {
            this.contacts.unshift(new Contact(this.name, this.destinationHost))
            HiLog.info(TAG, `onClick-save contacts = ${JSON.stringify(this.contacts)}`)
          }
        })
      }

      Column() {
        Button() {
          Text(this.deleteContact)
            .fancyText('40%', TextAlign.Center)
            .fontColor(Color.White)
        }
        .height(40)
        .type(ButtonType.Capsule)
        .backgroundColor('#0D9FFB')
        .margin({ top: 10, bottom: 10 })
        .onClick(() => {
          this.editable = !this.editable
          if (this.editable) {
            this.deleteContact = $r('app.string.cancel')
          } else {
            this.deleteContact = $r('app.string.delete')
          }
        })

        Column() {
          List({ space: 20, initialIndex: 0 }) {
            ForEach(this.contacts, (item) => {
              ListItem() {
                Row() {
                  Column() {
                    Row() {
                      Text($r('app.string.show_name'))
                        .fancyText('30%', TextAlign.Center)

                      Text(item.name)
                        .fancyText('50%', TextAlign.Start)
                    }
                    .margin({ bottom: 5 })

                    Row() {
                      Text($r('app.string.show_telephone'))
                        .fancyText('30%', TextAlign.Center)

                      Text(item.destinationHost)
                        .fancyText('50%', TextAlign.Start)
                    }
                  }
                  .margin({ top: 10, bottom: 10 })

                  Image($r('app.media.sms'))
                    .width(50)
                    .height(50)
                    .margin(10)
                    .objectFit(ImageFit.Contain)
                    .onClick(() => {
                      HiLog.info(TAG, `onClick-sms ${item.name},${item.destinationHost}`)
                      router.push({
                        uri: 'pages/SendMessage',
                        params: {
                          contact: item
                        }
                      })
                    })
                }
                .width('100%')
              }
              .editable(true)
            }, item => item.name)
          }
          .editMode(this.editable)
          .listDirection(Axis.Vertical)
          .chainAnimation(false) // 联动特效关闭
          .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
          .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 })
          .onItemDelete((index: number) => {
            this.contacts.splice((index - 1), 1)
            HiLog.info(TAG, `onItemDelete contacts = ${JSON.stringify(this.contacts[index])}`)
            return true
          })
          .width('90%')
        }
        .width('100%')
        .height('80%')
      }
      .width('100%')
      .height('80%')
      .margin({ top: 20 })
      .backgroundColor('#6bc1bdbf')
    }
    .width('100%')
    .height('100%')
  }
}