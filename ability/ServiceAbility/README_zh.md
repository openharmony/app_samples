# ServiceAbility<a name="ZH-CN_TOPIC_0000001127136377"></a>

### 简介

基于 Service 模板的 Ability（以下简称 "Service"）主要用于后台运行任务（如执行音乐播放、文件下载 等），但不提供用户交互界面。

Service 可由其他应用或 Ability 启动，即使用户切换到其他应用，Service 仍将在后台继续运行。

### 使用说明

选择两台设备A和B，组网条件下操作A设备：

1.点击“Start Local Service”按钮，启动本地服务。A设备应用界面显示“LocalService onStart”。

2.点击“Stop Local Service”按钮，停止本地服务。A设备应用界面显示“LocalService onStop”。

3.点击“Connect Local Service”按钮，连接本地服务。A设备应用界面显示“LocalService onConnect”。

4.点击“Disconnect Local Service”按钮，断开本地服务。A设备应用界面显示“LocalService onDisconnect”。

5.点击“Keep Background Running”按钮，保持后台运行。A设备应用通知栏显示“I'm a Foreground Service”。

6.点击“Start Remote Service”按钮，启动远程服务。B设备应用界面显示“RemoteService onStart”。

7.点击“Stop Remote Service”按钮，停止远程服务。B设备应用界面显示“RemoteService onStop”。

8.点击“Connect Remote Service”按钮，连接远程服务。B设备应用界面显示“RemoteService onConnect”。

9.点击“Disconnect Remote Service”按钮,断开远程服务。B设备应用界面显示“RemoteService onDisconnect”。

### 约束与限制

本示例仅支持在大型系统上运行。
