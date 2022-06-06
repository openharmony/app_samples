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

import missionManager from '@ohos.application.missionManager'
import Logger from '../modle/Logger'
import Mission from '../modle/Mission'
import { MissionInfoComponent } from '../common/MissionInfoComponent'
import { TitleBar } from '../common/TitleBar'

const TAG: string = 'Index'
const NUMMAX: number = 10

@Entry
@Component
struct Index {
  @State missionInfos: Array<Mission> = []
  @State listenerId: number = 0
  @State isRefreshing: boolean = false
  @State refreshMission: Resource = $r('app.string.get_mission_manager')
  @State isShow: boolean = true

  onMissionCreatedCallback() {
    Logger.info(TAG, `onMissionCreatedCallback Created`)
  }

  onMissionDestroyedCallback() {
    Logger.info(TAG, `onMissionDestroyedCallback destroyed`)
  }

  onMissionSnapshotChangedCallback() {
    Logger.info(TAG, `onMissionSnapshotChangedCallback  snapshot changed`)
  }

  onMissionMovedToFrontCallback() {
    Logger.info(TAG, `onMissionMovedToFrontCallback moved to fornt`)
  }

  onMissionIconUpdatedCallback() {
    Logger.info(TAG, `onMissionIconUpdatedCallback icon has changed`)
  }

  handlerRefresh = () => {
    Logger.info(TAG, `clickCallback start`)
    this.isShow = false
    missionManager.getMissionInfos('', NUMMAX, async (error, data) => {
      Logger.info(TAG, `MissionInfos: ${JSON.stringify(data)}`)
      this.missionInfos = []
      setTimeout(() => {
        this.missionInfos = data.map((item) => {
          return item
        })
        Logger.info(TAG, `getMissionInfos missionInfos= ${JSON.stringify(this.missionInfos)}`)
      }, 1000)
    })
  }

  aboutToAppear() {
    let listener = {
      onMissionCreated: this.onMissionCreatedCallback,
      onMissionDestroyed: this.onMissionDestroyedCallback,
      onMissionSnapshotChanged: this.onMissionSnapshotChangedCallback,
      onMissionMovedToFront: this.onMissionMovedToFrontCallback,
      onMissionIconUpdated: this.onMissionIconUpdatedCallback
    }

    this.listenerId = missionManager.registerMissionListener(listener)
    Logger.info(TAG, `aboutToAppear ${this.listenerId}`)
  }

  aboutToDisappear() {
    missionManager.unregisterMissionListener(this.listenerId)
  }

  build() {
    Column() {
      TitleBar()
      Text(this.isShow ? this.refreshMission : '')
        .fontSize(30)
        .margin(10)
      Refresh({ refreshing: this.isRefreshing, offset: 120, friction: 100 }) {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(this.missionInfos, (item) => {
            ListItem() {
              MissionInfoComponent({ mission: item, handlerRefresh: this.handlerRefresh })
            }
          }, item => item.bundleName)
        }
        .height('90%')
      }
      .width('95%')
      .onRefreshing(this.handlerRefresh)
    }
    .width('100%')
  }
}