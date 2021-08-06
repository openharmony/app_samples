# DistributedMusicPlayer

本示例完成了基本的音乐播放、暂停、上一曲、下一曲功能，并使用分布式能力完成了音乐播放状态的跨设备迁移。
- **音乐播放**

    使用MediaLibrary完成本地媒体文件扫描，并通过AudioPlayer完成了音乐的播放。
- **跨设备迁移播放**

    使用DeviceManager完成了分布式设备列表的显示

    使用分布式调度以及分布式数据完成了跨设备迁移功能

【运行步骤】

1. 编译运行：参考[DevEco Studio（OpenHarmony）使用指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/DevEco-Studio%EF%BC%88OpenHarmony%EF%BC%89%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)搭建OpenHarmony应用开发环境、并导入本工程进行编译、运行。

1. 运行结果截图：

![](screenshots/device/main.png)

【分布式流转体验】

1. 硬件准备：准备两台3516开发板，并通过网线直连

1. 下载[这个临时触发的构建版本](http://download.ci.openharmony.cn/Artifacts/hispark_taurus_L2_2_2-Beta2/20210806.12/version/Artifacts-hispark_taurus_L2_2_2-Beta2-20210806.12-version-hispark_taurus_L2_2_2-Beta2.tar.gz)并烧录进两台开发板
    * 若下载地址过期，可以参考[这个临时PR](https://gitee.com/openharmony/device_manager/pulls/8)，自行提交PR并start build触发构建
    * 也可以[搭建标准系统源码环境](https://gitee.com/openharmony/docs/blob/master/zh-cn/device-dev/quick-start/quickstart-standard-package-environment.md)，按[device_manager仓库首页指导](https://gitee.com/openharmony/device_manager)修改PIN_CODE以及PORT后，执行 `./build.sh --product-name Hi3516DV300` 编译版本后进行烧录
1. 开发板1配置一个IP（每次重启后需要重新配置）
    ```
    hdc shell ifconfig eth0 192.168.1.222 netmask 255.255.255.0
    ```
1. 开发板2配置另外一个不一样的IP（每次重启后需要重新配置）
    ```
    hdc shell ifconfig eth0 192.168.1.111 netmask 255.255.255.0
    ```
1. 打开音乐，点击左下角流转按钮，列表中会出现远端设备的id，选择远端设备id即可实现跨设备迁移播放
    ![](screenshots/device/distributed.gif)
## 相关仓
应用子系统

multimedia_medialibrary_standard

multimedia_media_standard

device_manager

distributedschedule_dms_fwk

distributeddatamgr_datamgr