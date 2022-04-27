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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../model/Logger'

class MediaUtils {
    private tag: string = 'MediaUtils'
    private mediaList: Array<mediaLibrary.FileAsset> = []
    private mediaLib: mediaLibrary.MediaLibrary = mediaLibrary.getMediaLibrary(globalThis.abilityContext)

    async queryFile(id) {
        Logger.info(this.tag, `queryFile,id = ${id}`)
        let fileKeyObj = mediaLibrary.FileKey
        if (!id) {
            return
        }
        let args = id.toString()
        let fetchOp = {
            selections: `${fileKeyObj.ID}=?`,
            selectionArgs: [args],
        }
        const fetchFileResult = await this.mediaLib.getFileAssets(fetchOp)
        Logger.info(this.tag, `fetchFileResult.getCount() = ${fetchFileResult.getCount()}`)
        const fileAsset = await fetchFileResult.getAllObject()
        return fileAsset[0]

    }

    getMediaList() {
        return this.mediaList
    }

    async getFdPath(fileAsset: any) {
        let fd = await fileAsset.open('Rw')
        Logger.info(this.tag, `fd = ${fd}`)
        return fd
    }

    async getFileAssetsFromType(mediaType: number) {
        Logger.info(this.tag, `getFileAssetsFromType,mediaType = ${mediaType}`)
        let fileKeyObj = mediaLibrary.FileKey
        let fetchOp = {
            selections: `${fileKeyObj.MEDIA_TYPE}=?`,
            selectionArgs: [`${mediaType}`],
        }
        let fetchFileResult = await this.mediaLib.getFileAssets(fetchOp)
        Logger.info(this.tag, `getFileAssetsFromType,fetchFileResult.count = ${fetchFileResult.getCount()}`)
        if (fetchFileResult.getCount() > 0) {
            this.mediaList = await fetchFileResult.getAllObject()
        }
        return this.mediaList
    }

    deleteFile(media: any) {
        let uri = media.uri
        Logger.info(this.tag, `deleteFile,uri = ${uri}`)
        return this.mediaLib.deleteAsset(uri)
    }

    onDateChange(callback: () => void) {
        this.mediaLib.on('videoChange', () => {
            Logger.info(this.tag, 'videoChange called')
            callback()
        })
    }

    offDateChange() {
        this.mediaLib.off('videoChange')
    }
}

export default new MediaUtils()