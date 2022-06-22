#  ServiceAbility的创建与使用

### 简介

本示例展示了在eTS中ServiceAbility的创建与使用。效果图如下：
![](screenshots/device/main.png)

### 相关概念

- [Ability开发](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ability/Readme-CN.md)：Ability开发。

### 相关权限

不涉及

### 使用说明

1.启动应用后，点击**连接服务**，连接Service成功后会弹出提示。

2.连接服务成功后，在界面上输入框中输入一个字符串，点击**字符串排序**会将字符串发送到Service中，Service对字符串做排序处理后返回给当前应用界面并显示在文本框中。

3.点击**断开服务**，断开Service后会弹出提示。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。
