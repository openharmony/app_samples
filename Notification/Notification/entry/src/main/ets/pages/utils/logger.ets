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

const TAG: string = "[Notification]"

export default class Logger {
  public static log(tag: string, log: string) {
    console.log(`${TAG}.${tag}: ${log}`);
  }

  public static info(tag: string, message: string) {
    console.info(`${TAG}.${tag}: ${message}`);
  }

  public static debug(tag: string, debug: string) {
    console.debug(`${TAG}.${tag}: ${debug}`);
  }

  public static error(tag: string, error: string) {
    console.error(`${TAG}.${tag}: ${error}`);
  }
}