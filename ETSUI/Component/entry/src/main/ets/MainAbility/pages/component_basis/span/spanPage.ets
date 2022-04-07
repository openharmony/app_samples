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

@Entry
@Component
struct SpanPage {
  @State spanText: string = 'span组件'
  @State temporary: string = ''
  @State num: number[] = [...Array(4).keys()]
  @State textCaseNum: number[] = [...Array(3).keys()]
  @State decorationId: number = 0
  @State decoration: TextDecorationType[] = [TextDecorationType.Underline, TextDecorationType.LineThrough, TextDecorationType.Overline, TextDecorationType.None]
  @State decorationDescribe: string[] = ['Underline', 'LineThrough', 'Overline', 'None']
  @State colorId: number = 0
  @State color: Color[] = [Color.Green, Color.Orange, Color.Pink, Color.Yellow]
  @State colorDescribe: string[] = ['Green', 'Orange', 'Pink', 'Yellow']
  @State textCaseId: number = 0
  @State textCase: TextCase[]= [TextCase.Normal, TextCase.LowerCase, TextCase.UpperCase]
  @State textCaseDescribe: string[]= ["Normal", "LowerCase", "UpperCase"]

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text() {
          Span(this.spanText)
            .fontSize(30)
            .decoration({ type: this.decoration[this.decorationId], color: this.color[this.colorId] })
            .textCase(this.textCase[this.textCaseId])
        }
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Row() {
          Text('文本内容：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            TextInput({ placeholder: '', text: this.temporary })
              .enterKeyType(EnterKeyType.Send)
              .placeholderFont({ size: 15 })
              .height(40)
              .border({ width: 3, radius: 20, color: '#88000000' })
              .onChange((value) => {
                this.temporary = value
              })
              .onSubmit(() => {
                this.spanText = this.temporary
                this.temporary = ''
              })
              .onEditChanged((isEditing) => {
                console.log('www data  ' + JSON.stringify(isEditing))
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Text('文本装饰线样式：')
          .fontSize(15)
          .backgroundColor(0xFAEEE0)
          .width('100%')
          .height(40)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bolder)
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
          ForEach(this.num, item => {
            Button(this.decorationDescribe[`${item}`])
              .margin({right:10})
              .fontSize(15)
              .width(120)
              .onClick(() => {
                this.decorationId = item
              })
          }, item => item.toString())
        }
        .width('90%')
        .margin({ top: 5, bottom: 5 ,left:10,right:10})

        Text('文本装饰线颜色：')
          .fontSize(15)
          .backgroundColor(0xFAEEE0)
          .width('100%')
          .height(40)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bolder)
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
          ForEach(this.num, item => {
            Button(this.colorDescribe[`${item}`])
              .margin({right:10})
              .fontSize(15)
              .width(120)
              .onClick(() => {
                this.colorId = item
              })
          }, item => item.toString())
        }
        .width('90%')
        .margin({ top: 5, bottom: 5 ,left:10,right:10})

        Text('文本大小写：')
          .fontSize(15)
          .backgroundColor(0xFAEEE0)
          .height(40)
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bolder)
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
          ForEach(this.textCaseNum, item => {
            Button(this.textCaseDescribe[`${item}`])
              .margin({right:10})
              .fontSize(15)
              .width(120)
              .onClick(() => {
                this.textCaseId = item
              })
          }, item => item.toString())
        }
        .width('90%')
        .margin({ top: 5, bottom: 5 ,left:10,right:10})

      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 20 })
    }.width('100%')
  }
}