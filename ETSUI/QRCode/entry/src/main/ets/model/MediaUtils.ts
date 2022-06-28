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
import image from '@ohos.multimedia.image'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import fileio from '@ohos.fileio'
import prompt from '@ohos.prompt'
import DateTimeUtil from '../model/DateTimeUtil'
import Logger from '../model/Logger'

const TAG: string = '[MediaUtils]'

class MediaUtils {
    private tag: string = 'MediaUtils'
    private mediaTest: mediaLibrary.MediaLibrary = mediaLibrary.getMediaLibrary(globalThis.abilityContext)

    async createAndGetFile() {
        let info = {
            prefix: 'IMG_', suffix: '.jpg', directory: mediaLibrary.DirectoryType.DIR_IMAGE
        }
        let dateTimeUtil = new DateTimeUtil()
        let name = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`
        let displayName = `${info.prefix}${name}${info.suffix}`
        Logger.info(this.tag, `displayName = ${displayName}`)
        let publicPath = await this.mediaTest.getPublicDirectory(info.directory)
        return await this.mediaTest.createAsset(mediaLibrary.MediaType.IMAGE, displayName, publicPath)
    }

    async queryFile(uri: string) {
        let fetchOp = {
            selections: '',
            selectionArgs: [],
            uri: uri
        }

        let fileAssetsResult = await this.mediaTest.getFileAssets(fetchOp)
        Logger.info(TAG, `queryFile fetchFileResult.getCount() = ${fileAssetsResult.getCount()}`)
        return await fileAssetsResult.getFirstObject()
    }

    async getPixelMap(uri: string) {
        Logger.info(this.tag, `getPixelMap, uri = ${uri}`)
        let file = await this.queryFile(uri)
        if (file.mediaType === mediaLibrary.MediaType.IMAGE) {
            let fd = await file.open('r')
            Logger.info(this.tag, `getPixelMap, fd = ${fd}`)
            let imageResource = await image.createImageSource(fd)
            let pixelMap = await imageResource.createPixelMap()
            await imageResource.release()
            file.close(fd)
            return pixelMap
        }
        return null
    }

    async savePicture(data: image.PixelMap) {
        Logger.info(TAG, `savePicture`)
        let packOpts: image.PackingOption = {
            format: "image/jpeg", quality: 100
        }
        let imagePackerApi = image.createImagePacker()
        let arrayBuffer = await imagePackerApi.packing(data, packOpts)
        let fileAsset = await this.createAndGetFile()
        let fd = await fileAsset.open('Rw')
        imagePackerApi.release()
        await fileio.write(fd, arrayBuffer)
        await fileAsset.close(fd)
        Logger.info(TAG, `write done`)
        prompt.showToast({
            message: '图片保存成功', duration: 1000
        })
    }
}

export default new MediaUtils()