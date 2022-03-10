/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import dataStorage from '@ohos.data.storage'
import process from '@ohos.process'
import fileIo from '@ohos.fileio'

export const PATH = '/data/accounts/account_0/appdata/ohos.samples.etsrecorder/files/'

const TAG = '[Record.FileManager]'

export class FileManager {
  private storage = undefined

  constructor() {
    this.initStorage()
  }

  initStorage() {
    this.storage = dataStorage.getStorageSync(PATH + '/myStore')
    console.info(`${TAG}create store success`)
  }

  putToStore(recordList) {
    console.info(`${TAG}putFile: recordList=${JSON.stringify(recordList)}`)
    this.storage.putSync('audio_files', JSON.stringify(recordList))
    this.storage.flush()
  }

  putFile(record) {
    let recordList = this.getFiles()
    for (let i = 0;i < recordList.length; i++) {
      if (recordList[i].fileName === record.fileName) {
        return
      }
    }
    recordList.push(record)
    this.putToStore(recordList)
  }

  getFiles() {
    let value = this.storage.getSync('audio_files', '')
    console.info(`${TAG}getFiles: value=${value}`)
    this.transStrToRecordersModel(value)
    return this.transStrToRecordersModel(value)
  }

  transStrToRecordersModel(str) {
    let recordList = []
    if (str === '') {
      return recordList
    }
    console.info(`${TAG}transStrToRecorderModel:str=${str}`)
    var files = JSON.parse(str)
    for (var file in files) {
      recordList.push({
        fileName: files[file].fileName,
        filePath: files[file].filePath,
        addDate: files[file].addDate,
        duration: files[file].duration,
        isCheck: files[file].isCheck
      })
    }
    return recordList
  }

  tempNum(number) {
    if (number < 10) {
      return "0" + number
    }
    return JSON.stringify(number)
  }

  createFile(callback) {
    console.info(`${TAG} createFile`)
    let Time = new Date()
    let addDate = JSON.stringify(Time.getFullYear()) + '/' + this.tempNum(Time.getMonth() + 1) + '/' + this.tempNum(Time.getDate())
    let fileName = JSON.stringify(Time.getFullYear()) + this.tempNum(Time.getMonth() + 1)
      + this.tempNum(Time.getDate()) + "_" + this.tempNum(Time.getHours())
      + this.tempNum(Time.getMinutes()) + this.tempNum(Time.getSeconds())
    let file = PATH + fileName + ".wav"
    let child = process.runCmd("touch " + file + ";chmod -R 777 /data/accounts/account_0/appdata/ohos.samples.etsrecorder/files/")
    let result = child.wait()
    result.then(() => {
      callback(fileName, file, addDate)
    })
  }

  deleteFile(record, recordList) {
    fileIo.unlinkSync(record.filePath)
    this.putToStore(recordList)
  }

  deleteFiles(records, newRecords) {
    for (let i = 0;i < records.length; i++) {
      fileIo.unlink(records[i].filePath, (err) => {
        if (!err) {
          console.info(`${TAG} delete file=${records[i].filePath}`)
        }
      })
    }
    this.putToStore(newRecords)
  }

  renameFile(record, newName) {
    console.info(`${TAG} renameFile: newName=${newName}`)
    let newFilePath = PATH + newName + ".wav"
    let recordList = this.getFiles()
    fileIo.renameSync(record.filePath, newFilePath)
    for (let i = 0;i < recordList.length; i++) {
      if (recordList[i].fileName == record.fileName) {
        recordList[i].filePath = newFilePath
        recordList[i].fileName = newName
      }
    }
    this.putToStore(recordList)
  }

  isDelete(fileName) {
    let recordList = this.getFiles()
    let result = true
    for (let i = 0;i < recordList.length; i++) {
      if (recordList[i].fileName == fileName) {
        result = false
      }
    }
    return result
  }
}