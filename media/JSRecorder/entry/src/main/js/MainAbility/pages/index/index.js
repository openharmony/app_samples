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

import router from '@ohos.router'
import prompt from '@ohos.prompt'
import process from '@ohos.process'
import logger from '../../common/Logger'
import { Util, PATH } from '../../common/Util'
import featureAbility from '@ohos.ability.featureAbility'

const TAG = '[index]'

export default {
  data: {
    util: new Util(),
    list: [],
    showList: [],
    Num: 0,
    file: '',
    path: '',
    date: '',
    oldName: '',
    newName: '',
    isLongPress: false,
  },

  onInit() {
    logger.info(`${TAG} grantPermission`)
    let context = featureAbility.getContext()
    context.requestPermissionsFromUser(['ohos.permission.MICROPHONE'], 666, function (result) {
      logger.info(`${TAG} grantPermission,requestPermissionsFromUser,result=${JSON.stringify(result)}`)
    })
    logger.info(`${TAG} enter oninit`)
    this.util.initStorage()
  },

  onShow() {
    if (this.util.get() !== '') {
      logger.info(`${TAG} getStorage = ${JSON.parse(this.util.get())}`)
      this.list = JSON.parse(this.util.get())
    }
  },

  createFile() {
    let time = new Date()
    let year = time.getFullYear()
    let month = this.complementNum(time.getMonth() + 1)
    let day = this.complementNum(time.getDate())
    let hour = this.complementNum(time.getHours())
    let minute = this.complementNum(time.getMinutes())
    let second = this.complementNum(time.getSeconds())
    this.file = `${year}${month}${day}_${hour}${minute}${second}`
    logger.info(`${TAG} file:  ${this.file}`)
    this.path = `${PATH}${this.file}.wav`
    logger.info(`${TAG} Path: ${this.path}`)
    var child = process.runCmd(`touch ${this.path};chmod -R 777 ${this.path}`)
    this.result = child == null ? 'failed' : 'succeed'
    logger.info(`${TAG} runCmd= ${this.result}`)
    var result = child.wait()
    result.then(val => {
      this.result = `child process run finish${JSON.stringify(val)}`
    })
    this.date = `${year}/${month}/${day}`
    router.push({
      url: "pages/recorder/recorder",
      params: {
        mainData: {
          file: this.file,
          path: this.path,
          date: this.date,
          isLongPress: this.isLongPress,
        }
      }
    })
    logger.info(`${TAG} OK`)
  },

  complementNum(number) {
    if (number < 10) {
      return `0${number}`
    }
    return JSON.stringify(number)
  },

  onLongPress(item) {
    if (!item.isLongPress) {
      item.isLongPress = true
    }
    this.oldName = item.file
    logger.info(`${TAG} this.oldName= ${this.oldName}`)
  },

  renameDialog() {
    this.$element('renameDialog').show()
    logger.info(`${TAG} enter renameDialog`)
  },

  renameDialogClose(item) {
    this.$element('renameDialog').close()
    logger.info(`${TAG} enter renameDialogClose`)
  },

  deleteDialog() {
    this.$element('deleteDialog').show()
    logger.info(`${TAG} enter deleteDialog`)
  },
  deleteDialogClose() {
    this.$element('deleteDialog').close()
    logger.info(`${TAG} enter deleteDialogClose`)
  },

  change(e) {
    this.newName = e.value
    logger.info(`${TAG} this.newName= ${this.newName}`)
  },

  renameFile() {
    logger.info(`${TAG} enter renameFile`)
    let fileList = this.list.map((item) => {
      return item.file
    })
    logger.info(`${TAG} fileList= ${JSON.stringify(fileList)}`)
    let index = fileList.indexOf(this.oldName)
    logger.info(`${TAG} index= ${JSON.stringify(index)}`)
    let isRename = fileList.indexOf(this.newName)
    logger.info(`${TAG} isRename= ${JSON.stringify(isRename)}`)
    if (isRename !== -1) {
      prompt.showToast({
        message: '该名称已被使用',
        duration: 1000
      })
      return
    }
    this.list[index].file = this.newName
    logger.info(`${TAG} newName= ${JSON.stringify(this.list[index].file)}`)
    logger.info(`${TAG} this.list= ${JSON.stringify(this.list)}`)
    this.util.put(this.list)
    this.list[index].isLongPress = false
    logger.info(`${TAG} this.list[index].isLongPress= ${JSON.stringify(this.list[index])}`)
    this.renameDialogClose()
  },

  deleteFile() {
    let fileList = this.list.map((item) => {
      return item.file
    })
    let index = fileList.indexOf(this.oldName)
    logger.info(`${TAG} index= ${JSON.stringify(index)}`)
    this.list.splice(index, 1)
    logger.info(`${TAG} this.list= ${JSON.stringify(this.list)}`)
    this.util.put(this.list)
    logger.info(`${TAG} list= ${JSON.stringify(this.list)}`)
    this.deleteDialogClose()
  },

  jump(item) {
    if (!item.isLongPress) {
      logger.info(`${TAG} list= ${JSON.stringify(this.list)}`)
      router.push({
        url: "pages/play/play",
        params: {
          file: item.file,
          path: item.path,
          dataTime: item.dataTime,
        }
      })
    }
  }
}