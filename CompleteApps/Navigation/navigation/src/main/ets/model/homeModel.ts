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

export class TabTitleModel {
  constructor(public id: number, public uri: Resource, public selectedUri: Resource, public title: Resource) {
    this.id = id;
    this.uri = uri;
    this.selectedUri = selectedUri;
    this.title = title;
  }
}

export class FavorLiveListsModel {
  constructor(public imgSrc: Resource, public title: Resource, public viewsInfo: Resource) {
    this.imgSrc = imgSrc
    this.title = title
    this.viewsInfo = viewsInfo
  }
}

export class SearchTextModel {
  constructor(public searchText: Resource) {
    this.searchText = searchText;
  }
}

export class NavDataModel {
  constructor(public navData: Resource, public id: number) {
    this.navData = navData;
    this.id = id
  }
}

export class SwiperModel {
  constructor(public img: Resource) {
    this.img = img;
  }
}

export class TitleBarModel {
  constructor(public id: number, public title: Resource, public content: Resource) {
    this.id = id;
    this.title = title;
    this.content = content
  }
}

export class newProductTitleBarModel {
  constructor(public id: number, public title: Resource) {
    this.id = id;
    this.title = title;
  }
}

export class ProductDataModel {
  constructor(public id: number, public uri: Resource, public title: Resource,public info: Resource, public labels: Resource, public price: Resource) {
    this.id = id;
    this.uri = uri;
    this.info = info
    this.title = title;
    this.labels = labels;
    this.price = price;
  }
}

export class CoreDataModel {
  constructor(public uri: Resource, public title: string) {
    this.uri = uri;
    this.title = title;
  }
}

export class BoutiqueModel {
  constructor(public text1: string, public text2: string, public img1: Resource, public img2: Resource) {
    this.text1 = text1;
    this.text2 = text2;
    this.img1 = img1;
    this.img2 = img2;
  }
}

export class ShopCartItemDataModel {
  constructor(public id: number, public uri: Resource, public title: Resource, public labels: Resource, public price: Resource) {
    this.id = id;
    this.uri = uri;
    this.title = title;
    this.labels = labels;
    this.price = price;
  }
}

export class FindImgSrcModel {
  constructor(public imgSrc: Resource) {
    this.imgSrc = imgSrc;
  }
}

export class NewProductDataModel {
  constructor(public text: string, public imgSrc: Resource, public imgInfo: string, public name: string, public userSrc: Resource) {
    this.text = text
    this.imgSrc = imgSrc
    this.imgInfo = imgInfo
    this.name = name
    this.userSrc = userSrc
  }
}

export class FindImgIntroModel {
  constructor(public imgIntro: string) {
    this.imgIntro = imgIntro;
  }
}


export class OrderModel {
  constructor(public id: number, public img: Resource, public title: Resource) {
    this.id = id;
    this.img = img;
    this.title = title;
  }
}

