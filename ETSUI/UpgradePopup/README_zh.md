# 自定义弹窗

### 介绍

本示例展示了通过**CustomDialogController**类显示一个自定义的升级弹窗。

本示例使用 [CustomDialogController](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-methods-custom-dialog-box.md) 组件实现自定义弹窗，用于给用户反馈升级信息。使用 [RichText](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-richtext.md) 组件实现富文本的显示。

使用说明： 

1.进入主页，界面会弹出升级弹窗，里面显示RichText信息。 

2.点击**取消**按钮和升级按钮，弹窗会关闭。

### 效果预览

![](screenshots/devices/zh/popup.png)

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，仅支持API9版本SDK，版本号：3.2.5.5。

3.本示例需要使用DevEco Studio 3.0 Beta4 (Build Version： 3.0.0.991， built on July 6， 2022)才可编译运行。