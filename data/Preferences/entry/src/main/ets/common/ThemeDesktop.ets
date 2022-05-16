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
export default struct ThemeDesktop {
  @Link themeDatas: Array<{
    image: Resource,
    name: string
  }>

  build() {
    Grid() {
      ForEach(this.themeDatas, (item) => {
        GridItem() {
          Column() {
            Image(item.image)
              .width(70)
              .height(70)
              .padding(10)
              .objectFit(ImageFit.Fill)
            Text(item.name).fontSize(15)
          }
          .width(90)
          .height(90)
        }
      }, item => item.name)
    }
    .rowsGap(10)
    .width('100%')
    .columnsGap(10)
    .layoutWeight(1)
    .padding({ top: 20 })
    .backgroundColor('#e5e5e5')
    .columnsTemplate('1fr 1fr 1fr 1fr')
  }
}