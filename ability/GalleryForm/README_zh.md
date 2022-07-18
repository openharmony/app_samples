# 图库卡片

### 简介

本示例是模拟图库卡片，实现对图库中的照片在卡片中显示，定时刷新卡片内容等功能。实现效果如下：

![](screenshots/device/gallery.png) ![](screenshots/device/gallery_form.png)

### 相关概念

媒体库管理：通过媒体库 getAllObject查询图库中所有的图片路径，通过open获取指定路径的图片fd，作为创建卡片的关键参数。

卡片数据更新：卡片数据更新可以调用formProvider中的setFormNextRefreshTime去设定卡片更新时间，最短时间为5分钟。在设定的时间结束后触发onUpdate回调更新卡片。

### 相关权限

允许应用访问用户媒体文件中的地理位置信息：ohos.permission.MEDIA_LOCATION

允许应用读取用户外部存储中的媒体文件信息：ohos.permission.READ_MEDIA

允许应用读写用户外部存储中的媒体文件信息：ohos.permission.WRITE_MEDIA

### 使用说明

1.首次打开应用，需要赋允许应用访问用户媒体文件中的地理位置信息权限。

2.长按应用图标创建卡片，将卡片添加至桌面，卡片正常显示图库照片。

3.点击卡片显示的图片可以拉起本应用。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例为Stage模型，从API version 9开始支持。

3.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.991, built on July 6, 2022)才可编译运行。

4.在创建卡片前确保系统图库中有图片，否则卡片不更新。

5.卡片内容更新为卡片创建5分钟后，且需要设备是亮屏的，否则卡片不更新。