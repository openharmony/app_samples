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

import router from '@system.router';
var params = router.getParams().message
@Entry
@Component
struct NavigatorDetail1 {
  AboutToAppear(){
    console.log('www data ' + params)
  }
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('目标页面1')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Text(`接收参数：${params}`)
        .fontSize(20)
    }
    .width('100%')
    .height('100%')
  }
}