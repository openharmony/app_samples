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
  constructor(public id: number, public uri: string, public selectedUri: string, public title: string) {
    this.id = id;
    this.uri = uri;
    this.selectedUri = selectedUri;
    this.title = title;
  }
}

export class SearchTextModel {
  constructor(public searchText: string) {
    this.searchText = searchText;
  }
}

export class NavDataModel {
  constructor(public navData: string) {
    this.navData = navData;
  }
}

export class SwiperModel {
  constructor(public img: string) {
    this.img = img;
  }
}

export class TitleBarModel {
  constructor(public id: number, public title: string) {
    this.id = id;
    this.title = title;
  }
}

export class ProductDataModel {
  constructor(public uri: string, public title: string, public labels: string, public price: string, public index: number) {
    this.uri = uri;
    this.title = title;
    this.labels = labels;
    this.price = price;
    this.index = index;
  }
}

export class CoreDataModel {
  constructor(public uri: string, public title: string) {
    this.uri = uri;
    this.title = title;
  }
}

export class BoutiqueModel {
  constructor(public text1: string, public text2: string, public img1: string, public img2: string) {
    this.text1 = text1;
    this.text2 = text2;
    this.img1 = img1;
    this.img2 = img2;
  }
}

export class InformationModel {
  constructor(public uri: string, public title: string, public notice: string, public time: string) {
    this.uri = uri;
    this.title = title;
    this.notice = notice;
    this.time = time;
  }
}

export class ShopCartItemDataModel {
  constructor(public img: string, public title: string) {
    this.img = img;
    this.title = title;
  }
}

export class FindTitleTextModel {
  constructor(public titleText: string) {
    this.titleText = titleText;
  }
}

export class FindImgSrcModel {
  constructor(public imgSrc: string) {
    this.imgSrc = imgSrc;
  }
}

export class FindImgIntroModel {
  constructor(public imgIntro: string) {
    this.imgIntro = imgIntro;
  }
}

export class FindImgNameModel {
  constructor(public imgName: string) {
    this.imgName = imgName;
  }
}

export class FindIconSrcModel {
  constructor(public iconSrc: string) {
    this.iconSrc = iconSrc;
  }
}

export class RecordModel {
  constructor(public img: string, public title: string, public uri: string) {
    this.img = img;
    this.title = title;
    this.uri = uri;
  }
}

export class OrderModel {
  constructor(public id: number, public img: string, public title: string, public uri: string) {
    this.id = id;
    this.img = img;
    this.title = title;
    this.uri = uri;
  }
}

export class DiscountModel {
  constructor(public img: string, public name: string, public text: string) {
    this.img = img;
    this.name = name;
    this.text = text;
  }
}

export class ServiceModel {
  constructor(public img: string, public title: string, public uri: string) {
    this.img = img;
    this.title = title;
    this.uri = uri;
  }
}