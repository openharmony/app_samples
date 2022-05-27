import { keySourceListData, numberSourceListData, symbolSourceListData, keySourceListType, sourceListType
} from '../model/keyboardKeyData'
import { InputHandler } from '../model/KeyboardController'
import styleConfiguration from '../common/styleConfiguration'

let inputStyle: any = styleConfiguration.getInputStyle()
//有大小写的按键组件
@Component
struct keyItemNumber {
  private keyValue: keySourceListType
  @Link upper: number

  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
      Text(this.keyValue.title)
        .fontSize(inputStyle.litterNumberFontSize)
        .fontColor(0x606060)
        .fontWeight(FontWeight.Lighter)
      if (this.upper === 0) {
        Text(this.keyValue.content)
          .fontSize(inputStyle.en_fontSize)
          .fontColor('#000')
          .fontWeight(FontWeight.Regular)
      } else {
        Text(this.keyValue.upperContent)
          .fontSize(inputStyle.en_fontSize)
          .fontColor('#000')
          .fontWeight(FontWeight.Regular)
      }
    }
    .backgroundColor('#ffffff')
    .borderRadius(4)
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
    .width(inputStyle.basicButtonWidth)
    .height(inputStyle.basicButtonHeight)
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//无大小写的按键组件
@Component
struct keyItem {
  private keyValue: keySourceListType
  private color: string

  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(this.keyValue.content)
        .fontSize(inputStyle.en_fontSize)
        .fontColor('black')
    }
    .backgroundColor('#fff')
    .borderRadius(4)
    .width(inputStyle.basicButtonWidth)
    .height(inputStyle.basicButtonHeight)
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .padding({ top: '5%', bottom: '5%' })
    .onClick(() => {
      InputHandler.getInstance().insertText(this.keyValue.content);
    })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//无大小写的灰色组件
@Component
struct keyItemGray {
  private keyValue: string
  @Link menuType: number

  @Styles pressedStyles() {
    .backgroundColor("#868b95")
  }

  @Styles normalStyles() {
    .backgroundColor("#a8abb7")
  }

  build() {
    Stack() {
      Text(this.keyValue).fontSize(inputStyle.switchNumberFontSize).fontColor('black')
    }
    .backgroundColor('#a8abb7')
    .borderRadius(4)
    .onClick(() => {
      if (this.keyValue === "?123") {
        this.menuType = 1
      } else if (this.keyValue === "=/\<") {
        this.menuType = 2
      } else if (this.keyValue === 'ABC') {
        this.menuType = 0
      }
    })
    .height(inputStyle.basicButtonHeight)
    .width(inputStyle.switchButtonWidth)
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//删除组件
@Component
struct deleteItem {
  @Styles pressedStyles() {
    .backgroundColor("#868b95")
  }

  @Styles normalStyles() {
    .backgroundColor("#a8abb7")
  }

  build() {
    Stack() {
      Image($rawfile('delete.svg'))
        .width(inputStyle.featurePicSize)
        .height(inputStyle.featurePicSize)
    }
    .backgroundColor('#a8abb7')
    .borderRadius(4)
    .onClick(() => {
      InputHandler.getInstance().deleteForward(1);
    })
    .width(inputStyle.switchButtonWidth)
    .height(inputStyle.basicButtonHeight)
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//返回组件
@Component
struct returnItem {
  private returnWidth: any

  @Styles pressedStyles() {
    .backgroundColor("#868b95")
  }

  @Styles normalStyles() {
    .backgroundColor("#a8abb7")
  }

  build() {
    Stack() {
      Image($rawfile('return.svg'))
        .width(inputStyle.returnPicSize)
        .height(inputStyle.returnPicSize)
    }
    .backgroundColor('#a8abb7')
    .width(this.returnWidth)
    .borderRadius(4)
    .height(inputStyle.basicButtonHeight)
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .onClick(() => {
      InputHandler.getInstance().sendKeyFunction();
    })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//空格组件
@Component
struct spaceItem {
  private spaceWith: any

  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Stack() {
      Text('space')
        .fontSize(inputStyle.en_fontSize)
        .fontColor('black')
    }
    .backgroundColor('#ffffff')
    .width(this.spaceWith)
    .borderRadius(4)
    .height(inputStyle.basicButtonHeight)
    .onClick(() => {
      InputHandler.getInstance().insertText(' ');
    })
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//key键盘
@Component
struct keyMenu {
  private keyList: keySourceListType[]
  @State public upper: number= 0
  @Link menuType: number

  @Styles pressedStyles() {
    .backgroundColor("#868b95")
  }

  @Styles normalStyles() {
    .backgroundColor("#a8abb7")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.keyList.slice(0, 10), (item: keySourceListType) => {
          keyItemNumber({ keyValue: item, upper: $upper })
        }, (item: keySourceListType) => item.content)
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Stack() {
        }.width('4%').height(0)

        ForEach(this.keyList.slice(10, 19), (item: keySourceListType) => {
          keyItemNumber({ keyValue: item, upper: $upper })
        }, (item: keySourceListType) => item.content)
        Stack() {
        }.width('4%').height(0)
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Stack() {
          Image($rawfile(this.upper === 1 ? 'shift light.svg' : this.upper === 2 ? 'shift light long.svg' : 'shift.svg'))
            .width(inputStyle.featurePicSize)
            .height(inputStyle.featurePicSize)
        }
        .backgroundColor('#a8abb7')
        .borderRadius(4)
        .onClick(() => {
          if (this.upper === 0) {
            this.upper = 1
          } else if (this.upper === 1) {
            this.upper = 2
          } else if (this.upper === 2) {
            this.upper = 0
          }
        })
        .height(inputStyle.basicButtonHeight)
        .width(inputStyle.switchButtonWidth)
        .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
        .stateStyles({
          normal: this.normalStyles, pressed: this.pressedStyles
        })


        ForEach(this.keyList.slice(19), (item: keySourceListType) => {
          keyItemNumber({ keyValue: item, upper: $upper })
        }, (item: keySourceListType) => item.content)
        deleteItem()
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: '?123', menuType: $menuType })
        keyItem({ keyValue: { content: ',', title: ',', upperContent: ',' }, color: '#a8abb7' })
        spaceItem({ spaceWith: inputStyle.spaceButtonWidth_1 })

        keyItem({ keyValue: { content: '.', title: '.', upperContent: '.' }, color: '#a8abb7' })
        returnItem({ returnWidth: inputStyle.returnButtonWidthType_1 })
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })

    }
    .width('100%')
    .height('100%')
    .padding({
      left: inputStyle.paddingLeftRight,
      right: inputStyle.paddingLeftRight
    })
  }
}

//数字键盘
@Component
struct numberMenu {
  private numberList: sourceListType[]
  @Link menuType: number

  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.numberList.slice(0, 10), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.numberList.slice(10, 20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: '=/\<', menuType: $menuType })
        ForEach(this.numberList.slice(20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
        deleteItem()
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: 'ABC', menuType: $menuType })
        keyItem({ keyValue: { content: '_', title: '_', upperContent: '_' }, color: '#a8abb7' })
        keyItem({ keyValue: { content: ',', title: ',', upperContent: ',' }, color: '#a8abb7' })
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text('12').fontSize(inputStyle.number1234ontFSize).fontColor('black')
          Text('34').fontSize(inputStyle.number1234ontFSize).fontColor('black')
        }
        .backgroundColor('#fff')
        .borderRadius(4)
        .width(inputStyle.basicButtonWidth)
        .height(inputStyle.basicButtonHeight)
        .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
        .stateStyles({
          normal: this.normalStyles, pressed: this.pressedStyles
        })

        spaceItem({ spaceWith: inputStyle.spaceButtonWidth_2 })
        keyItem({ keyValue: { content: '.', title: '.', upperContent: '.' }, color: '#a8abb7' })
        returnItem({ returnWidth: inputStyle.returnButtonWidthType_2 })
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })
    }
    .padding({
      left: inputStyle.paddingLeftRight,
      right: inputStyle.paddingLeftRight
    })
  }
}

