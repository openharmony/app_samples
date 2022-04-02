import router from '@system.router';
var params = router.getParams().message
@Entry
@Component
struct NavigatorDetail2 {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('目标页面2')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Text(`接收参数：${params}`)
        .fontSize(20)
    }
    .width('100%')
    .height('100%')
  }
}