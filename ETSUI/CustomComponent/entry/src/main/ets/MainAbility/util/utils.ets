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

export function getTextColor(number, index) {
  if (number == index) {
    return Color.Red
  } else {
    return Color.Black
  }
}

export function checkExist(data: string, list: string[]) {
  for (let i in list) {
    if (list[i] === data) {
      return true
    }
  }
  return false
}

export function refresh(release: Array<ReleaseData>) {
  let list = release
  release = []
  release = list
  return release
}

export function menuTitle(release: Array<ReleaseData>) {
  let title = []
  for (let i in release) {
    title[i] = release[i].title
  }
  return title.reverse()
}


