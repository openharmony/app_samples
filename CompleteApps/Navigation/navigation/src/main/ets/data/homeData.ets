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

import {
  TabTitleModel,
  SearchTextModel,
  NavDataModel,
  SwiperModel,
  TitleBarModel,
  ProductDataModel,
  ShopCartItemDataModel,
  OrderModel,
  FavorLiveListsModel,
  newProductTitleBarModel
} from '../model//homeModel'
// 我的页面直播中得直播列表
export const FavorLiveListsData: Array<FavorLiveListsModel> = [
  {
    imgSrc: $r('app.media.live_coriander'),
    title: $r("app.string.FavorLiveListsData_title"),
    viewsInfo: $r("app.string.FavorLiveListsData_viewsInfo")
  },
  {
    imgSrc: $r('app.media.live_scene'),
    title: $r("app.string.FavorLiveListsData_title"),
    viewsInfo: $r("app.string.FavorLiveListsData_viewsInfo")
  },
  {
    imgSrc: $r('app.media.live_scene'),
    title: $r("app.string.FavorLiveListsData_title"),
    viewsInfo: $r("app.string.FavorLiveListsData_viewsInfo")
  },
  {
    imgSrc: $r('app.media.live_coriander'),
    title: $r("app.string.FavorLiveListsData_title"),
    viewsInfo: $r("app.string.FavorLiveListsData_viewsInfo")
  }
]
// 底部标签栏
export const tabTitleData: Array<TabTitleModel> = [
  {
    id: 0,
    uri: $r("app.media.home"),
    selectedUri: $r('app.media.homeSelected'),
    title: $r("app.string.tabTitleData_home")
  },
  {
    id: 1,
    uri: $r('app.media.classification'),
    selectedUri: $r('app.media.classificationSelected'),
    title: $r("app.string.tabTitleData_newProduct")
  },
  {
    id: 2,
    uri: $r('app.media.cart'),
    selectedUri: $r('app.media.cartSelected'),
    title: $r("app.string.tabTitleData_cart")
  },
  {
    id: 3,
    uri: $r('app.media.user'),
    selectedUri: $r('app.media.userSelected'),
    title: $r("app.string.tabTitleData_mine")
  }
]
// 首页搜索框的Swiper
export const findSearchTextData: Array<SearchTextModel> = [
  { searchText: $r("app.string.findSearchTextData_searchText") },
  { searchText: $r("app.string.findSearchTextData_searchTex") },
  { searchText: $r("app.string.findSearchTextData_searchTe") }
]
// 首页导航栏
export const navData: Array<NavDataModel> = [
  { id: 0, navData: $r("app.string.tabTitleData_home") },
  { id: 1, navData: $r("app.string.NavData_phone") },
  { id: 2, navData: $r("app.string.NavData_food") },
  { id: 3, navData: $r("app.string.NavData_men_wear") },
  { id: 4, navData: $r("app.string.NavData_sport") },
  { id: 5, navData: $r("app.string.NavData_home_appliances") }
]
// 首页轮播图
export const swiperData: Array<SwiperModel> = [
  { img: $r('app.media.bannermovie2') },
  { img: $r('app.media.bannermovie2') }
]

export const indexData: Array<SwiperModel> = [
  { img: $r('app.media.bannermovie1') },
  { img: $r('app.media.bannermovie3') }
]
// 首页中间部分的tabBar
export const titleBarData: Array<TitleBarModel> = [
  { id: 0, title: $r("app.string.titleBarData_title_all"), content: $r("app.string.titleBarData_content_recommend") },
  { id: 1, title: $r("app.string.titleBarData_title_selected"), content: $r("app.string.titleBarData_content_find") },
  {
    id: 2,
    title: $r("app.string.titleBarData_title_newProduct"),
    content: $r("app.string.titleBarData_content_first_publish")
  },
  {
    id: 3,
    title: $r("app.string.titleBarData_title_benefits"),
    content: $r("app.string.titleBarData_content_cheap_good")
  }
]
// 新品页的导航栏
export const newProductTitleBarData: Array<newProductTitleBarModel> = [
  { id: 0, title: $r("app.string.newProductTitleBarData_title_selected") },
  { id: 1, title: $r("app.string.newProductTitleBarData_title_phone") },
  { id: 2, title: $r("app.string.newProductTitleBarData_title_electric_appliance") },
  { id: 3, title: $r("app.string.newProductTitleBarData_title_sport") },
  { id: 4, title: $r("app.string.newProductTitleBarData_title_clothes") }
]
// 首页商品列表
export const productData: Array<ProductDataModel> = [
  {
    id: 1,
    uri: $r('app.media.product001'),
    title: $r("app.string.productData_title_device"),
    info: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product002'),
    title: $r("app.string.productData_title_device"),
    info: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product003'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product004'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product005'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product006'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product007'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product008'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  }, {
    id: 1,
    uri: $r('app.media.product001'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product002'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product003'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product004'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product005'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product006'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product007'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  },
  {
    id: 1,
    uri: $r('app.media.product008'),
    title: $r("app.string.productData_title_device"),
    info: undefined,
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price"),
  }
]

export const shopCartItemData: Array<ShopCartItemDataModel> = [
  {
    id: 1,
    uri: $r('app.media.product008'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  },
  {
    id: 2,
    uri: $r('app.media.product003'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  },
  {
    id: 3,
    uri: $r('app.media.product004'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  },
  {
    id: 4,
    uri: $r('app.media.product005'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  },
  {
    id: 5,
    uri: $r('app.media.product006'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  },
  {
    id: 6,
    uri: $r('app.media.product006'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  },
  {
    id: 7,
    uri: $r('app.media.product007'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  },
  {
    id: 8,
    uri: $r('app.media.product008'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  },
  {
    id: 9,
    uri: $r('app.media.product009'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  },
  {
    id: 10,
    uri: $r('app.media.product010'),
    title: $r("app.string.productData_title_device"),
    labels: $r("app.string.productData_labels_newProduct"),
    price: $r("app.string.productData_price")
  }
]
// 我的页面 待发货、待付款...选项
export const orderData: Array<OrderModel> = [
  {
    id: 1,
    img: $r('app.media.obligation'),
    title: $r("app.string.orderData_title_obligation"),
  },
  {
    id: 2,
    img: $r('app.media.waitDelivery'),
    title: $r("app.string.orderData_title_wait_deliver"),
  },
  {
    id: 3,
    img: $r('app.media.waitReceive'),
    title: $r("app.string.orderData_title_wait_receive"),
  },
  {
    id: 4,
    img: $r('app.media.waitEvaluted'),
    title: $r("app.string.orderData_title_wait_recommend"),
  },
  {
    id: 5,
    img: $r('app.media.refund'),
    title: $r("app.string.orderData_title_refund"),
  }
]

