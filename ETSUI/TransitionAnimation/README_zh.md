# 转场动画

### 简介

本示例展示了转场动画的使用，包括页面间转场、组件内转场和共享元素转场。实现效果如下：

![](screenshots/devices/home.gif)

### 相关概念

- [页面间转场](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-page-transition-animation.md)：页面转场通过在全局pageTransition方法内配置页面入场组件和页面退场组件来自定义页面转场动效。
- [组件内转场](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-transition-animation-component.md)：组件转场主要通过transition属性进行配置转场参数，在组件插入和删除时进行过渡动效，主要用于容器组件子组件插入删除时提升用户体验。
- [共享元素转场](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-transition-animation-shared-elements.md)：在组件中通过sharedTransition方法设置共享元素转场，两个页面的组件配置为同一个id，则转场过程中会进行共享元素转场，配置为空字符串时不会有共享元素转场效果。
### 相关权限

不涉及

### 使用说明

1.点击**页面间转场：底部滑入**，进入新的页面，页面转场动画为从底部滑入，退出页面时向底部滑出。

2.点击**页面间转场：自定义1**，进入新的页面，入场时透明度从0.2到1，x、y轴缩放从0变化到1，页面退出时，x轴的偏移量为500，x,y轴缩放从1变化到0。

3.点击**页面间转场：自定义2**，进入新的页面，入场时旋转并从0放大到1，透明度从0到1，页面退出时，旋转并从1缩小到0，透明度从1到0。

4.点击**组件内转场**，进入新的页面，点击**显示**，出现组件出场动画，动画完成组件显示，点击**隐藏**，组件会隐藏，并显示隐藏动画。

5.点击**共享元素转场**，进入新的页面，点击界面的图片会到大图页面，页面出场和退场有共享元素转场动画。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例为stage模型，从API version 9开始支持。

3.本示例需要使用3.0.0.901及以上的DevEco Studio版本才可编译运行。