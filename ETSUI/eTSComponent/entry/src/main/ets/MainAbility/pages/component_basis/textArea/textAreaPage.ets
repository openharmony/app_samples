import prompt from '@system.prompt';

@Entry
@Component
struct TextAreaPage {
  scroller: Scroller = new Scroller()
  @State num1: number[] = [...Array(6).keys()]
  @State num2: number[] = [...Array(4).keys()]
  @State num3: number[] = [...Array(3).keys()]
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

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        TextArea({ placeholder: this.placeholder, text: this.text })
          .placeholderColor(this.color[this.colorId])
          .placeholderFont({
            size: this.size,
            weight: this.isNumber == true ? this.fontWeight : this.fontWeights[this.fontWeightId],
            style: this.fontStyle
          })
          .textAlign(this.textAlign[this.textAlignId])
          .caretColor(this.color[this.caretColorId])
          .onChange((value) => {
            prompt.showToast({
              message: 'value：' + value
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
                .height(40)
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
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
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
                .height(40)
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
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
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
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }

          Column() {
            Text('placeholder颜色：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num2, item => {
                Button(this.colorDescribe[`${item}`])
                  .margin({right:10})
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.colorId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('字体样式：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Button('Normal')
                .margin({right:10})
                .fontSize(15)
                .width(90)
                .onClick(() => {
                  this.fontStyle = FontStyle.Normal
                })
              Button('Italic')
                .fontSize(15)
                .width(90)
                .onClick(() => {
                  this.fontStyle = FontStyle.Italic
                })
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Column() {
              Text('fontWeight：')
                .fontSize(15)
                .backgroundColor(0xFAEEE0)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Bolder)
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
                Button('Number')
                  .margin({right:10})
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.isNumber = true
                  })
                Button('String')
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.isNumber = false
                  })
              }
              .width('100%')
              .margin({ top: 5, bottom: 5 ,left:10,right:10})
            }
            .alignItems(HorizontalAlign.Start)

            if (!this.isNumber) {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
                ForEach(this.num1, item => {
                  Button(this.fontWeightDescribe[`${item}`])
                    .margin({right:10})
                    .fontSize(15)
                    .width(90)
                    .onClick(() => {
                      this.fontWeightId = item
                    })
                }, item => item.toString())
              }
              .width('100%')
              .margin({ top: 5, bottom: 5 ,left:10,right:10})
            } else {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Start }) {
                Slider({ value: this.fontWeight, step: 100, min: -100, max: 1000 })
                  .blockColor(Color.Orange)
                  .width('100%')
                  .onChange((e) => {
                    this.fontWeight = Math.round(e)
                  })
                Text(`${this.fontWeight}`)
                  .fontSize(15)
              }
              .width('100%')
              .margin({ top: 5, bottom: 5 ,left:10,right:10})
            }
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('文本水平对齐方式：')
              .fontSize(12)
              .backgroundColor(0xFAEEE0)
              .width('90%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num3, item => {
                Button(this.textAlignDescribe[`${item}`])
                  .margin({right:10})
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.textAlignId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('光标颜色：')
              .fontSize(12)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num2, item => {
                Button(this.colorDescribe[`${item}`])
                  .margin({right:10})
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.caretColorId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
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