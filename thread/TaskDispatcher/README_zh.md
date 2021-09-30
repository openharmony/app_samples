# 线程管理<a name="ZH-CN_TOPIC_0000001080471862"></a>

### 简介

如果应用的业务逻辑比较复杂，可能需要创建多个线程来执行多个任务。

这种情况下，代码复杂难以维护，任务与线程的交互也会更加繁杂，要解决此问题，开发者可以使 TaskDispatcher 来分发不同的任务。

### 使用说明

1.点击“Sync Dispatch”，同步派发任务

2.点击“Async Dispatch”，异步分派任务

3.点击“Delay Dispatch”，异步延迟发送任务

4.点击“Dispatch Group”，任务组

5.点击“Revoke Task”，取消任务

6.点击“Sync Dispatch Barrier”，同步设置屏障任务

7.点击“Async Dispatch Barrier”，异步设置屏障任务

8.点击“Apply Dispatch”，执行多次任务

### 约束与限制

本示例仅支持在大型系统上运行。
