# 应用示例<a name="ZH-CN_TOPIC_0000001115464207"></a>

-   [概要简介](#section1470103520301)
-   [目录](#sectionMenu)
-   [使用说明](#section17988202503116)
-   [约束与限制](#section18841871178)
-   [相关仓](#section741114082513)

## 概要简介<a name="section1470103520301"></a>

为帮助开发者快速熟悉HarmonyOS和OpenHarmony SDK所提供的API和应用开发流程，我们提供了一系列的应用示例，即Sample。每一个应用示例都是一个独立的DevEco Studio工程项目，开发者可以将工程导入到DevEco Studio开发工具，通过浏览代码、编译工程、安装和运行应用示例来了解应用示例中涉及API的使用方法。

## 目录<a name="sectionMenu"></a>
- ability
  - [`EtsCommonEvent:`订阅公共事件（eTS）](https://gitee.com/openharmony/app_samples/tree/master/ability/EtsCommonEvent)
  - [`JsDistributedMusicPlayer:`分布式音乐播放（JS）](https://gitee.com/openharmony/app_samples/tree/master/ability/JsDistributedMusicPlayer)
- common
  - [`AirQuality:`空气质量（JS）](https://gitee.com/openharmony/app_samples/tree/master/common/AirQuality)
  - [`Clock:`时钟（JS）](https://gitee.com/openharmony/app_samples/tree/master/common/Clock)
  - [`DistributeCalc:`分布式计算器（JS）](https://gitee.com/openharmony/app_samples/tree/master/common/DistributeCalc)
  - [`ECG:`心率检测（JS）](https://gitee.com/openharmony/app_samples/tree/master/common/ECG)
  - [`EtsNotification:`通知（eTS）](https://gitee.com/openharmony/app_samples/tree/master/common/EtsNotification)
  - [`EtsResourceManager:`资源管理器（eTS）](https://gitee.com/openharmony/app_samples/tree/master/common/EtsResourceManager)
  - [`Flashlight:`手电筒（JS）](https://gitee.com/openharmony/app_samples/tree/master/common/Flashlight)
  - [`JsHelloWorld:`你好世界（JS）](https://gitee.com/openharmony/app_samples/tree/master/common/JsHelloWorld)
- data
  - [`eTSKvStore:`分布式数据库（eTS）](https://gitee.com/openharmony/app_samples/tree/master/data/eTSKvStore)
  - [`eTSLiteStorage:`轻量级存储（eTS）](https://gitee.com/openharmony/app_samples/tree/master/data/eTSLiteStorage)
  - [`eTSRdb:`关系型数据库（eTS）](https://gitee.com/openharmony/app_samples/tree/master/data/eTSRdb)
- media
  - [`JsAudioPlayer:`音频播放和管理（JS）](https://gitee.com/openharmony/app_samples/tree/master/media/JsAudioPlayer)
  - [`JsVideo:`视频播放（JS）](https://gitee.com/openharmony/app_samples/tree/master/media/JsVideo)
- security
  - [`JsDotTest:`测试打点（JS）](https://gitee.com/openharmony/app_samples/tree/master/security/JsDotTest)
- thread
  - [`JsWorker:`启动一个worker（JS）](https://gitee.com/openharmony/app_samples/tree/master/thread/JsWorker)
- CompleteApps
  - [`KikaInput:`轻量级输入法（JS）](https://gitee.com/openharmony/app_samples/tree/master/CompleteApps/KikaInput)
  - [`AstronautsGame:`太空人避障游戏（C++）](https://gitee.com/openharmony/app_samples/tree/master/CompleteApps/AstronautsGame)
- ETSUI
  - [`EtsProcess:`进程信息（eTS）](https://gitee.com/openharmony/app_samples/tree/master/ETSUI/EtsProcess)
  - [`StringCodec:`字符串编解码（eTS）](https://gitee.com/openharmony/app_samples/tree/master/ETSUI/StringCodec)
  - [`eTSBuildCommonView:`创建简单视图（eTS）](https://gitee.com/openharmony/app_samples/tree/master/ETSUI/eTSBuildCommonView)
  - [`eTSDefiningPageLayoutAndConnection:`页面布局和连接（eTS）](https://gitee.com/openharmony/app_samples/tree/master/ETSUI/eTSDefiningPageLayoutAndConnection)
  - [`eTSRunninglock:`运行锁（eTS）](https://gitee.com/openharmony/app_samples/tree/master/ETSUI/eTSRunninglock)
  - [`eTSUrlString:`URL字符串解析（eTS）](https://gitee.com/openharmony/app_samples/tree/master/ETSUI/eTSUrlString)
- ArkUI
  - [`AtomicLayout:`原子布局（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/AtomicLayout)
  - [`Badge:`事件标记控件（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/Badge)
  - [`International:`国际化（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/International)
  - [`JSMenu:`菜单（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JSMenu)
  - [`JSUICustomComponent:`自定义组件（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JSUICustomComponent)
  - [`JsAnimationStyle:`动画与自定义字体（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsAnimationStyle)
  - [`JsBasicComponents:`基础组件（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsBasicComponents)
  - [`JsBrightness:`设置屏幕亮度（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsBrightness)
  - [`JsCanvas:`画布组件（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsCanvas)
  - [`JsDevice:`设备信息（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsDevice)
  - [`JsDialog:`页面弹窗（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsDialog)
  - [`JsGrid:`栅格组件（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsGrid)
  - [`JsList:`商品列表（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsList)
  - [`JsPanel:`内容展示面板（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsPanel)
  - [`JsRouter:`页面路由（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsRouter)
  - [`JsSvg:`可缩放矢量图形（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsSvg)
  - [`JsTimer:`定时器与系统时间设置（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/JsTimer)
  - [`Picker:`滑动选择器（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/Picker)
  - [`Popup:`气泡（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/Popup)
  - [`RefreshContainer:`下拉刷新容器（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/RefreshContainer)
  - [`Slider:`滑动条（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/Slider)
  - [`Stack:`堆叠容器（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/Stack)
  - [`StepNavigator:`步骤导航器（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/StepNavigator)
  - [`Swiper:`内容滑动容器（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/Swiper)
  - [`Tabs:`页签容器（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/Tabs)
  - [`Toolbar:`工具栏（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/Toolbar)
  - [`chart:`图表组件（JS）](https://gitee.com/openharmony/app_samples/tree/master/UI/chart)

## 使用说明<a name="section17988202503116"></a>

1.  将独立的应用示例工程导入DevEco Studio进行编译构建及运行调试。
2.  部分应用示例中含有多个模块，开发者可以选择对单个模块进行编译构建，生成一个HAP应用安装包，也可以对整个工程进行编译构建，生成多个HAP应用安装包。
3.  安装运行后，即可在设备上查看应用示例运行效果，以及进行相关调试。

## 约束与限制<a name="section18841871178"></a>

1.  安装运行应用示例之前，请先通过config.json文件中的"deviceType"字段来确认该应用示例支持的设备类型，可尝试通过修改该字段使其可以在相应类型的设备上运行（config.json文件一般在代码的entry/src/main路径下，不同的Sample可能会有不同）。
2.  配置开发环境时，如果您想让应用示例运行到HarmonyOS上，请参考[DevEco Studio使用说明](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/tools_overview-0000001053582387)。如果您想让应用示例运行到OpenHarmony上，请参考[DevEco Studio（OpenHarmony）使用指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/Readme-CN.md)。
3.  Readme中标注为“支持标准系统”或“支持小型系统”的应用示例支持在OpenHarmony上运行，标注为“支持大型系统”的应用示例仅支持在HarmonyOS上运行。
4.  所有HarmonyOS相关示例已被全部迁移至[Harmony组织](https://gitee.com/harmonyos)之下的[harmonyos\_app\_samples](https://gitee.com/harmonyos/harmonyos_app_samples)仓中，本仓中这部分示例不再更新，并将在未来被移除。

## 相关仓<a name="section741114082513"></a>

1.  CAMERA\_SAMPLE\_APP组件的应用示例：[applications\_sample\_camera](https://gitee.com/openharmony/applications_sample_camera/blob/master/README_zh.md)
2.  WIFI\_IOT\_APP组件的应用示例：[applications\_sample\_wifi\_iot](https://gitee.com/openharmony/applications_sample_wifi_iot/blob/master/README_zh.md)
3.  HarmonyOS的应用示例：[harmonyos\_app\_samples](https://gitee.com/harmonyos/harmonyos_app_samples)