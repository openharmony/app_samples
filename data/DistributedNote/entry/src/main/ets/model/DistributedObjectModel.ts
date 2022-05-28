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
import distributedObject from '@ohos.data.distributedDataObject'
import Logger from './Logger'
import Note from '../model/Note'

const TAG: string = 'DistributedObjectModel'

export default class DistributedObjectModel {
    private distributedObject?: any
    private changeCallback?: () => void
    private statusCallback?: () => void

    constructor() {
        this.distributedObject = distributedObject.createDistributedObject({
            documents: [],
            documentSize: 0
        })
    }

    genSessionId() {
        return distributedObject.genSessionId()
    }

    setChangeCallback(changeCallback: () => void) {
        if (this.changeCallback === changeCallback) {
            Logger.info(TAG, 'same callback')
            return
        }
        Logger.info(TAG, 'start off')
        if (this.changeCallback !== undefined) {
            this.distributedObject.off('change', this.changeCallback)
        }
        this.changeCallback = changeCallback
        Logger.info(TAG, 'start watch change')
        this.distributedObject.on('change', this.changeCallback)
    }

    setStatusCallback(callback: () => void) {
        if (this.statusCallback === callback) {
            Logger.info(TAG, 'same callback')
            return
        }
        Logger.info(TAG, 'start off')
        if (this.statusCallback !== undefined) {
            this.distributedObject.off('status', this.statusCallback)
        }
        this.statusCallback = callback
        Logger.info(TAG, 'start watch change')
        this.distributedObject.on('status', this.statusCallback)
    }

    update(index: number, title: string, content: string, mark: number) {
        Logger.info(TAG, `doUpdate,${title},${index}`)
        let documents = this.distributedObject.documents
        documents[index] = {
            title: title, content: content, mark: mark
        }
        this.distributedObject.documents = documents
        Logger.info(TAG, `update my documents,${JSON.stringify(this.distributedObject.documents)}`)
    }

    add(title: string, content: string, mark: number) {
        Logger.info(TAG, `doAdd,${title},${content}`)
        Logger.info(TAG, `doAdd,${JSON.stringify(this.distributedObject.documents)}`)
        this.distributedObject.documents = [...this.distributedObject.documents,
        {
            title: title, content: content, mark: mark
        }]
        this.distributedObject.documentSize++
        Logger.info(TAG, `add my documents,${JSON.stringify(this.distributedObject.documents)}`)
    }

    clear() {
        Logger.info(TAG, 'doClear')
        this.distributedObject.documents = []
        this.distributedObject.documentSize = 0
        Logger.info(TAG, 'doClear finish')
    }

    off() {
        this.distributedObject.off('change')
        this.changeCallback = undefined
        this.distributedObject.off('status')
        this.statusCallback = undefined
    }
}
