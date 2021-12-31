import router from '@system.router';

let contextList = [
  { title: 'RenderingContext1', uri: 'pages/renderingContext1' },
  { title: 'RenderingContext2', uri: 'pages/renderingContext2' },
  { title: 'transform', uri: 'pages/transform' },
  { title: 'back', uri: 'pages/index' }
]

@Entry
@Component
struct contextComponent {
  private controller: TabsController = new TabsController()
  @State isShow: boolean = false
  @State subassemblyName: string = '' //组件名
  @State selectItem: string = '' //选择验证项
  build() {
    Column() {
      Row() {
        Column() {
          Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
            TabContent() {
              List({ space: 6, initialIndex: 0 }) {
                ForEach(contextList, (item) => {
                  ListItem() {
                    Text(item.title).fontSize(18)
                  }.backgroundColor(Color.Pink)
                  .width("100%")
                  .height(50)
                  .onClick(() => {
                    router.push({
                      uri: item.uri
                    })
                  })
                }, item => item.title)
              }.listDirection(Axis.Vertical)
              .height("100%")
            }.tabBar("List")
          }
          .vertical(true)
          .barMode(BarMode.Fixed)
          .barHeight(500)
          .barWidth(50)
        }.width("80%")
      }
    }
  }
}



