/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
import hilog from '@ohos.hilog';

const DOMAIN: number = 0x300A;
const FILTER_KEYS = [
  new RegExp('hide', "gi")
]

export function filterKey(target: any, propKey: string, descriptor: PropertyDescriptor) {
  const original = descriptor.value;
  descriptor.value = function (...args: string[]) {
    let filterResult = args.map((str) => {
      let tempStr = str
      FILTER_KEYS.forEach((filterKey) => tempStr = tempStr.replace(filterKey, "**"))
      return tempStr
    });
    const result = original.call(this, ...filterResult);
    return result;
  };
}

/**
 * Basic log class
 */
export default class Log {
  /**
   * Outputs debug-level logs.
   *
   * @param tag Identifies the log tag.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   * @since 7
   */
  static showDebug(tag: string, format: string, ...args: any[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.DEBUG)) {
      hilog.debug(DOMAIN, tag, format, args);
    }
  }

  /**
   * Outputs info-level logs.
   *
   * @param tag Identifies the log tag.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   * @since 7
   */
  static showInfo(tag: string, format: string, ...args: any[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.INFO)) {
      hilog.info(DOMAIN, tag, format, args);
    }
  }

  /**
   * Outputs warning-level logs.
   *
   * @param tag Identifies the log tag.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   * @since 7
   */
  static showWarn(tag: string, format: string, ...args: any[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.WARN)) {
      hilog.warn(DOMAIN, tag, format, args);
    }
  }

  /**
   * Outputs error-level logs.
   *
   * @param tag Identifies the log tag.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   * @since 7
   */
  static showError(tag: string, format: string, ...args: any[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.ERROR)) {
      hilog.error(DOMAIN, tag, format, args);
    }
  }

  /**
   * Outputs fatal-level logs.
   *
   * @param tag Identifies the log tag.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   * @since 7
   */
  static showFatal(tag: string, format: string, ...args: any[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.FATAL)) {
      hilog.fatal(DOMAIN, tag, format, args);
    }
  }

  /**
   * Checks whether logs of the specified tag, and level can be printed.
   *
   * @param tag Identifies the log tag.
   * @param level log level
   * @since 7
   */
  private static isLoggable(tag: string, level: hilog.LogLevel): boolean {
    return hilog.isLoggable(DOMAIN, tag, level);
  }
}
