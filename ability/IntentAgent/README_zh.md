# IntentAgent<a name="ZH-CN_TOPIC_0000001127136355"></a>

-   IntentAgent 封装了一个指定行为的 Intent，可以通过 triggerIntentAgent 接口主动触发，也可以与通知绑定被动触发。

    具体的行为包括：启动 Ability 和发送公共事件。例如：收到通知后，在点击通知后跳转到一个新的 Ability，不点击则不会触发
