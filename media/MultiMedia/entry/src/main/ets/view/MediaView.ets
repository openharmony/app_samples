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
import Album from '../pages/Index'

@Component
export struct MediaView {
  @Link albums: Array<Album>

  build() {
    Column() {
      List() {
        ForEach(this.albums, (item, index) => {
          ListItem() {
            Row() {
              Text(item.albumName)
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Start)
              Blank()
              Text(`${item.count}`)
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .padding(16)
            .constraintSize({ minHeight: 70 })
          }
          .onClick(() => {
            if (item.count > 0) {
              router.push({
                url: 'pages/AlbumPage',
                params: { albumName: item.albumName, mediaType: item.mediaType }
              })
            } else {
              AlertDialog.show(
                {
                  title: $r('app.string.album_empty'),
                  message: null,
                  primaryButton: {
                    value: $r('app.string.yes'),
                    fontColor: Color.Red,
                    action: () => {
                    }
                  }
                }
              )
            }
          })
        }, item => item.albumName)
      }
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 16, endMargin: 16 })
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
}