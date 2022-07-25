# 小鸟避障游戏

### 简介

本示例用于验证OpenHarmony提供的FA模型，Canvas组件、media组件做小游戏的能效是否符合预期，以及验证资源调度子系统的API接口是否符合后台规范运行的预期。实现效果如下：

![](screenshot/snapshot1.png) ![](screenshot/snapshot2.png)

### 相关概念

Canvas：提供画布组件，用于自定义绘制图形。

### 相关权限

后台持续运行: ohos.permission.KEEP_BACKGROUND_RUNNING

查询其他应用的运行时间: ohos.permission.BUNDLE_ACTIVE_INFO

修改音频设置: ohos.permission.MODIFY_AUDIO_SETTINGS

读取媒体文件信息: ohos.permission.READ_MEDIA

读取用户存储: ohos.permission.READ_USER_STORAGE

写入用户存储: ohos.permission.WRITE_USER_STORAGE

后台代理提醒: ohos.permission.PUBLISH_AGENT_REMINDER

### 使用说明

1.点击**ConnectService**按钮，创建一个ServiceAbility并连接。

2.点击**DisconenctService**按钮，断开ServiceAbility。

3.点击**set game alarm**按钮，利用闹钟提醒代理API，验证游戏进程在收到闹铃通知时不被拉起。

4.点击**set game calendar**按钮，利用日历提醒代理API，验证游戏进程在收到日历通知时不被拉起。

5.点击**start game**前，下载一个音频文件，重命名为12664.mp3，通过hdc file send 12664.mp3 /data/，
点击**start game**利用了后台长时任务API播放了一个音乐，验证应用退到后台后能否正常播放。选择对应
的游戏难度1-5关玩游戏，游戏玩的过程中会利用后台信息统计API统计展示游戏在线时长。

6.点**home**按钮后，应用生命周期为onInactive, 在此回调中起一个短时任务，验证短时任务API能否正常执行。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.从API version 9开始支持。

3.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。

4.本示例所配置的权限ohos.permission.BUNDLE_ACTIVE_INFO为system_basic级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)查看)，需要手动配置对应级别的权限签名。