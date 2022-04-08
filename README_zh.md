# 应用示例<a name="ZH-CN_TOPIC_0000001115464207"></a>

-   [概要简介](#section1470103520301)
-   [目录](#sectionMenu)
-   [使用说明](#section17988202503116)
-   [约束与限制](#section18841871178)
-   [相关仓](#section741114082513)

## 概要简介<a name="section1470103520301"></a>

为帮助开发者快速熟悉HarmonyOS和OpenHarmony SDK所提供的API和应用开发流程，我们提供了一系列的应用示例，即Sample。每一个应用示例都是一个独立的DevEco Studio工程项目，开发者可以将工程导入到DevEco Studio开发工具，通过浏览代码、编译工程、安装和运行应用示例来了解应用示例中涉及API的使用方法。

## 目录<a name="sectionMenu"></a>
- Basic
  - [`Container:`语言基础类库---线性容器ArrayList（eTS）（API8）](Basic/Container)
  - [`Screenshot:`基础功能-屏幕截图（eTS）（API8）](Basic/Screenshot)
- Account
  - [`AppAccountManager:`账号管理-应用账号管理（eTS）（API8）](Account/AppAccountManager)
  - [`DistributeAccount:`账号管理-分布式账号管理（eTS）（API8）](Account/DistributeAccount)
- Communication
  - [`RPC:`通信与连接-RPC连接（eTS）（API8）](Communication/RPC)
  - [`Wlan:`WLAN（eTS）（API8）](Communication/Wlan) 
- ability
  - [`DMS:`分布式Demo（eTS）（API7）](ability/DMS)
  - [`CommonEvent:`订阅公共事件（eTS）（API7）](ability/CommonEvent)
  - [`JsDistributedMusicPlayer:`分布式音乐播放（JS）（API7）](ability/JsDistributedMusicPlayer)
  - [`DataAbility:`DataAbility的创建与访问（eTS）（API8）](ability/DataAbility)
  - [`ServiceAbility:`ServiceAbility的创建与使用（eTS）（API8）](ability/ServiceAbility)
  - [`StageCallAbility:`StageAbility的创建与使用（eTS）（API8）](ability/StageCallAbility)
  - [`FormAbility:`FA模型卡片（JS）（API8）](ability/FormAbility)
  - [`FormExtAbility:`Stage模型卡片（eTS JS）（API9）](ability/FormExtAbility)
  - [`FormLauncher:`卡片使用方（eTS）（API8）](ability/FormLauncher)
  - [`ServiceExtAbility:`StageAbility的创建与使用（eTS）（API9）](ability/ServiceExtAbility)  
- common
  - [`AirQuality:`空气质量（JS）（API7）](common/AirQuality)
  - [`Clock:`时钟（JS）（API7）](common/Clock)
  - [`DistributeCalc:`分布式计算器（JS）（API7）](common/DistributeCalc)
  - [`ECG:`心率检测（JS）（API7）](common/ECG)
  - [`Notification:`通知（eTS）（API7）](common/Notification)
  - [`ResourceManager:`资源管理器（eTS）（API7）](common/ResourceManager)
  - [`Runninglock:`运行锁（eTS）（API7）](common/Runninglock)
  - [`Flashlight:`手电筒（JS）（API7）](common/Flashlight)
  - [`JsHelloWorld:`你好世界（JS）（API7）](common/JsHelloWorld)
  - [`PowerManager:`系统电源管理（eTS）（API8）](common/PowerManager)
- data
  - [`KvStore:`分布式数据库（eTS）（API8）](data/Kvstore)
  - [`LiteStorage:`轻量级存储（eTS）（API7）](data/LiteStorage)
  - [`Rdb:`关系型数据库（eTS）（API8）](data/Rdb)
  - [`DDMQuery:`结果集与谓词（eTS）（API8）](data/DDMQuery)
- device
  - [`DeviceManager:`设备管理（eTS）（API8）](device/DeviceManager)
  - [`SenSor:`传感器（eTS）（API8）](device/SenSor)
- media
  - [`JsAudioPlayer:`音频播放和管理（JS）（API7）](media/JsAudioPlayer)
  - [`JsVideo:`视频播放（JS）（API7）](media/JsVideo)
  - [`Recorder:`录音机（eTS）（API8）](media/Recorder)
  - [`MultiMedia:`相机和媒体库（eTS）（API9）](media/MultiMedia)
- DFX
  - [`JsDotTest:`测试打点（JS）（API7）](DFX/JsDotTest)
- Telephony
  - [`Call:`电话服务-拨打电话（eTS）（API8）](Telephony/Call)
  - [`Message:`电话服务-短信服务（eTS）（API8）](Telephony/Message)
  - [`RadioTech:`电话服务-网络搜索（eTS）（API8）](Telephony/RadioTech)
  - [`SimManager:`电话服务-SIM卡管理（eTS）（API8）](Telephony/SimManager)
- thread
  - [`JsWorker:`启动一个worker（JS）（API7）](thread/JsWorker)
- CompleteApps
  - [`KikaInput:`轻量级输入法（JS）（API9）](CompleteApps/KikaInput)
  - [`AstronautsGame:`太空人避障游戏（C++）](CompleteApps/AstronautsGame)
- ETSUI
  - [`Canvas:`画布组件（eTS）（API8）](ETSUI/Canvas)
  - [`CustomComponent:`组件化（eTS）（API8）](ETSUI/CustomComponent)
  - [`Process:`进程信息（eTS）（API7）](ETSUI/Process)
  - [`BuildCommonView:`创建简单视图（eTS）（API7）](ETSUI/BuildCommonView)
  - [`DefiningPageLayoutAndConnection:`页面布局和连接（eTS）（API7）](ETSUI/DefiningPageLayoutAndConnection)
  - [`Drag:`ArkUI-拖拽事件（eTS）（API8）](ETSUI/Drag)
  - [`Component:`Ets组件测试Demo（eTS）（API8）](ETSUI/Component)
  - [`ArkUIAnimation:`Ets动画（eTS）（API8）](ETSUI/ArkUIAnimation)
  - [`MediaQuery:`Ets媒体查询（eTS）（API8）](ETSUI/MediaQuery)
  - [`XComponent:`ArkUI-XComponent（eTS）（API8）](ETSUI/XComponent)
  - [`MouseEvent:`ArkUI-鼠标事件（eTS）（API8）](ETSUI/MouseEvent)
  - [`Web:`ArkUI-Web（eTS）（API8）](ETSUI/Web)
- FileManager
  - [`Environment:`目录环境（eTS）（API8）](FileManager/Environment)
  - [`FileIo:`文件管理（eTS）（API8）](FileManager/FileIo)
- Notification
  - [`Emitter:`处理进程内事件（eTS）（API8）](Notification/Emitter)
  - [`AlarmClock:`后台代理提醒（eTS）（API8）](Notification/AlarmClock)
  - [`Notification:`通知-订阅、发送通知（eTS）（API9）](Notification/Notification)
- UI
  - [`AtomicLayout:`原子布局（JS）（API7）](UI/AtomicLayout)
  - [`Badge:`事件标记控件（JS）（API7）](UI/Badge)
  - [`International:`国际化（JS）（API7）](UI/International)
  - [`JsFA:`FA示例应用（JS）（API8）](UI/JsFA)  
  - [`JsShopping:`购物示例应用（JS）（API8）](UI/JsShopping)     
  - [`JSMenu:`菜单（JS）（API7）](UI/JSMenu)
  - [`JSUICustomComponent:`自定义组件（JS）（API7）](UI/JSUICustomComponent)
  - [`JsAnimation:`动效示例应用（JS）](UI/JsAnimation)
  - [`JsAnimationStyle:`动画与自定义字体（JS）（API7）](UI/JsAnimationStyle)
  - [`JsBasicComponents:`基础组件（JS）（API8）](UI/JsBasicComponents)
  - [`JsBrightness:`设置屏幕亮度（JS）（API7）](UI/JsBrightness)
  - [`JsCanvas:`画布组件（JS）（API7）](UI/JsCanvas)
  - [`JsDevice:`设备信息（JS）（API7）](UI/JsDevice)
  - [`JsDialog:`页面弹窗（JS）（API7）](UI/JsDialog)
  - [`JsGrid:`栅格组件（JS）（API7）](UI/JsGrid)
  - [`JsList:`商品列表（JS）（API7）](UI/JsList)
  - [`JsPanel:`内容展示面板（JS）（API7）](UI/JsPanel)
  - [`JsRouter:`页面路由（JS）（API7）](UI/JsRouter)
  - [`JsSvg:`可缩放矢量图形（JS）（API7）](UI/JsSvg)
  - [`JsTimer:`定时器与系统时间设置（JS）（API7）](UI/JsTimer)
  - [`Picker:`滑动选择器（JS）（API7）](UI/Picker)
  - [`Popup:`气泡（JS）（API7）](UI/Popup)
  - [`RefreshContainer:`下拉刷新容器（JS）（API7）](UI/RefreshContainer)
  - [`Slider:`滑动条（JS）（API7）](UI/Slider)
  - [`Stack:`堆叠容器（JS）（API7）](UI/Stack)
  - [`StepNavigator:`步骤导航器（JS）（API7）](UI/StepNavigator)
  - [`Swiper:`内容滑动容器（JS）（API7）](UI/Swiper)
  - [`Tabs:`页签容器（JS）（API7）](UI/Tabs)
  - [`Toolbar:`工具栏（JS）（API7）](UI/Toolbar)
  - [`chart:`图表组件（JS）（API7）](UI/chart)
  - [`JsAdaptivePortalList:`多设备自适应的效率型首页（JS）（API8）](UI/JsAdaptivePortalList)
  - [`JsAdaptivePortalPage:`多设备自适应的FA页面（JS）（API8）](UI/JsAdaptivePortalPage)
  - [`JsImage:`基本动画（JS）（API8）](UI/JsImage)
  - [`JsGallery:`图库示例应用（JS）（API8）](UI/JsGallery)
  - [`JSComponments:`Js组件（JS）（API8）](UI/JSComponments)
  - [`JsUserRegistration:`用户注册（JS）（API8）](UI/JsUserRegistration)
- Util
  - [`UtilBase64Codec:`Base64编解码（eTS）（API8）](Util/UtilBase64Codec)
  - [`UtilScope:`范围判断（eTS）（API8）](Util/UtilScope)
  - [`UtilStringCodec:`字符串编解码（eTS）（API7）](Util/UtilStringCodec)
  - [`UtilLruBuffer:`缓冲区（eTS）（API8）](Util/UtilLruBuffer)
  - [`UtilRationalNumber:`有理数（eTS）（API8）](Util/UtilRationalNumber)
  - [`UtilTypeCheck:`内置对象类型检查（eTS）（API8）](Util/UtilTypeCheck)
  - [`UtilUrlString:`URL字符串解析（eTS）（API7）](Util/UtilUrlString)
  - [`XmlTextConvert:`xml文本转换（eTS）（API8）](Util/XmlTextConvert)

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