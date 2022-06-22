# 动画

### 简介

本示例通过点击按钮触发动画，向用户展示`@ohos.animator`接口的动画的效果。效果图如下：
![](screenshots/device/main.gif)

### 相关概念

- [动画](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-animator.md)：Animator类。

### 相关权限

不涉及

### 使用说明

1.点击屏幕下方的播放按钮按钮变为暂停，太阳图片先升后降移动从页面左端移动至右端，月亮图片先降后升从页面右端移动至左端。

2.播放过程中点击停止按钮，动画播放结束，图片回归至初始位置。

3.点击暂停按钮，动画播放中止，再次点击播放按钮，页面动画继续播放。

4.点击反向播放按钮，动画播放方向相反，但是播放顺序不变。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.`@ohos.animator`库目前仅支持类web方式调用，ets暂不支持。

3.本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)才可编译运行。