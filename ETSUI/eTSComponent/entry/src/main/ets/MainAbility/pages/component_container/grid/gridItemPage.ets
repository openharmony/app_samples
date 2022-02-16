import prompt from '@system.prompt';

class AppInfoItem {
  src: string;
  name: string;

  constructor(src: string, name: string) {
    this.src = src
    this.name = name
  }
}

@Entry
@Component
struct GridItemPage {
  private mItemInfoList: AppInfoItem[] = [
    new AppInfoItem('/common/system/huawei_music.png', '音乐'),
    new AppInfoItem('/common/system/huawei_himovie.png', '视频'),
    new AppInfoItem('/common/system/huawei_browser.png', '浏览器'),
    new AppInfoItem('/common/system/huawei_appmarket.png', '应用市场'),
    new AppInfoItem('/common/system/huawei_calendar.png', '日历'),
    new AppInfoItem('/common/system/huawei_meetime.png', '畅连'),
    new AppInfoItem('/common/system/android_FMRadio.png', '收音机'),
    new AppInfoItem('/common/system/vmall_client.png', '智慧生活'),
    new AppInfoItem('/common/system/android_email.png', '邮件'),
  ]
  @State rowStart: number = 0
  @State rowEnd: number = 0
  @State columnStart: number = 0
  @State columnEnd: number = 0
  @State forceRebuild: boolean = false
  @State num: number = 1

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Grid() {
          GridItem(){
            Column(){}
            .backgroundColor(Color.Orange)
            .width(100)
            .height(100)
          }
          .rowStart(this.rowStart)
          .rowEnd(this.rowEnd)
          .columnStart(this.columnStart)
          .columnEnd(this.columnEnd)
          .forceRebuild(this.forceRebuild)
          ForEach(this.mItemInfoList, (item) => {
            GridItem() {
              Column() {
                Image(item.src)
                  .objectFit(ImageFit.Contain)
              }
            }
            .border({ width: 1, color:'#30000000'})
          }, item => item.toString())
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr')
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Row() {
          Text(`起始行号：${this.rowStart}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .height(40)
            .fontWeight(FontWeight.Bolder)
            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.rowStart, step: 1, min: -1, max: 2 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.rowStart = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 2, bottom: 2 })
        }

        Row() {
          Text(`终点行号：${this.rowEnd}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .height(40)
            .fontWeight(FontWeight.Bolder)
            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.rowEnd, step: 1, min: -1, max: 2 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.rowEnd = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 2, bottom: 2 })
        }

        Row() {
          Text(`起始列号：${this.columnStart}`)
            .fontSize(15)
            .fontWeight(FontWeight.Bolder)
            .backgroundColor(0xFAEEE0)
            .height(40)

            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.columnStart, step: 1, min: -1, max: 2 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.columnStart = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 2, bottom: 2 })
        }

        Row() {
          Text(`终止列号：${this.columnEnd}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .height(40)
            .fontWeight(FontWeight.Bolder)
            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.columnEnd, step: 1, min: -1, max: 2 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.columnEnd = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 2, bottom: 2 })
        }

        Row() {
          Text('是否重建节点：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .height(40)
            .fontWeight(FontWeight.Bolder)
            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround,alignItems:ItemAlign.Center }) {
            Button('true')
              .fontSize(15)
              .margin({right:10})
              .width(90)
              .onClick(() => {
                this.forceRebuild = true
              })
            Button('false')
              .fontSize(15)
              .margin({right:10})
              .width(90)
              .onClick(() => {
                this.forceRebuild = false
              })
            Text(`${this.num}`)
            Button('++++')
              .fontSize(15)
              .width(90)
              .onClick(() => {
                this.num++
              })
          }
          .margin({ top: 2, bottom: 2 })
          .width('70%')
        }
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 10 })
    }
    .width('100%')
  }
}