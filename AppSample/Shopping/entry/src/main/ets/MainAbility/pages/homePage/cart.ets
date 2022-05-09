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

@Component
export struct Cart {
  @State flag: boolean = true
  @State value: number = 1
  @Prop ratio: number

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Row() {
          Image('/resources/homeImg/imgLoads/product004.png')
            .width(130 * this.ratio)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
            .border({ radius: 10 * this.ratio })
          Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Column }) {
            Column() {
              Text('功能手机5G网速')
                .fontSize(15 * this.ratio)
                .fontWeight(FontWeight.Bolder)
                .width('52%')
                .margin({ bottom: 20 })
              Text('12GB+GB 官方精品')
                .fontSize(12 * this.ratio)
                .margin({ top: 10 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 20 })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Row() {
                Text('￥')
                  .fontSize(12 * this.ratio)
                  .fontColor(Color.Red)
                Text('35.8')
                  .fontSize(18 * this.ratio)
                  .fontColor(Color.Red)
                  .fontWeight(FontWeight.Bolder)
                  .margin({ right: 30 })
              }

              if (this.flag) {
                Text('x1')
                  .fontSize(10 * this.ratio)
                  .padding(5)
                  .border({ width: 1, radius: 5, color: Color.Grey })
                  .onClick(() => {
                    this.flag = false
                  })
              } else {
                Counter() {
                  Text(`${this.value}`)
                    .fontSize(10 * this.ratio)
                }
                .onInc(() => {
                  this.value++
                })
                .onDec(() => {
                  if (this.value <= 0) {
                    this.value = 0
                  } else {
                    this.value--
                  }
                })
              }
            }
            .width('60%')
          }
        }

        Toggle({ type: ToggleType.Checkbox })
          .width(20)
          .aspectRatio(1)
      }
    }
    .margin({ bottom: 10 })
  }
}