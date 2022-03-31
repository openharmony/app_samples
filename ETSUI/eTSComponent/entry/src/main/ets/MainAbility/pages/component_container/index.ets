import router from '@system.router'

const componentContainerItems = [

  { title: 'Panel', uri: 'pages/component_container/panel/panelPage' },
  { title: 'Navigator', uri: 'pages/component_container/navigator/navigatorPage' },
  { title: "Swiper", uri: 'pages/component_container/swiper/swiperPage' },
  { title: "Stack", uri: 'pages/component_container/stack/stackPage' },
  { title: "Column", uri: 'pages/component_container/Column/ColumnPage' },
  { title: "Row", uri: 'pages/component_container/row/rowPage' },
  { title: "flex", uri: 'pages/component_container/flex/flexPage' },
  { title: "Scroll", uri: 'pages/component_container/scroll/scrollPage' },
  { title: "list", uri: 'pages/component_container/list/listPage' },
  { title: "Badge", uri: 'pages/component_container/badge/badgePage' },
  { title: "tab", uri: 'pages/component_container/tab/tabsPage' },
  { title: "Counter", uri: 'pages/component_container/Counter/counterPage' },
]

@Entry
@Component
struct component_container {
  @State basisActive: boolean = false
  @State statusActive: boolean = false
  @State containerActive: boolean = false

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center
    }) {
      List() {
        ForEach(componentContainerItems, (item) => {
          ListItem() {
            Row() {
              Text(item.title)
                .fontSize(16)
                .padding({ left: 10 })

            }
            .padding({ left: 10 })
            .width('100%')
            .height(55)
            .alignItems(VerticalAlign.Center)
            .backgroundColor(0xfff5deb3)
            .margin({ top: 5, bottom: 5})
            .borderRadius(12)
            .onClick(() => {
              router.push({
                uri: item.uri
              })
            })
          }
        }, item => item.title)
      }
      .width('100%')
    }
  }
}
