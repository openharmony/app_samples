# 应用示例<a name="ZH-CN_TOPIC_0000001115464207"></a>

-   [概要简介](#section1470103520301)
-   [使用说明](#section17988202503116)
-   [约束与限制](#section18841871178)
-   [相关仓](#section741114082513)
-   [许可证](#section5315468537)

## 概要简介<a name="section1470103520301"></a>

为帮助开发者快速熟悉OpenHarmony SDK所提供的API和应用开发流程，OpenHarmony提供了一系列的应用示例，即Sample。每一个应用示例都是一个独立的DevEco Studio工程项目，开发者可以将工程导入到DevEco Studio开发工具，通过浏览代码、编译工程、安装和运行应用示例来了解应用示例中涉及API的使用方法。

## 使用说明<a name="section17988202503116"></a>

1.  将独立的应用示例工程导入DevEco Studio进行编译构建及运行调试，具体使用可参考[DevEco Studio使用说明](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/tools_overview-0000001053582387)。
2.  部分应用示例中含有多个模块，开发者可以选择对单个模块进行编译构建，生成一个HAP应用安装包，也可以对整个工程进行编译构建，生成多个HAP应用安装包。
3.  安装运行后，即可在设备上查看应用示例运行效果，以及进行相关调试。

## 约束与限制<a name="section18841871178"></a>

1.  安装运行应用示例之前，请先通过config.json文件中的"deviceType"字段来确认该应用示例支持的设备类型，可尝试通过修改该字段使其可以在相应类型的设备上运行（config.json文件一般在代码的entry/src/main路径下，不同的Sample可能会有不同）。
2.  以下路径下的应用示例支持在**标准系统**（参考内存≥128MiB）上运行，其余应用示例仅支持在**大型系统**（参考内存≥1GiB）上运行。
    -   common/Clock
    -   common/JsHelloWorld


## 相关仓<a name="section741114082513"></a>

1.  CAMERA\_SAMPLE\_APP组件的应用示例：[applications\_sample\_camera](https://gitee.com/openharmony/applications_sample_camera/blob/master/README_zh.md)
2.  WIFI\_IOT\_APP组件的应用示例：[applications\_sample\_wifi\_iot](https://gitee.com/openharmony/applications_sample_wifi_iot/blob/master/README_zh.md)



