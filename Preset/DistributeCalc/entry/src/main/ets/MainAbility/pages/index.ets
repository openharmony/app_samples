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
import featureAbility from '@ohos.ability.featureAbility'
import mediaQuery from '@ohos.mediaquery'
import Logger from '../model/Logger'
import { ButtonComponent } from '../common/ButtonComponent'
import { ButtonComponentTwo } from '../common/ButtonComponentTwo'
import { create, all, MathJsStatic } from 'mathjs'
import { InPutComponent } from '../common/InPutComponent'
import { KvStoreModel } from '../model/KvStoreModel'
import { RemoteDeviceModel } from '../model/RemoteDeviceModel'
import { TitleBar } from '../common/TitleBar'

const TAG: string = 'Index'
const EXIT: string = 'exit'
const DATA_CHANGE: string = 'dataChange'
const MATH: MathJsStatic = create(all) // 外部库math初始化
let kvStoreModel: KvStoreModel = new KvStoreModel()

@Entry
@Component
struct Index {
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  @State isLand: boolean = false
  @State result: string = ''
  @State @Watch('dataChange') expression: string = ''
  @State isDistributed: boolean = false
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()
  onLand = (mediaQueryResult) => {
    Logger.info(TAG, `onLand: mediaQueryResult.matches= ${mediaQueryResult.matches}`)
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
  }

  dataChange() {
    Logger.info(TAG, `dataChange, expression = ${this.expression}`)
    kvStoreModel.put(DATA_CHANGE, this.expression)
  }

  isOperator(operator) {
    return (
      operator === '+' || operator === '-' || operator === '*' || operator === '/'
    )
  }

  onInputValue = (value) => {
    Logger.info(TAG, `value = ${value}`)
    if (value === 'C') { // 当用户点击C按钮，表达式和运算结果归0
      this.expression = ''
      this.result = ''
      return
    }
    if (value === '') { // 当用户点击删除按钮，表达式删除上一次的输入，重新运算表达式
      this.expression = this.expression.substr(0, this.expression.length - 1)
      this.result = JSON.stringify(MATH.evaluate(this.expression))
      return
    }
    if (this.isOperator(value)) { // 当用户输入的是运算符
      // 判断表达式最后一个字符是运算符则覆盖上一个运算符，否则表达式直接拼接
      if (this.isOperator(this.expression.substr(this.expression.length - 1, this.expression.length))) {
        this.expression = this.expression.substr(0, this.expression.length - 1)
        this.expression += value
      } else {
        this.expression += value
      }
      return
    }
    if (value === '=') { // 当用户点击=按钮
      this.result = ''
      // 判断表达式最后一个字符是运算符，运算结果需要去掉最后一个运算符运算，否则直接运算
      if (this.isOperator(this.expression.substr(this.expression.length - 1, this.expression.length))) {
        this.expression = JSON.stringify(MATH.evaluate(this.expression.substr(0, this.expression.length - 1)))
      } else {
        this.expression = JSON.stringify(MATH.evaluate(this.expression))
      }
      return
    }
    // 输入数字，表达式直接拼接，计算运算结果
    this.expression += value
    this.result = JSON.stringify(MATH.evaluate(this.expression))
  }

  aboutToAppear() {
    let context = featureAbility.getContext()
    context.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], 666, function (result) {
      Logger.info(TAG, `grantPermission,requestPermissionsFromUser,result= ${result}`)
    })
    this.listener.on('change', this.onLand)
    featureAbility.getWant((error, want) => {
      Logger.error(TAG, `featureAbility.getWant error = ${JSON.stringify(error)}`)
      Logger.info(TAG, `featureAbility.getWant = ${JSON.stringify(want.parameters)}`)
      if (want.parameters.isFA === 'FA') {
        this.isDistributed = true
      }
    })
    kvStoreModel.setOnMessageReceivedListener(DATA_CHANGE, (value) => {
      Logger.info(TAG, `DATA_CHANGE ${value}`)
      if (this.isDistributed) {
        if (value.search(EXIT) !== -1) {
          Logger.info(TAG, `EXIT ${EXIT}`)
          featureAbility.terminateSelf((error) => {
            Logger.error(TAG, `terminateSelf finished, error= ${error}`)
          });
        } else {
          if (value === 'null') {
            this.expression = ''
          } else {
            this.expression = value
          }
          if (this.isOperator(this.expression.substr(this.expression.length - 1, this.expression.length))) {
            this.result = JSON.stringify(MATH.evaluate(this.expression.substr(0, this.expression.length - 1)))
          } else {
            this.result = JSON.stringify(MATH.evaluate(this.expression))
          }
        }
      }
    })
  }

  startAbilityCallBack(key) {
    Logger.info(TAG, `startAbilityCallBack ${key}`)
    if (DATA_CHANGE === key) {
      kvStoreModel.put(DATA_CHANGE, this.expression)
    }
    if (EXIT === key) {
      kvStoreModel.put(DATA_CHANGE, EXIT)
    }
  }

  build() {
    Column() {
      TitleBar({
        isLand: this.isLand,
        startAbilityCallBack: this.startAbilityCallBack,
        remoteDeviceModel: this.remoteDeviceModel,
        isDistributed: $isDistributed
      })

      if (this.isLand) {
        Row() {
          InPutComponent({ isLand: this.isLand, result: $result, expression: $expression })
          ButtonComponentTwo({ isLand: this.isLand, onInputValue: this.onInputValue })
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        Column() {
          InPutComponent({ isLand: this.isLand, result: $result, expression: $expression })
          ButtonComponent({ isLand: this.isLand, onInputValue: this.onInputValue })
        }
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}