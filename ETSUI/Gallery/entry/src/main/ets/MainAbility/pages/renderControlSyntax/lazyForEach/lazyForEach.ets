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

import { NavigationBar } from "../../../common/components/navigationBar"

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): any {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdded(index)
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChanged(index)
    })
  }
}

class MyDataSource extends BasicDataSource {
  public dataArray: string[] = []

  constructor(count) {
    super()
    for (var index = 0;index < count; index++) {
      this.dataArray.push(`${index}`)
    }
  }

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): any {
    return this.dataArray[index]
  }

  public addData(index: number, data: string): void {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }
}

@Entry
@Component
struct lazyForEachSample {
  @State number: number = 10
  @State data: MyDataSource = new MyDataSource(10)

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: '数据懒加载' })
      Flex({ direction: FlexDirection.Column }) {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text('数据数量')
            .fontSize('16fp')
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
          Column() {
            Text(`${this.number}`)
              .textAlign(TextAlign.End)
              .fontSize('16fp')
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .width('100%')
          }
          .width('30%')
          .bindMenu([
            {
              value: '10',
              action: () => {
                this.number = 10
                this.data = new MyDataSource(this.number)
              }
            },
            {
              value: '100',
              action: () => {
                this.number = 100
                this.data = new MyDataSource(this.number)
              }
            },
            {
              value: '1000',
              action: () => {
                this.number = 1000
                this.data = new MyDataSource(this.number)
              }
            },
            {
              value: '10000',
              action: () => {
                this.number = 10000
                this.data = new MyDataSource(this.number)
              }
            },
            {
              value: '100000',
              action: () => {
                this.number = 100000
                this.data = new MyDataSource(this.number)
              }
            },
          ])
        }
        .height(56)
        .width('100%')
        .padding({ left: '3%', right: '3%' })
        .borderRadius(24)
        .backgroundColor('#FFFFFF')
        .margin({ top: 8 })

        List({ space: 20, initialIndex: 0 }) {
          LazyForEach(this.data, (item, index) => {
            ListItem() {
              Row() {
                Image($r("app.media.ic_public_play_norm"))
                  .objectFit(ImageFit.Contain)
                  .width('15%')
                  .margin({ top: 10, right: '4%', bottom: 10 })
                  .borderRadius('50%')
                Text(`${this.data["dataArray"].indexOf(item)}`)
                  .textAlign(TextAlign.Center)
                  .fontSize('16fp')
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                  .width('73%')
                  .height(40)
                  .margin({ top: 5 ,left:'5%'})
                .backgroundColor('#ccc')
              }
              .height('10%')
            }
            .margin({ top: 22 })
          }, item => item)
        }
        .padding({ bottom: 22, left: '3%', right: '3%' })
        .borderRadius(24)
        .margin({ top: 12 })
        .backgroundColor('#FFFFFF')
        .listDirection(Axis.Vertical)
        .divider({ strokeWidth: 1, color: '#32000000', startMargin: '10%', endMargin: 20 })
        .edgeEffect(EdgeEffect.Spring)
        .flexGrow(1)
        .width('100%')
        .padding({ left: '3%', right: '3%', top: 22, bottom: 22 })
        .borderRadius(24)
        .backgroundColor('#FFFFFF')
        .margin({ top: 8 })
      }.width('100%')
      .height('93%')
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 35 })
  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }
}