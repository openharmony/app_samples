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

const TAG = "flybirdDebug"

async function routePage(uri_string, idNum){
  let options = {
    uri:uri_string,
    params: {
      'id': idNum
    }
  }
  try{
    await router.push(options)
  }catch(err){
    console.error(TAG + ' fail callback,code: ${err.code},msg: ${err,msg}')
  }
}

@Entry
@Component
struct Selects{
  build(){
    Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center,justifyContent:FlexAlign.Center}){
      Text('请选择关卡')
        .fontSize(60)
      Button(){
        Text('关卡1')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top : 30
      })
      .backgroundColor('#0D9FFB')
      .onClick(()=> {
        routePage('pages/game', 1)
      })
      Button(){
        Text('关卡2')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top : 30
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        routePage('pages/game', 2)
      })
      Button(){
        Text('关卡3')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top : 30
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        routePage('pages/game', 3)
      })
      Button(){
        Text('关卡4')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top : 30
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        routePage('pages/game', 4)
      })
      Button(){
        Text('关卡5')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top : 30
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        routePage('pages/game', 5)
      })
      Button(){
        Text('返回')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top : 30
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        router.back()
      })
    }
    .width('100%')
    .height('100%')
  }
}