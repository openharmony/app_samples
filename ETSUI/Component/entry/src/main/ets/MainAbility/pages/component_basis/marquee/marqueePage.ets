import prompt from '@system.prompt';

@Entry
@Component
struct MarqueePage {
  @State start: boolean = true
  @State step: number = 30
  @State loop: number = -1
  @State fromStart: boolean = true
  @State src: string = ''
  @State temporary: string = ''

  build() {
    Column() {
      Column() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Marquee({
            start: this.start,
            step: this.step,
            loop: this.loop,
            fromStart: this.fromStart,
            src: this.src
          })
            .fontSize(15)
            .onStart(() => {
              prompt.showToast({
                message: '开始滚动',
                duration: 2000
              })
            })
            .onBounce(() => {
              prompt.showToast({
                message: '滚动到底',
                duration: 2000
              })
            })
            .onFinish(() => {
              prompt.showToast({
                message: '滚动完成',
                duration: 2000
              })
            })
        }
        .height('40%')
        .width('100%')
        .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })
      }

      Column() {
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
                this.src = this.temporary
                this.temporary = ''
              })
              .onEditChanged((isEditing) => {
                console.log('www data  ' + JSON.stringify(isEditing))
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Column() {
          Text('是否播放：')
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
                this.start = true
              })
            Button('false')
              .margin({right:10})
              .fontSize(15)
              .width(90)
              .onClick(() => {
                this.start = false
              })
          }
          .width('95%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }
        .alignItems(HorizontalAlign.Start)

        Row() {
          Text(`滚动步长：${this.step}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('30%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Slider({ value: this.step, step: 1, min: -10, max: 100 })
              .blockColor(Color.Orange)
              .height(40)
              .onChange((e) => {
                this.step = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Row() {
          Text(`滚动次数：${this.loop}`)
            .fontSize(15)
            .width('30%')
            .backgroundColor(0xFAEEE0)
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Slider({ value: this.loop, step: 1, min: -5, max: 15 })
              .height(40)
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.loop = Math.round(e)
              })
          }
          .width('70%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }

        Column() {
          Text('滚动方向：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start}) {
            Button('true')
              .fontSize(15)
              .margin({right:10})
              .width(90)
              .onClick(() => {
                this.start = true
              })
            Button('false')
              .margin({right:10})
              .fontSize(15)
              .width(90)
              .onClick(() => {
                this.start = false
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
    .width('100%')
  }
}