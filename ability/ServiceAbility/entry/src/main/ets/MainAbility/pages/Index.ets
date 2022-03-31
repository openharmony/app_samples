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
import prompt from '@system.prompt'
import rpc from "@ohos.rpc"
import { TitleBar } from '../component/TitleBar'
import { OperateView } from '../component/OperateView'
import { ServiceModel } from '../model/ServiceModel'

let TAG: string = '[ServiceAbility.index]'

@Entry
@Component
struct Index {
  private btnResources: Array<Resource> = [$r('app.string.connect_service'), $r('app.string.disconnect_service'), $r('app.string.sort_string')]
  private serviceModel = new ServiceModel()
  @State beforeSortString: string = ''
  @State afterSortString: string = ''

  async sortString() {
    console.log(`${TAG} sortString begin`)
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    }
    if (this.beforeSortString.length === 0) {
      prompt.showToast({
        message: 'please input a string'
      })
    }
    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    data.writeString(this.beforeSortString)
    await mRemote.sendRequest(1, data, reply, option)
    let msg = reply.readString()
    this.afterSortString = msg
  }

  build() {
    Column() {
      TitleBar()
      Scroll() {
        Column() {
          OperateView({ before: $beforeSortString, after: $afterSortString })
          ForEach(this.btnResources, (item, index) => {
            Button() {
              Text(item)
                .fontColor(Color.White)
                .fontSize(20)
            }
            .type(ButtonType.Capsule)
            .backgroundColor('#0D9FFB')
            .width('94%')
            .height(50)
            .margin(10)
            .onClick(() => {
              console.info(`${TAG} button clicked,index=${index}`)
              switch (index) {
                case 0:
                  this.serviceModel.connectService()
                  break
                case 1:
                  this.serviceModel.disconnectService()
                  break
                case 2:
                  this.sortString()
                  break
                default:
                  break
              }
            })
          }, item => JSON.stringify(item))
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}