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

import { TabTitleModel, SearchTextModel, NavDataModel, SwiperModel, TitleBarModel, ProductDataModel, CoreDataModel,
  BoutiqueModel, InformationModel, ShopCartItemDataModel, FindTitleTextModel, FindImgSrcModel, FindImgIntroModel,
  FindImgNameModel, FindIconSrcModel, RecordModel, OrderModel, DiscountModel, ServiceModel } from '../model/homeModel'

export const tabTitleData: Array<TabTitleModel> = [
  {
    id: 0,
    uri: "/resources/homeImg/tabIcon/home.png",
    selectedUri: "/resources/homeImg/tabIcon/homeSelected.png",
    title: "首页",
  },
  {
    id: 1,
    uri: "/resources/homeImg/tabIcon/classification.png",
    selectedUri: "/resources/homeImg/tabIcon/classificationSelected.png",
    title: "分类",
  },
  {
    id: 2,
    uri: "/resources/homeImg/tabIcon/find.png",
    selectedUri: "/resources/homeImg/tabIcon/findSelected.png",
    title: "消息",
  },
  {
    id: 3,
    uri: "/resources/homeImg/tabIcon/cart.png",
    selectedUri: "/resources/homeImg/tabIcon/cartSelected.png",
    title: "购物车",
  },
  {
    id: 4,
    uri: "/resources/homeImg/tabIcon/user.png",
    selectedUri: "/resources/homeImg/tabIcon/userSelected.png",
    title: "我的",
  }
]

export const findSearchTextData: Array<SearchTextModel> = [
  { searchText: "精品好礼" },
  { searchText: "节日大优惠" },
  { searchText: "品牌手机" }
]

export const navData: Array<NavDataModel> = [
  { navData: "首页" },
  { navData: "推荐" },
  { navData: "XX专区" },
  { navData: "新品频道" },
  { navData: "智能家居" },
  { navData: "拼团" },
  { navData: "企业购物" },
  { navData: "推荐" },
  { navData: "XX专区" },
  { navData: "新品频道" },
  { navData: "智能家居" },
  { navData: "拼团" },
  { navData: "企业购物" },
  { navData: "推荐" },
  { navData: "XX专区" },
  { navData: "新品频道" },
  { navData: "智能家居" },
  { navData: "拼团" },
  { navData: "企业购物" }
]

export const swiperData: Array<SwiperModel> = [
  { img: "/resources/homeImg/banner/banner1.jpg" },
  { img: "/resources/homeImg/banner/banner2.jpg" },
  { img: "/resources/homeImg/banner/banner1.jpg" }
]

export const coreData: Array<CoreDataModel> = [
  {
    "uri": "/resources/homeImg/core/core1.png",
    "title": "火爆热款"
  },
  {
    "uri": "/resources/homeImg/core/core2.png",
    "title": "商品分类"
  },
  {
    "uri": "/resources/homeImg/core/core3.png",
    "title": "充值中心"
  },
  {
    "uri": "/resources/homeImg/core/core4.png",
    "title": "活动专区"
  },
  {
    "uri": "/resources/homeImg/core/core5.png",
    "title": "积分商城"
  },
  {
    "uri": "/resources/homeImg/core/core6.png",
    "title": "精选热卖"
  },
  {
    "uri": "/resources/homeImg/core/core7.png",
    "title": "酒店订购"
  },
  {
    "uri": "/resources/homeImg/core/core8.png",
    "title": "好物众测"
  },
  {
    "uri": "/resources/homeImg/core/core9.png",
    "title": "精品手机"
  },
  {
    "uri": "/resources/homeImg/core/core10.png",
    "title": "数码电器"
  },
  {
    "uri": "/resources/homeImg/core/core11.png",
    "title": "数码配件"
  },
  {
    "uri": "/resources/homeImg/core/core12.png",
    "title": "以旧换新"
  },
  {
    "uri": "/resources/homeImg/core/core13.png",
    "title": "限时抢购"
  },
  {
    "uri": "/resources/homeImg/core/core14.png",
    "title": "新品推荐"
  },
  {
    "uri": "/resources/homeImg/core/core15.png",
    "title": "邀请有礼"
  },
  {
    "uri": "/resources/homeImg/core/core16.png",
    "title": "优惠专区"
  },
  {
    "uri": "/resources/homeImg/core/core17.png",
    "title": "正在直播"
  },
  {
    "uri": "/resources/homeImg/core/core18.png",
    "title": "智慧生活"
  },
  {
    "uri": "/resources/homeImg/core/core19.png",
    "title": "会员中心"
  },
  {
    "uri": "/resources/homeImg/core/core13.png",
    "title": "限时抢购"
  }
]

