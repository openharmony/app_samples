# 设备管理

### 简介

本示例展示了在eTS中DeviceManager接口的使用，包括获取授信设备列表，设备扫描，设备认证，设备状态订阅。实现效果如下：

![main](screenshots/device/main.png)

### 相关概念

- 设备管理：用于获取可信设备和本地设备的相关信息。在调用DeviceManager的方法前，需要先通过createDeviceManager构建一个DeviceManager实例。

### 相关权限

不涉及

### 使用说明

1.进入应用会自动获取授信设备列表显示在设备列表中，状态显示为"online"，并开始设备扫描发现设备，发现设备后会显示在设备列表中，状态显示为"discover"。

2.点击状态为"discover"的设备，会触发认证，认证完成会刷新界面。

3.设备状态订阅监听组网状态变化从而刷新界面。

### 约束与限制

1.本示例需要组网测试。

2.本示例仅支持标准系统上运行。

3.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。
