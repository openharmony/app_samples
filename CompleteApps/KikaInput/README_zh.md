# 轻量级输入法

## 简介
kikainput是一个轻量级的输入法应用，支持在运行OpenHarmony OS的智能终端上。
## 目录

```
├─AppScope
│  │  app.json5                                        #应用配置文件
│  └─resources
│      └─base
│          ├─element
│          │      string.json
│          │
│          └─media
│                 app_icon.png
│
├─entry
│  │  .gitignore
│  │  build-profile.json5
│  │  hvigorfile.js
│  │  package.json
│  │
│  └─src
│      └─main
│          │  module.json5                             #项目配置文件
│          │
│          ├─ets
│          │   ├─Application
│          │   │     │  AbilityStage.ts
│          │   │
│          │   ├─model
│          │   │     │  HardKeyUtils.ets
│          │   │     │  KeyboardController.ets
│          │   │     │  KeyboardKeyData.ets
│          │   │
│          │   ├─pages
│          │   │    └─service
│          │   │        └─pages
│          │   │            │  index.ets
│          │   │
│          │   ├─ServiceExtAbility
│          │   │     │  service.ts
│          │   │     │  ServiceExtAbility.ts
│          │   │
│          │   └─test
│          │       │  Ability.test.ets
│          │       │  List.test.ets
│          │
│          └─resources
│              ├─base
│              │   ├─element
│              │   │      string.json
│              │   │
│              │   ├─media
│              │   │        icon.png
│              │   │
│              │   └─profile
│              │           main_pages.json
│              └─rawfile
│                  │    delete.png
│                  │    down.png
│                  │    return.png
│                  │    shift.png
│                  │    shift light.png
│                  │    shift light long.png

```

## 使用场景
**支持语言:** JavaScript

**操作系统限制:** OpenHarmony操作系统

**模型限制:** Stage模型
## 开发步骤
**1.样式布局，以及逻辑修改**

找到pages/service/pages/index.ets文件进行布局修改。

找到model/KeyboardController.ets文件进行逻辑修改。

**2.配置签名文件然后进行打包**

配置签名文件可以参照:[https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/hapsigntool-guidelines.md]

