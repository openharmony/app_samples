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
import router from '@system.router'
import mediaQuery from '@ohos.mediaquery'
import { TitleBar } from '../common/TitleBar'
import { newsList, getNew } from '../model/New'
import { NewView } from '../common/NewView'

@Entry
@Component
struct Index {
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  @State currentNew: any = getNew(0)
  @State isLand: boolean = false

  onLand(mediaQueryResult) {
    console.info(`[eTSMediaQuery.Index]onLand: mediaQueryResult.matches=${mediaQueryResult.matches}`)
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
  }

  aboutToAppear() {
    this.listener.on('change', this.onLand.bind(this))
  }

  build() {
    Row() {
      Column() {
        TitleBar()
        List() {
          ForEach(newsList, (item) => {
            ListItem() {
              Flex({
                direction: FlexDirection.Column,
                alignContent: FlexAlign.Center,
                justifyContent: FlexAlign.Center
              }) {
                Text(item.title)
                  .width('100%')
                  .fontSize(22)
                Text(item.publisher)
                  .width('100%')
                  .fontSize(18)
                  .fontColor(Color.Gray)
              }
              .padding(10)
              .height('10%')
              .constraintSize({ minHeight: 80 })
              .backgroundColor(Color.White)
            }
            .onClick(() => {
              if (!this.isLand) {
                router.push({
                  params: { title: item.title, newId: item.newId },
                  uri: 'pages/New' })
              } else {
                this.currentNew = getNew(item.newId)
              }
            })
          }, item => JSON.stringify(item))
        }
        .layoutWeight(1)
        .divider({ strokeWidth: 1, startMargin: 15, endMargin: 15 })
        .padding({ left: 10, right: 10 })
      }
      .layoutWeight(2)
      .height('100%')
      .backgroundColor('#F5F5F5')

      if (this.isLand) {
        NewView({ currentNew: $currentNew })
      }
    }
    .size({ width: '100%', height: '100%' })
  }
}