# App Samples<a name="EN-US_TOPIC_0000001115464207"></a>

-   [Introduction](#section1470103520301)
-   [Usage](#section17988202503116)
-   [Limitations](#section18841871178)
-   [Repositories Involved](#section741114082513)
-   [Licensing](#section5315468537)

## Introduction<a name="section1470103520301"></a>

OpenHarmony provides a series of app samples to help you quickly get familiar with the APIs and app development process of the OpenHarmony SDK. Each app sample is an independent project in DevEco Studio. You can import a project into DevEco Studio to learn how to use APIs in the sample by browsing code, building the project, and installing and running the app.

## Usage<a name="section17988202503116"></a>

1.  Import an independent app sample project into DevEco Studio for compilation, building, running, and debugging. For details, see  [HUAWEI DevEco Studio User Guide](https://developer.harmonyos.com/en/docs/documentation/doc-guides/tools_overview-0000001053582387).
2.  Some samples contain multiple modules. You can compile and build a single module to generate a HAP file or compile and build the entire project to generate multiple HAP files.
3.  After HAP installation and execution, you can view the execution effect of the sample on the device and then conduct debugging.

## Limitations<a name="section18841871178"></a>

1.  Before installing and running the sample, check the  **deviceType**  field in the  **config.json**  file to obtain the device types supported by the sample. You can modify this field to enable the sample to run on your target device. \(The  **config.json**  file is generally stored in the  **entry/src/main**  directory, which may be different depending on the samples.\)
2.  App samples in the following directories can run on the standard system \(reference memory ≥ 128 MiB\). Other app examples can run only on the large system \(reference memory ≥ 1 GiB\):
    -   common/Clock
    -   common/JsHelloWorld


## Repositories Involved<a name="section741114082513"></a>

1.  [applications\_sample\_camera](https://gitee.com/openharmony/applications_sample_camera/blob/master/README.md)
2.  [applications\_sample\_wifi\_iot](https://gitee.com/openharmony/applications_sample_wifi_iot/blob/master/README.md)
