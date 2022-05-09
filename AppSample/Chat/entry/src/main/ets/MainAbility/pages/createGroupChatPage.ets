/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import { Header } from '../components/Header';

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
      Row()
        .width("100%")
        .height(2)
        .backgroundColor(0xF1F3F5)
      functionRow({ title: "面对面建群" })
      functionRow({ title: "选择企业聊天联系人" })
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

@Component
struct functionRow {
  //跳转的路由地址
  @State routerStr: string = ''
  //显示的文字
  @State title: string = ''

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Text(this.title)
        .fontSize(16)
      Image("/resources/images/right.png")
        .height(15)
        .width(15)
        .opacity(0.5)
        .margin({ left: 10, top: 2 })
    }
    .width("100%")
    .height(70)
    .backgroundColor(0xffffff)
    .padding({ left: 20, right: 20 })
    .onClick(() => {
      router.push({
        uri: this.routerStr
      })
    })
  }
}

@Component
struct MySearchComponent {
  @State changevalue: string = ''
  @State submitvalue: string = ''

  build() {
    Column() {
      Search({ value: '', placeholder: '搜索' })
        .placeholderColor(0x999999)
        .placeholderFont({ size: 18, weight: 10, family: 'serif', style: FontStyle.Normal })
        .onSubmit((value: string) => {
          this.submitvalue = value
        })
        .onChange((value: string) => {
          this.changevalue = value
        })
          //待处理：搜索框颜色不能为白
        .backgroundColor(0xffffff)
    }
  }
}