import router from '@system.router';
var params = router.getParams().message
@Entry
@Component
struct NavigatorDetail1 {
  AboutToAppear(){
    console.log('www data ' + params)
  }
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('目标页面1')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Text(`接收参数：${params}`)
        .fontSize(20)
    }
    .width('100%')
    .height('100%')
  }
}