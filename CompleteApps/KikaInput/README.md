# kikainput

## 简介
kikainput是一个轻量级的输入法应用，支持在运行OpenHarmony OS的智能终端上。
## 目录

```
├─entry
│  │  .gitignore
│  │  build.gradle
│  │  package.json
│  │  proguard-rules.pro
│  │
│  └─src
│      └─main
│          │  config.json                              #项目配置文件
│          │
│          ├─js
│          │  └─default
│          │      │  app.js                            
│          │      │
│          │      ├─common
│          │      │  └─images
│          │      │          bg-tv.jpg
│          │      │          delete.png
│          │      │          down.png
│          │      │          return.png
│          │      │          shift light long.png
│          │      │          shift light.png
│          │      │          shift.png
│          │      │          Wallpaper.png
│          │      │
│          │      ├─i18n
│          │      │      en-US.json
│          │      │      zh-CN.json
│          │      │
│          │      └─pages
│          │          ├─index
│          │          │      index.css				    #项目样式文件
│          │          │      index.hml                  #项目view文件   
│          │          │      index.js                   #项目逻辑页面
│          │          │
│          │          └─second
│          │                  second.css
│          │                  second.hml
│          │                  second.js
│          │
│          └─resources
│              └─base
│                  ├─element
│                  │      string.json
│                  │
│                  └─media
│                          icon.png

```

## 使用场景
**支持语言:** JavaScript
**操作系统限制:** OpenHarmony操作系统
## 开发步骤
**1.样式布局，以及逻辑修改**

找到pages文件夹中的index文件夹。在.hml .css文件中进行样式的修改,在.js文件中进行逻辑的修改。

**2.配置签名文件然后进行打包**

配置签名文件可以参照:[https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/%E9%85%8D%E7%BD%AEOpenHarmony%E5%BA%94%E7%94%A8%E7%AD%BE%E5%90%8D%E4%BF%A1%E6%81%AF.md]()

**3.把生产的签名文件上传到开发板上进行调试**

具体操作可参照：[https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/%E5%AE%89%E8%A3%85%E8%BF%90%E8%A1%8COpenHarmony%E5%BA%94%E7%94%A8.md]()

