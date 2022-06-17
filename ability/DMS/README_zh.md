# 分布式Demo

### 简介

本示例展示了在eTS中如何构建分布式Ability和Service,包含:

1.通过分布式硬件提供的接口，获取设备。

2.远程拉起对端Ability。

3.远程绑定对端Service。


### 使用说明

1.两台设备组网

2.对弹出的分布式权限弹框进行授权

3.在一台设备界面中点击RegisterDeviceListCallback注册设备,成功后点击AuthDevice认证设备,在另一台设备输入对应的PIN。

4.连接成功后可调用本地Ability、对端Ability、本地Service、远端Service。

5.操作对端设备，当前设备界面也会保持和对端设备界面显示一致。

### 约束与限制

1.本示例仅支持标准系统上运行，支持API version 8及以上版本。

2.本示例需要使用3.0.0.901及以上的IDE版本才可编译运行。