export const boutiqueData: Array<BoutiqueModel> = [
  {
    text1: "XX Phone",
    text2: "最高优惠200元",
    img1: "/resources/homeImg/boutique/1.png",
    img2: "/resources/homeImg/boutique/2.png"
  },
  {
    text1: "XX Watch",
    text2: "500元起",
    img1: "/resources/homeImg/boutique/3.png",
    img2: "/resources/homeImg/boutique/4.png"
  },
  {
    text1: "phone & watch",
    text2: "8这起购",
    img1: "/resources/homeImg/boutique/5.png",
    img2: "/resources/homeImg/boutique/6.png"
  },
  {
    text1: "XX配件",
    text2: "500元起",
    img1: "/resources/homeImg/boutique/7.png",
    img2: "/resources/homeImg/boutique/8.png"
  },
  {
    text1: "XX笔记本",
    text2: "500元起",
    img1: "/resources/homeImg/boutique/9.png",
    img2: "/resources/homeImg/boutique/10.png"
  },
  {
    text1: "XX笔记本",
    text2: "4000元起",
    img1: "/resources/homeImg/boutique/11.png",
    img2: "/resources/homeImg/boutique/12.png"
  }
]

export const titleBarData: Array<TitleBarModel> = [
  { id: 0, title: "全部" },
  { id: 1, title: "直播" },
  { id: 2, title: "便宜好货" },
  { id: 3, title: "淘货" }
]

export const productData: Array<ProductDataModel> = [
  {
    uri: '/resources/homeImg/imgLoads/product001.png',
    title: 'XX设备 优惠直购',
    labels: '尊享',
    price: '￥4122.0',
    index: 0
  },
  {
    uri: '/resources/homeImg/imgLoads/product002.png',
    title: '送给亲人！快速购买',
    labels: '纯色',
    price: '￥4122.0',
    index: 0
  },
  {
    uri: '/resources/homeImg/imgLoads/product003.png',
    title: '高质量产品',
    labels: '净含量:350g',
    price: '￥4122.0',
    index: 0
  },
  {
    uri: '/resources/homeImg/imgLoads/product004.png',
    title: 'XX pro手机',
    labels: '材质:玻璃/金属/塑料',
    price: '￥4122.0',
    index: 0
  },
  {
    uri: '/resources/homeImg/imgLoads/product005.png',
    title: 'XX手机 限时特惠',
    labels: '购买免运费 | 跨店',
    price: '￥4122.0',
    index: 0
  },
  {
    uri: '/resources/homeImg/imgLoads/product006.png',
    title: 'XX设备 优惠直购',
    labels: '尊享',
    price: '￥4122.0',
    index: 0
  },
  {
    uri: '/resources/homeImg/imgLoads/product007.png',
    title: '送给亲人！快速购买',
    labels: '纯色',
    price: '￥4122.0',
    index: 0
  },
  {
    uri: '/resources/homeImg/imgLoads/product008.png',
    title: '高质量产品',
    labels: '净含量:350g',
    price: '￥4122.0',
    index: 0,
  },
  {
    uri: '/resources/homeImg/imgLoads/product009.png',
    title: 'XX pro手机',
    labels: '材质:玻璃/金属/塑料',
    price: '￥4122.0',
    index: 0,
  },
  {
    uri: '/resources/homeImg/imgLoads/product010.png',
    title: 'XX手机 限时特惠',
    labels: '购买免运费 | 跨店',
    price: '￥4122.0',
    index: 0,
  },
  {
    uri: '/resources/homeImg/imgLoads/product011.png',
    title: 'XX设备 优惠直购',
    labels: '尊享',
    price: '￥4122.0',
    index: 0,
  },
  {
    uri: '/resources/homeImg/imgLoads/product012.png',
    title: '送给亲人！快速购买',
    labels: '纯色',
    price: '￥4122.0',
    index: 0,
  },
  {
    uri: '/resources/homeImg/imgLoads/product013.png',
    title: '高质量产品',
    labels: '净含量:350g',
    price: '￥4122.0',
    index: 0,
  },
  {
    uri: '/resources/homeImg/imgLoads/product014.png',
    title: 'XX pro手机',
    labels: '材质:玻璃/金属/塑料',
    price: '￥4122.0',
    index: 0,
  }
]

