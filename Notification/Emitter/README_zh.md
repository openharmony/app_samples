# 处理进程内事件

### 简介

本示例主要展示进程内事件通知，用户通过选择对应商品并提交订单后在订单列表显示所选商品。效果图如下：
![](screenshots/device/main.png)
![](screenshots/device/mall.png)

### 相关概念

- [Emitter](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-appAccount.md)：进程通信相关功能。

### 相关权限

不涉及

### 使用说明

1.在主界面点击 **进入商城** ，跳转至商城页面。

2.在商城面点击商品前的方框，选择对应的商品，点击 **提交** 按钮，跳转至主页面，显示已选择的商品。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例需要使用DevEco Studio 3.0（Beta3Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。