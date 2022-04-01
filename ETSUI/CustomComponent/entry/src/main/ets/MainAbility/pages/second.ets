import router from '@system.router';
@Entry
@Component
struct Second {
  @State message: string = 'Second Page'
build() {
  Row() {
    Column() {
      Text(this.message)
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
      .width('35%')
      .height('5%')
      .onClick(()=>{
        router.back()
      })
    }
    .width('100%')
  }
  .height('100%')
}
}