# 文档管理

### 简介

本示例用于验证OpenHarmony提供的FA模型，Canvas组件、media组件做小游戏的能效是否符合预期，以及验证资源调度子系统的API接口是否符合后台规范运行的预期。

### 使用说明

1.点击"ConnectService"按钮，创建一个ServiceAbility并连接；

2.点击"DisconenctService"按钮，断开ServiceAbility；

3.点击"set game alarm"按钮，利用闹钟提醒代理API，验证游戏进程在收到闹铃通知时不被拉起；

4.点击"set game calendar"按钮，利用日历提醒代理API，验证游戏进程在收到日历通知时不被拉起；

5.点击"start game"前，下载一个音频文件，重命名为12664.mp3，通过hdc file send 12664.mp3 /data/，
点击"start game"利用了后台长时任务API播放了一个音乐，选择对应的游戏难度1-5关玩游戏，游戏玩的过程中会
利用后台信息统计API统计展示游戏在线时长。

### 约束与限制

本示例仅支持在标准系统上运行。

### 运行结果截图：

![](screenshot/snapshot1.png)
![](screenshot/snapshot2.png)
