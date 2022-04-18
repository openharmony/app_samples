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
import {NavigationBar} from "../../../common/components/navigationBar"
import {GetColor} from "../../../common/components/getColor"

enum AttributesType {
  BUTTON,
  OPTION,
  SELECTEDOPTION
}

@Observed
class SelectAttributes {
  public selected: number= 0
  public value: string= 'TTT'
  public buttonFont: Font = new Font(60, FontWeight.Normal, 'serif', FontStyle.Normal)
  public selectedOptionFont: Font = new Font(60, FontWeight.Normal, 'serif', FontStyle.Normal)
  public optionFont: Font = new Font(40, FontWeight.Normal, 'serif', FontStyle.Normal)
}

@Observed
class Font {
  public size: number= 60
  public weight: FontWeight= FontWeight.Normal
  public family: string = 'serif'
  public style: FontStyle= FontStyle.Normal

  constructor(size: number, weight: FontWeight, family: string, style: FontStyle) {
    this.size = size, this.weight = weight, this.family = family, this.style = style
  }
}

@Entry
@Component
struct SelectSample {
  @State attributes: SelectAttributes = new SelectAttributes()
  @State fontColor: string= 'white'
  @State optionFontColor: string= 'black'
  @State optionBgColor: string= 'white'
  @State selectedOptionBgColor: string= '#ee0a24'
  @State selectedOptionFontColor: string= 'black'
  private controller: TabsController = new TabsController()
  @State attributesType: AttributesType= AttributesType.BUTTON

  build() {
    Flex({ direction: FlexDirection.Column }) {
      NavigationBar({ title: 'Select' })
      //上部分显示效果
      Scroll() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Select([{ value: 'select1', icon: "/common/favor.png" },
                  { value: 'select2', icon: "/common/favor.png" },
                  { value: 'select3', icon: "/common/favor.png" },
                  { value: 'select4', icon: "/common/favor.png" }])
            .selected(this.attributes.selected)
            .value(this.attributes.value)
            .font({
              size: this.attributes.buttonFont.size,
              weight: this.attributes.buttonFont.weight,
              family: this.attributes.buttonFont.family,
              style: this.attributes.buttonFont.style
            })
            .selectedOptionFont({
              size: this.attributes.selectedOptionFont.size,
              weight: this.attributes.selectedOptionFont.weight,
              family: this.attributes.selectedOptionFont.family,
              style: this.attributes.selectedOptionFont.style
            })
            .selectedOptionFontColor(this.selectedOptionFontColor)
            .fontColor(this.fontColor)
            .selectedOptionBgColor(this.selectedOptionBgColor)
            .optionFont({
              size: this.attributes.optionFont.size,
              weight: this.attributes.optionFont.weight,
              family: this.attributes.optionFont.family,
              style: this.attributes.optionFont.style
            })
            .optionBgColor(this.optionBgColor)
            .optionFontColor(this.optionFontColor)
        }
        .width('100%')
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding(18)
      .backgroundColor('#696969')
      //下部分属性、属性值
      Scroll() {
        Column() {
          Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
            TabContent() {
              Scroll() {
                Column() {
                  ButtonControl({
                    attributes: this.attributes, fontColor: $fontColor
                  })
                  FontControl({
                    attributes: this.attributes, attributesType: $attributesType
                  })
                }.height(500)
              }
            }.tabBar('Button属性')

            TabContent() {
              Scroll() {
                Column() {
                  OptionControl({
                    attributes: this.attributes, optionFontColor: $optionFontColor, optionBgColor: $optionBgColor
                  })
                  FontControl({
                    attributes: this.attributes, attributesType: $attributesType
                  })
                }.height(500)
              }

            }.tabBar('Option属性').height('100%')

            TabContent() {
              Scroll() {
                Column() {
                  SelectedOptionControl({
                    attributes: this.attributes,
                    selectedOptionBgColor: $selectedOptionBgColor,
                    selectedOptionFontColor: $selectedOptionFontColor
                  })
                  FontControl({
                    attributes: this.attributes, attributesType: $attributesType
                  })
                }.height(500)
              }
            }.tabBar('Selected属性')
          }
          .vertical(false)
          .scrollable(true)
          .barMode(BarMode.Fixed)
          .barWidth(400)
          .animationDuration(100)
          .onChange((index: number) => {
            this.attributesType = index
            console.info(`${this.attributesType}`)
          })
          .height('100%')
        }
        .width('100%')
      }
      .width('100%')
      .height('60%')
      .margin({ top: 24 })
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })
  }
}

