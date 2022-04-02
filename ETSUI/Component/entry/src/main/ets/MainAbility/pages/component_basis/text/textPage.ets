@Entry
@Component
struct TextPage {
  scroller: Scroller = new Scroller()
  @State value: string = 'This framework is a framework for application development based on front-end development technology stacks. It adopts popular front-end development models and fits the thinking habits of mainstream front-end developers.'
  @State temporary: string = ''
  @State textAlignId: number = 0
  @State textAlign: TextAlign[] = [TextAlign.Start, TextAlign.End, TextAlign.Center]
  @State textAlignDescribe: string[] = ['Start', 'End', 'Center']
  @State textOverflowId: number = 0
  @State textOverflow: TextOverflow[] = [TextOverflow.Clip, TextOverflow.Ellipsis, TextOverflow.None]
  @State textOverflowDescribe: string[] = ['Clip', 'Ellipsis', 'None']
  @State decorationId: number = 0
  @State decoration: TextDecorationType[] = [TextDecorationType.Underline, TextDecorationType.LineThrough, TextDecorationType.Overline, TextDecorationType.None]
  @State decorationDescribe: string[] = ['Underline', 'LineThrough', 'Overline', 'None']
  @State num1: number[] = [...Array(3).keys()]
  @State num2: number[] = [...Array(4).keys()]
  @State lines: number = 5
  @State lineHeight: number = 40
  @State colorId: number = 0
  @State color: Color[] = [Color.Green, Color.Orange, Color.Pink, Color.Yellow]
  @State colorDescribe: string[] = ['Green', 'Orange', 'Pink', 'Yellow']
  @State baselineOffset: number = 0
  @State textCaseId: number = 0
  @State textCase: TextCase[]= [TextCase.Normal, TextCase.LowerCase, TextCase.UpperCase]
  @State textCaseDescribe: string[]= ["Normal", "LowerCase", "UpperCase"]

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Scroll() {
          Text(this.value)
            .fontSize(30)
            .textAlign(this.textAlign[this.textAlignId])
            .textOverflow({ overflow: this.textOverflow[this.textOverflowId] })
            .maxLines(this.lines)
            .lineHeight(this.lineHeight)
            .decoration({ type: this.decoration[this.decorationId], color: this.color[this.colorId] })
            .baselineOffset(this.baselineOffset)
            .textCase(this.textCase[this.textCaseId])
        }
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Scroll(this.scroller) {
        Column() {
          Row() {
            Text(`maxLines：${this.lines}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.lines, step: 1, min: -1, max: 15 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.lines = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }

          Row() {
            Text(`lineHeight：${this.lineHeight}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.lineHeight, step: 1, min: -1, max: 99 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.lineHeight = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }

          Row() {
            Text(`baselineOffset：${this.baselineOffset}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.baselineOffset, step: 1, min: -1, max: 99 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.baselineOffset = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }

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
                  this.value = this.temporary
                  this.temporary = ''
                })
                .onEditChanged((isEditing) => {
                  console.log('www data  ' + JSON.stringify(isEditing))
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }

          Column() {
            Text('多行文本对齐：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num1, item => {
                Button(this.textAlignDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(120)
                  .onClick(() => {
                    this.textAlignId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('超长文本显示方式：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num1, item => {
                Button(this.textOverflowDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(120)
                  .onClick(() => {
                    this.textOverflowId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('文本装饰线样式：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num2, item => {
                Button(this.decorationDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(120)
                  .onClick(() => {
                    this.decorationId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('文本装饰线颜色：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num2, item => {
                Button(this.colorDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(120)
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
            Text('文本大小写：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num1, item => {
                Button(this.textCaseDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(120)
                  .onClick(() => {
                    this.textCaseId = item
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
      .height("60%")
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(10)
    }.width('100%')
  }
}