/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import mediaQuery from '@ohos.mediaquery';
import { LiveInfoDataModel } from './model/liveDataModel'
import { liveData } from './mock/liveData'

@Component
export struct commentPage {
  @State liveList: Array<any> = []
  @State comments: Array<LiveInfoDataModel> = liveData
  @State text: string = ''
  @State isPhone: boolean = false
  @Link @Watch("onActiveUpdated") activeItem: number
  portraitFunc = null
  listenerIsPhone = mediaQuery.matchMediaSync('(orientation:landscape)');

  onPortrait(mediaQueryResult) {
    this.isPhone = !mediaQueryResult.matches
  }

  onActiveUpdated(): void {
    this.updateCommentList()
  }

  updateCommentList() {
    var i = 0
    let intervalID = setInterval(() => {
      this.liveList.push(this.comments[0]["commentList"][i++])
      if (i == this.comments[0]["commentList"].length) {
        clearInterval(intervalID);
      }
      console.log(JSON.stringify(this.liveList))
    }, 1000);
  }

  aboutToAppear() {
    this.portraitFunc = this.onPortrait.bind(this) // bind current js instance
    this.listenerIsPhone.on('change', this.portraitFunc)

    this.updateCommentList() // 启动评论定时器
  }

  build() {
    Column() {
      // 评论框
      Column() {
        List({ space: 6, initialIndex: 0 }) {
          ForEach(this.liveList, (items) => {
            ListItem() {
              Text() {
                Span(items.name)
                  .fontSize(12)
                  .fontColor('#FFFFFF')
                Span(":")
                  .fontSize(12)
                  .fontColor('#FFFFFF')
                Span(items.comment)
                  .fontSize(12)
                  .fontColor('#FFFFFF')
              }
              .padding({ left: 10, top: 5, right: 10, bottom: 5 })
              .borderRadius(18)
              .backgroundColor('rgba(0,0,0,0.20)')
            }
            .editable(true)
          }, item => item.toString())
        }
      }
      .alignItems(HorizontalAlign.Start)
      .width('60%')
      .height('66%')

      // 底部3件套
      Row() {
        Image($r('app.media.live_shopping')) // 购物图标
          .width(52).height(52)
        TextInput({ placeholder: $r("app.string.talk_something") }) // TextInput输入框
          .backgroundColor('rgba(0,0,0,0.20)')
          .placeholderColor("rgb(255,255,255)")
          .padding({ left: 20 })
          .fontSize(20)
          .width('47.2%')
          .height(52)
          .borderRadius(26)
          .margin({ left: 16 })
          .onChange((value: string) => {
            this.text = value
          })
          .onSubmit(() => {
            this.liveList.push({ name: "My", comment: this.text })
            this.text = ''
          })
        Image($r('app.media.givelike')) // 点赞图标
          .width(52).height(52)
          .margin({ left: '22%' })
      }
      .justifyContent(FlexAlign.Start)
      .margin({ top: 10 })
    }
    .alignItems(HorizontalAlign.Start)
    .width('95%')
    .height('28%')
  }
}
