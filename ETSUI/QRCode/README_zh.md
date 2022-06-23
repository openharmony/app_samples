# 二维码

### 简介

本示例展示了在eTS中如何生成二维码和如何使用jsqr解析二维码。

在工程中使用npm安装jsqr，安装步骤：

1.在**DevEco Studio**的控制台Terminal窗口中，执行cd entry进入entry目录。

2.执行npm install jsqr --save 命令安装jsqr。

3.在工程中import jsQR from 'jsqr'导入后即可使用。

实现效果如下：

![create](screenshots/devices/create.png) ![paras](screenshots/devices/paras.png)

### 相关概念

-  QRCode：显示二维码信息组件，传入要生成二维码的字符串即可显示生成的二维码。
-  jsqr：提供解析二维码的api，支持npm安装。

### 相关权限

```
本示例需要在module.json5中配置如下权限:

获取屏幕截图权限：ohos.permission.CAPTURE_SCREEN
```

### 使用说明

1.启动应用,点击**生成二维码**进入界面，在输入框中输入内容，下方显示输入内容生成的二维码。

2.点击**保存二维码**可以将当前二维码图片保存到本地。

3.点击**解析二维码**进入界面，会显示一个默认的二维码，点击**选择二维码文件**可以在设备中选择生成二维码界面中保存的二维码图片。

4.点击**解析二维码**，解析完成会在二维码下方显示解析结果

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例为Stage模型，从API version 9开始支持。

3.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。