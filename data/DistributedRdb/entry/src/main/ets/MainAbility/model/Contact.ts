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
export default class Contact {
    id: number
    name: string
    gender: number
    phone: string
    remark: string
    isSelected: boolean

    constructor(id: number, name: string, gender: number, phone: string, remark: string) {
        this.id = id
        this.name = name
        this.gender = gender
        this.phone = phone
        this.remark = remark
        this.isSelected = false
    }
}