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

@Observed
class ListInfo {
  public id: number = 0;
  public value: string = '';
  public isSolve: boolean = false

  constructor(id: number, value: string, isSolve: boolean) {
    this.id = id;
    this.value = value;
    this.isSolve = isSolve;
  }
}

@Component
struct ItemTemplate {
  @State showButton: boolean = false;
  @Link nowId: number;
  @Link list: ListInfo[];
  @ObjectLink listInfo: ListInfo;
  @State translateX: number = 0

  build() {
    Row() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Flex({ alignItems: ItemAlign.Center }) {
          Text('' + this.listInfo.value).fontSize(24).padding({ left: '3.3%', right: '3.3%', top: 8, bottom: 8 })
        }
        .layoutWeight(1)
        .onClick(() => {
          animateTo({ duration: 370, curve: Curve.Friction }, () => {
            this.showButton = false;
            this.translateX = 0
          })
        })
      }
      .translate({ x: this.showButton && this.nowId == this.listInfo.id ? this.translateX : 0 })
      .height(72)
      .borderRadius(24)
      .backgroundColor('#ffffff')
      .backgroundColor(this.listInfo.isSolve ? '#FFFFFF' : '#FFFFFF')
      .gesture(
      PanGesture({ direction: PanDirection.Left })
        .onActionStart(() => {
          this.nowId = this.listInfo.id
          this.showButton = false
        })
        .onActionUpdate(() => {
          animateTo({ duration: 300, curve: Curve.Friction }, () => {
            this.showButton = true;
            this.translateX = -120

          })
        })
      )

      if (this.showButton && this.nowId == this.listInfo.id) {
        Flex({ justifyContent: FlexAlign.SpaceAround }) {
          Flex({ justifyContent: FlexAlign.Center }) {
            Image(this.listInfo.isSolve ? $r('app.media.ic_public_edit_filled') : $r('app.media.ic_public_deselect_all'))
              .width(30)
              .height(30)
              .alignSelf(ItemAlign.Center)
              .onClick(() => {
                animateTo({ duration: 300, curve: Curve.Friction }, () => {
                  this.list.splice(this.list.findIndex(item => item.id === this.nowId), 1)
                  this.list.unshift({
                    id: this.listInfo.id,
                    value: this.listInfo.value,
                    isSolve: !this.listInfo.isSolve
                  })
                })
                this.showButton = false
              })
          }
          .borderRadius(50)
          .backgroundColor('#1a98ec')
          .width(50)
          .height(50)

          Flex({ justifyContent: FlexAlign.Center }) {
            Image($r('app.media.ic_public_delete_filled'))
              .width(30)
              .height(30)
              .alignSelf(ItemAlign.Center)
          }
          .onClick(() => {
            animateTo({ duration: 300, curve: Curve.Friction }, () => {
              this.list.splice(this.list.findIndex(item => item.id === this.nowId), 1)
            })
            this.showButton = false
          })
          .borderRadius(50)
          .backgroundColor('#ff0000')
          .width(50)
          .height(50)
        }
        .translate({ x: -120 })
        .width(120)
        .height(50)
        .transition({ opacity: 0 })
        .borderRadius(10)
      }
    }

  }
}

@CustomDialog
struct CustomDialogExample {
  @State text: string = ''
  controller: CustomDialogController
  confirm: (text: string) => void

  build() {
    Column() {
      TextArea({ placeholder: '请输入要添加的内容' })
        .placeholderColor(0xC0C0C0)
        .placeholderFont({ size: 24, weight: 400 })
        .textAlign(TextAlign.Start)
        .caretColor(Color.Black)
        .onChange((value: string) => {
          this.text = value
        })
        .height(200)
        .margin(20)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(() => {
            this.controller.close()
            this.confirm(this.text)
            this.text = ''
          }).backgroundColor(0xffffff).fontColor(Color.Red)

      }
    }.margin({ bottom: 10 })
  }
}

@Entry
@Component
struct ListSample {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({ confirm: this.onAccept.bind(this) }),
    cancel: this.existApp,
    autoCancel: true
  })

  onAccept(text: string) {
    animateTo({ duration: 300 }, () => {
      this.list.unshift(new ListInfo((new Date()).valueOf(), text, false))
    })
  }

  existApp() {
    console.info('Click the callback in the blank area')
  }

  @State list: ListInfo[] = [
    new ListInfo(1, '1', false),
    new ListInfo(2, '2', false),
    new ListInfo(3, '3', false),
    new ListInfo(4, '4', false),
    new ListInfo(5, '5', true),
    new ListInfo(6, '6', true),
    new ListInfo(7, '7', true)
  ]
  @State nowId: number = 0

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'List' })
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        List({ space: 12 }) {
          ListItem() {
            Text('未完成')
              .fontSize('14fp')
              .fontColor('#182431')
              .width('100%')
          }.width('100%')

          ForEach(this.list, (item, index) => {
            if (!item.isSolve) {
              ListItem() {
                ItemTemplate({
                  list: $list,
                  nowId: $nowId,
                  listInfo: this.list[index]
                })
              }.height(50).width('100%').margin({ top: 10, bottom: 10 })
            }
          })

          ListItem() {
            Text('已完成')
              .fontSize('14fp')
              .fontColor('#182431')
              .width('100%')
          }.width('100%')

          ForEach(this.list, (item, index) => {
            if (item.isSolve) {
              ListItem() {
                ItemTemplate({
                  list: $list,
                  nowId: $nowId,
                  listInfo: this.list[index]
                })
              }.height(50).width('100%').margin({ top: 10, bottom: 10 })
            }
          })
        }
        .chainAnimation(false)
        .width('95%')
        .height('80%')

        Text('+')
          .height(48)
          .width(48)
          .backgroundColor('#000000')
          .fontSize('40FP')
          .fontColor('#FFFFFF')
          .textAlign(TextAlign.Center)
          .lineHeight(48)
          .borderRadius(50)
          .onClick(() => {
            this.dialogController.open()
          })
          .margin({ bottom: 12 })
      }.height('100%')
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })

  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }
}