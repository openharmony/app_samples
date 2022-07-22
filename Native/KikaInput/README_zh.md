# 中文输入法

### 简介

本工程是中文输入法Demo，支持中文输入、中文联想以及部分外接键盘的功能。实现效果如下：

![](screenshots/device/keyboard.png)

### 相关概念

本示例在AbilityStage.ts文件中实现了输入法设置功能,在InputDemoService.ts文件中实现了输入法相关服务,在model文件夹下实现了引擎交互与控制逻辑。

### 相关权限

允许应用查询其他应用的信息权限：ohos.permission.GET_BUNDLE_INFO_PRIVILEGED

### 使用说明

1. 中文输入法Sample需要加载中文输入法引擎。
   
2. 打开中文输入法app,点击左边列表中的中文输入法,然后点击输入框会拉起自动拉起输入法,点击kikainput则是拉起系统默认的输入法,如果在选择中文输入法后并未拉起输入法或者拉起的是kikainput,则只需重启RK板重新拉起即可。


### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本实例为stage模型,从API version 9 开始支持。

3.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。