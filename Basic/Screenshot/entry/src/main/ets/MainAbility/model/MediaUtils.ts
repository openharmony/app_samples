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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import DateTimeUtil from '../model/datetimeutil'
import Logger from '../model/Logger'

const TAG: string = '[Screenshot]'

export default class MediaUtils {
    private tag: string = 'MediaUtils'
    private mediaTest: mediaLibrary.MediaLibrary = mediaLibrary.getMediaLibrary()
    private static instance: MediaUtils = new MediaUtils()

    public static getInstance() {
        if (this.instance === undefined) {
            this.instance = new MediaUtils()
        }
        return this.instance
    }

    async createAndGetUri(mediaType: number) {
        let info = {
            prefix: 'IMG_', suffix: '.jpg', directory: mediaLibrary.DirectoryType.DIR_IMAGE
        }
        let dateTimeUtil = new DateTimeUtil()
        let name = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`
        let displayName = `${info.prefix}${name}${info.suffix}`
        Logger.info(this.tag, `displayName = ${displayName},mediaType = ${mediaType}`)
        let publicPath = await this.mediaTest.getPublicDirectory(info.directory)
        Logger.info(this.tag, `publicPath = ${publicPath}`)
        let dataUri = await this.mediaTest.createAsset(mediaType, displayName, publicPath)
        return dataUri
    }
}