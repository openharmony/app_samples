import DataModel from '../model/DataModel'
import TitleBar from '../common/TitleBar'
import Logger from '../model/Logger'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  @State changeValue: string = ''
  @State books: Array<{
    title: string,
    introduction: string,
    image: Resource
  }> = DataModel.getAllData()
  private controller: SearchController = new SearchController()

  @Builder
  BookItem(image: Resource, title: string, introduction: string) {
    Row() {
      Image(image)
        .width(80)
        .height(120)
      Column() {
        Text(title)
          .fontColor(Color.Black)
          .fontSize(25)
        Text(introduction)
          .fontColor(Color.Gray)
          .fontSize(25)
      }
      .layoutWeight(1)
      .margin({ left: 10 })
      .alignItems(HorizontalAlign.Start)
    }
    .padding(10)
    .margin({ left: 10, right: 10 })
    .backgroundColor(Color.White)
    .borderRadius(10)
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      TitleBar()
      Search({ value: this.changeValue, placeholder: 'input to search', controller: this.controller })
        .searchButton('Search')
        .width('95%')
        .height(40)
        .textFont({ size: 25, weight: FontWeight.Bold })
        .placeholderFont({ size: 25, weight: FontWeight.Normal, style: FontStyle.Normal })
        .backgroundColor(Color.White)
        .placeholderColor(Color.Grey)
        .onSubmit((value: string) => {
          Logger.info(TAG, `onSubmit: ${value}`)
          this.books = DataModel.query(value)
        })
        .onChange((value: string) => {
          Logger.info(TAG, `onChange: ${value}`)
          this.changeValue = value
          this.books = DataModel.query(value)
        })
        .margin({ top: 10 })
      List({ space: 10 }) {
        ForEach(this.books, item => {
          ListItem() {
            this.BookItem(item.image, item.title, item.introduction)
          }
        }, item => item.title)
      }
      .width('100%')
      .layoutWeight(1)
      .margin({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}