@Component
struct ButtonControl {
  @ObjectLink attributes: SelectAttributes
  @Link fontColor: string

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('value')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Column() {
          TextInput({ placeholder: '' })
            .type(InputType.Normal)
            .placeholderColor(Color.Blue)
            .placeholderFont({ size: 25, weight: FontWeight.Normal, family: "Arial", style: FontStyle.Normal })
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.Green)
            .width('20%')
            .fontSize('10fp')
            .fontFamily("cursive")
            .fontStyle(FontStyle.Italic)
            .fontWeight(FontWeight.Regular)
            .borderRadius(24)
            .fontColor('#182431')
            .maxLength(20)
            .onChange((value: string) => {
              this.attributes.value = value
            })
        }
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('fontColor')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Row() {
          GetColor({ colorVal: $fontColor })
        }.width('20%')
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })
    }
  }
}

@Component
struct SelectedOptionControl {
  @ObjectLink attributes: SelectAttributes
  @Link selectedOptionBgColor: string
  @Link selectedOptionFontColor: string

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('selectedOptionBgColor')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Row() {
          GetColor({ colorVal: $selectedOptionBgColor })
        }.width('20%')
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('selectedOptionFontColor')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Row() {
          GetColor({ colorVal: $selectedOptionFontColor })
        }.width('20%')
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })
    }
  }
}

@Component
struct OptionControl {
  @ObjectLink attributes: SelectAttributes
  @Link optionFontColor: string
  @Link optionBgColor: string

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('selected')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')

        Column() {
          Text(`${this.attributes.selected}`)
            .fontSize('10fp')
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
            .width('50%')
            .textAlign(TextAlign.End)
        }
        .bindMenu([
          {
            value: '0',
            action: () => {
              this.attributes.selected = 0
            }
          },
          {
            value: '1',
            action: () => {
              this.attributes.selected = 1
            }
          },
          {
            value: '2',
            action: () => {
              this.attributes.selected = 2
            }
          },
          {
            value: '3',
            action: () => {
              this.attributes.selected = 3
            }
          },
        ])
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('optionFontColor')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Row() {
          GetColor({ colorVal: $optionFontColor })
        }.width('20%')
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('optionBgColor')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Row() {
          GetColor({ colorVal: $optionBgColor })
        }.width('20%')
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })
    }
  }
}

