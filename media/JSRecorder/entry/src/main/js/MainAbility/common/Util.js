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

import fileIo from '@ohos.fileio'
import logger from '../common/Logger'
import dataStorage from '@ohos.data.storage'
import featureAbility from '@ohos.ability.featureAbility'

export let PATH = ''
const TAG = '[util]'
const MINUTE = 60
const MILLISECOND = 1000
export class Util {
    storage = undefined

    constructor() {
        this.initStorage()
    }

    initStorage() {
        let context = featureAbility.getContext()
        context.getFilesDir().then(path => {
            PATH = `${path}/`
            logger.info(`${TAG} create store PATH=${PATH}`)
            this.storage = dataStorage.getStorageSync(`${path}/myStore`)
            logger.info(`${TAG} create store success`)
        })
    }

    put(value) {
        logger.info(`${TAG} enter put value= ${JSON.stringify(value)}`)
        let putValue = JSON.stringify(this.putList(value))
        logger.info(`${TAG} putValue= ${putValue}`)
        this.storage.putSync('record_files', putValue)
        this.storage.flush()
        logger.info(`${TAG} flush success`)
    }

    putList(value) {
        let list = []
        logger.info(`${TAG} typeof(list)= ${typeof(list)}`)
        if (!Array.isArray(value)) {
            logger.info(`${TAG} this.storage.hasSync('record_files')= ${this.storage.hasSync('record_files')}`)
            if (this.storage.hasSync('record_files')) {
                list = JSON.parse(this.get())
                logger.info(`${TAG} List= ${JSON.stringify(list)}` )
                //判断修改文件名是否已存在
                for (let i = 0; i < list.length; i++) {
                    if (list[i].file === value.file) {
                        return
                    }
                }
            }
            list.push(value)
        } else {
            list = value
        }
        logger.info(`${TAG} return putList= ${JSON.stringify(list)} `)
        return list
    }

    get() {
        let value = this.storage.getSync('record_files', '')
        logger.info(`${TAG} value is ${JSON.stringify(value)}`)
        return value
    }
}
export async function getFdNumber(path) {
    logger.info(`${TAG} getFdNumber,path=${path}`)
    let fdNumber = await fileIo.open(path)
    return `fd://${fdNumber}`
}

export async function prepareFdNumber(path) {
    logger.info(`${TAG} prepareFdNumber,path=${path}`)
    let fdNumber = await fileIo.open(path, 0o2, 0o666)
    return `fd://${fdNumber}`
}

export function updateTime(millisecond) {
    logger.info(`${TAG} millisecond is ${millisecond}`)
    let minute = Math.floor(millisecond / (MILLISECOND * MINUTE))
    let second = Math.floor((millisecond - (minute * MILLISECOND * MINUTE)) / MILLISECOND)
    let minuteStr = '' + minute
    let secondStr = '' + second
    if (minute < 10) {
        minuteStr = "0" + minute
    }
    if (second < 10) {
        secondStr = "0" + second
    }
    logger.info(`${TAG} dateTime= ${minuteStr}:${secondStr}`)
    return `${minuteStr}:${secondStr}`
}
