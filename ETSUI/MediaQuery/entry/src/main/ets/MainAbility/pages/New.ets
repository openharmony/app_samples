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
import router from '@system.router'
import { NewView } from '../common/NewView'
import { getNew } from '../model/New'
import { TitleBar } from '../common/TitleWithBack'

@Entry
@Component
struct New {
  private newId: number = <number> router.getParams().newId
  private title: string = <string> router.getParams().title
  @State currentNew: { newId: number,content: Resource, img: Resource } = undefined

  aboutToAppear() {
    this.currentNew = getNew(this.newId)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      TitleBar({ title: this.title })
      NewView({ currentNew: $currentNew })
    }
    .width('100%')
    .height('100%')
  }
}