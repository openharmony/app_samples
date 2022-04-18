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
import display from '@ohos.display';

@Observed
class useSizeTypes {
  public xsspan: number;
  public smspan: number;
  public mdspan: number;
  public lgspan: number;
  public id: number = 0;

  constructor(id: number, xsspan: number, smspan: number, mdspan: number, lgspan: number) {
    this.id = id,
    this.xsspan = xsspan
    this.smspan = smspan
    this.mdspan = mdspan
    this.lgspan = lgspan
  }
}

@Entry
@Component
struct GridContainerSample {
  @State sizeType: SizeType = SizeType.Auto
  @State gutter: number = 2
  @State initialGutter: number = 2
  @State margin: number = 10
  @State initialMargin: number = 10
  @State columns: number = 4
  @State isFixedColumns: boolean = false
  @State indexs: number = 0
  @State typeSpan: string = ''
  @State temp: number = 1
  @State items: useSizeTypes[] = [
    new useSizeTypes(1, 1, 1, 1, 1,),
    new useSizeTypes(2, 1, 1, 1, 1,),
    new useSizeTypes(3, 1, 1, 1, 1,),
    new useSizeTypes(4, 1, 1, 1, 1,),
    new useSizeTypes(5, 1, 1, 1, 1,),
    new useSizeTypes(6, 1, 1, 1, 1,),
    new useSizeTypes(7, 1, 1, 1, 1,),
    new useSizeTypes(8, 1, 1, 1, 1,),
    new useSizeTypes(9, 1, 1, 1, 1,),
    new useSizeTypes(10, 1, 1, 1, 1,),
    new useSizeTypes(11, 1, 1, 1, 1,),
    new useSizeTypes(12, 1, 1, 1, 1,),
  ]

  aboutToAppear(): void{
    display.getDefaultDisplay((err, data) => {
      if (data['width'] >= 2560) {
        this.sizeType = SizeType.LG
        this.columns = 12
      }
      else if (data['width'] > 560 && data['width'] < 2560) {
        this.sizeType = SizeType.MD
        this.columns = 8
      } else {
        this.sizeType = SizeType.SM
        this.columns = 4
      }
      switch (this.sizeType) {
        case SizeType.XS:
          this.typeSpan = 'xsspan'
          break;
        case SizeType.SM:
          this.typeSpan = 'smspan'
          break;
        case SizeType.MD:
          this.typeSpan = 'mdspan'
          break;
        case SizeType.LG:
          this.typeSpan = 'lgspan'
          break;
      }
      this.temp = this.items[this.indexs][this.typeSpan]
    })
  }

  build() {
    Column() {
      NavigationBar({ title: 'GridContainer' })
      //上部分显示效果
      Scroll() {
        MyGrid({
          indexs: $indexs,
          temp: $temp,
          sizeType: $sizeType,
          gutter: $gutter,
          margin: $margin,
          columns: $columns,
          isFixedColumns: $isFixedColumns,
          typeSpan: $typeSpan,
          items: $items,
        })
      }
      .width('100%')
      .height('40%')
      .padding({ top: 22, bottom: 22 })
      .backgroundColor('#FFFFFF')
      .borderRadius(24)

      //下部分属性、属性值
      List() {
        ListItem() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('columnsAuto:')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
              Toggle({ type: ToggleType.Switch, isOn: this.isFixedColumns })
                .selectedColor('#007DFF')
                .switchPointColor(0xe5ffffff)
                .onChange((isOn: boolean) => {
                  this.isFixedColumns = !this.isFixedColumns
                  if (this.temp == this.columns) {
                    this.temp = this.columns
                  } else {
                    this.temp = this.items[this.indexs][this.typeSpan]
                  }
                  if (this.isFixedColumns === false) {
                    this.columns = 4
                    this.items[this.indexs][this.typeSpan] = 1
                    this.temp = 1
                  }
                  this.initialGutter = this.gutter
                  this.initialMargin = this.margin
                })
                .width(35)
                .height(20)
                .padding({ top: 0, bottom: 0 })
            }
            .width('100%')

            Divider()
              .strokeWidth(1)
              .color(0xeeeeee)
              .margin(this.isFixedColumns ? { top: 12, bottom: 12 } : 0)
              .visibility(this.isFixedColumns ? Visibility.Visible : Visibility.None)
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('columns:')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)

              Text(`${this.columns ? this.columns : 'auto'}`)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .width('100%')
            .visibility(this.isFixedColumns ? Visibility.Visible : Visibility.None)

            Slider({
              value: this.columns,
              min: 0,
              max: 12,
              step: 1,
              style: SliderStyle.OutSet
            })
              .blockColor('#FFFFFF')
              .trackColor('#182431')
              .selectedColor('#007DFF')
              .showSteps(true)
              .showTips(true)
              .onChange((value: number) => {
                this.columns = Math.round(value)
                if (this.columns === 1) {
                  this.items.forEach(elm => {
                    elm[this.typeSpan] = 0
                  })
                } else {
                  this.items.forEach(elm => {
                    elm[this.typeSpan] = 1
                  })
                  this.temp = 1
                }
                this.initialGutter = this.gutter
                this.initialMargin = this.margin
              })
              .visibility(this.isFixedColumns ? Visibility.Visible : Visibility.None)
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }

