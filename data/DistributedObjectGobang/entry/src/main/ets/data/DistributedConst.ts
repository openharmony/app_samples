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

class DistributedConst {
  BUNDLE: string = 'ohos.samples.distributedobjectgobang'
  ABILITY: string = 'MainAbility'
  USER_CHESS: number = 1 // 用户落子(白)
  OWN_CHESS: number = 2 // 自己落子(黑)
  SIZE: number = 15 // 棋盘大小
  WIN_NUM: number = 5 // 五子连在一起为赢
  SECOND: number = 1 // 秒
  COUNT_SECOND: number = 30 // 初始时间
  SUBSCRIBE_NUMBER: number = 65536 // SUBSCRIBE_ID在0到65535，用于运算
}

export const distributedConst = new DistributedConst()
