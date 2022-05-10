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
import router from '@ohos.router';
import { SECOND_NAV_LIST } from '../../model/constant'


@Component
export struct SecondaryNavigation {
  private index: number = 0;

  build() {
    Column() {
      List() {
        ForEach(SECOND_NAV_LIST[this.index], (item) => {
          ListItem() {
            Row() {
              Image($r("app.media.ic_public_collect"))
                .objectFit(ImageFit.Contain)
                .width('6%')
                .height(24)
                .margin({ left: '9%' })
              Text(item.title)
                .fontColor('#182431')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .width('55%')
                .margin({ left: '5.2%', right: '20.2%' })
              Image($r("app.media.ic_public_arrow_right"))
                .objectFit(ImageFit.Contain)
                .width('4%')
                .height(24)
            }
          }
          .width('100%')
          .height(56)
          .backgroundColor('#ffffff')
          .editable(true)
          .onClick(() => {
            router.push({
              url: item.url
            })
          })
        })
      }
      .backgroundColor('#FFFFFF')
      .padding({top:12})
      .listDirection(Axis.Vertical)
      .divider({ strokeWidth: '1', color: '#32000000',startMargin:'10%',  })
    }
    .width('100%')
    .backgroundColor('#F1F3F5')
  }
}