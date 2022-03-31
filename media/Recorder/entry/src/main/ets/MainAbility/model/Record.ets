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
export class Record {
  fileName: string
  addDate: string
  filePath: string
  duration: string
  isCheck: boolean

  constructor(fileName: string, filePath: string, addDate: string, duration: string, isCheck: boolean) {
    this.fileName = fileName
    this.filePath = filePath
    this.addDate = addDate
    this.duration = duration
    this.isCheck = isCheck
  }
}