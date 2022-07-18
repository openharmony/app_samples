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

import FormExtension from '@ohos.application.FormExtension'
import formBindingData from '@ohos.application.formBindingData'
import formInfo from '@ohos.application.formInfo'
import formProvider from '@ohos.application.formProvider'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import fileio from '@ohos.fileio'
import preferences from '@ohos.data.preferences'
import Logger from '../data/Logger'
import GalleryFormConst from '../data/GalleryFormConst'

const TAG: string = 'FormAbility'
let counts: number = 0

export default class FormAbility extends FormExtension {
  getPreferences(context, key) {
    return preferences.getPreferences(context, key)
  }

  // 从图库获取图片uri
  async getImageUri(context) {
    let media = mediaLibrary.getMediaLibrary(context)
    let fileKey = mediaLibrary.FileKey
    let mediaFetchOptions = {
      selections: `${fileKey.MEDIA_TYPE}=?`,
      selectionArgs: [mediaLibrary.MediaType.IMAGE.toString()],
    }
    let fetchFileResult = await media.getFileAssets(mediaFetchOptions)
    Logger.info(TAG, `getFileAsset getFileAssetsFromType fetchFileResult.count = ${fetchFileResult.getCount()}`)
    let fileAssets = await fetchFileResult.getAllObject()
    Logger.info(TAG, `getAllObject result = ${fileAssets.length}`)
    await media.release()
    return fileAssets
  }

  // 更新卡片内容
  async refreshData(formId) {
    Logger.info(TAG, `refreshData`)
    let fileAssets = await this.getImageUri(this.context)
    let preferences = await this.getPreferences(this.context, 'preferences')
    let preferencesValue = <number> await preferences.get('count', -1)
    if (preferencesValue !== -1) {
      counts = preferencesValue
    }
    if (counts >= fileAssets.length) {
      counts = 0
    }
    if (fileAssets.length > 0 && fileAssets[counts] !== null) {
      Logger.info(TAG, `fileAssets open start`)
      let fd = await fileAssets[counts].open('r')
      Logger.info(TAG, `fd = ${fd}`)
      let formBindingDataObj = undefined
      if (counts === 0) {
        formBindingDataObj = {
          'jsonImage': 'memory://iamge0',
          'formImages': {
            'iamge0': fd
          }
        }
      } else {
        formBindingDataObj = {
          'jsonImage': 'memory://iamge1',
          'formImages': {
            'iamge1': fd
          }
        }
      }
      Logger.info(TAG, `formBindingDataObj = ${JSON.stringify(formBindingDataObj)}`)
      await formProvider.updateForm(formId, formBindingData.createFormBindingData(formBindingDataObj))
      await preferences.put('count', ++counts)
      await preferences.flush()
      Logger.info(TAG, `update finish, COUNT = ${preferences.get('count', 'NA')}`)
      formProvider.setFormNextRefreshTime(formId, 5, () => {
        Logger.info(TAG, `setFormNextRefreshTime ${counts} end`)
      })
    }
  }

  onCreate(want) {
    Logger.info(TAG, `onCreate`)
    let formId = want.parameters[GalleryFormConst.FORM_PARAM_IDENTITY_KEY]
    let fd = fileio.openSync('/data/storage/el1/bundle/entry/resources/base/media/poster.png') // 本地图片路径
    let formBindingDataObj = {
      'jsonImage': 'memory://iamge',
      'formImages': {
        'iamge': fd
      }
    }
    let formData = formBindingData.createFormBindingData(formBindingDataObj)
    formProvider.setFormNextRefreshTime(formId, 5, () => {
      Logger.info(TAG, `setFormNextRefreshTime end`)
    })
    return formData
  }

  onCastToNormal(formId) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdate(formId) {
    // Called to notify the form provider to update a specified form.
    Logger.info(TAG, 'onUpdate')
    this.refreshData(formId)
  }

  onVisibilityChange(newStatus) {
    // Called when the form provider receives form events from the system.
  }

  onEvent(formId, message) {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onDestroy(formId) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY
  }
}