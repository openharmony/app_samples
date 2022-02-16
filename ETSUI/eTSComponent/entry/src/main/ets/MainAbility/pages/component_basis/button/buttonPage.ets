@Entry
@Component
struct ButtonPage {
  @State types: ButtonType[] = [ButtonType.Capsule, ButtonType.Circle, ButtonType.Normal]
  @State typeBtn: ButtonType = ButtonType.Normal
  @State effect: boolean = true
  @State btnText: boolean = true
  @State label: string = '纯文本按钮'
  @State temporary: string = ''

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        if (this.btnText) {
          Button('Button', {  type: this.typeBtn, stateEffect: this.effect }) {
            Column() {

              Text('Button')
                .fontSize(15)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
            }
          }
          .width(180)
          .height(70)
        } else {
          Button(this.label, { type: this.typeBtn, stateEffect: this.effect })
            .fontSize(15)
            .width(180)
            .height(70)
        }
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Column() {
          Text('包含子组件：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Button('true')
              .fontSize(15)
              .width(100)
              .margin({ right: 10 })
              .onClick(() => {
                this.btnText = true
              })
            Button('false')
              .width(100)
              .fontSize(15)
              .onClick(() => {
                this.btnText = false
              })
          }
          .width('100%')
          .margin({ top: 10, bottom: 5 })
        }
        .alignItems(HorizontalAlign.Start)

        if (!this.btnText) {
          Column() {
            Text('label取值：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
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
                  this.label = this.temporary
                  this.temporary = ''
                })
            }
            .width('100%')
            .margin({ top: 10, bottom: 5, right: 10 })
          }
        }
        Column() {
          Text('切换效果：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Button('true')
              .margin({ right: 10 })
              .fontSize(15)
              .width(100)
              .onClick(() => {
                this.effect = true
              })
            Button('false')
              .width(100)
              .fontSize(15)
              .onClick(() => {
                this.effect = false
              })
          }
          .width('90%')
          .margin({ top: 5, bottom: 5, right: 10 })
        }
        .alignItems(HorizontalAlign.Start)

        Text('按钮类型：')
          .fontSize(15)
          .backgroundColor(0xFAEEE0)
          .width('100%')
          .height(40)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bolder)
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
          Button('Capsule')
            .margin({ right: 10 })
            .fontSize(15)
            .width(100)
            .onClick(() => {
              this.typeBtn = this.types[0]
            })
          Button('Circle')
            .margin({ right: 10 })
            .fontSize(15)
            .width(100)
            .onClick(() => {
              this.typeBtn = this.types[1]
            })
          Button('Arc')
            .margin({ right: 10 })
            .fontSize(15)
            .width(100)
            .onClick(() => {
              this.typeBtn = this.types[2]
            })
          Button('Normal')
            .fontSize(15)
            .width(100)
            .onClick(() => {
              this.typeBtn = this.types[3]
            })
        }
        .width('100%')
        .margin({ top: 5, bottom: 5 })

      }.alignItems(HorizontalAlign.Start)
      .margin({ top: 20 })
    }.width('100%')
  }
}