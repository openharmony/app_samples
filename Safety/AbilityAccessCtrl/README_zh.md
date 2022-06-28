# 访问权限控制

### 概要简介

本示例通过模拟应用申请权限场景，向用户展示`@ohos.abilityAccessCtrl`接口，具体实现效果如下图。

![](screenshot/devices/main.png)
![](screenshot/devices/dialog.png)

### 相关权限

[权限检测](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-abilityAccessCtrl.md#verifyaccesstoken)：查询权限是否被被授予。

[权限授予](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-abilityAccessCtrl.md#grantusergrantedpermission)：授予应用 user grant 权限。


### 相关权限

本示例需要在 module.json5 中配置如下权限：

```json
"reqPermissions": [
      {
        "name": "ohos.permission.GET_SENSITIVE_PERMISSIONS",
        "reason": "$string:MainAbility_desc",
        "usedScene": {
          "ability": [
            "ohos.samples.abilityaccessctrl.MainAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.REVOKE_SENSITIVE_PERMISSIONS",
        "reason": "$string:MainAbility_desc",
        "usedScene": {
          "ability": [
            "ohos.samples.abilityaccessctrl.MainAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.GRANT_SENSITIVE_PERMISSIONS",
        "reason": "$string:MainAbility_desc",
        "usedScene": {
          "ability": [
            "ohos.samples.abilityaccessctrl.MainAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.GET_BUNDLE_INFO_PRIVILEGED",
        "reason": "$string:MainAbility_desc",
        "usedScene": {
          "ability": [
            "ohos.samples.abilityaccessctrl.MainAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.GET_BUNDLE_INFO",
        "reason": "$string:MainAbility_desc",
        "usedScene": {
          "ability": [
            "ohos.samples.abilityaccessctrl.MainAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.MICROPHONE",
        "reason": "$string:MainAbility_desc",
        "usedScene": {
          "ability": [
            "ohos.samples.abilityaccessctrl.MainAbility"
          ],
          "when": "inuse"
        }
      }
    ]
```

### 使用说明

1.打开应用，页面出现弹窗，点击 **取消** 按钮。

2.页面跳转显示 **检测权限** 按钮，点击检测权限，出现提示信息“权限未授予”。

3.关闭应用再次打开，页面出现弹窗，点击 **确认** 按钮。

4.页面跳转显示 **检测权限** 按钮，点击**检测权限** 按钮，出现提示信息“权限已授予”。

5.关闭应用再次打开，页面不出现弹窗，点击 **检测权限** 按钮，点击检测权限，出现提示信息“权限已授予”。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.工程编译前需要先执行Make Module 'entry'。

3.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。