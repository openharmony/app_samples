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

export function getTimeString(timeIndex: number, index: number) {
  let result = timeIndex + index - 3
  if (result < 0) {
    return '        '
  }
  if (result % 60 < 10) {
    return '0' + Math.floor(result / 60) + ':0' + (result % 60)
  }
  if (result % 60 >= 10) {
    return '0' + Math.floor(result / 60) + ':' + (result % 60)
  }
}

export function updateTime(millisecond: number) {
  let minute = parseInt((millisecond / 60000).toString())
  let second = parseInt(((millisecond - (minute * 60000)) / 1000).toString())
  let minuteStr = '' + minute
  let secondStr = '' + second
  if (minute < 10) {
    minuteStr = "0" + minute
  }
  if (second < 10) {
    secondStr = "0" + second
  }
  return minuteStr + ':' + secondStr;
}