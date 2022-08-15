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
import mediaQuery from '@ohos.mediaquery';
import { LiveInfoDataModel } from './model/LiveDataModel'
import { liveData } from './mock/LiveData'
import { live } from './net/Utils'
import { commentPage } from './CommentPage'

class LiveInfoResponse {
  code: number
  data: Array<Info>
}

class Info {
  uri: string
  name: string
  peopleNum: string
  commentList: Array<commentInfo>
}

class commentInfo {
  name: string
  comment: string
}

@Entry
@Component
export struct LivePage {
  @State active: number = 0
  @State liveInfoList: Array<LiveInfoDataModel> = liveData // 直播信息
  @State liveList: any[] = []
  @State mData: LiveInfoResponse = {
    code: 0,
    data: [{ uri: '', name: '', peopleNum: '', commentList: [{ name: '', comment: '' }] }]
  }
  @State isPhone: boolean = false
  portraitFunc = null
  listenerIsPhone = mediaQuery.matchMediaSync('(orientation:landscape)');

  onPortrait(mediaQueryResult) {
    this.isPhone = !mediaQueryResult.matches
  }

  async aboutToAppear() {
    this.portraitFunc = this.onPortrait.bind(this) // bind current js instance
    this.listenerIsPhone.on('change', this.portraitFunc)

    try {
      let a = await live() // 调用网络接口
      this.mData = JSON.parse(a.result.toString())
      this.liveInfoList = this.mData.data
    } catch (error) {
      console.log('http resquest is fail:' + error)
    }
  }

  build() {
    Scroll() {
      Column() {
        Swiper() {
          ForEach(this.liveInfoList, (item, index) => {
            Stack({}) {
              if (this.active == index) {
                Video({ src: item.uri })
                  .autoPlay(true)
                  .loop(false)
                  .controls(false)
                  .objectFit(ImageFit.Contain)
                  .width('100%')
                  .height('100%')
              }

              // 直播界面信息栏
              Row() {
                // 信息栏左边信息
                Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                  Row() {
                    Image($r('app.media.live_author')) // 直播间头像
                      .width(38).height(38)

                    Column() {
                      Text(item.name) // 直播间名字
                        .fontSize(16)
                        .fontColor('#ffffff')
                      Row() {
                        Text(item.peopleNum) // 直播间观看人数
                          .fontSize(12)
                          .fontColor('#ffffff')
                        Text($r('app.string.watch'))
                          .fontSize(12)
                          .fontColor('#ffffff')
                      }
                    }
                    .alignItems(HorizontalAlign.Start)
                    .padding({ left: '3%' })
                  }

                  Image($r('app.media.live_attention')) // 关注按钮
                    .height(35)
                    .width(59)
                }
                .padding({ left: this.isPhone ? '2%' : '1%', right: this.isPhone ? '2%' : '1%' })
                .width(this.isPhone ? '57.2%' : '30%')
                .aspectRatio(this.isPhone ? 5.15 : 7)
                .backgroundColor('rgba(0,0,0,0.40)')
                .borderRadius(this.isPhone ? 26 : 36)

                // 右边信息栏
                Column() {
                  Image($r('app.media.live_share')) // 分享图标
                    .width(42).height(42)
                }
                .margin({ left: this.isPhone ? '12%' : '49%' })

                Column() {
                  Image($r('app.media.live_close')) // 关闭图标
                    .width(42).height(42)
                    .onClick(() => {
                      router.back()
                    })
                }
                .margin({ left: '4%' })
              }
              .position({ x: '4.4%', y: '5.1%' })

              // 评论框
              Column() {
                if (this.active === index) {
                  commentPage({ activeItem: $active })
                }
              }
              .position({ x: '4.4%', y: this.isPhone ? '72%' : '62%' })
            }
            .backgroundColor('#D8D8D8')
            .width('100%')
            .height('100%')
          })
        }
        .width('100%')
        .height('100%')
        .loop(false)
        .indicator(false)
        .vertical(true)
        .onChange((index: number) => {
          this.active = index
        })
      }
    }
  }
}
