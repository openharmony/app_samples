# 购物实例应用

### 介绍

本实例展示通过**Tabs**容器设计应用框架，通过**TabContent**组件设置分页面，在子页面中绘制界面。

本实例使用[Tabs容器](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-tabs.md)实现通过页签进行内容视图切换。

使用说明：

1.启动应用进入首页，当未配置网络请求时，加载本地数据；配置网络请求时可加载网络数据。

2.底部导航栏可点击进入不同页面。

3.“我的”页面中设置按钮可配置网络请求。

### 效果预览

![](screenshots/device/index.png) ![](screenshots/device/new.png)
![](screenshots/device/shopping.png) ![](screenshots/device/mine.png)

### 相关权限

允许使用Internet网络: ohos.permission.INTERNET

### 依赖

[橘子购物](https://gitee.com/openharmony/app_samples/tree/master/AppSample/OrangeShopping) 中导航依赖本示例。

[网络请求](https://gitee.com/openharmony/app_samples/tree/master/AppSample/OrangeShopping) 本示例依赖网络请求。


### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例为Stage模型，从API version 9开始支持。

3.本实例仅为框架实例，故所有页面均为静态页面。

4.本示例需联网运行。

5.本示例需要使用DevEco Studio 3.0 Beta4 (Build Version: 3.0.0.991, built on July 6, 2022)才可编译运行。