        ListItem() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('indexColumns:')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
              Column() {
                Text(`${this.indexs + 1}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
              }
              .justifyContent(FlexAlign.Center)
              .bindMenu([
                {
                  value: '1',
                  action: () => {
                    this.indexs = 0
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '2',
                  action: () => {
                    this.indexs = 1
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '3',
                  action: () => {
                    this.indexs = 2
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '4',
                  action: () => {
                    this.indexs = 3
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '5',
                  action: () => {
                    this.indexs = 4
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '6',
                  action: () => {
                    this.indexs = 5
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '7',
                  action: () => {
                    this.indexs = 6
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '8',
                  action: () => {
                    this.indexs = 7
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '9',
                  action: () => {
                    this.indexs = 8
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '10',
                  action: () => {
                    this.indexs = 9
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '11',
                  action: () => {
                    this.indexs = 10
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
                {
                  value: '12',
                  action: () => {
                    this.indexs = 11
                    this.temp = this.items[this.indexs][this.typeSpan] === (this.columns + 1) ? 0 : this.items[this.indexs][this.typeSpan]
                  }
                },
              ])
            }
            .width('100%')

            Divider().strokeWidth(1).color(0xeeeeee).margin({ top: '3%' })

            Flex({ justifyContent: FlexAlign.Center }) {
              Slider({
                value: this.temp,
                min: 0,
                max: this.columns,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .showSteps(true)
                .showTips(true)
                .onChange((value: number) => {
                  switch (Math.round(value)) {
                    case 0:
                      this.items[this.indexs][this.typeSpan] = this.columns + 1
                      break;
                    case this.columns:
                      this.items[this.indexs][this.typeSpan] = 0
                      break;
                    default:
                      this.items[this.indexs][this.typeSpan] = Math.round(value)
                      break;
                  }
                  this.temp = Math.round(value)
                  this.initialGutter = this.gutter
                  this.initialMargin = this.margin
                })
            }
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }

        ListItem() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('gutter:')
                .fontSize(16)
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
            }
            .width('100%')

            Divider().strokeWidth(1).color(0xeeeeee).margin({ top: 12 })

            Slider({
              value: this.initialGutter,
              min: 0,
              max: 40,
              step: 2,
              style: SliderStyle.OutSet
            })
              .blockColor('#FFFFFF')
              .trackColor('#182431')
              .selectedColor('#007DFF')
              .showSteps(true)
              .showTips(true)
              .onChange((value: number) => {
                this.gutter = value
              })
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }

        ListItem() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('margin:')
                .fontSize(16)
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
            }
            .width('100%')

            Divider().strokeWidth(1).color(0xeeeeee).margin({ top: 12 })

            Slider({
              value: this.initialMargin,
              min: 0,
              max: 50,
              step: 5,
              style: SliderStyle.OutSet
            })
              .blockColor('#FFFFFF')
              .trackColor('#182431')
              .selectedColor('#007DFF')
              .showSteps(true)
              .showTips(true)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.margin = value
              })
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }
      .width('100%')
      .height('60%')
      .margin({ top: 24 })
      .padding({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: '3%', right: '3%', bottom: 10 })
    .backgroundColor('#F1F3F5')
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

@Component
struct MyGrid {
  @Link isFixedColumns: boolean
  @Link columns: number
  @Link sizeType: SizeType
  @Link gutter: number
  @Link margin: number
  @Link items: useSizeTypes[]
  @Link indexs: number
  @Link temp: number
  @Link typeSpan: string

  build() {
    GridContainer({
      columns: this.isFixedColumns ? this.columns : 'auto',
      sizeType: this.sizeType,
      gutter: this.gutter,
      margin: this.margin
    }) {
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
        ForEach(this.items, (item, index) => {
          Column() {
            Column() {
              Text(`${item.id}`)
                .fontSize(30)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor('#337aae')
                .fontColor(index === this.indexs ? '#f1ca06' : '#000000')
                .fontWeight(FontWeight.Medium)
            }.width('100%').padding(this.gutter)
          }
          .useSizeType({
            xs: item.xsspan,
            sm: item.smspan,
            md: item.mdspan,
            lg: item.lgspan,
          })
          .onClick(() => {
            this.indexs = index
            this.temp = this.items[this.indexs][this.typeSpan] === 0 ? this.columns : this.items[this.indexs][this.typeSpan]
          })
          .visibility(item[this.typeSpan] === (this.columns + 1) ? Visibility.None : Visibility.Visible)
        }, item => item.id.toString())
      }
    }
  }
}