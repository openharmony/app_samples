# 访问权限控制

### 概要简介

本示例通过模拟应用申请权限场景，向用户展示`@ohos.abilityAccessCtrl`接口。具体实现效果如下图：

![](screenshots/device/main.png) ![](screenshots/device/dialog.png)

### 相关概念

程序访问控制管理：程序访问控制提供程序的权限管理能力，包括鉴权、授权和取消授权等。

### 相关权限

获取应用敏感权限: ohos.permission.GET_SENSITIVE_PERMISSIONS,

撤销应用敏感权限: ohos.permission.REVOKE_SENSITIVE_PERMISSIONS,

为其他应用授予敏感权限: ohos.permission.GRANT_SENSITIVE_PERMISSIONS,

查询其他应用的信息: ohos.permission.GET_BUNDLE_INFO_PRIVILEGED,

查询其他应用的信息: ohos.permission.GET_BUNDLE_INFO,

麦克风权限: ohos.permission.MICROPHONE,

### 使用说明

1.打开应用，页面出现弹窗，点击 **取消** 按钮。

2.页面跳转显示 **检测权限** 按钮，点击检测权限，出现提示信息“权限未授予”。

3.关闭应用再次打开，页面出现弹窗，点击 **确认** 按钮。

4.页面跳转显示 **检测权限** 按钮，点击**检测权限** 按钮，出现提示信息“权限已授予”。

5.关闭应用再次打开，页面不出现弹窗，点击 **检测权限** 按钮，点击检测权限，出现提示信息“权限已授予”。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.工程编译前需要先执行Make Module 'entry'。

3.本示例涉及使用系统接口：grantUserGrantedPermission()，需要手动替换Full SDK才能编译通过，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md)。

4.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。

5.本示例所配置的权限ohos.permission.GET_SENSITIVE_PERMISSIONS、ohos.permission.REVOKE_SENSITIVE_PERMISSIONS、ohos.permission.GRANT_SENSITIVE_PERMISSIONS为system_core级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)查看)，需要手动配置对应级别的权限签名(具体操作可查看[自动化签名方案](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/ohos-auto-configuring-signature-information-0000001271659465))。