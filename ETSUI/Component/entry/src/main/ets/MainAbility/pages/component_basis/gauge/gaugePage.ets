import prompt from '@system.prompt';

@Entry
@Component
struct GaugePage {
  @State value: number = 60
  @State min: number = 0
  @State max: number = 360
  @State startAngle: number = 0
  @State endAngle: number = 360
  @State strokeWidth: number = 5

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Gauge({ value: this.value, min: this.min, max: this.max })
          .width('100%')
          .height('90%')
          .startAngle(this.startAngle)
          .endAngle(this.endAngle)
          .colors([
            [Color.Red, 0.5],
            [Color.Blue, 0.5],
            [Color.Yellow, 0.5]
          ])
          .strokeWidth(this.strokeWidth)
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Row() {
          Text(`当前数据值：${this.value}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.value, step: 1, min: -1, max: this.max })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.value = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Row() {
          Text(`当前数据段最小值：${this.min}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.min, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.min = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Row() {
          Text(`当前数据段最大值：${this.max}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.max, step: 1, min: -1, max: 365 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.max = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Row() {
          Text(`起始角度：${this.startAngle}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.startAngle, step: 1, min: -360, max: 360 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.startAngle = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Row() {
          Text(`终止角度：${this.endAngle}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.endAngle, step: 1, min: -36, max: 360 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.endAngle = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 20 })
    }
    .width('100%')
  }
}