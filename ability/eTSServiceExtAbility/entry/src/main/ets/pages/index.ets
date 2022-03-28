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
import ServiceModel from '../model/ServiceModel'

const ERROR_CODE = -1;
const SUCCESS_CODE = 1;

@Entry
@Component
struct Index {
  fontColor: string = '#000000'
  private serviceModel = new ServiceModel()
  @State message: Resource = $r("app.string.entry_desc")
  @State localFir: number = 0
  @State localSec: number = 0
  @State remoteCallbackInfo: number = 0
  @State connectState: Resource  = $r("app.string.state_unconnected")

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin(20)
        Row() {
          Text($r("app.string.tips_current_state"))
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
          Text(`：`)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
          Text(this.connectState)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }
        .margin({ bottom: 30 })

        Row() {
          Text($r("app.string.tips_step"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text(`1：`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text($r("app.string.opt_start_ability"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }

        Text($r("app.string.tips_start"))
          .fontSize(15)
        Button() {
          Text($r("app.string.opt_start_ability"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 5,
          bottom: 20
        })
        .backgroundColor('#0D9FFB')
        .width('60%')
        .height('5%')
        .onClick(() => {
          let that = this;
          this.serviceModel.startServiceExtAbility(function (code) {
            if (code === SUCCESS_CODE) {
              that.connectState = $r("app.string.state_start_ability");
            } else {
              that.connectState = $r("app.string.state_start_ability_error");
            }
          })
        })

        Row() {
          Text($r("app.string.tips_step"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text(`2：`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text($r("app.string.tips_enter_two_number"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }

        Text($r("app.string.tips_connect"))
          .fontSize(15)
          .margin({ bottom: 5 })
        TextInput({ placeholder: $r("app.string.tips_connect_first_value") })
          .width('50%')
          .type(InputType.Number)
          .margin({ bottom: 5 })
          .onChange((value) => {
            this.localFir = Number(value);
          })
        TextInput({ placeholder: $r("app.string.tips_connect_second_value") })
          .width('50%')
          .type(InputType.Number)
          .margin({ bottom: 20 })
          .onChange((value) => {
            this.localSec = Number(value);
          })
        Row() {
          Text($r("app.string.tips_step"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text(`3：`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text($r("app.string.opt_connect_ability"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }

        Button() {
          Text($r("app.string.opt_connect_ability"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 5,
          bottom: 5
        })
        .backgroundColor('#0D9FFB')
        .width('60%')
        .height('5%')
        .onClick(() => {
          let that = this;
          this.serviceModel.connectServiceExtAbility(this.localFir, this.localSec, function (code, data) {
            if (code === SUCCESS_CODE) {
              that.connectState = $r("app.string.state_connect_ability");
              that.remoteCallbackInfo = data;
            } else {
              that.connectState = $r("app.string.state_connect_ability_error");
              that.remoteCallbackInfo = data;
            }
          })
        })

        Text($r("app.string.tips_connect_end"))
          .fontSize(15)
          .margin({ bottom: 5 })

        Row() {
          Text($r("app.string.tips_return_result"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text(`： ${this.remoteCallbackInfo}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .margin({ bottom: 20 })

        Row() {
          Text($r("app.string.tips_step"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text(`4：`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text($r("app.string.opt_disconnect_ability"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }

        Button() {
          Text($r("app.string.opt_disconnect_ability"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 5
        })
        .backgroundColor('#0D9FFB')
        .width('60%')
        .height('5%')
        .onClick(() => {
          let that = this;
          this.serviceModel.disconnectServiceExtAbility(function (code) {
            if (code === SUCCESS_CODE) {
              that.connectState = $r("app.string.state_disconnect_ability");
            } else {
              that.connectState = $r("app.string.state_disconnect_ability_error");
            }
          })
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}