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

import prompt from '@system.prompt';

@Entry
@Component
struct TextInputPage {
  scroller: Scroller = new Scroller()
  @State num1: number[] = [...Array(6).keys()]
  @State num2: number[] = [...Array(4).keys()]
  @State num3: number[] = [...Array(3).keys()]
  @State num4: number[] = [...Array(5).keys()]
  @State placeholder: string = '三生三世'
  @State text: string = ''
  @State temporary1: string = ''
  @State temporary2: string = ''
  @State size: number = 15
  @State colorId: number = 0
  @State color: Color[] = [Color.Green, Color.Orange, Color.Pink, Color.Yellow]
  @State colorDescribe: string[] = ['Green', 'Orange', 'Pink', 'Yellow']
  @State fontStyle: FontStyle = FontStyle.Normal
  @State isNumber: boolean = true
  @State fontWeight: number = 500
  @State fontWeightId: number = 0
  @State fontWeights: FontWeight[] = [FontWeight.Bold, FontWeight.Normal, FontWeight.Bolder, FontWeight.Lighter, FontWeight.Medium, FontWeight.Regular]
  @State fontWeightDescribe: string[] = ['Bold', 'Normal', 'Bolder', 'Lighter', 'Medium', 'Regular']
  @State textAlignId: number = 0
  @State textAlign: TextAlign[] = [TextAlign.Start, TextAlign.End, TextAlign.Center]
  @State textAlignDescribe: string[] = ['Start', 'End', 'Center']
  @State caretColorId: number = 0
  @State typeId: number = 0
  @State type: InputType[] = [InputType.Normal, InputType.Password, InputType.Email, InputType.Number]
  @State typeDescribe: string[] = ['Normal', 'Password', 'Email', 'Number']
  @State enterKeyTypeId: number = 1
  @State enterKeyType: EnterKeyType[] = [EnterKeyType.Go, EnterKeyType.Search, EnterKeyType.Send, EnterKeyType.Next, EnterKeyType.Done]
  @State enterKeyTypeDescribe: string[] = ['Go', 'Search', 'Send', 'Next', 'Done']

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: this.placeholder, text: this.text })
          .type(this.type[this.typeId])
          .placeholderColor(this.color[this.colorId])
          .placeholderFont({
            size: this.size,
            weight: this.isNumber == true ? this.fontWeight : this.fontWeights[this.fontWeightId],
            style: this.fontStyle,
            family: 'sans-serif'
          })
          .enterKeyType(this.enterKeyType[this.enterKeyTypeId])
          .caretColor(this.color[this.caretColorId])
          .height(50)
          .width('80%')
          .border({ width: 1, radius: 25, color: '#80000000' })
          .onChange((value) => {
            prompt.showToast({
              message: 'value：' + value
            })
          })
          .onSubmit((enterKey: EnterKeyType) => {
            prompt.showToast({
              message: 'enterKey：' + enterKey
            })
          })
          .onEditChanged((isEditing: boolean) => {
            prompt.showToast({
              message: 'isEditing：' + isEditing
            })
          })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Scroll(this.scroller) {
        Column() {
          Row() {
            Text('placeholder：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              TextInput({ placeholder: '', text: this.temporary1 })
                .enterKeyType(EnterKeyType.Send)
                .placeholderFont({ size: 15 })
                .height(35)
                .border({ width: 3, radius: 20, color: '#88000000' })
                .onChange((value) => {
                  this.temporary1 = value
                })
                .onSubmit(() => {
                  this.placeholder = this.temporary1
                  this.temporary1 = ''
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }

          Row() {
            Text('text：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              TextInput({ placeholder: '', text: this.temporary2 })
                .enterKeyType(EnterKeyType.Send)
                .placeholderFont({ size: 15 })
                .height(35)
                .border({ width: 3, radius: 20, color: '#88000000' })
                .onChange((value) => {
                  this.temporary2 = value
                })
                .onSubmit(() => {
                  this.text = this.temporary2
                  this.temporary2 = ''
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }

          Row() {
            Text(`placeholder size：${this.size}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.size, step: 1, min: -1, max: 100 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.size = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }

          Column() {
            Text('type：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num2, item => {
                Button(this.typeDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(100)
                  .onClick(() => {
                    this.typeId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('enterKeyType：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num4, item => {
                Button(this.enterKeyTypeDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(100)
                  .onClick(() => {
                    this.enterKeyTypeId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('placeholder颜色：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('90%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num2, item => {
                Button(this.colorDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(100)
                  .onClick(() => {
                    this.colorId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('字体样式：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('90%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Button('Normal')
                .margin({ right: 10 })
                .fontSize(15)
                .width(100)
                .onClick(() => {
                  this.fontStyle = FontStyle.Normal
                })
              Button('Italic')
                .fontSize(15)
                .width(100)
                .onClick(() => {
                  this.fontStyle = FontStyle.Italic
                })
            }
            .width('90%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('fontWeight：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('90%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Button('Number')
                .margin({ right: 10 })
                .fontSize(15)
                .width(100)
                .onClick(() => {
                  this.isNumber = true
                })
              Button('String')
                .fontSize(15)
                .width(100)
                .onClick(() => {
                  this.isNumber = false
                })
            }
            .width('90%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            if (!this.isNumber) {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
                ForEach(this.num1, item => {
                  Button(this.fontWeightDescribe[`${item}`])
                    .margin({ right: 10 })
                    .fontSize(15)
                    .width(100)
                    .onClick(() => {
                      this.fontWeightId = item
                    })
                }, item => item.toString())
              }
              .width('90%')
              .margin({ top: 5, bottom: 5, left: 10, right: 10 })
            } else {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceAround,
                alignItems: ItemAlign.Start
              }) {
                Slider({ value: this.fontWeight, step: 100, min: -100, max: 1000 })
                  .blockColor(Color.Orange)
                  .width('90%')
                  .onChange((e) => {
                    this.fontWeight = Math.round(e)
                  })
                Text(`${this.fontWeight}`)
                  .fontSize(15)
              }
              .width('100%')
              .margin({ top: 5, bottom: 5, left: 10, right: 10 })
            }
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('光标颜色：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('90%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num2, item => {
                Button(this.colorDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(100)
                  .onClick(() => {
                    this.caretColorId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ top: 20 })
      }
      .height("50%")
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(10)
    }
    .width('100%')
  }
}