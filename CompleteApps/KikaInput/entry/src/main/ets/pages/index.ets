import { keySourceListData, numberSourceListData, symbolSourceListData, keySourceListType, sourceListType
} from '../model/keyboardKeyData'
import { InputHandler } from '../model/KeyboardController'

//有大小写的按键组件
@Component
struct keyItemNumber {
  private keyValue: keySourceListType
  @Link upper: number

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
      Text(this.keyValue.title).fontSize(12).fontColor('gray')

      if (this.upper === 0) {
        Text(this.keyValue.content).fontSize(20).fontColor('black')
      } else {
        Text(this.keyValue.upperContent).fontSize(20).fontColor('black')
      }

    }
    .backgroundColor('#ffffff')
    .borderRadius(6)
    .width('8%')
    .height('90%')
    .padding({ top: '5%', bottom: '5%' })
    .onClick(() => {
      if (this.upper === 0) {
        InputHandler.getInstance().insertText(this.keyValue.content);
      } else {
        if (this.upper === 1) {
          this.upper = 0
        }
        InputHandler.getInstance().insertText(this.keyValue.upperContent);
      }
    })
  }
}

//无大小写的按键组件
@Component
struct keyItem {
  private keyValue: keySourceListType
  private color: string

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(this.keyValue.content).fontSize(20).fontColor('black')
    }
    .backgroundColor(this.color)
    .borderRadius(6)
    .width('8%')
    .height('90%')
    .padding({ top: '5%', bottom: '5%' })
    .onClick(() => {
      InputHandler.getInstance().insertText(this.keyValue.content);
    })
  }
}

//无大小写的灰色组件
@Component
struct keyItemGray {
  private keyValue: string
  @Link menuType: number

  build() {
    Stack() {
      Text(this.keyValue).fontSize(14).fontColor('black')
    }
    .backgroundColor('#a8abb7')
    .width('13%')
    .borderRadius(6)
    .height(45)
    .onClick(() => {
      if (this.keyValue === "?123") {
        this.menuType = 1
      } else if (this.keyValue === "=/\<") {
        this.menuType = 2
      } else if (this.keyValue === 'ABC') {
        this.menuType = 0
      }
    })
  }
}

//删除组件
@Component
struct deleteItem {
  build() {
    Stack() {
      Image($rawfile('delete.png')).width(25).height(22)
    }.backgroundColor('#a8abb7').width('13%').borderRadius(6).onClick(() => {
      InputHandler.getInstance().deleteForward(1);
    })
  }
}

//返回组件
@Component
struct returnItem {
  build() {
    Stack() {
      Image($rawfile('return.png')).width(25).height(22)
    }
    .backgroundColor('#a8abb7')
    .width('16%')
    .borderRadius(6)
    .height(45)
    .onClick(() => {
      InputHandler.getInstance().sendKeyFunction();
    })
  }
}

//空格组件
@Component
struct spaceItem {
  private spaceWith: string

  build() {
    Stack() {
      Text('space').fontSize(12).fontColor('black')
    }
    .backgroundColor('#ffffff')
    .width(this.spaceWith)
    .borderRadius(6)
    .height(45)
    .onClick(() => {
      InputHandler.getInstance().insertText(' ');
    })
  }
}

//key键盘
@Component
struct keyMenu {
  private keyList: keySourceListType[]
  @State public upper: number= 0
  @Link menuType: number

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.keyList.slice(0, 10), (item: keySourceListType) => {
          keyItemNumber({ keyValue: item, upper: $upper })
        }, (item: keySourceListType) => item.content)
      }
      .width('96%')
      .height('25%')

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Stack() {
        }.width('4%').height(0)

        ForEach(this.keyList.slice(10, 19), (item: keySourceListType) => {
          keyItemNumber({ keyValue: item, upper: $upper })
        }, (item: keySourceListType) => item.content)
        Stack() {
        }.width('4%').height(0)
      }
      .margin({ top: 10, bottom: 10 })
      .width('96%')
      .height('25%')

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Stack() {
          Image($rawfile(this.upper === 1 ? 'shift light.png' : this.upper === 2 ? 'shift light long.png' : 'shift.png'))
            .width(25)
            .height(22)
        }.backgroundColor('#a8abb7').width('13%').borderRadius(6).onClick(() => {
          if (this.upper === 0) {
            this.upper = 1
          } else if (this.upper === 1) {
            this.upper = 2
          } else if (this.upper === 2) {
            this.upper = 0
          }
        })

        ForEach(this.keyList.slice(19), (item: keySourceListType) => {
          keyItemNumber({ keyValue: item, upper: $upper })
        }, (item: keySourceListType) => item.content)
        deleteItem()
      }
      .width('96%')
      .height('25%')

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({ keyValue: '?123', menuType: $menuType })
        keyItem({ keyValue: { content: ',', title: ',', upperContent: ',' }, color: '#a8abb7' })
        spaceItem({ spaceWith: '45%' })

        keyItem({ keyValue: { content: '.', title: '.', upperContent: '.' }, color: '#a8abb7' })
        returnItem()
      }
      .width('96%')
      .height('25%')

    }
    .width('100%')
    .height('100%')
  }
}

