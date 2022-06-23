# 网络搜索

### 简介

本示例通过eTS来展示电话服务中网络搜索功能，包含无线接入技术、网络状态、选网模式、ISO国家码、信号强度信息列表及Radio是否打开。实现效果如下：

<img src="./screenshots/device/main.png" />

### 相关概念

获取当前接入的CS域和PS域无线接入技术、获取网络状态、获取当前选网模式、获取注册网络所在国家的ISO国家码、判断主卡的Radio是否打开等。

### 相关权限

获取网络信息权限：ohos.permission.GET_NETWORK_INFO

### 使用说明

1.点击**SIM1 status**，弹出面板显示卡1的无线接入技术、注册网络信号强度信息列表、选网模式、ISO国家码，
  再次点击面板消失， 点击**SIM2 status**显示同理。

2.**NetworkState**显示网络状态相关信息。

3.**IsRadioOn**显示Radio是否打开，true为打开，false为关闭。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。