//符号键盘
@Component
struct symbolMenu {
  private symbolList: sourceListType[]
  @Link menuType: number

  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.symbolList.slice(0, 10), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.symbolList.slice(10, 20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: '?123', menuType: $menuType })
        ForEach(this.symbolList.slice(20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff'
          })
        }, (item: sourceListType) => item.content)
        deleteItem()
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })


      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: 'ABC', menuType: $menuType })
        keyItem({ keyValue: { content: '<', title: '<', upperContent: '<' }, color: '#a8abb7' })
        keyItem({ keyValue: { content: '>', title: '>', upperContent: '>' }, color: '#a8abb7' })
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text('12').fontSize(inputStyle.number1234ontFSize).fontColor('black')
          Text('34').fontSize(inputStyle.number1234ontFSize).fontColor('black')
        }
        .backgroundColor('#fff')
        .borderRadius(4)
        .width(inputStyle.basicButtonWidth)
        .height(inputStyle.basicButtonHeight)
        .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
        .stateStyles({
          normal: this.normalStyles, pressed: this.pressedStyles
        })

        spaceItem({ spaceWith: inputStyle.spaceButtonWidth_2 })
        keyItem({ keyValue: { content: '.', title: '.', upperContent: '.' }, color: '#a8abb7' })
        returnItem({ returnWidth: inputStyle.returnButtonWidthType_2 })
      }
      .width('100%')
      .height(inputStyle.basicButtonHeight)
      .margin({ top: inputStyle.paddingTop })
    }
    .padding({
      left: inputStyle.paddingLeftRight,
      right: inputStyle.paddingLeftRight
    })
  }
}

//下拉按钮
@Component
struct downMenu {
  build() {
    Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
      Stack() {
        Image($rawfile('down.svg'))
          .width(inputStyle.downMenuPicWidth)
          .height(inputStyle.downMenuPicHeight)
          .onClick(() => {
            InputHandler.getInstance().hideKeyboardSelf();
          })
      }
      .width(inputStyle.downMenuWidth)
      .borderRadius(4)
      .height('100%')
    }
    .width('100%')
    .height(inputStyle.downMenuHeight)
    .padding(1)
    .backgroundColor('#ffffff')
    .borderColor('#000000CC')
    .borderWidth(0.5)
  }
}

@Entry
@Component
struct Index {
  private keyList: keySourceListType[]= keySourceListData
  private numberList: sourceListType[]= numberSourceListData
  private symbolList: sourceListType[]= symbolSourceListData
  @State menuType: number= 0

  onBackPress(): boolean{
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
        .height(inputStyle.keyboardHeight)
        .backgroundColor('#D5D7DD')
      }.height('100%')
    }
  }
}