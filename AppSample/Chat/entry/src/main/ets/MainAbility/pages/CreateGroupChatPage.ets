// @ts-nocheck
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
import { Header, FunctionRow, MySearchComponent } from '../components/Header';

@Entry
@Component
struct CreateGroupChatPage {
  @State message: string = 'Hello World'

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      //页头
      Header({ title: "选择联系人" })
      //搜索
      MySearchComponent()
      //分割线
      Divider().vertical(false).color(0xF1F3F5).strokeWidth(2)
      FunctionRow({ title: "面对面建群" })
      FunctionRow({ title: "选择企业聊天联系人" })
    }
    .width("100%")
    .height("100%")
    .backgroundColor(0xeeeeee)
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}