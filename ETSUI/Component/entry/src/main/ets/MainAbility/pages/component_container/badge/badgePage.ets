// @ts-nocheck
import  image  from '@ohos.multimedia.image_napi_plugin';
import fileio from '@ohos.fileio';

@Entry
@Component
struct BadgeItemExample {
  @State type: string = 'Number'
  @State temporary: string = ''
  @State value: string = ''
  @State num1: number[] = [...Array(3).keys()]
  @State num2: number[] = [...Array(4).keys()]
  @State count: number = 10
  @State maxCount: number = 100
  @State positionId: number = 0
  @State position: BadgePosition[] = [BadgePosition.Right, BadgePosition.RightTop, BadgePosition.Left]
  @State positionDescribe: string[] = ['Right', 'RightTop', 'Left']
  @State colorId: number = 2
  @State color: Color[] = [Color.Green, Color.Orange, Color.Pink, Color.Yellow]
  @State colorDescribe: string[] = ['Green', 'Orange', 'Red', 'Yellow']
  @State fontSize: number = 12
  @State badgeSize: number = 30
  @State badgeColorId: number = 0

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        if (this.type == 'Number') {
          Badge({
            count: this.count,
            maxCount: this.maxCount,
            position: this.position[this.positionId],
            style: {
              color: this.color[this.colorId],
              fontSize: this.fontSize,
              badgeSize: this.badgeSize,
              badgeColor: this.color[this.badgeColorId]
            }
          }) {
            Row() {
            }
            .width(200).height(200)
            .border({ width: 2, radius: 10 })
          }
          .width(200).height(200)
        } else {
          Badge({
            value: this.value,
            position: this.position[this.positionId],
            style: {
              color: this.color[this.colorId],
              fontSize: this.fontSize,
              badgeSize: this.badgeSize,
              badgeColor: this.color[this.badgeColorId]
            }
          }) {
            Row() {
            }
            .width(200).height(200)
            .border({ width: 2, radius: 10 })
          }
          .width(200).height(200)
        }
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Row() {
        Text('提示类型：')
          .height(40)
          .backgroundColor(0xFAEEE0)
          .fontSize(15)
          .fontWeight(FontWeight.Bolder)
          .margin({ left: 5 })
          .width('23%')
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
          Button('String')
            .fontSize(15)
            .width('100%')
            .onClick(() => {
              this.type = 'String'
            })
          Button('Number')
            .fontSize(15)
            .width('100%')
            .onClick(() => {
              this.type = 'Number'
            })
        }
        .margin({ top: 2, bottom: 2 })
        .width('75%')
      }

      if (this.type == 'String') {
        Grid() {
          GridItem() {
            Text('文本内容')
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontSize(15)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            TextInput({ placeholder: '', text: this.temporary })
              .enterKeyType(EnterKeyType.Send)
              .placeholderFont({ size: 12 })
              .height(40)
              .border({ width: 3, radius: 20, color: '#88000000' })
              .onChange((value) => {
                this.temporary = value
              })
              .onSubmit(() => {
                this.value = this.temporary
                this.temporary = ''
              })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Text('提醒消息数')
              .backgroundColor(0xFAEEE0)
              .fontSize(15)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Slider({ value: this.count, step: 1, min: -1, max: this.maxCount + 50 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.count = Math.round(e)
              })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Text('最大消息数')
              .backgroundColor(0xFAEEE0)
              .fontSize(15)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Slider({ value: this.maxCount, step: 1, min: -1, max: 1000 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.maxCount = Math.round(e)
              })
          }.columnStart(0).columnEnd(1).forceRebuild(true)
        }.columnsTemplate('1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
      }

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text('文本大小：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(3)

          GridItem() {
            Slider({ value: this.fontSize, step: 1, min: -1, max: 100 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.fontSize = Math.round(e)
              })
          }.columnStart(0).columnEnd(3)

          GridItem() {
            Text('badge大小：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(3)

          GridItem() {
            Slider({ value: this.fontSize, step: 1, min: -1, max: 200 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.badgeSize = Math.round(e)
              })
          }.columnStart(0).columnEnd(3)

          GridItem() {
            Text('提示点显示位置')
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
              Button(this.positionDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.positionId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('文本颜色:')
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
              Button(this.colorDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.colorId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('badge颜色:')
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
              Button(this.colorDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.badgeColorId = item
                })
            }
          }, item => item.toString())

        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
        .rowsGap(5)
        .scrollBarWidth(this.barWidth)
        .scrollBar(BarState.Auto)
      }.height('45%')
      .width('100%')
    }.width('100%').margin({ top: 5 })
  }
}

