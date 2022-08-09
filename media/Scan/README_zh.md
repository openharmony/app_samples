# 扫一扫模块

### 简介

本示例展示了扫一扫功能组件,同时提供一个可拉起相机权限和媒体库资源权限的ability,实现效果如下:

![home](screenshots/devices/scan1.png) ![play1](screenshots/devices/scan2.png)

### 相关概念

- Scan：扫一扫的主要工作是将相册中的二维码图片进行解析并识别和读取,同时点击拍照可以对拍摄的二维码图片信息进行解析和显示。
  本示例用到的接口或者能力：
  SystemCapability.Multimedia.MediaLibraryCore  媒体库管理
  
  SystemCapability.Multimedia.Camera.Core       相机管理
  
  SystemCapability.Multimedia.Image           图片处理
  
  SystemCapability.FileManagement.File.FileIO   文件管理
  

### 相关权限

```
本示例需要在module.json5中配置如下权限:

读取公共媒体文件权限：ohos.permission.READ_MEDIA

相机权限 ohos.permission.CAMERA

本地资源读取权限 ohos.permission.MEDIA_LOCATION
```

### 使用说明

需要替换full sdk中的xcomponent.d.ts

1.启动应用,首页展示扫一扫跳转页面,点击扫一扫跳转至相机模块。

2.点击右上角相册图标可以进入手机本地存储文件,点击picture,点击图片选取相关二维码图片进行识别读取。

3.点击轻触照亮可以对其进行相机拍照并对拍摄的照片进行处理和识别。



### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例为stage模型，从API version 9开始支持。

3.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。