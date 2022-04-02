import prompt from '@system.prompt';

@Entry
@Component
struct SliderPage {
  scroller: Scroller = new Scroller()
  @State num1: number[] = [...Array(4).keys()]
  @State currentValue: number = 10
  @State min: number = 0
  @State max: number = 100
  @State step: number = 1
  @State SliderStyleId: number = 0
  @State SliderStyles: SliderStyle[] = [SliderStyle.OutSet, SliderStyle.InSet]
  @State blockId: number = 0
  @State trackId: number = 1
  @State selectedId: number = 2
  @State sliderColor: Color[] = [Color.Green, Color.Orange, Color.Pink, Color.Yellow]
  @State colorDescribe: string[] = ['Green', 'Orange', 'Pink', 'Yellow']
  @State showSteps: boolean = false
  @State showTips: boolean = false

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text(`${this.currentValue}`)
          .fontSize(20)
        Slider({
          value: this.currentValue,
          min: this.min,
          max: this.max,
          step: this.step,
          style: this.SliderStyles[this.SliderStyleId]
        })
          .blockColor(this.sliderColor[this.blockId])
          .trackColor(this.sliderColor[this.trackId])
          .selectedColor(this.sliderColor[this.selectedId])
          .showSteps(this.showSteps)
          .showTips(this.showTips)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.currentValue = Math.round(value)
            prompt.showToast({
              message: 'value：' + value + ',mode：' + mode,
              duration: 2000
            })
          })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Scroll(this.scroller){
        Column() {
          Row() {
            Text(`当前进度：${this.currentValue}`)
              .fontSize(12)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.currentValue, step: 1, min: -1, max: this.max })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.currentValue = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }

          Row() {
            Text(`最小值：${this.min}`)
              .fontSize(12)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.min, step: 1, min: -1, max: 20 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.min = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }

          Row() {
            Text(`最大值：${this.max}`)
              .fontSize(12)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.max, step: 1, min: -1, max: 500 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.max = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }

          Row() {
            Text(`滑动跳动值：${this.step}`)
              .fontSize(12)
              .backgroundColor(0xFAEEE0)
              .width('30%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.step, step: 1, min: -1, max: 20 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.step = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }

          Column() {
            Text('滑块样式：')
              .fontSize(12)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Button('Outset')
                .margin({right:10})
                .fontSize(15)
                .width(90)
                .onClick(() => {
                  this.SliderStyleId = 0
                })
              Button('Inset')
                .margin({right:10})
                .fontSize(15)
                .width(90)
                .onClick(() => {
                  this.SliderStyleId = 1
                })
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }
          .alignItems(HorizontalAlign.Start)
          Column(){
            Text('滑块颜色：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num1, item => {
                Button(this.colorDescribe[`${item}`])
                  .margin({right:10})
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.blockId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }
          .alignItems(HorizontalAlign.Start)
          Column(){
            Text('滑轨背景颜色：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num1, item => {
                Button(this.colorDescribe[`${item}`])
                  .margin({right:10})
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.trackId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }
          .alignItems(HorizontalAlign.Start)
          Column(){
            Text('已滑动颜色：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start}) {
              ForEach(this.num1, item => {
                Button(this.colorDescribe[`${item}`])
                  .margin({right:10})
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.selectedId = item
                  })
              }, item => item.toString())
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }
          .alignItems(HorizontalAlign.Start)

          Column(){
            Text('显示刻度：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start}) {
              Button(`${this.showSteps}`)
                .margin({right:2})
                .fontSize(15)
                .width(90)
                .onClick(() => {
                  this.showSteps = !this.showSteps
                })
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
          }
          .alignItems(HorizontalAlign.Start)
          Column() {
            Text('显示气泡：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Button(`${this.showTips}`)
                .margin({right:10})
                .fontSize(15)
                .width(90)
                .onClick(() => {
                  this.showTips = !this.showTips
                })
            }
            .width('90%')
            .margin({ top: 5, bottom: 5 ,left:10,right:10})
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
    }
    .width('100%')
  }
}