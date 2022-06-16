# 媒体服务-图片处理

### 简介

本示例仿照相册应用，读取本地设备中图片，获取图片信息，可对图片进行旋转操作。效果图如下：
![](screenshots/devices/index.png)
![](screenshots/devices/image.png)

### 相关概念

- [图片处理](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-image.md)：对PixelMap读写、获取信息等操作。

### 相关权限

    "reqPermissions": [
      {
        "name": "ohos.permission.MEDIA_LOCATION",
        "reason": "$string:description_mainability",
        "usedScene": {
          "ability": [
            "ohos.samples.image.MainAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.READ_MEDIA",
        "reason": "$string:description_mainability",
        "usedScene": {
          "ability": [
            "ohos.samples.image.MainAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.WRITE_MEDIA",
        "reason": "$string:description_mainability",
        "usedScene": {
          "ability": [
            "ohos.samples.image.MainAbility"
          ],
          "when": "inuse"
        }
      }
    ]

### 使用说明

1.点击主页下任意图片，跳转图片详情界面。

2.点击左上角方**细节**按钮，弹窗显示图片的大小、名称、路径信息。

3.点击**旋转**按钮，滑动进度条选择旋转度数，点击**保存**按钮，将旋转后图片保存至本地。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本实例读取本机设备图片，需要设备中有至少一张图片文件。

3.本示例需要使用3.0.0.901及以上的DevEco Studio版本才可编译运行.

