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
@Component
export struct KeySetting {
  @Link isClickShow: boolean
  private swiperController: SwiperController = new SwiperController()
  @State array: Array<object> = [
    {
      icon: $r("app.media.icon"),
      text: '登陆账号',
      index: 0
    },
    {
      icon: $r("app.media.icon"),
      text: '键盘布局',
      index: 1
    },
    {
      icon: $r("app.media.icon"),
      text: '键盘模式',
      index: 2
    },
    {
      icon: $r("app.media.icon"),
      text: '语录',
      index: 3
    },
    {
      icon: $r("app.media.icon"),
      text: '皮肤商店',
      index: 4
    },
    {
      icon: $r("app.media.icon"),
      text: '键盘调节',
      index: 5
    },
    {
      icon: $r("app.media.icon"),
      text: '字体大小',
      index: 6
    },
    {
      icon: $r("app.media.icon"),
      text: '剪贴板',
      index: 7
    },
  ]
  @State arrayTwo: Array<object> = [
    {
      icon: $r("app.media.icon"),
      text: '文字编辑',
      index: 8
    },
    {
      icon: $r("app.media.icon"),
      text: '按键反馈',
      index: 9
    },
    {
      icon: $r("app.media.icon"),
      text: '机械键盘',
      index: 10
    },
    {
      icon: $r("app.media.icon"),
      text: '上滑输入',
      index: 11
    },
    {
      icon: $r("app.media.icon"),
      text: '繁体输入',
      index: 12
    },
    {
      icon: $r("app.media.icon"),
      text: '设置',
      index: 13
    },
  ]
  @State isClick: boolean = false;
  @State isClickIndex: number = 0;

  build() {
    if (!this.isClick) {
      Swiper(this.swiperController) {
        Flex({
          direction: FlexDirection.Row,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceEvenly,
          wrap: FlexWrap.Wrap
        }) {
          ForEach(this.array, (item, index) => {
            Column() {
              Image(item.icon).width(45).height(45)
              Text(item.text).margin({ top: 10 })
            }.width("22%").margin({ top: 30 }).onClick(() => {
              this.isClickIndex = item.index
              this.array.forEach((item, index) => {
                if (index == index) {
                  this.isClick = true
                }
              })
            })
          })
        }.height("100%").width("100%")

        Flex({
          direction: FlexDirection.Row,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Start,
          wrap: FlexWrap.Wrap
        }) {
          ForEach(this.arrayTwo, (item) => {
            Column() {
              Image(item.icon).width(45).height(45)
              Text(item.text).margin({ top: 10 })
            }.width("22%").margin({ top: 30 }).onClick(() => {
              this.isClickIndex = item.index
              this.array.forEach((item, index) => {
                if (index == index) {
                  this.isClick = true
                }
              })
            })
          })
        }.height("100%").width("100%")
      }
      .index(0)
      .autoPlay(false)
      .interval(4000)
      .indicator(true)
      .loop(false)
      .duration(1000)
      .vertical(false)
      .itemSpace(0)
      .visibility(this.isClickShow ? Visibility.Visible : Visibility.None)
    } else {
      if (this.isClickIndex == 3) {
      } else if (this.isClickIndex == 7) {
      } else if (this.isClickIndex == 9) {
      }
    }
  }
}