//数字键盘
@Component
struct numberMenu {
  private numberList: sourceListType[]
  @Link menuType: number

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.numberList.slice(0, 10), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
      }
      .width('96%')
      .height('25%')

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.numberList.slice(10, 20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
      }
      .width('96%')
      .height('25%')

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({ keyValue: '=/\<', menuType: $menuType })
        ForEach(this.numberList.slice(20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
        deleteItem()
      }
      .width('96%')
      .height('25%')

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({ keyValue: 'ABC', menuType: $menuType })
        keyItem({ keyValue: { content: '_', title: '_', upperContent: '_' }, color: '#a8abb7' })
        keyItem({ keyValue: { content: ',', title: ',', upperContent: ',' }, color: '#a8abb7' })
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text('12').fontSize(14).fontColor('black')
          Text('34').fontSize(14).fontColor('black')
        }.backgroundColor('#a8abb7').borderRadius(6).width('8%').height(45)

        spaceItem({ spaceWith: '25%' })
        keyItem({ keyValue: { content: '.', title: '.', upperContent: '.' }, color: '#a8abb7' })
        returnItem()
      }
      .width('96%')
      .height('25%')
    }
  }
}

//符号键盘
@Component
struct symbolMenu {
  private symbolList: sourceListType[]
  @Link menuType: number

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.symbolList.slice(0, 10), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
      }
      .width('96%')
      .height('25%')

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.symbolList.slice(10, 20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
      }
      .width('96%')
      .height('25%')

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({ keyValue: '?123', menuType: $menuType })
        ForEach(this.symbolList.slice(20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
        deleteItem()
      }
      .width('96%')
      .height('25%')


      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        keyItemGray({ keyValue: 'ABC', menuType: $menuType })
        keyItem({ keyValue: { content: '<', title: '<', upperContent: '<' }, color: '#a8abb7' })
        keyItem({ keyValue: { content: '>', title: '>', upperContent: '>' }, color: '#a8abb7' })
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text('12').fontSize(14).fontColor('black')
          Text('34').fontSize(14).fontColor('black')
        }.backgroundColor('#a8abb7').borderRadius(6).width('8%').height(45)

        spaceItem({ spaceWith: '25%' })
        keyItem({ keyValue: { content: '.', title: '.', upperContent: '.' }, color: '#a8abb7' })
        returnItem()
      }
      .width('96%')
      .height('25%')
    }
  }
}

//下拉按钮
@Component
struct downMenu {
  build() {
    Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
      Stack() {
        Image($rawfile('down.png')).width(25).height(25).onClick(() => {
          InputHandler.getInstance().hideKeyboardSelf();
        })
      }.width('16%').borderRadius(6).height('100%')

    }.width('100%').height('10%').padding('2%').backgroundColor('#ffffff')
  }
}

@Entry
@Component
struct Index {
  private keyList: keySourceListType[]= keySourceListData
  private numberList: sourceListType[]= numberSourceListData
  private symbolList: sourceListType[]= symbolSourceListData
  @State menuType: number= 0

  private onBackPress(): boolean{
    console.info('kikaInput onBackPress');
    InputHandler.getInstance().hideKeyboardSelf();
    return true;
  }

  build() {
    Stack() {
      Column() {
        downMenu()
        Column() {
          if (this.menuType === 0) {
            keyMenu({ keyList: this.keyList, menuType: $menuType })
          } else if (this.menuType === 1) {
            numberMenu({ numberList: this.numberList, menuType: $menuType })
          } else {
            symbolMenu({ symbolList: this.symbolList, menuType: $menuType })
          }

        }.width('100%')
        .height('90%')
        .backgroundColor('#cdd0d7')

      }.height('100%')
    }
  }
}