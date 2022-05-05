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

class Logger {
  prefix = ''

  constructor(prefix) {
    this.prefix = prefix
  }

  debug(...args) {
    console.debug(this.prefix + args)
  }

  info(...args) {
    console.info(this.prefix + args)
  }

  warn(...args) {
    console.warn(this.prefix + args)
  }

  error(...args) {
    console.error(this.prefix + args)
  }
}

export default new Logger('[JsRecorder]')