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
export struct NewView{
  @Link currentNew:any

  build(){
    Column(){
      Text(this.currentNew.content)
        .fontSize(22)
        .width('100%')
      Image(this.currentNew.img)
        .width('100%')
        .objectFit(ImageFit.Fill)
        .margin({top:10,bottom:10})
        .height('30%')
    }
    .height('100%')
    .padding(15)
    .layoutWeight(3)
  }
}