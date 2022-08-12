# 联系人

### 介绍

本示例展示手机联系人功能。

本示例使用[Tabs](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-tabs.md)容器组件设置应用整体布局,在首页面中使用[List](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-list.md)容器组件设置页面布局，再通过[AlphabetIndexer](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-alphabet-indexer.md)组件设置索引导航条。

使用说明：

1.点击**+**，跳转添加联系人界面，输入联系人信息，点击**√**，确认添加联系人，并返回首页。

2.点击联系人列表跳转页面查看详细信息，并且可以编辑或删除联系人信息。

### 效果预览

![](screenshots/device/main.png) ![](screenshots/device/details.png)

### 相关权限

允许应用读取联系人数据：[ohos.permission.READ_CONTACTS](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

允许应用添加、移除和更改联系人数据：[ohos.permission.WRITE_CONTACTS](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例仅支持API9版本SDK，版本号：3.2.5.5 Beta2。

3.本示例需要使用DevEco Studio 3.0 Beta4 (Build Version: 3.0.0.991， built on July 30， 2022)才可编译运行。

4.本示例因接口问题，目前实现了联系人查询接口，可通过预置联系人应用添加联系人，再进入本应用查看已添加的联系人。

5.因联系人接口问题添加忽略编译校验。