@Component
struct FontControl {
  @ObjectLink attributes: SelectAttributes
  @Link attributesType: AttributesType

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('fontSize')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Column() {
          TextInput({ placeholder: '' })
            .type(InputType.Normal)
            .placeholderColor(Color.Blue)
            .placeholderFont({ size: 25, weight: FontWeight.Normal, family: "Arial", style: FontStyle.Normal })
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.Green)
            .width('20%')
            .fontSize(25)
            .fontFamily("cursive")
            .fontStyle(FontStyle.Italic)
            .borderRadius(24)
            .fontWeight(FontWeight.Regular)
            .fontColor('#182431')
            .maxLength(20)
            .onChange((value: string) => {
              if (this.attributesType == AttributesType.BUTTON) {
                this.attributes.buttonFont = new Font(parseInt(value), this.attributes.buttonFont.weight, this.attributes.buttonFont.family, this.attributes.buttonFont.style)
              } else if (this.attributesType == AttributesType.OPTION) {
                this.attributes.optionFont = new Font(parseInt(value), this.attributes.optionFont.weight, this.attributes.optionFont.family, this.attributes.optionFont.style)
              } else if (this.attributesType == AttributesType.SELECTEDOPTION) {
                this.attributes.selectedOptionFont = new Font(parseInt(value), this.attributes.selectedOptionFont.weight, this.attributes.selectedOptionFont.family, this.attributes.selectedOptionFont.style)
              }
            })
        }
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('fontWeight')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Column() {
          TextInput({ placeholder: '' })
            .type(InputType.Normal)
            .placeholderColor(Color.Blue)
            .placeholderFont({ size: 25, weight: FontWeight.Normal, family: "Arial", style: FontStyle.Normal })
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.Green)
            .width('20%')
            .fontSize('10fp')
            .fontFamily("cursive")
            .fontStyle(FontStyle.Italic)
            .borderRadius(24)
            .fontWeight(FontWeight.Regular)
            .fontColor('#182431')
            .maxLength(20)
            .onChange((value: string) => {
              if (this.attributesType == AttributesType.BUTTON) {
                this.attributes.buttonFont = new Font(this.attributes.buttonFont.size, parseInt(value), this.attributes.buttonFont.family, this.attributes.buttonFont.style)
              } else if (this.attributesType == AttributesType.OPTION) {
                this.attributes.optionFont = new Font(this.attributes.optionFont.size, parseInt(value), this.attributes.optionFont.family, this.attributes.optionFont.style)
              } else if (this.attributesType == AttributesType.SELECTEDOPTION) {
                this.attributes.selectedOptionFont = new Font(this.attributes.selectedOptionFont.size, parseInt(value), this.attributes.selectedOptionFont.family, this.attributes.selectedOptionFont.style)
              }
            })
        }
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('fontFamily')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Column() {
          TextInput({ placeholder: '' })
            .type(InputType.Normal)
            .placeholderColor(Color.Blue)
            .placeholderFont({ size: 25, weight: FontWeight.Normal, family: "Arial", style: FontStyle.Normal })
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.Green)
            .width('20%')
            .fontSize('10fp')
            .fontFamily("cursive")
            .fontStyle(FontStyle.Italic)
            .borderRadius(24)
            .fontWeight(FontWeight.Regular)
            .fontColor('#182431')
            .maxLength(20)
            .onChange((value: string) => {
              if (this.attributesType == AttributesType.BUTTON) {
                this.attributes.buttonFont = new Font(this.attributes.buttonFont.size, this.attributes.buttonFont.weight, value, this.attributes.buttonFont.style)
              } else if (this.attributesType == AttributesType.OPTION) {
                this.attributes.optionFont = new Font(this.attributes.optionFont.size, this.attributes.optionFont.weight, value, this.attributes.optionFont.style)
              } else if (this.attributesType == AttributesType.SELECTEDOPTION) {
                this.attributes.selectedOptionFont = new Font(this.attributes.selectedOptionFont.size, this.attributes.selectedOptionFont.weight, value, this.attributes.selectedOptionFont.style)
              }
            })
        }
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('fontStyle')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .opacity(0.5)
          .fontSize('16fp')
        Column() {
          if (this.attributesType == AttributesType.BUTTON) {
            Text(this.attributes.buttonFont.style == FontStyle.Normal ? 'Normal' : 'Italic')
              .fontSize('10fp')
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
          } else if (this.attributesType == AttributesType.OPTION) {
            Text(this.attributes.optionFont.style == FontStyle.Normal ? 'Normal' : 'Italic')
              .fontSize('10fp')
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
          } else if (this.attributesType == AttributesType.SELECTEDOPTION) {
            Text(this.attributes.selectedOptionFont.style == FontStyle.Normal ? 'Normal' : 'Italic')
              .fontSize('10fp')
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
          }
        }
        .bindMenu([
          {
            value: 'Normal',
            action: () => {
              if (this.attributesType == AttributesType.BUTTON) {
                this.attributes.buttonFont = new Font(this.attributes.buttonFont.size, this.attributes.buttonFont.weight, this.attributes.buttonFont.family, FontStyle.Normal)
              } else if (this.attributesType == AttributesType.OPTION) {
                this.attributes.optionFont = new Font(this.attributes.optionFont.size, this.attributes.optionFont.weight, this.attributes.optionFont.family, FontStyle.Italic)
              } else if (this.attributesType == AttributesType.SELECTEDOPTION) {
                this.attributes.selectedOptionFont = new Font(this.attributes.selectedOptionFont.size, this.attributes.selectedOptionFont.weight, this.attributes.selectedOptionFont.family, FontStyle.Italic)
              }
            }
          },
          {
            value: 'Italic',
            action: () => {
              if (this.attributesType == AttributesType.BUTTON) {
                this.attributes.buttonFont = new Font(this.attributes.buttonFont.size, this.attributes.buttonFont.weight, this.attributes.buttonFont.family, FontStyle.Italic)
                console.log(`${this.attributes.buttonFont.style}`);
              } else if (this.attributesType == AttributesType.OPTION) {
                this.attributes.optionFont = new Font(this.attributes.optionFont.size, this.attributes.optionFont.weight, this.attributes.optionFont.family, FontStyle.Italic)
              } else if (this.attributesType == AttributesType.SELECTEDOPTION) {
                this.attributes.selectedOptionFont = new Font(this.attributes.selectedOptionFont.size, this.attributes.selectedOptionFont.weight, this.attributes.selectedOptionFont.family, FontStyle.Italic)
              }
            }
          }
        ])
      }
      .width('100%')
      .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
      .borderRadius(24)
      .backgroundColor('#FFFFFF')
      .margin({ top: 8 })
    }
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
