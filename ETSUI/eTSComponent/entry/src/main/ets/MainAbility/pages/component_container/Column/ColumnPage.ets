import prompt from '@system.prompt';

@Entry
@Component
struct ColumnPage {
  @State num1: number[] = [...Array(3).keys()]
  @State num2: number[] = [...Array(4).keys()]
  @State alignItemsId: number = 0
  @State alignItems: HorizontalAlign[] = [HorizontalAlign.Start, HorizontalAlign.Center, HorizontalAlign.End]
  @State alignItemsDescribe: string[] = ['Start', 'Center', 'End']
  @State space: number = 0
  @State useAlign: string = 'Start'
  @State edgeId: number = 0
  @State edge: Edge[] = [Edge.Start, Edge.Center, Edge.End, Edge.Middle]
  @State edgeDescribe: string[] = ['Start', 'Center', 'End', 'Middle']
  @State offset: number = 0

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        if (this.useAlign == 'Start') {
          Column({ space: this.space }) {
            Row() {
            }.width(50).height(50).backgroundColor(Color.Orange)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Yellow)

            Row() {
            }.width(40).height(50).backgroundColor(Color.Green)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Red)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Pink)
          }
          .width(300)
          .height(300)
          .border({ width: 1 })
          .alignItems(this.alignItems[this.alignItemsId])
        } else if (this.useAlign == 'Center') {
          Column({ space: this.space }) {
            Row() {
            }.width(50).height(50).backgroundColor(Color.Orange)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Yellow)

            Row() {
            }.width(50).height(40).backgroundColor(Color.Green)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Red)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Pink)
          }
          .width(300)
          .height(300)
          .border({ width: 1 })
          .alignItems(this.alignItems[this.alignItemsId])
        } else {
          Column({ space: this.space }) {
            Row() {
            }.width(50).height(50).backgroundColor(Color.Orange)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Yellow)

            Row() {
            }.width(50).height(40).backgroundColor(Color.Green)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Red)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Pink)
          }
          .width(300)
          .height(300)
          .border({ width: 1 })
          .alignItems(this.alignItems[this.alignItemsId])
        }
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text('对齐方式')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          ForEach(this.num1, item => {
            GridItem() {
              Button(this.alignItemsDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.alignItemsId = item
                })
            }
          }, item => item.toString())
          GridItem() {
            Text(`space：${this.space}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.space, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width('100%')
              .onChange((e) => {
                this.space = Math.round(e)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Text('自定义纵向对齐方式')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          ForEach(this.num1, item => {
            GridItem() {
              Button(this.alignItemsDescribe[`${item}`])
                .fontSize(15)
                .width('100%')

                .onClick(() => {
                  this.alignItemsId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('Edge位置')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          ForEach(this.num2, item => {
            GridItem() {
              Button(this.edgeDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.edgeId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text(`offset：${this.offset}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.space, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width("100%")
              .onChange((e) => {
                this.offset = Math.round(e)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
        .rowsGap(5)
        .scrollBar(BarState.Auto)
        .margin({bottom:10})
      }.height('60%')
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%').margin({ top: 5})
  }
}