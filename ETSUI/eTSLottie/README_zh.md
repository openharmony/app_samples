# Lottie功能展示

### 简介

本示例展示了Lottie组件的功能，依赖于Canvas与RenderingContext来配合使用。

### 使用说明

1.点击load ui-clean,加载ui-clean动画。点击load-clock按钮，加载clock动画。点击Debug按钮，控制台打印loadAnimation接口的返回对象。
2.lottie-control-All(控制所有动画)：按钮togglePause控制动画暂停和播放，stop：停止（从第一帧），pause：暂停，play：播放，setSpeed：播放速度，direction：方向，destroy:销毁动画。

3.lottie-ui-clean(控制ui-clean)：按钮togglePause控制所有动画暂停和播放，stop：停止（从第一帧），pause：暂停，play：播放，setSpeed：播放速度，direction：方向。

4.AnimationItem-common(AnimationItem的接口控制ui-clean动画)：按钮togglePause控制动画暂停和播放，stop：停止（从第一帧），pause：暂停，play：播放，setSpeed：播放速度，direction：方向，destroy:销毁动画。

5.AnimationItem-Segments(控制动画(ui-clean)播放片段):按钮playSegments:设置动画仅播放指定片段,resetSegments:重置动画播放片段，播放全帧。setSubframe:设置属性currentFrame的精度显示浮点数。

6.AnimationItem-goToPlay/Stop:按钮ToStop(250):设置动画停止在250帧,ToStop(5000):设置动画停止在5000帧,ToPlay(250):设置动画在250帧开始播放,ToPlay(12000):设置动画在12000帧开始播放。

7.AnimationItem-resize/destroy(ui-clean):按钮resize:刷新动画布局。AnimationItem-destroy:销毁动画。lottie-destroy:销毁动画.

8.AnimationItem-event:按钮addEvent:添加侦听事件,点击控制台打印相应的回调函数返回值EventListener。delEvent:删除指定动画的监听。trigEvent:触发相应的监听的回调函数。delAllEvent:删除所有的监听事件。

### 约束与限制
本示例仅支持在标准系统上运行。
