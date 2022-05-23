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
import resourceManager from '@ohos.resourceManager'

class ResourceUtil {
    async getString(id: number) {
        let rscManager = await resourceManager.getResourceManager()
        let str = await rscManager.getString(id)
        return str
    }

    async getStringArray(id: number) {
        let rscManager = await resourceManager.getResourceManager()
        let strArray = await rscManager.getStringArray(id)
        return strArray
    }

    async getPluralString(id: number, num: number) {
        let rscManager = await resourceManager.getResourceManager()
        let plural = await rscManager.getPluralString(id, num)
        return plural
    }

    async getDirection() {
        let rscManager = await resourceManager.getResourceManager()
        let configuration = await rscManager.getConfiguration()
        if (configuration.direction === 1) { // 1代表Horizontal，0代表Vertical
            return 'Horizontal'
        } else {
            return 'Vertical'
        }
    }
}

export default new ResourceUtil()