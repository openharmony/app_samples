# 应用示例<a name="ZH-CN_TOPIC_0000001115464207"></a>

-   [概要简介](#section1470103520301)
-   [目录](#sectionMenu)
-   [使用说明](#section17988202503116)
-   [约束与限制](#section18841871178)
-   [相关仓](#section741114082513)

## 概要简介<a name="section1470103520301"></a>

为帮助开发者快速熟悉OpenHarmony SDK所提供的API和应用开发流程，我们提供了一系列的应用示例，即Sample。每一个应用示例都是一个独立的DevEco Studio工程项目，开发者可以将工程导入到DevEco Studio开发工具，通过浏览代码、编译工程、安装和运行应用示例来了解应用示例中涉及API的使用方法。

## 目录<a name="sectionMenu"></a>
- Basic
  - [`Container:`线性容器ArrayList（eTS）（API8）](Basic/Container)
  - [`Screenshot:`屏幕截图（eTS）（API9）](Basic/Screenshot)
- Account
  - [`AppAccountManager:`应用帐号管理（eTS）（API8）](Account/AppAccountManager)
  - [`DistributeAccount:`分布式帐号管理（eTS）（API8）](Account/DistributeAccount)
- Communication
  - [`RPC:`RPC连接（eTS）（API8）](Communication/RPC)
  - [`Wlan:`WLAN（eTS）（API8）](Communication/Wlan) 
- ability
  - [`DMS:`分布式Demo（eTS）（API8）](ability/DMS)
  - [`JsDistributedMusicPlayer:`分布式音乐播放（JS）（API7）](ability/JsDistributedMusicPlayer)
  - [`DataAbility:`DataAbility的创建与访问（eTS）（API8）](ability/DataAbility)
  - [`ServiceAbility:`ServiceAbility的创建与使用（eTS）（API8）](ability/ServiceAbility)
  - [`StageCallAbility:`StageCallAbility的创建与使用（eTS）（API9）](ability/StageCallAbility)
  - [`FormAbility:`FA模型卡片（JS）（API8）](ability/FormAbility)
  - [`FormExtAbility:`Stage模型卡片（eTS JS）（API9）](ability/FormExtAbility)
  - [`FormLauncher:`卡片使用方（eTS）（API8）](ability/FormLauncher)
  - [`ServiceExtAbility:`StageExtAbility的创建与使用（eTS）（API9）](ability/ServiceExtAbility)
  - [`DistributedGraffiti:`分布式涂鸦（eTS）（API8）](ability/DistributedGraffiti)  
- common
  - [`AirQuality:`空气质量（JS）（API8）](common/AirQuality)
  - [`Clock:`时钟（JS）（API8）](common/Clock)
  - [`DistributeCalc:`分布式计算器（JS）（API7）](common/DistributeCalc)
  - [`ECG:`心率检测（JS）（API8）](common/ECG)
  - [`Notification:`通知（eTS）（API8）](common/Notification)
  - [`ResourceManager:`资源管理器（eTS）（API8）](common/ResourceManager)
  - [`Runninglock:`运行锁（eTS）（API8）](common/Runninglock)
  - [`Flashlight:`手电筒（JS）（API8）](common/Flashlight)
  - [`JsHelloWorld:`你好世界（JS）（API8）](common/JsHelloWorld)
  - [`PowerManager:`系统电源管理（eTS）（API8）](common/PowerManager)
- data
  - [`KvStore:`分布式数据库（eTS）（API8）](data/Kvstore)
  - [`LiteStorage:`轻量级存储（eTS）（API8）](data/LiteStorage)
  - [`Rdb:`关系型数据库（eTS）（API8）](data/Rdb)
  - [`DDMQuery:`结果集与谓词（eTS）（API8）](data/DDMQuery)
  - [`DistributedRdb:`分布式关系型数据库（eTS）（API8）](data/DistributedRdb)
- device
  - [`DeviceManager:`设备管理（eTS）（API8）](device/DeviceManager)
  - [`Sensor:`传感器（eTS）（API8）](device/Sensor)
  - [`Vibrator:`振动（eTS）（API8）](device/Vibrator)
- Graphics
  - [`JsWebGL:`WebGL(JS)（API8）](Graphics/JsWebGL)
- media
  - [`JsAudioPlayer:`音频播放和管理（JS）（API8）](media/JsAudioPlayer)
  - [`JsVideo:`视频播放（JS）（API8）](media/JsVideo)
  - [`Recorder:`录音机（eTS）（API8）](media/Recorder)
  - [`MultiMedia:`相机和媒体库（eTS）（API9）](media/MultiMedia)
  - [`VideoPlayer:`视频播放（eTS）（API9）](media/VideoPlayer)
  - [`JsRecorder:`录音机（JS）（API8）](media/JSRecorder)
- DFX
  - [`JsDotTest:`测试打点（JS）（API8）](DFX/JsDotTest)
  - [`FaultLogger:`故障日志获取（eTS）（API8）](DFX/FaultLogger)
- Telephony
  - [`Call:`拨打电话（eTS）（API8）](Telephony/Call)
  - [`Message:`短信服务（eTS）（API8）](Telephony/Message)
  - [`RadioTech:`网络搜索（eTS）（API8）](Telephony/RadioTech)
  - [`SimManager:`SIM卡管理（eTS）（API8）](Telephony/SimManager)
- thread
  - [`JsWorker:`启动一个worker（JS）（API8）](thread/JsWorker)
- CompleteApps
  - [`KikaInput:`轻量级输入法（JS）（API9）](CompleteApps/KikaInput)
  - [`AstronautsGame:`太空人避障游戏（C++）](CompleteApps/AstronautsGame)
- ETSUI
  - [`Canvas:`画布组件（eTS）（API8）](ETSUI/Canvas)
  - [`CustomComponent:`组件化（eTS）（API8）](ETSUI/CustomComponent)
  - [`Process:`进程信息（eTS）（API8）](ETSUI/Process)
  - [`BuildCommonView:`创建简单视图（eTS）（API8）](ETSUI/BuildCommonView)
  - [`DefiningPageLayoutAndConnection:`页面布局和连接（eTS）（API8）](ETSUI/DefiningPageLayoutAndConnection)
  - [`Drag:`拖拽事件（eTS）（API8）](ETSUI/Drag)
  - [`Component:`eTS组件测试Demo（eTS）（API8）](ETSUI/Component)
  - [`ArkUIAnimation:`动画（eTS）（API8）](ETSUI/ArkUIAnimation)
  - [`MediaQuery:`媒体查询（eTS）（API8）](ETSUI/MediaQuery)
  - [`XComponent:`XComponent（eTS）（API8）](ETSUI/XComponent)
  - [`MouseEvent:`鼠标事件（eTS）（API8）](ETSUI/MouseEvent)
  - [`Web:`Web（eTS）（API8）](ETSUI/Web)
  - [`Gallery:`组件集合（eTS）（API8）](ETSUI/Gallery)
  - [`BringApp:`拉起系统应用（eTS）（API8）](ETSUI/BringApp)
- FileManager
  - [`Environment:`目录环境（eTS）（API8）](FileManager/Environment)
  - [`FileIo:`文件管理（eTS）（API8）](FileManager/FileIo)
- Notification
  - [`CommonEvent:`订阅公共事件（eTS）（API8）](Notification/CommonEvent)
  - [`Emitter:`处理进程内事件（eTS）（API8）](Notification/Emitter)
  - [`AlarmClock:`后台代理提醒（eTS）（API8）](Notification/AlarmClock)
  - [`Notification:`订阅、发送通知（eTS）（API9）](Notification/Notification)
- Network
  - [`Http:`数据请求（eTS）（API8）](Network/Http)
  - [`Socket:`Socket 连接（eTS）（API8）](Network/Socket)
- Preset
  - [`Clock:`简单时钟（eTS）（API9）](Preset/Clock)
  - [`FlishLight:`手电筒（eTS）（API8）](Preset/FlishLight)
  - [`DistributeCalc:`分布式计算器（eTS）（API8）](Preset/DistributeCalc)
- ResourcesSchedule
  - [`Flybird:`小鸟避障游戏（eTS）（API9）](ResourcesSchedule/Flybird)
  - [`News:`新闻浏览（eTS）（API9）](ResourcesSchedule/News)
  - [`BackgroundTaskManager:`后台任务管理（eTS）（API8）](ResourcesSchedule/BackgroundTaskManager)
- UI
  - [`AtomicLayout:`原子布局（JS）（API8）](UI/AtomicLayout)
  - [`Badge:`事件标记控件（JS）（API8）](UI/Badge)
  - [`International:`国际化（JS）（API8）](UI/International)
  - [`JsFA:`FA示例应用（JS）（API8）](UI/JsFA)  
  - [`JsShopping:`购物示例应用（JS）（API8）](UI/JsShopping)     
  - [`JSMenu:`菜单（JS）（API8）](UI/JSMenu)
  - [`JSUICustomComponent:`自定义组件（JS）（API8）](UI/JSUICustomComponent)
  - [`JsAnimation:`动效示例应用（JS）（API8）](UI/JsAnimation)
  - [`JsAnimationStyle:`动画与自定义字体（JS）（API8）](UI/JsAnimationStyle)
  - [`JsBasicComponents:`基础组件（JS）（API8）](UI/JsBasicComponents)
  - [`JsBrightness:`设置屏幕亮度（JS）（API8）](UI/JsBrightness)
  - [`JsCanvas:`画布组件（JS）（API8）](UI/JsCanvas)
  - [`JsDevice:`设备信息（JS）（API8）](UI/JsDevice)
  - [`JsDialog:`页面弹窗（JS）（API8）](UI/JsDialog)
  - [`JsGrid:`栅格布局（JS）（API8）](UI/JsGrid)
  - [`JsList:`商品列表（JS）（API8）](UI/JsList)
  - [`JsPanel:`内容展示面板（JS）（API8）](UI/JsPanel)
  - [`JsRouter:`页面路由（JS）（API8）](UI/JsRouter)
  - [`JsSvg:`可缩放矢量图形（JS）（API8）](UI/JsSvg)
  - [`JsTimer:`定时器与系统时间设置（JS）（API8）](UI/JsTimer)
  - [`Picker:`滑动选择器（JS）（API8）](UI/Picker)
  - [`Popup:`气泡（JS）（API8）](UI/Popup)
  - [`RefreshContainer:`下拉刷新容器（JS）（API8）](UI/RefreshContainer)
  - [`Slider:`滑动条（JS）（API8）](UI/Slider)
  - [`Stack:`堆叠容器（JS）（API8）](UI/Stack)
  - [`StepNavigator:`步骤导航器（JS）（API8）](UI/StepNavigator)
  - [`Swiper:`内容滑动容器（JS）（API8）](UI/Swiper)
  - [`Tabs:`页签容器（JS）（API8）](UI/Tabs)
  - [`Toolbar:`工具栏（JS）（API8）](UI/Toolbar)
  - [`chart:`图表组件（JS）（API8）](UI/chart)
  - [`JsAdaptivePortalList:`多设备自适应的效率型首页（JS）（API8）](UI/JsAdaptivePortalList)
  - [`JsAdaptivePortalPage:`多设备自适应的FA页面（JS）（API8）](UI/JsAdaptivePortalPage)
  - [`JsImage:`基本动画（JS）（API8）](UI/JsImage)
  - [`JsGallery:`图库示例应用（JS）（API8）](UI/JsGallery)
  - [`JSComponments:`Js组件（JS）（API8）](UI/JSComponments)
  - [`JsUserRegistration:`用户注册（JS）（API8）](UI/JsUserRegistration)
- Util
  - [`UtilBase64Codec:`Base64编解码（eTS）（API8）](Util/UtilBase64Codec)
  - [`UtilScope:`范围判断（eTS）（API8）](Util/UtilScope)
  - [`UtilStringCodec:`字符串编解码（eTS）（API8）](Util/UtilStringCodec)
  - [`UtilLruBuffer:`缓冲区（eTS）（API8）](Util/UtilLruBuffer)
  - [`UtilRationalNumber:`有理数（eTS）（API8）](Util/UtilRationalNumber)
  - [`UtilTypeCheck:`内置对象类型检查（eTS）（API8）](Util/UtilTypeCheck)
  - [`UtilUrlString:`URL字符串解析（eTS）（API8）](Util/UtilUrlString)
  - [`XmlTextConvert:`xml文本转换（eTS）（API8）](Util/XmlTextConvert)

## 使用说明<a name="section17988202503116"></a>

1.  将独立的应用示例工程导入DevEco Studio进行编译构建及运行调试。
2.  部分应用示例中含有多个模块，开发者可以选择对单个模块进行编译构建，生成一个HAP应用安装包，也可以对整个工程进行编译构建，生成多个HAP应用安装包。
3.  安装运行后，即可在设备上查看应用示例运行效果，以及进行相关调试。

## 约束与限制<a name="section18841871178"></a>

​        安装应用示例之前，请先查看"README_zh.md"文件来确认应用示例是否为stage模型，若为stage模型需要查看entry/src/main路径下的module.json5文件中的"deviceType"字段来确认该应用支持的设备类型；否则为FA模型，查看entry/src/main路径下的config.json文件中的"deviceType"字段来确认该应用示例支持的设备类型，两种模型都可尝试通过修改该字段使其可以在相应类型的设备上运行。