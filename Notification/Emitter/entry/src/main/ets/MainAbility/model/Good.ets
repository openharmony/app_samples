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

export class Good {
  image: Resource
  name: String
  price: String
  isCheck: Boolean

  constructor(image: Resource, name: String, price: String, isCheck: Boolean) {
    this.image = image
    this.name = name
    this.price = price
    this.isCheck = isCheck
  }
}

export function getData() {
  return [
    { image: $r("app.media.huawei1"), name: 'HUAWEI nova 9 Pro', price: '¥3469.00', isCheck: false },
    { image: $r("app.media.huawei2"), name: 'HUAWEI Mate X2', price: '¥17799.00', isCheck: false },
    { image: $r("app.media.huawei3"), name: 'HUAWEI Mate 40 Pro', price: '¥6599.00', isCheck: false },
    { image: $r("app.media.watch1"), name: 'HUAWEI WATCH 3 Pro', price: '¥3199.00', isCheck: false },
    { image: $r("app.media.watch2"), name: 'HUAWEI Children\'s Watch 4X', price: '¥1098.00', isCheck: false },
    { image: $r("app.media.watch3"), name: 'HUAWEI WATCH GT 2', price: '¥4488.00', isCheck: false }
  ]
}