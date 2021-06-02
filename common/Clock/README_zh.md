# 简单时钟<a name="ZH-CN_TOPIC_0000001160407657"></a>

-   本示例使用JS UI能力实现一个简单的时钟应用，通过setInterval实现周期性实时刷新时间。

    transform：css的动画样式，可以设置平移/旋转/缩放的属性。时钟的指针使用rotate设置x轴和y轴两个维度参数，rotate可以传入具体角度值。指针旋转角度通过计算得出。

    例如："transform : rotate\(\{\{ second \* 6 \}\}deg\)", 秒针1秒转动6度。
