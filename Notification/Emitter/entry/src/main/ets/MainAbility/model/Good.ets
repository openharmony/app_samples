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
    { image: $r("app.media.desktop"), name: 'Desktop', price: '¥9365.00', isCheck: false },
    { image: $r("app.media.display"), name: 'Display', price: '¥1500.00', isCheck: false },
    { image: $r("app.media.notebook"), name: 'NoteBook', price: '¥7800.00', isCheck: false },
    { image: $r("app.media.phone1"), name: 'Phone', price: '¥5000.00', isCheck: false },
    { image: $r("app.media.table"), name: 'Table', price: '¥4000.00', isCheck: false },
    { image: $r("app.media.watch"), name: 'Watch', price: '¥1999.00', isCheck: false }
  ]
}