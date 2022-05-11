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

import { appInit } from '../model/AppInfo'
import AppTime from '../model/AppTime'

export function hmsToString(time: number) {
  let timeStr: string = ''
  if (Math.floor(time / 60 / 60 % 24) > 1) {
    timeStr = `${Math.floor(time / 60 / 60 % 24)} 时 ${Math.floor(time / 60 % 60)
      } 分 ${Math.floor(time % 60)} 秒`
  } else if (Math.floor(time / 60 % 60) > 1) {
    timeStr = `${Math.floor(time / 60 % 60)} 分 ${Math.floor(time % 60)} 秒`
  } else {
    timeStr = `${Math.floor(time % 60)} 秒`
  }
  return timeStr
}

export function getAppName(bundleName: string) {
  let i = 0
  let name = ''
  let apps = appInit()
  for (i = 0; i < apps.length; i++) {
    if (apps[i].bundleName === bundleName) {
      name = apps[i].name
    }
  }
  if (name == '') {
    return bundleName.substr(13, bundleName.length - 1)
  } else {
    return name
  }
}

export function getAppIcon(bundleName: string) {
  let i = 0
  let apps = appInit()
  let icon = $r('app.media.icon')
  for (i = 0; i < apps.length; i++) {
    if (apps[i].bundleName === bundleName) {
      icon = apps[i].icon
    }
  }
  return icon
}

export function getTotalTime(list: Array<AppTime>) {
  let totalTime = 0
  for (let index = 0; index < list.length; index++) {
    totalTime += list[index].totalTime
  }
  return totalTime
}

export function getTimStr(date: Date) {
  return `${date.getFullYear()}-${date.getMonth()}-${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`
}