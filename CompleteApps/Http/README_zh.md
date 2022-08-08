# Http

### 介绍

本示例通过**TextInput**组件输入参数，**Text**组件显示返回结果。

本实例使用[SystemCapability.Communication.NetStack](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-http.md)系统能力，创建了一个HTTP请求，并根据URL地址和相关配置项，发起HTTP网络请求。

使用说明：

1.启动应用可配置网络请求，设置网址、请求方式、请求参数。

2.点击确认按钮，跳转请求结果页面。

3.点击返回按钮，返回配置页面。

### 效果预览

![](screenshots/device/index.png) ![](screenshots/device/result.png)

### 相关权限

允许使用Internet网络: ohos.permission.INTERNET

### 依赖

[橘子购物](https://gitee.com/openharmony/app_samples/tree/master/AppSample/OrangeShopping) 中橘子商城依赖本示例。

[导航](https://gitee.com/openharmony/app_samples/tree/master/AppSample/OrangeShopping) 中导航依赖本示例。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本实例需全程联网。

3.本示例为Stage模型，从API version 9开始支持。

4.本示例需要使用DevEco Studio 3.0 Beta4 (Build Version: 3.0.0.991, built on July 6, 2022)才可编译运行。