export const informationData: Array<InformationModel> = [
  {
    uri: "/resources/common/our.png",
    title: "我的助手",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/person.png",
    title: "活动优惠",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/user.png",
    title: "中国XX官方旗舰店",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/our.png",
    title: "服务通知",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/person.png",
    title: "消息互动",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/user.png",
    title: "交易物流",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/our.png",
    title: "我的助手",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/person.png",
    title: "活动优惠",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/user.png",
    title: "中国XX官方旗舰店",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/person.png",
    title: "服务通知",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/user.png",
    title: "互动消息",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/our.png",
    title: "交易物流",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/user.png",
    title: "中国XX官方旗舰店",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/person.png",
    title: "服务通知",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/user.png",
    title: "互动消息",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
  {
    uri: "/resources/common/our.png",
    title: "交易物流",
    notice: "您的交易存在商品问题？点击快速解决！",
    time: "09:50"
  },
]

export const shopCartItemData: Array<ShopCartItemDataModel> = [
  {
    img: '/resources/homeImg/imgLoads/product001.png',
    title: 'XX 官方旗舰店手机 5G网速 超大内存 快来购买'
  },
  {
    img: '/resources/homeImg/imgLoads/product002.png',
    title: 'XX 官方旗舰店手机 5G网速 超大内存 快来购买'
  },
  {
    img: '/resources/homeImg/imgLoads/product003.png',
    title: 'XX 官方旗舰店手机 5G网速 超大内存 快来购买'
  },
  {
    img: '/resources/homeImg/imgLoads/product004.png',
    title: 'XX 官方旗舰店手机 5G网速 超大内存 快来购买'
  },
  {
    img: '/resources/homeImg/imgLoads/product005.png',
    title: 'XX XX 官方旗舰店手机 5G网速 超大内存 快来购买'
  },
  {
    img: '/resources/homeImg/imgLoads/product006.png',
    title: 'XX 官方旗舰店手机 5G网速 超大内存 快来购买'
  },
  {
    img: '/resources/homeImg/imgLoads/product007.png',
    title: 'XX 官方旗舰店手机 5G网速 超大内存 快来购买'
  }
]

export const findTitleTextData: Array<FindTitleTextModel> = [
  { titleText: "全部" },
  { titleText: "节日优惠晒单" },
  { titleText: "出品" },
  { titleText: "穿搭" },
  { titleText: "家居" },
  { titleText: "+" }
]

export const findImgSrcData: Array<FindImgSrcModel> = [
  { imgSrc: "/resources/homeImg/imgLoads/product001.png" },
  { imgSrc: "/resources/homeImg/imgLoads/product001.png" },
  { imgSrc: "/resources/homeImg/imgLoads/product001.png" }
]

export const findImgIntroData: Array<FindImgIntroModel> = [
  { imgIntro: "XXX Phone 30 vip手机设计 5G 全网通 12GB+256GB" },
  { imgIntro: "室外摄像机 精品版 （支持XX XX等设备）" },
  { imgIntro: "潮流XXX系列手机壳" }
]

export const findImgNameData: Array<FindImgNameModel> = [
  { imgName: "普通用户" },
  { imgName: "我是VIP" },
  { imgName: "User" }
]

export const findIconSrcData: Array<FindIconSrcModel> = [
  { iconSrc: "/resources/icon/game.png" },
  { iconSrc: "/resources/icon/install.png" },
  { iconSrc: "/resources/icon/promotions.png" },
]

export const recordData: Array<RecordModel> = [
  {
    img: "/resources/icon/attention.png",
    title: "收藏",
    uri: "pages/collect/collected"
  },
  {
    img: "/resources/icon/attention.png",
    title: "订阅店铺",
    uri: ""
  },
  {
    img: "/resources/icon/attention.png",
    title: "足迹",
    uri: ""
  },
  {
    img: "/resources/icon/attention.png",
    title: "零钱￥100.0",
    uri: ""
  }
]

export const orderData: Array<OrderModel> = [
  {
    id: 1,
    img: "/resources/icon/attention.png",
    title: "待付款",
    uri: "pages/delivery/delivery"
  },
  {
    id: 2,
    img: "/resources/icon/attention.png",
    title: "待发货",
    uri: "pages/delivery/delivery"
  },
  {
    id: 3,
    img: "/resources/icon/attention.png",
    title: "待收货",
    uri: "pages/delivery/delivery"
  },
  {
    id: 4,
    img: "/resources/icon/attention.png",
    title: "待评价",
    uri: "pages/delivery/delivery"
  },
  {
    id: 5,
    img: "/resources/icon/attention.png",
    title: "退款/售后",
    uri: ""
  }
]

export const discountData: Array<DiscountModel> = [
  {
    img: "/resources/common/achievement.png",
    name: "88VIP",
    text: "抢5折券"
  },
  {
    img: "/resources/common/activity.png",
    name: "打折优惠共享",
    text: "领101元红包"
  },
  {
    img: "/resources/common/gift.png",
    name: "88VIP",
    text: "查看可用优惠"
  },
  {
    img: "/resources/common/sales.png",
    name: "领券中心",
    text: "天天领5折券"
  }
]

export const serviceData: Array<ServiceModel> = [
  {
    img: "/resources/icon/attention.png",
    title: "待付款",
    uri: ""
  },
  {
    img: "/resources/icon/attention.png",
    title: "待发货",
    uri: ""
  },
  {
    img: "/resources/icon/attention.png",
    title: "待收货",
    uri: ""
  },
  {
    img: "/resources/icon/attention.png",
    title: "官方客服",
    uri: "pages/customerService/customerService"
  }
]