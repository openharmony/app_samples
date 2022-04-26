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
import featureAbility from '@ohos.ability.featureAbility'
import Logger from '../model/Logger'

const TAG = '[Component.ReleaseData]'

let release: Array<ReleaseData> = []
let browse: Array<ReleaseData> = []
let storage = null

@Observed
export class ReleaseData {
  title: string //发布会名称
  date: string //发布会日期
  place: string //发布会地点
  isRelease: boolean //是否发布
  isNear: boolean //是否本月
  playNum: number //播放量
  BarrageNum: number //弹幕量
  isRes: boolean //是否预约
  isCollect: boolean //是否收藏
  resImg: Resource //预约图标
  collectImg: Resource //收藏图标

  constructor(title: string, date: string, place: string, isRelease: boolean, isNear: boolean, playNum: number, BarrageNum: number, isRes: boolean, isCollect: boolean, resImg: Resource, collectImg: Resource) {
    this.title = title
    this.date = date
    this.place = place
    this.isRelease = isRelease
    this.isNear = isNear
    this.playNum = playNum
    this.BarrageNum = BarrageNum
    this.isRes = isRes
    this.isCollect = isCollect
    this.resImg = resImg
    this.collectImg = collectImg
  }
}

export function dataInit(): Array<ReleaseData> {
  let release = [
    {
      title: 'H手机发布会',
      date: '2021.12.23',
      place: '德国·慕尼黑',
      isRelease: false,
      isNear: false,
      playNum: 0,
      BarrageNum: 0,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'M平板发布会',
      date: '2021.12.28',
      place: '中国·北京',
      isRelease: false,
      isNear: false,
      playNum: 0,
      BarrageNum: 0,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'R笔记本发布会',
      date: '2021.1.45',
      place: '中国·珠海',
      isRelease: true,
      isNear: false,
      playNum: 4684,
      BarrageNum: 89,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'H智慧屏发布会',
      date: '2021.5.13',
      place: '中国·深圳',
      isRelease: true,
      isNear: false,
      playNum: 1658,
      BarrageNum: 231,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'A汽车发布会',
      date: '2021.6.30',
      place: '美国·硅谷',
      isRelease: true,
      isNear: false,
      playNum: 8464,
      BarrageNum: 841,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'H全屋智能发布会',
      date: '2021.6.8',
      place: '中国·深圳',
      isRelease: true,
      isNear: false,
      playNum: 5651,
      BarrageNum: 561,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'O折叠屏旗舰发布会',
      date: '2021.5.1',
      place: '中国·深圳',
      isRelease: true,
      isNear: false,
      playNum: 5312,
      BarrageNum: 456,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'S折叠屏旗舰发布会',
      date: '2021.8.16',
      place: '韩国·首尔',
      isRelease: true,
      isNear: false,
      playNum: 1563,
      BarrageNum: 684,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'H平板发布会',
      date: '2021.9.10',
      place: '中国·北京',
      isRelease: true,
      isNear: false,
      playNum: 4561,
      BarrageNum: 489,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'M电视发布会',
      date: '2021.7.26',
      place: '中国·北京',
      isRelease: true,
      isNear: false,
      playNum: 3655,
      BarrageNum: 713,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'G开发者大会',
      date: '2021.2.23',
      place: '美国·硅谷',
      isRelease: true,
      isNear: false,
      playNum: 1358,
      BarrageNum: 56,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'M穿戴发布会',
      date: '2021.11.17',
      place: '中国·成都',
      isRelease: true,
      isNear: true,
      playNum: 1385,
      BarrageNum: 212,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'A手机发布会',
      date: '2021.10.8',
      place: '美国·硅谷',
      isRelease: true,
      isNear: false,
      playNum: 9841,
      BarrageNum: 864,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'V手机发布会',
      date: '2021.12.20',
      place: '中国·深圳',
      isRelease: false,
      isNear: true,
      playNum: 0,
      BarrageNum: 0,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'V穿戴发布会',
      date: '2021.1.9',
      place: '中国·深圳',
      isRelease: true,
      isNear: false,
      playNum: 1068,
      BarrageNum: 149,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'H开发者大会',
      date: '2021.8.18',
      place: '中国·东莞',
      isRelease: true,
      isNear: false,
      playNum: 5618,
      BarrageNum: 856,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'W汽车发布会',
      date: '2021.3.7',
      place: '中国·上海',
      isRelease: true,
      isNear: false,
      playNum: 2354,
      BarrageNum: 354,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'L汽车发布会',
      date: '2021.11.11',
      place: '中国·北京',
      isRelease: true,
      isNear: true,
      playNum: 7641,
      BarrageNum: 455,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'J汽车发布会',
      date: '2021.11.29',
      place: '中国·北京',
      isRelease: true,
      isNear: true,
      playNum: 3511,
      BarrageNum: 315,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'A电脑发布会',
      date: '2021.12.2',
      place: '美国·硅谷',
      isRelease: false,
      isNear: true,
      playNum: 0,
      BarrageNum: 0,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'A开发者大会',
      date: '2021.2.3',
      place: '美国·硅谷',
      isRelease: true,
      isNear: false,
      playNum: 6318,
      BarrageNum: 762,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    },
    {
      title: 'P汽车发布会',
      date: '2021.4.6',
      place: '中国·上海',
      isRelease: true,
      isNear: false,
      playNum: 7631,
      BarrageNum: 566,
      isRes: false,
      isCollect: false,
      resImg: $r('app.media.nofocus'),
      collectImg: $r('app.media.nocollect')
    }
  ]
  return release
}

