# 线程间通信<a name="ZH-CN_TOPIC_0000001127136651"></a>

-   EventHandler 的主要功能是将 InnerEvent 事件或者 Runnable 任务投递到其他的线程进行处理;

    EventRunner 的工作模式可以分为托管模式和手动模式。两种模式是在调用 EventRunner 的 create\(\) 方法时，通过选择不同的参数来实现的。
