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

import router from '@ohos.router'
import { rewardSectionComponent } from '../../components/user/rewardSection'
import { ServiceSectionComponent } from '../../components/user/serviceSection'
import { MyOrderComponent } from '../../components/user/myOrders'
import { FavorLiveListComponent } from '../../components/user/favorLiveLists'
import { setting } from '@ohos/http'

@Component
export struct User {
  private url: string
  private option: object
  @Prop ratio: number

  build() {
    Flex({ direction: FlexDirection.Column }) {
      List() {
        ListItem() {
          Column() {
            Row() {
              Image($r('app.media.setting'))
                .width('6.7%')
                .objectFit(ImageFit.Contain)
                .margin({ left: '10vp' })
                .onClick(() => {
                  router.replace({
                    url: 'pages/Setting'
                  })
                })
              Image($r('app.media.scanCode'))
                .width('6.7%')
                .objectFit(ImageFit.Contain)
                .margin({ left: '10vp' })
            }
            .width('100%')
            .height('10%')
            .margin({ top: 2 })
            .justifyContent(FlexAlign.End)
            .padding({ top: '10vp', bottom: '10vp' })

            Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
              Image($r('app.media.usname'))
                .width('13%')
                .height('10%')
                .objectFit(ImageFit.Contain)
                .margin({ right: '10vp' })
              Column() {
                Text($r('app.string.user_name'))
                  .fontSize(16 * this.ratio)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                  .padding({ right: 20 })
                  .margin({ top: '8vp', bottom: '2vp' })

                Row() {
                  Row() {
                    Text($r("app.string.sign_Info"))
                      .fontColor(Color.White)
                      .fontSize(11 * this.ratio)
                  }
                  .margin(2)
                  .padding('3vp')
                  .borderRadius('10vp')
                  .backgroundColor('#23000000')

                  Row() {
                    Text($r("app.string.sign_info_address"))
                      .fontColor(Color.White)
                      .fontSize(11 * this.ratio)
                  }
                  .margin(2)
                  .padding('3vp')
                  .borderRadius('10vp')
                  .backgroundColor('#23000000')
                }
                .width('48%')
                .height('5%')
                .margin({ top: 5, bottom: 5 })
              }
              .width('70%')
              .alignItems(HorizontalAlign.Start)
            }


            Column() {
              MyOrderComponent({ ratio: this.ratio })
            }
            .height('18%')
            .margin({ top: 12 })
            .border({ radius: 30 })
            .backgroundColor('#FFFFFF')

            Column() {
              rewardSectionComponent({ ratio: this.ratio })
            }
            .height('14%')
            .margin({ top: 14 })
            .backgroundColor('#FFFFFF')
            .border({ radius: 30 })

            Column() {
              ServiceSectionComponent({ ratio: this.ratio })
            }
            .height('14%')
            .margin({ top: 14 })
            .backgroundColor('#FFFFFF')
            .border({ radius: 30 })
          }
        }
        .padding({ left: '3.3%', right: '3.3%' })
        .backgroundImageSize({ width: '100%', height: '50%' })
        .backgroundImage($r('app.media.homeMask'), ImageRepeat.NoRepeat)

        ListItem() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text($r("app.string.often_see_live"))
                .fontSize(20)
                .fontWeight(500)
              Row() {
                Text($r("app.string.read_more"))
                  .fontSize(18)
                  .opacity(0.6)
                Image($r('app.media.arrows_right'))
                  .width(14 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
              }
            }
            .margin({ top: 14, bottom: 8 })
            .padding({ top: 12, bottom: 12 })

            Column() {
              FavorLiveListComponent({ ratio: this.ratio })
            }.aspectRatio(0.5)
          }
        }.padding({ left: '3.3%', right: '3.3%' })
      }

      Divider()
        .color('#ffa9a9a9')
        .width(1)
    }
  }
}