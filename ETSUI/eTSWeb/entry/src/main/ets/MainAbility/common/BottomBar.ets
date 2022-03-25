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
export struct BottomBar {
  private controller: WebController = null
  @Link webTitle: string
  @Link isWebError: boolean
  @Link webState: boolean
  @Link url: string
  @Link isHttpError: boolean
  @Link backToHome: boolean
  private options: Array<{
    image: Resource,
    onClick: () => void
  }> = [
    {
      image: $r("app.media.back"),
      onClick: () => {
        this.controller.backward()
        this.isWebError = false
        this.isHttpError = false
      }
    },
    {
      image: $r("app.media.main"),
      onClick: () => {
        this.url = ''
        this.webTitle = '主页'
        this.backToHome = true
        this.webState = false
        this.isWebError = false
        this.isHttpError = false
      }
    },
    {
      image: $r("app.media.forward"),
      onClick: () => {
        this.controller.forward()
        this.isWebError = false
        this.isHttpError = false
      }
    }
  ]

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
      ForEach(this.options, item => {
        Image(item.image)
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
          .onClick(item.onClick)
      }, item => JSON.stringify(item))
    }
    .width('100%')
    .height(50)
  }
}