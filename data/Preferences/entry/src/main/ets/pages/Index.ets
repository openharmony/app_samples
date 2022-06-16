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

import Logger from '../model/Logger'
import preferences from '@ohos.data.preferences'
import ThemeDesktop from '../common/ThemeDesktop'

const THEMES = [
  [
    { image: $r('app.media.dialer'), name: '电话' },
    { image: $r('app.media.shopping'), name: '商城' },
    { image: $r('app.media.notes'), name: '备忘录' },
    { image: $r('app.media.settings'), name: '设置' },
    { image: $r('app.media.camera'), name: '相机' },
    { image: $r('app.media.gallery'), name: '相册' },
    { image: $r('app.media.music'), name: '音乐' },
    { image: $r('app.media.video'), name: '视频' },
  ],
  [
    { image: $r('app.media.simplicityCall'), name: '电话' },
    { image: $r('app.media.simplicityShop'), name: '商城' },
    { image: $r('app.media.simplicityNotes'), name: '备忘录' },
    { image: $r('app.media.simplicitySetting'), name: '设置' },
    { image: $r('app.media.simplicityCamera'), name: '相机' },
    { image: $r('app.media.simplicityPhotos'), name: '相册' },
    { image: $r('app.media.simplicityMusic'), name: '音乐' },
    { image: $r('app.media.simplicityVideo'), name: '视频' },
  ],
  [
    { image: $r('app.media.pwcall'), name: '电话' },
    { image: $r('app.media.pwshop'), name: '商城' },
    { image: $r('app.media.pwnotes'), name: '备忘录' },
    { image: $r('app.media.pwsetting'), name: '设置' },
    { image: $r('app.media.pwcamera'), name: '相机' },
    { image: $r('app.media.pwphotos'), name: '相册' },
    { image: $r('app.media.pwmusic'), name: '音乐' },
    { image: $r('app.media.pwvideo'), name: '视频' },
  ]
]
const TAG: string = '[Index]'
const PREFERENCES_NAME = 'theme.db'
const THEME_NAMES: string[] = ['default', 'simplicity', 'pomeloWhtie']
let preferenceTheme: preferences.Preferences = null

@Entry
@Component
struct Index {
  @State nowTheme: string = ''
  @State themeDatas: Array<{
    image: Resource,
    name: string
  }> = []

  async aboutToAppear() {
    //从内存中获取轻量级存储db文件
    await this.getPreferencesFromStorage()
    //从轻量级存储db文件中获取键名为theme的键值
    this.nowTheme = await this.getPreference()
    let index = THEME_NAMES.indexOf(this.nowTheme)
    this.themeDatas = THEMES[index]
  }

  async getPreferencesFromStorage() {
    preferenceTheme = await preferences.getPreferences(globalThis.abilityContext, PREFERENCES_NAME)
  }

  async putPreference(data: string) {
    Logger.info(TAG, `Put begin`)
    if (preferenceTheme !== null) {
      await preferenceTheme.put('theme', data)
      await preferenceTheme.flush()
    }
  }

  async getPreference() {
    Logger.info(TAG, `Get begin`)
    let theme: string = ''
    if (preferenceTheme !== null) {
      theme = <string> await preferenceTheme.get('theme', 'default')
      return theme
    }
  }

  changeTheme(themeNum: number) {
    this.themeDatas = THEMES[themeNum]
    this.putPreference(THEME_NAMES[themeNum])
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Row() {
        Text($r('app.string.MainAbility_label'))
          .fontSize(25)
          .layoutWeight(5)
          .padding({ left: 10 })
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
        Image($r('app.media.change'))
          .height(30)
          .layoutWeight(1)
          .objectFit(ImageFit.ScaleDown)
          .bindMenu([
            {
              value: THEME_NAMES[0],
              action: () => {
                this.changeTheme(0)
              }
            },
            {
              value: THEME_NAMES[1],
              action: () => {
                this.changeTheme(1)
              }
            },
            {
              value: THEME_NAMES[2],
              action: () => {
                this.changeTheme(2)
              }
            }
          ])
      }
      .width('100%')
      .height(50)
      .backgroundColor('#0D9FFB')

      ThemeDesktop({ themeDatas: $themeDatas })
    }
    .width('100%')
    .height('100%')
  }
}