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

import { ReleaseData } from '../model/releaseData'

export function nearRelease(release: Array<ReleaseData>) {
  let nearList = []
  for (let i in release) {
    if (release[i].isNear === true) {
      nearList.push(release[i])
    }
  }
  return nearList
}

export function hotRelease(release: Array<ReleaseData>) {
  let hotList = []
  let boxList = []
  for (let i in release) {
    if (release[i].playNum >= 5000) {
      boxList.push(release[i])
    }
  }
  hotList = boxList.sort((a, b) => b.playNum - a.playNum)
  return hotList
}


export function classicRelease(release: Array<ReleaseData>) {
  let classicList = []
  let boxList = []
  for (let i in release) {
    if (release[i].BarrageNum >= 500) {
      boxList.push(release[i])
    }
  }
  classicList = boxList.sort((a, b) => b.BarrageNum - a.BarrageNum)
  return classicList
}