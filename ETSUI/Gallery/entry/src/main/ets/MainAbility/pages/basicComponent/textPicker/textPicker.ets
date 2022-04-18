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

import { NavigationBar } from "../../../common/components/navigationBar";

@Entry
@Component
struct TextPickerSample {
  private array: string[] = ['item1', 'item2', 'item3', 'item4'];
  @State select: number = 1;
  @State textPickerCase: string = "The current item is the default value";
  @State textPickerItem: string = "value:" + this.array[this.select] + " , " + "index:" + this.select;
  @State defaultPickerItemHeight: number = 0;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {

      NavigationBar({ title: 'textPicker' })

      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
            Text('选择滑动')
              .width("100%")
              .height("10%")
              .fontSize(18)
              .textAlign(TextAlign.Center)
            Text(this.textPickerCase)
              .width("100%")
              .height("15%")
              .fontSize(18)
              .textAlign(TextAlign.Center)
            Text(this.textPickerItem)
              .width("100%")
              .height("15%")
              .fontSize(18)
              .textAlign(TextAlign.Center)
          }
          .width("100%")
        }
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })
      .backgroundColor("#FFFFFF")

      Row() {
        TextPicker({ range: this.array, selected: this.select })
          .width("100%")
          .height("100%")
          .defaultPickerItemHeight(this.defaultPickerItemHeight)
          .onChange((value: string, index: number) => {
            this.textPickerCase = "Picker item changed";
            this.textPickerItem = "value:" + value + " , " + "index: " + index;
            console.info('Picker item changed, value: ' + value + ', index: ' + index)
          })
      }
      .height("30%")
      .width("100%")
      .margin({ bottom: 8 })
      .backgroundColor("#FFFFFF")
      .borderRadius(20)

      Scroll() {
        Column() {
          Flex({ direction: FlexDirection.Column }) {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('defaultPickerItemHeight')
                .fontSize(16)
                .lineHeight(28)
                .fontWeight(FontWeight.Medium)
                .fontColor("#182431")
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Text(this.defaultPickerItemHeight.toFixed(0))
                .fontSize(16)
                .lineHeight(28)
                .fontColor("#182431")
                .fontWeight(FontWeight.Medium)
            }.padding({ left: '3%', right: '3%' })

            Slider({
              value: this.defaultPickerItemHeight,
              min: -1,
              max: 1,
              step: 1,
              style: SliderStyle.OutSet
            })
              .width('100%')
              .blockColor("#FFFFFF")
              .trackColor("rgba(24,36,49,0.2)")
              .selectedColor("#007DFF")
              .borderRadius(12)
              .onChange((value: number) => {
                this.defaultPickerItemHeight = value
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('defaultSelect').fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Counter() {
              Text("" + this.select).fontSize(18)
            }
            .onInc(() => {
                this.select < this.array.length - 1 ? this.select++ : this.array.length - 1;
                this.textPickerCase = "The current item is the default value";
                this.textPickerItem = "value:" + this.array[this.select] + " , " + "index: " + this.select;
            })
            .onDec(() => {
                this.select > 0 ? this.select-- : 0;
                this.textPickerCase = "The current item is the default value";
                this.textPickerItem = "value:" + this.array[this.select] + " , " + "index: " + this.select;
            })
          }
          .width('100%')
          .height("6%")
          .padding({ left: '3%', right: '4%' })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

        }
        .width('100%')
      }
    }
    .width('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })
  }
}