export function addStorage(data: ReleaseData, str: string) {
  if (str === 'release') {
    release.push(data);
    storage.putSync('release', JSON.stringify(release))
    storage.flush()
  } else {
    browse.push(data);
    storage.putSync('browse', JSON.stringify(browse))
    storage.flush()
  }
}

export function modifyStorage(data: ReleaseData, num: number, str: string) {
  if (str === 'release') {
    release[num] = data
    storage.putSync('release', JSON.stringify(release))
    storage.flush()
  } else {
    browse.push(data);
    storage.putSync('browse', JSON.stringify(browse))
    storage.flush()
  }
}

export function deleteStorage(data: ReleaseData, str: string) {
  if (str === 'release') {
    release.splice(release.indexOf(data), 1);
    storage.putSync('release', JSON.stringify(release))
    storage.flush()
  } else {
    browse.splice(browse.indexOf(data), 1)
    storage.putSync('browse', JSON.stringify(browse));
    storage.flush()
  }
}

export function getStorageList(str: string) {
  if (str === 'release') {
    return release
  } else {
    return browse
  }
}

export function getDataFromStorage(callback) {
  let context = featureAbility.getContext()
  let path1, path2
  context.getOrCreateLocalDir().then((e) => {
    path1 = e + '/files/storage1'
    path2 = e + '/files/storage2'
    storage = dataStorage.getStorageSync(path1);
    storage = dataStorage.getStorageSync(path2);
    let releaseStr = storage.getSync('release', '')
    let browseStr = storage.getSync('browse', '')
    Logger.info(TAG, `getDateFromStorage reservation= ${releaseStr}`)
    Logger.info(TAG, `getDateFromStorage browse= ${browseStr}`)
    if (releaseStr === '' && browseStr != '') {
      releaseStr = []
    } else if (releaseStr !== '' && browseStr === '') {
      browseStr = []
    } else if (releaseStr === '' && browseStr === '') {
      releaseStr = []
      browseStr = []
    } else {
      browseStr = browseStr
      releaseStr = releaseStr
    }
    release = transStrToReleaseModel(releaseStr)
    browse = transStrToReleaseModel(browseStr)
    callback()
  })
}

function transStrToReleaseModel(str: string): Array<ReleaseData> {
  let optionList: Array<ReleaseData> = []
  if (str == '') {
    return []
  }
  let release = JSON.parse(str)
  for (let res in release) {
    optionList.push({
      title: release[res].title,
      date: release[res].date,
      place: release[res].place,
      isRelease: release[res].isRelease,
      isNear: release[res].isNear,
      playNum: release[res].playNum,
      BarrageNum: release[res].BarrageNum,
      isRes: release[res].isRes,
      isCollect: release[res].isCollect,
      resImg: release[res].resImg,
      collectImg: release[res].collectImg
    })
  }
  return optionList
}
