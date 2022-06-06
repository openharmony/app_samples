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

import Mission from '../modle/Mission'
import missionManager from '@ohos.application.missionManager'
import Logger from '../modle/Logger'
import image from '@ohos.multimedia.image'

const TAG: string = 'MissionInfoComponent'

@Component
export struct MissionInfoComponent {
  @State missionSnapshot: image.PixelMap | undefined = undefined
  @State isOn: boolean = undefined
  @State translateLeft: number = 0
  @State translateRight: number = -350
  @State panDirection: PanDirection = PanDirection.Left
  private mission: Mission
  private handlerRefresh: () => void

  onClickLockMission(missionId: number) {
    this.isOn = true
    missionManager.lockMission(missionId).then(() => {
      Logger.info(TAG, 'lockMission is called')
      this.handlerRefresh()
    })
  }

  onClickUnlockMission(missionId: number) {
    this.isOn = false
    missionManager.unlockMission(missionId).then(() => {
      Logger.info(TAG, 'UnlockMission is called')
      this.handlerRefresh()
    })
  }

  onClickClearMission(missionId: number) {
    missionManager.clearMission(missionId).then(() => {
      Logger.info(TAG, 'ClearMission is called')
      this.handlerRefresh()
    })
  }

  onClickMoveMissionToFront(missionId: number) {
    missionManager.moveMissionToFront(missionId).then(() => {
      Logger.info(TAG, 'moveMissionToFront is called')
    })
  }

  @Builder RowOfSquareTexts(resourceText: Resource, stringText: string | Resource) {
    Row() {
      Text(resourceText)
        .fontSize(20)
        .fontWeight(10)
      Text(stringText)
        .height(40)
        .fontSize(16)
        .textAlign(TextAlign.Center)
    }
  }

  @Builder RowOfSquareButtons(button: Resource, color, handlerClick) {
    Text(button)
      .width(100)
      .height(200)
      .fontSize(30)
      .textAlign(TextAlign.Center)
      .margin({ top: 10 })
      .backgroundColor(color)
      .onClick(handlerClick)
  }

  async getSnapshot() {
    Logger.info(TAG, `mission= ${JSON.stringify(this.mission)}`)
    let missionSnapshot = await missionManager.getMissionSnapShot('', this.mission.missionId)
    this.missionSnapshot = missionSnapshot.snapshot
    Logger.info(TAG, `getMissionSnapShot missionSnapshot = ${JSON.stringify(missionSnapshot)}`)
  }

  onRunningState(runningState: number) {
    return runningState === 0 ? $r('app.string.is') : $r('app.string.no')
  }

  onLockedState(lockedState: boolean) {
    return lockedState ? $r('app.string.is') : $r('app.string.no')
  }

  onContinuable(continuable: boolean) {
    return continuable ? $r('app.string.is') : $r('app.string.no')
  }

  aboutToAppear() {
    this.getSnapshot()
    this.isOn = this.mission.lockedState
  }

  build() {
    Row() {
      Row() {
        Image(this.missionSnapshot)
          .objectFit(ImageFit.Contain)
          .size({ width: 100, height: 200 })
          .margin({ left: 20, right: 40 })
        Column() {
          this.RowOfSquareTexts($r('app.string.bundle_name'), this.mission.want.bundleName)
          this.RowOfSquareTexts($r('app.string.running_state'), this.onRunningState(this.mission.runningState))
          this.RowOfSquareTexts($r('app.string.locked_state'), this.onLockedState(this.mission.lockedState))
          this.RowOfSquareTexts($r('app.string.continuable'), this.onContinuable(this.mission.continuable))
        }
        .width('50%')
        .height(200)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      }
      .backgroundColor('#f5f5f5')
      .borderRadius(20)

      Row() {
        if (this.isOn) {
          this.RowOfSquareButtons($r('app.string.unlocked_mission'), '#0D9FFB', () => {
            this.onClickUnlockMission(this.mission.missionId)
          })
        } else {
          this.RowOfSquareButtons($r('app.string.locked_mission'), '#0D9FFB', () => {
            this.onClickLockMission(this.mission.missionId)
          })
        }
        this.RowOfSquareButtons($r('app.string.move_mission'), Color.Orange, () => {
          this.onClickMoveMissionToFront(this.mission.missionId)
        })
        this.RowOfSquareButtons($r('app.string.clear_mission'), '#ffea0606', () => {
          this.onClickClearMission(this.mission.missionId)
        })
      }
      .margin({ left: 20 })
    }
    .padding(10)
    .margin({ left: this.translateLeft, right: this.translateRight })
    .gesture(
      PanGesture({ fingers: 1, direction: this.panDirection, distance: 20 })
        .onActionStart(() => {
          Logger.info(TAG, `PanGesture onActionStart`)
          if (this.panDirection === PanDirection.Left) {
            this.panDirection = PanDirection.Right
            this.translateLeft = -350
            this.translateRight = 0
          } else {
            this.panDirection = PanDirection.Left
            this.translateLeft = 0
            this.translateRight = -350
          }
        })
    )
  }
}