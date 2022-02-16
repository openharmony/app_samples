import prompt from '@system.prompt';

class AppInfo {
  src: string;
  name: string;

  constructor(src: string, name: string) {
    this.src = src
    this.name = name
  }
}

@Entry
@Component
struct GridPage {
  private mItemInfoList: AppInfo[] = [
    new AppInfo('/common/system/huawei_music.png', '音乐'),
    new AppInfo('/common/system/huawei_himovie.png', '视频'),
    new AppInfo('/common/system/huawei_browser.png', '浏览器'),
    new AppInfo('/common/system/huawei_appmarket.png', '应用市场'),
    new AppInfo('/common/system/huawei_calendar.png', '日历'),
    new AppInfo('/common/system/huawei_meetime.png', '畅连'),
    new AppInfo('/common/system/android_FMRadio.png', '收音机'),
    new AppInfo('/common/system/vmall_client.png', '智慧生活'),
    new AppInfo('/common/system/android_settings.png', '华为商城'),
    new AppInfo('/common/system/android_notepad.png', '备忘录'),
    new AppInfo('/common/system/android_deskclock.png', '时钟'),
    new AppInfo('/common/system/android_mms.png', '短信'),
    new AppInfo('/common/system/huawei_mycenter.png', '服务'),
    new AppInfo('/common/system/huawei_camera.png', '相机'),
    new AppInfo('/common/system/huawei_calendar.png', '日历'),
    new AppInfo('/common/system/android_calculator2.png', '计算器'),
    new AppInfo('/common/system/huawei_gamebox.png', '游戏中心'),
    new AppInfo('/common/system/huawei_health.png', '运动健康'),
    new AppInfo('/common/system/huawei_wallet.png', '钱包'),
    new AppInfo('/common/system/huawei_systemmanager.png', '安全中心'),
    new AppInfo('/common/system/huawei_photos.png', '图库'),
    new AppInfo('/common/system/android_DialtactsActivity.png', '通话'),
    new AppInfo('/common/system/huawei_contacts.png', '联系人'),
    new AppInfo('/common/system/huawei_compass.png', '指南针'),
    new AppInfo('/common/system/android_totemweather.png', '天气'),
    new AppInfo('/common/system/android_email.png', '邮件'),
    new AppInfo('/common/system/huawei_educenter.png', '教育中心'),
    new AppInfo('/common/system/android_tips.png', '玩机技巧'),
  ]
  @State num1: number[] = [...Array(3).keys()]
  @State num2: number[] = [...Array(4).keys()]
  @State num3: number[] = [...Array(6).keys()]
  @State cols: number = 2
  @State rows: number = 0
  @State ColTemplate: string = '1fr 1fr'
  @State RowTemplate: string = ''
  @State columnsGap: number = 0
  @State rowsGap: number = 0
  @State barWidth: number = 0
  @State barHeight: number = 0
  @State scrollBarId: number = 0
  @State scrollBar: BarState[] = [BarState.Auto, BarState.Off, BarState.On]
  @State scrollBarDescribe: string[] = ['Auto', 'Off', 'On']
  @State isScrollBar: boolean = true

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Grid() {
          ForEach(this.mItemInfoList, (item) => {
            GridItem() {
              Column() {
                Image(item.src)
                  .objectFit(ImageFit.Contain)
                  .height(50)
              }
            }.border({ width: 1 }).height(60)
          }, item => item.toString())
        }.margin(5)
        .columnsTemplate(this.ColTemplate)
        .rowsTemplate(this.RowTemplate)
        .columnsGap(this.columnsGap)
        .rowsGap(this.rowsGap)
        .scrollBarWidth(this.barWidth)
        .scrollBarColor(this.barHeight)
        .scrollBar(BarState.Auto)
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Row() {
          Text(`布局列数：${this.cols}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .height(40)
            .fontWeight(FontWeight.Bolder)
            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.cols, step: 1, min: -1, max: 9 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.cols = Math.round(e)
                this.ColTemplate = '1fr '.repeat(this.cols)
              })
          }
          .width('70%')
          .margin({ top: 2, bottom: 2 })
        }

        Row() {
          Text(`布局行数：${this.rows}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .height(40)
            .fontWeight(FontWeight.Bolder)
            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.rows, step: 1, min: -1, max: 9 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.rows = Math.round(e)
                if (this.rows == 0) {
                  this.RowTemplate = null
                } else {
                  this.RowTemplate = '1fr '.repeat(this.rows)
                }
              })
          }
          .width('70%')
          .margin({ top: 2, bottom: 2 })
        }

        Row() {
          Text(`行与行间距：${this.rowsGap}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .height(40)
            .fontWeight(FontWeight.Bolder)
            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.rowsGap, step: 1, min: -1, max: 9 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.rowsGap = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 2, bottom: 2 })
        }

        Row() {
          Text(`列与列间距：${this.columnsGap}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .height(40)
            .fontWeight(FontWeight.Bolder)
            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.columnsGap, step: 1, min: -1, max: 9 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.columnsGap = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 2, bottom: 2 })
        }

        Row() {
          Text('滚动条状态：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .height(40)
            .fontWeight(FontWeight.Bolder)
            .width('30%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            ForEach(this.num1, item => {
              Button(this.scrollBarDescribe[`${item}`])
                .fontSize(15)
                .width(90)
                .onClick(() => {
                  this.scrollBarId = item
                  if (item != 1) {
                    this.isScrollBar = true
                  } else {
                    this.isScrollBar = false
                  }
                })
            }, item => item.toString())
          }
          .margin({ top: 2, bottom: 2 })
          .width('70%')
        }

        if (this.isScrollBar) {
          Row() {
            Text(`滚动条宽度：${this.barWidth}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('30%')
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
              Slider({ value: this.barWidth, step: 1, min: -1, max: 9 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.barWidth = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 2, bottom: 2 })
          }

          Row() {
            Text(`滚动条高度：${this.barHeight}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('30%')
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
              Slider({ value: this.barHeight, step: 1, min: -1, max: 9 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.barHeight = Math.round(e)
                })
            }
            .width('70%')
            .margin({ top: 2, bottom: 2 })
          }
        }
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 10 })
    }
    .width('100%')
  }
}