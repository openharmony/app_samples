# 中文输入法

### 简介

本工程是中文输入法Demo，支持中文输入、中文联想以及部分外接键盘的功能。

![](screenshots/device/keyboard.png)

### 相关概念

[中文输入法相关库文件](https://github.com/lizhangqu/PinyinIME/tree/master/app/src/main)

### 相关权限
允许应用查询其他应用的信息权限：ohos.permission.GET_BUNDLE_INFO_PRIVILEGED

### 使用说明

1. 首先前往 https://github.com/lizhangqu/PinyinIME/tree/master/app/src/main 上下载cpp文件并添加到中文输入法中
   
2. 打开中文输入法工程cpp文件中的userdict.h文件并导入头文件#include<sys/time.h>

3. 编译生成hap并签名安装(签名步骤在下面),打开中文输入法app,点击左边列表中的中文输入法,然后点击输入框
   会拉起自动拉起输入法,点击kikainput则是拉起系统默认的输入法,如果在选择中文输入法后并未拉起输入法或
   者拉起的是kikainput,则只需重启RK板重新拉起即可。


### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本实例为stage模型,从API version 9 开始支持。

3.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。