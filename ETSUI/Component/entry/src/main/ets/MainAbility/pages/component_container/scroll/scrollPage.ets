import prompt from '@system.prompt';

@Entry
@Component
struct ScrollPage {
  scroller: Scroller = new Scroller()
  @State scrollNum: number[] = [...Array(100).keys()]
  @State num1: number[] = [...Array(3).keys()]
  @State num2: number[] = [...Array(4).keys()]
  @State scrollableId: number = 1
  @State scrollable: ScrollDirection[] = [ScrollDirection.Horizontal, ScrollDirection.Vertical, ScrollDirection.None]
  @State scrollableDescribe: string[] = ['Horizontal', 'Vertical', 'None']
  @State barStateId: number = 1
  @State barState: BarState[] = [BarState.Off, BarState.On, BarState.Auto]
  @State barStateDescribe: string[] = ['Horizontal', 'Vertical', 'None']
  @State colorId: number = 0
  @State color: Color[] = [Color.Green, Color.Orange, Color.Pink, Color.Yellow]
  @State colorDescribe: string[] = ['Green', 'Orange', 'Pink', 'Yellow']
  @State scrollWidth: number = 20

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Scroll(this.scroller) {
          Column() {
            ForEach(this.scrollNum, (item) => {
              Row() {
                Text(`${item}`)
                  .fontSize(20)
              }
              .height(50)
              .width('100%')
              .backgroundColor(Color.Orange)
              .margin(10)
              .border({ radius: 10 })
            }, item => item.toString())
          }.padding(10)
        }
        .scrollable(this.scrollable[this.scrollableId])
        .scrollBar(this.barState[this.barStateId])
        .scrollBarWidth(this.scrollWidth)
        .scrollBarColor(this.color[this.colorId])
        .onScroll((xOffset: number, yOffset: number) => {
          console.log('yOffset:' + yOffset)
        })
        .onScrollEdge((side) => {
          console.info('side:' + side)
        })
        .onScrollEnd(() => {
          console.info('滑动停止')
        })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text('滚动方法：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          ForEach(this.num1, item => {
            GridItem() {
              Button(this.scrollableDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.scrollableId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('滚动条状态：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          ForEach(this.num1, item => {
            GridItem() {
              Button(this.barStateDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.barStateId = item
                })
            }
          }, item => item.toString())
          GridItem() {
            Text('滚动条颜色：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          ForEach(this.num2, item => {
            GridItem() {
              Button(this.colorDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.colorId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text(`scrollWidth：${this.scrollWidth}`)
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.scrollWidth, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width("100%")
              .onChange((e) => {
                this.scrollWidth = Math.round(e)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Button('滑动到指定位置')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.scroller.scrollTo({
                  xOffset: 0,
                  yOffset: 200,
                  animation: {
                    duration: 1000,
                    curve: Curve.Linear
                  }
                })
              })
          }

          GridItem() {
            Button('滑动到容器边缘')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.scroller.scrollEdge(Edge.End)
              })
          }

          GridItem() {
            Button('滑动到下一页')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.scroller.scrollPage({
                  next: true,
                  direction: Axis.Vertical
                })
              })
          }

          GridItem() {
            Button('滑动偏移量')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.scroller.scrollTo({
                  xOffset: 0,
                  yOffset: this.scroller.currentOffset()
                  .yOffset + 150
                })
              })
          }
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
        .rowsGap(5)
        .scrollBar(BarState.Auto)
        .onScrollIndex((e) => {
          console.info('www data ' + String(e))
        })
        .margin({bottom:10})
      }
      .height('60%')
      .width('100%')
      .margin({ top: 10})
    }
    .width('100%').margin({ top: 5 })
  }
}

