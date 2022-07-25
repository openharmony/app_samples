# 定时器与系统时间设置

### 简介

本示例通过 systemTime 接口来实现设置系统时间，通过 setTimeout() 等函数来设置定时器。

实现效果如下：

![](screenshots/device/screen.png)

### 相关概念

设置系统时间：本模块主要由时间、时区和定时三大功能组成。其中，定时服务用来管理和使用时间、时区。开发者可以通过对系统进行设置、获取等操作管理系统时间、时区，也可以通过定时功能实现定时服务如闹钟服务等。

### 相关权限

设置系统时间权限：ohos.permission.SET_TIME

### 使用说明

1.点击**时间框**，选择时间日期，点击相应按钮来设置系统时间。

2.点击**倒计时框**，选择定时器的时长，点击**按钮**来启动定时器，若想中途放弃定时任务，点击**取消**按钮。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。

3.本示例所配置的权限ohos.permission.SET_TIME为system_basic级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)查看)，需要手动配置对应级别的权限签名。
