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

export class Icon {
  icon: Resource
  name: string

  constructor(icon: Resource, name: string) {
    this.icon = icon
    this.name = name
  }
}

export function iconInit(): Array<Icon> {
  let iconList = [
    { icon: $r('app.media.call'), name: '电话' },
    { icon: $r('app.media.mms'), name: '短信' },
    { icon: $r('app.media.music'), name: '音乐' },
    { icon: $r('app.media.notes'), name: "备忘录" },
    { icon: $r('app.media.camera'), name: "相机" },
    { icon: $r('app.media.video'), name: "相册" }
  ]
  return iconList
}


