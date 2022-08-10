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

import display from '@ohos.display'
import Logger from '../util/Logger'
import geolocation from '@ohos.geolocation'
import { listData, heatCity } from '../mock/LocationMock'
import httpRequestResponse from '../net/HttpRequestResponse'

const TAG: string = '[Location]'

@Entry
@Component
export struct Location {
  @State ratio: number = 1
  @State TabIndex: number = 0
  @State location: boolean = true
  @State isCity: string = ''
  @State currentLocation: string = ''
  @State latitude: number = 0
  @State longitude: number = 0
  @State city: string = ''
  @State isShow: boolean = true
  private controller: TabsController = new TabsController()
  private tabValue: string[] = ['A', 'B', 'C', 'F', 'G', 'H', 'J', 'L', 'N', 'Q', 'S', 'T', 'X', 'Y', 'Z']
  private scroller: Scroller = new Scroller()

  async aboutToAppear() {
    display.getAllDisplay((err, data) => {
      Logger.info(TAG, `data = ${JSON.stringify(data)}`)
      let aspect = data[0].width / data[0].height
      if (aspect === 0.5625) {
        this.ratio = 1.4
      }
    })
    await this.requestResponse()
  }

  async aboutToDisappear() {
    await geolocation.off('locationChange')
  }

  async requestResponse() {
    Logger.info(TAG, `enter requestResponse`)
    try {
      let httpResponse = await httpRequestResponse.httpRequest('http://123.60.114.86:8090/address/home', this.latitude, this.longitude)
      Logger.info(TAG, `http response = ${JSON.stringify(httpResponse)}`)
      let requestResponse = JSON.parse(httpResponse.result.toString())
      this.city = requestResponse.data
      Logger.info(TAG, `this.city = ${JSON.stringify(this.city)}`)
    } catch (error) {
      Logger.info(TAG, `http request error: ${JSON.stringify(error)}`)
    }
  }

  locationChange = async (location) => {
    this.latitude = location.latitude
    this.longitude = location.longitude
    if (this.longitude !== 0 && this.longitude !== 0) {
      Logger.info(TAG, `latitude = ${this.latitude}, longitude = ${this.longitude}`)
      await this.requestResponse()
    }
  }

  async getLocation() {
    let requestInfo: geolocation.LocationRequest = {
      priority: 0x203,
      scenario: 0x300,
      timeInterval: 0,
      distanceInterval: 100,
      maxAccuracy: 100
    }
    geolocation.on('locationChange', requestInfo, this.locationChange)
  }

  build() {
    Panel(this.isShow) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
          Text($r('app.string.deliver_to'))
            .fontSize(25)
            .margin({ bottom: 30 })
          if (this.currentLocation) {
            Text(`${this.currentLocation}` || $r('app.string.xian'))
              .fontSize(16 * this.ratio)
          } else {
            Text($r('app.string.current_positioning'))
              .fontSize(20)
              .opacity(0.6)
          }
        }
        .width('100%')
        .height(130)
        .margin({ top: 20 })

        Flex() {
          Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
            Image($r("app.media.location"))
              .width(16 * this.ratio)
              .aspectRatio(1)
              .padding({ left: 4 })
            Text(this.city === '' ? $r('app.string.xian') : this.city)
              .fontSize(14 * this.ratio)
              .fontColor('#E92F4F')
              .padding({ right: 3, top: 2 })
          }
          .width(64 * this.ratio)
          .height(20 * this.ratio)
          .borderRadius(13 * this.ratio)
          .borderWidth(1)
          .borderColor('#E92F4F')
          .onClick(async () => {
            await this.getLocation()
          })
        }
        .margin({ top: 5 * this.ratio })

        Flex({ direction: FlexDirection.Column }) {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Stack({ alignContent: Alignment.End }) {
              Flex({ wrap: FlexWrap.Wrap }) {
                Column() {
                  Flex() {
                    Text($r('app.string.domestic_hot_city'))
                      .fontSize(14 * this.ratio)
                      .fontColor('#000000')
                      .opacity(0.6)
                  }
                  .margin({ top: 30 * this.ratio, bottom: 15 * this.ratio })

                  Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap }) {
                    ForEach(heatCity, (item) => {
                      Text(`${item}`)
                        .margin({ bottom: 16 })
                        .width('25%')
                        .fontSize(14 * this.ratio)
                        .maxLines(3)
                        .fontColor('#000000')
                        .onClick(() => {
                          this.currentLocation = item
                        })
                    })
                  }
                  .width('100%')
                }

                List({ space: 15, initialIndex: 0, scroller: this.scroller }) {
                  ForEach(listData, (index) => {
                    ListItem() {
                      Column() {
                        Text(`${index.name}`)
                          .height(30 * this.ratio)
                          .fontSize(16 * this.ratio)
                          .fontColor('#000000;')
                          .width('100%')
                        Divider()
                          .strokeWidth(0.8)
                          .color('#000000')
                          .opacity(0.2).margin({ right: 10 })

                        ForEach(index.city, item => {
                          Text(`${item.name === undefined ? item : item.name}`)
                            .height(30 * this.ratio)
                            .fontSize(14 * this.ratio)
                            .width('100%')
                            .margin({ top: 10 })
                            .onClick(() => {
                              this.currentLocation = item.name === undefined ? item : item.name
                              if (this.isCity == item.name) {
                                console.log(this.isCity);
                                console.log(item.name === undefined ? item : item.name);
                                this.isCity = ''
                              } else {
                                this.isCity = item.name === undefined ? item : item.name
                              }
                            })
                          if (this.isCity == item.name) {
                            List() {
                              ForEach(item.city, secondCity => {
                                ListItem() {
                                  Column() {
                                    Text(`${secondCity}`)
                                      .width('100%')
                                      .height(30 * this.ratio)
                                      .fontSize(14 * this.ratio)
                                      .onClick(() => {
                                        this.currentLocation = `${item.name}/${secondCity}`
                                      })
                                  }
                                }
                              })
                            }
                            .width('100%')
                          }
                        })
                      }
                    }
                  })
                }
                .width('100%')
                .edgeEffect(EdgeEffect.None)
                .listDirection(Axis.Vertical)
                .onScrollIndex((firstIndex: number, lastIndex: number) => {
                  this.TabIndex = firstIndex
                })
              }

              Flex() {
                AlphabetIndexer({ arrayValue: this.tabValue, selected: this.TabIndex })
                  .height('100%')
                  .font({ size: 16 })
                  .popupColor('#FFFFFF') // 弹出框颜色
                  .selectedBackgroundColor(0xCCCCCC) // 选中背景颜色
                  .popupBackground(0xCCCCCC) // 弹出框背景颜色
                  .usingPopup(true) // 是否显示弹出框
                  .selectedFont({ size: 16, style: FontStyle.Normal }) // 选中的样式
                  .selectedColor('#969494') // 选中颜色
                  .popupFont({ size: 30, weight: FontWeight.Bolder }) // 弹出框的演示
                  .alignStyle(this.location ? IndexerAlign.Right : IndexerAlign.Left)
                  .onSelect((TabIndex: number) => {
                    this.scroller.scrollToIndex(TabIndex)
                  })
              }
              .position({ x: '97%' })
              .margin({ top: 4 })
            }
          }
        }
      }
      .width('100%')
      .padding({ left: '6.7%', right: '6.7%', top: 20 })
      .backgroundColor('#F1F3F5')
      .borderRadius({ topLeft: 40, topRight: 40 })
    }
    .dragBar(true).mode(PanelMode.Full)
  }
}