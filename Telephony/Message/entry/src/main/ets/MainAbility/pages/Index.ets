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
import Logger from '../model/Logger'
import { TitleBar } from '../common/TitleBar'
import { AddDialog } from '../common/AddDialog'
import { grantPermission } from '../model/PermissionUtils'

const TAG: string = '[Index]'

@Extend(Text) function fancyText (width: string, textAlign: number) {
  .width(width)
  .fontSize(20)
  .textAlign(textAlign)
}

@Extend(TextInput) function fancyInput () {
  .width('60%')
  .fontSize(20)
  .fontWeight(FontWeight.Bold)
}

@Entry
@Component
struct Index {
  @State editable: boolean = false
  @State contacts: Array<Contact> = []
  @State editContact: Contact = new Contact('', '')
  @State managerContact: Resource = $r('app.string.manager')
  private addDialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({ editContact: this.editContact, action: this.onAccept.bind(this) }),
    autoCancel: true
  })

  onAccept(contact: Contact) {
    Logger.info(`${TAG}, onAccept contact:${JSON.stringify(contact)}`)
    let newContact = new Contact(contact.name, contact.destinationHost)
    this.contacts.unshift(newContact)
    Logger.info(`${TAG}, onClick-save contacts = ${JSON.stringify(this.contacts)}`)

  }

  aboutToAppear() {
    grantPermission()
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar()
      Column() {
        Row() {
          Button() {
            Text($r('app.string.new_contact'))
              .fancyText('40%', TextAlign.Center)
              .fontColor(Color.White)
          }
          .height(40)
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            this.editContact = new Contact('', '')
            this.addDialogController.open()
          })

          Button() {
            Text(this.managerContact)
              .fancyText('40%', TextAlign.Center)
              .fontColor(Color.White)
          }
          .height(40)
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .margin({ top: 10, bottom: 10, left: 10 })
          .onClick(() => {
            this.editable = !this.editable
            if (this.editable) {
              this.managerContact = $r('app.string.cancel')
            } else {
              this.managerContact = $r('app.string.manager')
            }
          })
        }

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
                      Logger.info(`${TAG}, onClick-sms ${item.name} ${item.destinationHost}`)
                      router.push({
                        uri: 'pages/SendMessage',
                        params: {
                          contact: item
                        }
                      })
                    }
                    )
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
            this.contacts.splice(index, 1)
            Logger.info(`${TAG}, onItemDelete contacts = ${JSON.stringify(this.contacts[index])}`)
            return true
          })
          .width('90%')
        }
        .width('100%')
        .height('80%')
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
  }
}