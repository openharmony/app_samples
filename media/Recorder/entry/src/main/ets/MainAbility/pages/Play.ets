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
import MediaManager from '../model/MediaManager'
import { Record } from '../model/Record'
import { TitleBar } from '../common/TitleWithBack'
import { PlayView } from '../common/PlayView'
import { AudioModel } from '../model/AudioModel'

@Entry
@Component
struct Play {
  private fileId: number = router.getParams()['fileId']
  private audioModel: AudioModel = new AudioModel()
  @State record: Record = undefined

  async aboutToAppear() {
    this.record = await MediaManager.queryFile(this.fileId)
    if (this.record) {
      this.audioModel.initAudioPlayer(this.record.fileAsset, true)
    }
  }

  build() {
    Column() {
      if (this.record) {
        TitleBar({ title: this.record.fileAsset.title })
        PlayView({ fileName: this.record.title, duration: this.record.duration, audioModel: this.audioModel })
      }
    }
    .height('100%')
    .backgroundColor('#F0F0F0')
  }

  onPageHide() {
    this.audioModel.finish()
  }
}