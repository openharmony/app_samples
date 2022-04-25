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
import resourceManager from '@ohos.resourceManager';

@Entry
@Component
struct Index {
  @State string_str: string = ''
  @State strArray: string = 'stringArray:'
  @State plural: string = 'plural:'
  @State configuration: string = ''
  @State capability: string = ''
  @State media: string = 'icon'
  @State mediaBase: string = 'icon'

  aboutToAppear() {
    resourceManager.getResourceManager().then(mgr => {
      mgr.getString(0x1000007, (error, value) => {
        console.log('ResourceManager:getString string_str error=' + error + ',value=' + value);
        if (error != null) {
          return;
        }
        this.string_str += value
      });
      mgr.getStringArray(0x1000009, (error, value) => {
        console.log('ResourceManager:getStringArray error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.strArray += JSON.stringify(value)
      });
      mgr.getString(0x1000000, (error, value) => {
        console.log('ResourceManager:getString capability error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.capability = value
      });
      mgr.getString(0x1000001, (error, value) => {
        console.log('ResourceManager:getString configuration error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.configuration = value
      });
      mgr.getPluralString(0x100000a, 2, (error, value) => {
        console.log('ResourceManager:getPluralString error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.plural += JSON.stringify(value)
      });
      mgr.getDeviceCapability((error, value) => {
        console.log('ResourceManager:getDeviceCapability error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.capability += JSON.stringify(value)
      });

      mgr.getString(0x1000006, (error, value) => {
        console.log('ResourceManager:getString mediaBase error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.mediaBase += value
      });
      mgr.getConfiguration((error, value) => {
        console.log('ResourceManager:getConfiguration error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.configuration += JSON.stringify(value)
      });
      mgr.getString(0x1000005, (error, value) => {
        console.log('ResourceManager:getString media error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.media += value
      });
      mgr.getMedia(0x100000b, (error, value) => {
        console.log('ResourceManager:getMedia error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.media += value.length
      });
      mgr.getMediaBase64(0x100000b, (error, value) => {
        console.log('ResourceManager:getMediaBase64 error=' + error + ',value=' + value);
        if (error != null) {
          return
        }
        this.mediaBase += value.length
      });
    }).catch(error => {
      console.log(error);
    });
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
      Text($r("app.string.title"))
        .width('100%')
        .height(50)
        .backgroundColor('#0D9FFB')
        .fontColor(Color.White)
        .fontSize(20)
        .padding({ left: 15 })

      Scroll() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
          Text(this.string_str)
            .fontSize(25)
          Text(this.strArray)
            .fontSize(25)
          Text(this.plural)
            .fontSize(25)
          Text(this.capability)
            .fontSize(25)
          Text(this.configuration)
            .fontSize(25)
          Text(this.media)
            .fontSize(25)
          Text(this.mediaBase)
            .fontSize(25)
        }
        .width('100%')
        .padding(15)
      }
    }
    .width('100%')
    .height('100%')
  }
}