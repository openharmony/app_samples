import prompt from '@system.prompt';

@Entry
@Component
struct RatingPage {
  @State rating: number = 2
  @State indicator: boolean = false
  @State stars: number = 5
  @State stepSize: number = 0.5
  @State backgroundUriId: number = -1
  @State foregroundUriId: number = -1
  @State secondaryUriId: number = -1
  @State backgroundUri: string[] = ['/common/star/star-1-1.png', '/common/star/star-2-1.png', '/common/star/star-3-1.png', '/common/star/star-4-1.png']
  @State foregroundUri: string[] = ['/common/star/star-1-3.png', '/common/star/star-2-3.png', '/common/star/star-3-3.png', '/common/star/star-4-3.png']
  @State secondaryUri: string[] = ['/common/star/star-1-2.png', '/common/star/star-2-2.png', '/common/star/star-3-2.png', '/common/star/star-4-2.png']

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Rating({ rating: this.rating, indicator: this.indicator })
          .stars(this.stars)
          .stepSize(this.stepSize)
          .starStyle({
            backgroundUri: this.backgroundUri[this.backgroundUriId],
            foregroundUri: this.foregroundUri[this.foregroundUriId],
            secondaryUri: this.secondaryUri[this.secondaryUriId]
          })
          .onChange((value) => {
            prompt.showToast({
              message: 'value：' + value
            })
          })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Row() {
          Text(`评分值：${this.rating}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Slider({ value: this.rating, step: this.stepSize, min: -1, max: 6 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.rating = Number(e)
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Row() {
          Text(`评星总数：${this.stars}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.stars, step: this.stepSize, min: -1, max: 10 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.stars =Math.round((Number(e))*100)/100
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Row() {
          Text(`评级步长：${this.stepSize}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
            Slider({ value: this.stepSize, step: 0.1, min: -1, max: 6 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.stepSize = Number(e)
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Column() {
          Text('是否为指示器：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Button('true')
              .margin({right:10})
              .fontSize(15)
              .width(90)
              .onClick(() => {
                this.indicator = true
              })
            Button('false')
              .fontSize(15)
              .width(90)
              .onClick(() => {
                this.indicator = false
              })
          }
          .width('90%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }
        .alignItems(HorizontalAlign.Start)

        Row() {
          Text(`未选中图片:${this.backgroundUriId}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Image($r('app.media.add'))
              .margin({right:10})
              .width(30).height(30).objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.backgroundUriId >= 3) {
                  this.backgroundUriId = 3
                } else {
                  this.backgroundUriId += 1
                }
              })
            Image($r('app.media.cut'))
              .margin({right:10})
              .width(30).height(30).objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.backgroundUriId <= 0) {
                  this.backgroundUriId = 0
                } else {
                  this.backgroundUriId -= 1
                }
              })
            Image($r('app.media.reset'))
              .width(30).height(30).objectFit(ImageFit.Contain)
              .onClick(() => {
                this.backgroundUriId = -1
              })
          }.width('70%')
        }

        Row() {
          Text(`已选中图片:${this.foregroundUriId}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Image($r('app.media.add'))
              .margin({right:10})
              .width(30).height(30).objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.foregroundUriId >= 3) {
                  this.foregroundUriId = 3
                } else {
                  this.foregroundUriId += 1
                }
              })
            Image($r('app.media.cut'))
              .margin({right:10})
              .width(30).height(30).objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.foregroundUriId <= 0) {
                  this.foregroundUriId = 0
                } else {
                  this.foregroundUriId -= 1
                }
              })
            Image($r('app.media.reset'))
              .margin({right:2})
              .width(30).height(30).objectFit(ImageFit.Contain)
              .onClick(() => {
                this.foregroundUriId = -1
              })
          }.width('70%')
        }

        Row() {
          Text(`部分选中图片:${this.secondaryUriId}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Image($r('app.media.add'))
              .margin({right:10})
              .width(30).height(30).objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.secondaryUriId >= 3) {
                  this.secondaryUriId = 3
                } else {
                  this.secondaryUriId += 1
                }
              })
            Image($r('app.media.cut'))
              .margin({right:10})
              .width(30).height(30).objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.secondaryUriId <= 0) {
                  this.secondaryUriId = 0
                } else {
                  this.secondaryUriId -= 1
                }
              })
            Image($r('app.media.reset'))
              .width(30).height(30).objectFit(ImageFit.Contain)
              .onClick(() => {
                this.secondaryUriId = -1
              })
          }.width('70%')
        }
      }.alignItems(HorizontalAlign.Start)
      .margin({ top: 20 })
    }
    .width('100%')
  }
}