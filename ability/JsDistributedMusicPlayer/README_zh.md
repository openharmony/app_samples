# DistributedMusicPlayer

本示例完成了基本的音乐播放、暂停、上一曲、下一曲功能，并使用分布式能力完成了音乐播放状态的跨设备迁移。
- **音乐播放**

    使用MediaLibrary完成本地媒体文件扫描，并通过AudioPlayer完成了音乐的播放。
- **跨设备迁移播放**

    使用DeviceManager完成了分布式设备列表的显示

    使用分布式调度以及分布式数据完成了跨设备迁移功能

运行步骤：
参考[DevEco Studio（OpenHarmony）使用指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/DevEco-Studio%EF%BC%88OpenHarmony%EF%BC%89%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)搭建OpenHarmony应用开发环境、并导入本工程进行编译、运行。

运行结果截图：

![](screenshots/device/main.png)

## 相关仓
应用子系统

multimedia_medialibrary_standard

multimedia_media_standard

device_manager

distributedschedule_dms_fwk

distributeddatamgr_datamgr