# WLAN<a name="ZH-CN_TOPIC_0000001127136597"></a>

### 简介

WLAN 服务系统为用户提供 WLAN 基础功能、P2P（peer-to-peer）功能和 WLAN 消息通知的相应服务，让应用可以通过 WLAN 和其他设备互联互通。

1、WLAN 基础功能可以获取WLAN状态，查询WLAN是否打开。发起扫描并获取扫描结果。获取连接态详细信息，包括连接信息、IP 信息等。

2、不信任热点配置是指应用可以添加指定的热点，其选网优先级低于已保存热点。如果扫描后判断该热点为最合适热点，自动连接该热点。

3、WLAN P2P 功能用于设备与设备之间的点对点数据传输。

4、WLAN 消息通知（Notification）是系统内部或者与应用之间跨进程通讯的机制，注册者在注册消息通知后，一旦符合条件的消息被发出，注册者即可接收到该消息并获取消息中附带的信息。

### 使用说明

 1.点击“Basic Features”，跳转页面，WLAN基础功能

​     a.点击“Scan”，扫描无线网络

​     b.点击“Get Connected Info”，获取连接状态信息

​     c.点击“Get Country Code”，获取设备国家码

​     d.点击“Get Support Feature”，获取设备是否支持指定的能力

 2.点击“Untrusted Config”，跳转页面，不信任热点配置

​      a.点击“Add Untrusted Wifi”，设置不信任热点配置

​      b.点击“Remove Untrusted Wifi”，删除不信任热点配置

 3.点击“P2P”，跳转页面，P2P功能

​       a.点击“Discover”，搜索附近可用的P2P设备

​       b.点击“Stop Discover”，停止搜索附近的P2P设备

​       c.点击“Create Group”，建立P2P群组

​       d.点击“Remove Group”，移除P2P群组

​       e.点击“Disconnect”，取消向指定设备发起的连接

 4.点击“Wlan Notification”，WLAN消息通知

​       a.点击“Register”，注册WLAN变化消息事件

​       b.点击“Unregister”，注销WLAN变化消息事件

### 约束与限制

本示例仅支持在大型系统上运行。
