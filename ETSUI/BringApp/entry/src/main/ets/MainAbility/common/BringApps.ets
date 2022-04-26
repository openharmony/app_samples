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

import bundle from '@ohos.bundle'
import prompt from '@ohos.prompt'
import { Apps } from '../model/Apps'
import Logger from '../model/Logger'
import featureAbility from '@ohos.ability.featureAbility'

const TAG = '[BringApps]'

@Component
export struct BringApp {
  @State text: string = ''
  @State app: Apps = new Apps()

  build() {
    Scroll() {
      Column() {
        ForEach(this.app.apps, item => {
          Row() {
            Image(item.img)
              .margin(5)
              .width('20%')
              .height('60%')
              .objectFit(ImageFit.Contain)

            Text(item.name)
              .margin(5)
              .fontSize(20)
              .textAlign(TextAlign.Start)

            Blank()
              .width('10%')

            Image($r('app.media.right'))
              .margin(10)
              .width('15%')
              .height('20%')
              .objectFit(ImageFit.Contain)
          }
          .margin(5)
          .width('95%')
          .height('12%')
          .borderRadius(20)
          .backgroundColor('#f6f6f6')
          .onClick(() => {
            try {
              featureAbility.startAbility(
                {
                  want:
                  {
                    bundleName: item.bundleName,
                    abilityName: item.abilityName,
                  },
                }
              ).then((data) => {
                this.text = 'Success!'
                Logger.info(TAG, `End ability data is ${data}} `)
              })
            } catch (err) {
              this.text = 'Error!'
              Logger.info(TAG, `err is ${err}`)
            }
            prompt.showToast({
              message: this.text,
              duration: 1500
            })
          })
        }, item => item.toString())
      }
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
  }
}