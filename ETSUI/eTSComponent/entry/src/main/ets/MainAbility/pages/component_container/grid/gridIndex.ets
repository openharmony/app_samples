import router from '@system.router'

const GridIndexContents = [
  { title: "Grid", uri: 'pages/component_container/grid/gridPage' },
  { title: "GridItem", uri: 'pages/component_container/grid/gridItemPage' }
]

@Entry
@Component
struct GridIndex {
  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center
    }) {
      List() {
        ForEach(GridIndexContents, (item) => {
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
            .margin({ top: 5, bottom: 5, left: 10 })
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




