# JS 启动模态配置<a name="ZH-CN_TOPIC_0000001080439964"></a>

-   本示例主要演示 JS UI 框架提供半模态和弹窗模态的启动方式。

    使用半模态 FA 或者弹窗模态 FA 时，对应的 ability 在 config.json 中配置相关透明主题并通过设置相应的 window\_modal 参数来使能相应的启动模态。

    window\_modal 参数可以通过调用在 startAbility 时在 intent 对象中进行设置，也可以在应用本身的 ability 类的 onStart 方法中进行设置。
