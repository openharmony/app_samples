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

const MAX_CAPACITY: number = 100 // 最大缓存数量

/**
 * A class provides memory cache operation.
 */
export default class LruCache {
  private readonly cache: Map<string, object | string> = new Map()
  private readonly capacity: number = MAX_CAPACITY

  constructor() {
  }

  /**
   * Get cache from memory.
   *
   * @param {string} key - key of the cache map
   * @return {any} - cache from memory
   */
  getCache(key: string): any {
    if (this.cache.has(key)) {
      // exist and update
      const temp = this.cache.get(key)
      //delete the old cache
      this.cache.delete(key)
      //update the cache to recent use
      this.cache.set(key, temp)
      return temp
    }
    return -1
  }

  /**
   * Put cache to disk.
   *
   * @param {string} key - key of the cache map
   * @param {any} value - value of the cache map
   */
  putCache(key: string, value: any): void {
    if (this.cache.has(key)) {
      // exist and update
      this.cache.delete(key)
    } else if (this.cache.size >= this.capacity) {
      // if size > capacity ,remove the old
      this.cache.delete(this.cache.keys().next().value)
    }
    //update the cache to recent use
    this.cache.set(key, value)
  }

  /**
   * Remove cache of corresponding key.
   *
   * @param {string} key - key of the cache map
   */
  remove(key: string): void {
    this.cache.delete(key)
  }

  /**
   * Clear cache of memory.
   */
  clear(): void {
    this.cache.clear()
  }
}