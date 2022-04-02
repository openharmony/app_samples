import prompt from '@system.prompt';

@Entry
@Component
struct SwiperPage {
  SwiperController: SwiperController = new SwiperController()
  @State index: number = 0
  @State interval: number = 2000
  @State duration: number = 1000
  @State itemSpace: number = 0
  @State autoPlay: boolean = true
  @State indicator: boolean = true
  @State loop: boolean = false
  @State vertical: boolean = false
  @State displayMode: SwiperDisplayMode = SwiperDisplayMode.AutoLinear

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Swiper(this.SwiperController) {
          Image($r('app.media.test'))
          Column() {
            Text('Swiper文本1')
              .fontSize(30)
              .textAlign(TextAlign.Center)
              .height('100%')
              .width('100%')
          }
          Column() {
            Text('Swiper文本2')
              .fontSize(30)
              .textAlign(TextAlign.Center)
              .height('100%')
              .width('100%')
          }
          Column() {
            Text('Swiper文本3')
              .fontSize(30)
              .textAlign(TextAlign.Center)
              .height('100%')
              .width('100%')
          }
        }
        .index(this.index)
        .autoPlay(this.autoPlay)
        .interval(this.interval)
        .indicator(this.indicator)
        .loop(this.loop)
        .duration(this.duration)
        .vertical(this.vertical)
        .itemSpace(this.itemSpace)
        .onChange((index: number) => {
          console.info('当前索引：' + index)
        })
      }
      .height('40%')
      .width('90%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text(`当前索引：${this.index}`)
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.itemSpace, step: 1, min: 1, max: 2 })
              .blockColor(Color.Orange)
              .width('100%')
              .showSteps(true)
              .onChange((e) => {
                this.index = Math.round(e)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Text(`播放间隔：${this.interval}`)
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.itemSpace, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width('100%')
              .showSteps(true)
              .onChange((e) => {
                this.interval = Math.round(e)*1000
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Text(`切换间隔：${this.duration}`)
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.itemSpace, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width('100%')
              .showSteps(true)
              .onChange((e) => {
                this.duration = Math.round(e)*1000
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Text(`组件间隙：${this.itemSpace}`)
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.itemSpace, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width('100%')
              .showSteps(true)
              .onChange((e) => {
                this.itemSpace = Math.round(e)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Text('自动播放:')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }

          GridItem() {
            Button(`${this.autoPlay}`)
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.autoPlay = !this.autoPlay
              })
          }

          GridItem() {
            Text('循环播放:')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }

          GridItem() {
            Button(`${this.loop}`)
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.loop = !this.loop
              })
          }

          GridItem() {
            Text('导航指示:')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }

          GridItem() {
            Button(`${this.indicator}`)
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.indicator = !this.indicator
              })
          }

          GridItem() {
            Text('纵向滑动:')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }

          GridItem() {
            Button(`${this.vertical}`)
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.vertical = !this.vertical
              })
          }

          GridItem() {
            Text('呈现方式:')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(0).forceRebuild(true)

          GridItem() {
            Button('Stretch')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.displayMode = SwiperDisplayMode.Stretch
              })
          }

          GridItem() {
            Button('AutoLinear')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.displayMode = SwiperDisplayMode.AutoLinear
              })
          }

          GridItem() {
            Text('控制器:')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.rowStart(11).columnStart(0).columnEnd(0).forceRebuild(true)

          GridItem() {
            Button('翻至下一页')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.SwiperController.showNext()
              })
          }.rowStart(11).columnStart(1).columnEnd(1)

          GridItem() {
            Button('翻至上一页')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.SwiperController.showPrevious()
              })
          }.rowStart(11).columnStart(2).columnEnd(2)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(10)
        .rowsGap(5)
        .scrollBar(BarState.Auto)
      }
      .height('60%')
      .width('100%')
      .margin({top:10})
    }
    .width('100%').margin({ top: 5,bottom:10 })
  }
}