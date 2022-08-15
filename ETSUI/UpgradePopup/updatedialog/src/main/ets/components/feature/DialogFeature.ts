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

import bundle from '@ohos.bundle'
import { AbilityContext } from '../model/DialogDataModel'
import { httpRequest, RequestResponse, RequestResponseContent } from '../net/RequestResponse'

export class DialogFeature {
  async getRichTextData(context: AbilityContext) {
    let richTextData = await context.resourceManager.getString($r('app.string.rich_text').id)
    return richTextData
  }

  async getCurrentVersion() {
    let { versionName } = await this.getApplicationVersion()
    let currentVersion = versionName
    return currentVersion
  }

  async getApplicationVersion() {
    let bundleName = 'ohos.samples.upgradepopup'
    let bundleFlags = 1
    return await bundle.getBundleInfo(bundleName, bundleFlags)
  }

  async getLastVersion() {
    let response = await httpRequest('http://123.60.114.86:8090/version')
    if (response === null || response === undefined) {
      return
    }
    let requestResponse: RequestResponse = JSON.parse(response.result.toString())
    if (requestResponse.data === null || requestResponse.data === undefined) {
      return
    }
    let requestResContent: RequestResponseContent = requestResponse.data
    return requestResContent
  }
}

export const dialogFeature = new DialogFeature()