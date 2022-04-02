import router from '@system.router';
@Entry
@Component
struct menu_testcase {
  @State bindMenuStyle:boolean=true
  @State valueMenu:string='null'
  @Builder MenuBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Text('text1')
        .fontSize(20)
        .width(150)
        .height(50)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.valueMenu='menu1'
        })

      Divider().height(10)
      Text('text2')
        .fontSize(20)
        .width(150)
        .height(50)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.valueMenu='menu2'
        })

      Divider().height(10)

      Button('BackPage')
        .fontSize(15)
        .width(150)
        .height(50)
        .onClick(() => {
          router.push({ uri: 'pages/component_basis/menu/menuIndex' })
        })

    }.width(100)
  }

  build() {
    Column() {
      Column() {
        if (this.bindMenuStyle == true) {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Text('click for menu1')
              .fontSize(15)
              .width('40%')
              .height('40%')
          }
          .height('40%')
          .width('100%')
          .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })
        } else if (this.bindMenuStyle == false) {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Column() {
              Text('click for menu2')
                .fontSize(15)
                .width('40%')
                .height('40%')
            }
            .bindMenu([
              {
                value: 'Menu1',
                action: () => {
                  console.info('handle Menu1 select')
                  this.valueMenu = 'menu1'
                }
              },
              {
                value: 'Menu2',
                action: () => {
                  console.info('handle Menu2 select')
                  this.valueMenu = 'menu2'
                }
              },
            ])
          }
          .height('45%')
          .width('90%')
          .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })
      }
      }
      Column(){
        Text(`菜单项文本:${this.valueMenu}`)
          .fontSize(15)
          .backgroundColor(0xFAEEE0)
          .width('90%')
          .height(40)
          .textAlign(TextAlign.Start)
          .margin({ left: 20 })
          .fontWeight(FontWeight.Bolder)
        Text('bindMenuStyle：')
          .fontSize(15)
          .backgroundColor(0xFAEEE0)
          .width('90%')
          .height(40)
          .textAlign(TextAlign.Start)
          .margin({ left: 20 })
          .fontWeight(FontWeight.Bolder)
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
          Button('CustomBuilder')
            .margin({right:10})
            .fontSize(15)
            .width(140)
            .onClick(() => {
              this.bindMenuStyle = true
            })
          Button('MenuItem')
            .width(140)
            .fontSize(15)
            .onClick(() => {
              this.bindMenuStyle = false
            })
        }
        .width('90%')
        .margin({ top: 5, bottom: 5 ,left:10,right:10})
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 20 })
    }
    .width('100%')
    .margin({ top: 5 })
    .bindMenu(this.MenuBuilder)
  }
}