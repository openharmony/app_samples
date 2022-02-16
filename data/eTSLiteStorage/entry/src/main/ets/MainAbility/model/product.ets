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

import featureAbility from '@ohos.ability.featureAbility';
import dataStorage from '@ohos.data.storage';

export class Good {
  name: string
  price: number
  img: Resource

  constructor(name: string, price: number, img: Resource) {
    this.name = name
    this.price = price
    this.img = img
  }
}

export function GoodInit(): Array<Good> {
  let goods = [{ name: 'MateX2', price: 17999, img: $r('app.media.product') },
               { name: 'Mate40Pro+', price: 8999, img: $r('app.media.product') },
               { name: 'P50Pro', price: 6488, img: $r('app.media.product') },
               { name: 'MatePadPro12.6', price: 6699, img: $r('app.media.product') },
               { name: 'MateBookXPro', price: 8999, img: $r('app.media.product') },
               { name: 'MateStation X', price: 11999, img: $r('app.media.product') },
               { name: 'MateStation S', price: 5199, img: $r('app.media.product') },
               { name: 'MateView', price: 4699, img: $r('app.media.product') },
               { name: 'PixLab', price: 1999, img: $r('app.media.product') },
               { name: 'WatchGT3', price: 1588, img: $r('app.media.product') },
               { name: 'Watch3Pro', price: 3299, img: $r('app.media.product') },
               { name: 'FreebudsPro', price: 1099, img: $r('app.media.product') },
               { name: 'Sound X', price: 2199, img: $r('app.media.product') },
               { name: 'V75 Super', price: 24999, img: $r('app.media.product') }
  ]
  return goods
}

let shopCar: Array<Good> = []

export function addGood(good: Good) {
  shopCar.push(good)
  console.info('[storage]add good')
  putStorage()
}

export function clearGoodShop() {
  shopCar = []
  if (storage !== null) {
    storage.clearSync()
    storage.flushSync()
  }
  console.info('[storage]clearGoodShop')
}

export function deleteGood(good: Good) {
  shopCar.splice(shopCar.indexOf(good), 1)
  console.info('[storage]delete  good')
  putStorage()
}

export function getShopCart(): Array<Good> {
  console.info('[storage]getShopCart')
  return shopCar
}

let storage = null

export function getShopCartFromStorage() {
  let context = featureAbility.getContext()
  let path1
  context.getOrCreateLocalDir().then((e) => {
    path1 = e + '/files/storage'
    storage = dataStorage.getStorageSync(path1);
    let shopCarStr = storage.getSync('shopCar', 'test')
    console.log('[storage]storage shopCar  =' + JSON.stringify(shopCarStr))
    if (shopCarStr === '') {
      shopCar = []
      return
    }
    shopCar = transStrToGoodsModel(shopCarStr)
  })
}

export function transStrToGoodsModel(str: string): Array<Good> {
  console.log('[storage]transStrToNoteModel  =' + str)
  let goodList: Array<Good> = []
  var goods = JSON.parse(str)
  console.info('[storage]notes.length = ' + goods.length)
  for (var good in goods) {
    goodList.push({ name: goods[good].name, price: goods[good].price, img: goods[good].img })
  }
  return goodList
}

export function putStorage() {
  console.log('[Storage]putStorage')
  if (storage !== null) {
    storage.putSync('shopCar', JSON.stringify(shopCar))
    console.info('[Storage]put shopCar')
    storage.flushSync()
    let shopCarStr = storage.getSync('shopCar', 'test')
  }
}