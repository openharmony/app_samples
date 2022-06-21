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
import PictureItem from '../model/PictureItem'

enum gameStatus {
  running = 1,
  over = 0
}

const EMPTY_PICTURE: PictureItem = new PictureItem(9, undefined)

@Observed
export default class GameRules {
  public numArray: PictureItem[]
  public gameStatus: number = gameStatus.over

  itemChange(index: number, pictures: PictureItem[]) {
    let emptyIndex = this.findEmptyIndex(pictures)
    let temp: PictureItem = pictures[index]
    pictures[index] = EMPTY_PICTURE
    pictures[emptyIndex] = new PictureItem(temp.index, temp.pixelMap)
    return pictures
  }

  findEmptyIndex(pictures: PictureItem[]) {
    for (let i = 0;i < pictures.length; i++) {
      if (pictures[i].index === EMPTY_PICTURE.index) {
        return i
      }
    }
    return -1
  }

  gameInit(i: number, pictures: PictureItem[]) {
    let emptyIndex = this.findEmptyIndex(pictures)
    if (this.gameStatus == gameStatus.running) {
      switch (emptyIndex) {
        case 0:
          if (i === 1 || i === 3) {
            pictures = this.itemChange(i, pictures)
          }
          break;
        case 2:
          if (i === 1 || i === 5) {
            pictures = this.itemChange(i, pictures)
          }
          break;
        case 6:
          if (i === 3 || i === 7) {
            pictures = this.itemChange(i, pictures)
          }
          break;
        case 8:
          if (i === 5 || i === 7) {
            pictures = this.itemChange(i, pictures)
          }
          break;
        case 3:
          switch (i) {
            case emptyIndex + 1:
            case emptyIndex - 3:
            case emptyIndex + 3:
              pictures = this.itemChange(i, pictures)
          }
          break;
        case 1:
          switch (i) {
            case emptyIndex + 1:
            case emptyIndex - 1:
            case emptyIndex + 3:
              pictures = this.itemChange(i, pictures)
          }
          break;
        case 5:
          switch (i) {
            case emptyIndex + 3:
            case emptyIndex - 3:
            case emptyIndex - 1:
              pictures = this.itemChange(i, pictures)
          }
          break;
        case 7:
          switch (i) {
            case emptyIndex + 1:
            case emptyIndex - 3:
            case emptyIndex - 1:
              pictures = this.itemChange(i, pictures)
          }
          break;
        case 4:
          switch (i) {
            case emptyIndex + 1:
            case emptyIndex - 3:
            case emptyIndex - 1:
            case emptyIndex + 3:
              pictures = this.itemChange(i, pictures)
          }
          break;
      }
    }
    return pictures
  }

  gameBegin(pictures: PictureItem[]) {
    this.gameStatus = gameStatus.running
    var l = pictures.length
    var index, temp
    while (l > 0) {
      index = Math.floor(Math.random() * l)
      temp = pictures[l-1]
      pictures[l-1] = pictures[index]
      pictures[index] = temp
      l--
    }
    return pictures
  }
}