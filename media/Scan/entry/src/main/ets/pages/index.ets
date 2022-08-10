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

const array: Array<string> = [
  'ohos.permission.CAMERA',
  'ohos.permission.MICROPHONE',
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA',
  'ohos.permission.MEDIA_LOCATION'
];

interface EventHub {
  emit(event: string, ...args: Object[]): void
}

interface AbilityContext {
  terminateSelf(): Promise<void>
  eventHub: EventHub
}
@Entry
@Component
struct Index{
  private contexts: AbilityContext
  contextCaller: any

  async aboutToAppear(){
    this.contexts = getContext(this) as AbilityContext
    let data = {
      context: null,
      launchWant: null
    }
    this.contexts.eventHub.emit("getAbilityData", data)
    this.contextCaller = data.context // 拿到全局的context，即类似globalThis.mainAbilityContext
    await this.contextCaller.requestPermissionsFromUser(array)
  }
  build(){
    Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Center,alignItems:ItemAlign.Center}){
      Button("扫一扫").fontSize(25).onClick(()=>{
        router.push({
          url:"pages/second"
        })
      })
    }.width("100%").height("100%")
  }
}