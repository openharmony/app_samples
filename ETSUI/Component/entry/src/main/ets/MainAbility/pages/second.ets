import router from '@system.router';

@Entry
@Component
struct Second {
  private content: string = "Second Page"

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(`${this.content}`)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button() {
        Text('back to index')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        router.back()
      })
    }
    .width('100%')
    .height('100%')
  }
}