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

AppStorage.Link('isShowDialog') || AppStorage.SetOrCreate('isShowDialog', true)

@CustomDialog
struct DialogContentSample {
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void
  isOn: boolean = false
  @StorageLink('isShowDialog') isShowDialog: boolean = true

  build() {
    Column() {
      Text('弹窗提醒')
        .width('90%')
        .fontSize('16fp')
        .textAlign(TextAlign.Start)
        .margin({ top: 18, bottom: 24, left: '20%', right: '9%' })
      Image($r('app.media.icon')).width(80).height(80)
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Toggle({ type: ToggleType.Checkbox, isOn: this.isOn })
          .selectedColor('#007DFF')
          .onChange((isOn: boolean) => {
            this.isOn = !this.isOn
            this.isShowDialog = !this.isOn
          }).size({ width: 15, height: 15 })
        Text('下次不再提示')
          .fontSize('16fp')
          .fontColor('#182431')
          .opacity(0.6)
          .fontWeight(FontWeight.Regular)
      }.margin({ top: 12, bottom: 12 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button() {
          Text('取消').fontColor('#007DFF').fontSize('16fp')
        }
        .onClick(() => {
          this.controller.close()
          this.cancel()
        }).backgroundColor(0xffffff).fontColor(Color.Black)

        Row() {
          Text()
            .width(1)
            .backgroundColor(Color.Grey)
            .opacity(0.6)
            .height(16)
        }

        Button() {
          Text('确认').fontColor('#007DFF').fontSize('16fp')
        }
        .onClick(() => {
          this.controller.close()
          this.confirm()
        }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.width('70%').margin({ bottom: 10 })
    }.width('100%')
  }
}

@Entry
@Component
struct DialogSample {
  @StorageLink('isShowDialog') isShowDialog: boolean = true

  private onPageShow(): void  {
    if (this.isShowDialog) {
      this.dialogController.open()
    }
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: DialogContentSample({ cancel: this.onCancel, confirm: this.onAccept }),
    cancel: this.existApp,
    autoCancel: true
  })

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  existApp() {
    console.info('Click the callback in the blank area')
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: 'AppStorage' })
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text(`提示弹框${this.isShowDialog ? "正常弹出" : "不在弹出"}`).fontSize('16fp').fontWeight(FontWeight.Medium)
        Button('重置')
          .fontSize('16')
          .onClick(() => {
            this.isShowDialog = true
            this.dialogController.open()
          }).backgroundColor('#007DFF')
      }.width('100%').margin({ top: '40%' })
    }
    .width('100%')
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