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

const TAG: string = '[CallSample]'

export default class Logger {
    public static log(tag, ...args: any[]) {
        console.log(`${TAG}.${tag}: ${args.join('')}`)
    }

    public static info(tag, ...args: any[]) {
        console.info(`${TAG}.${tag}: ${args.join('')}`)
    }

    public static debug(tag, ...args: any[]) {
        console.debug(`${TAG}.${tag}: ${args.join('')}`)
    }

    public static warn(tag, ...args: any[]) {
        console.warn(`${TAG}.${tag}: ${args.join('')}`)
    }

    public static error(tag, ...args: any[]) {
        console.error(`${TAG}.${tag}: ${args.join('')}`)
    }
}
