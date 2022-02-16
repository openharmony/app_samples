import prompt from '@system.prompt';

@Entry
@Component
struct CounterPage {
  @State value: number = 0

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Counter() {
          Text(`${this.value}`)
            .fontSize(15)
        }
        .onInc(() => {
          this.value++
          prompt.showToast({
            message: '数值增加'
          })
        })
        .onDec(() => {
          this.value--
          prompt.showToast({
            message: '数值减少'
          })
        })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 10 })
    }
    .width('100%')
  }
}