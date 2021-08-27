# PageAbility<a name="ZH-CN_TOPIC_0000001126997465"></a>

### 简介

Page 模板的 Ability，用于提供与用户交互的能力。一个 Page 可以由一个或多个 AbilitySlice 构成，AbilitySlice 是指应用的单个页面及其控制逻辑的总和。跨设备迁移支持将 Page 在同一用户的不同设备间迁移，以便支持用户无缝切换的诉求。

### 使用说明

1.点击“Ability Slice Navigation”，启动FirstAbility。

​        a.点击“First Ability Second Slice”,页面跳转至FirstAbility的Second Slice。

​        b.点击“Second Ability Second Slice”,启动SecondAbility的Second Slice。

​        c.点击“Second Ability”,启动SecondAbility.

​        d.点击“Back”，返回上一个界面。

2.两台设备A和B，组网条件下。

​         a.点击设备A的“Ability Continuation”,启动Continuation Ability。

​         b.在输入框中任意输入文本内容。

​         c.点击“Continue Ability”，将输入框中的内容迁移到设备B。

### 约束与限制

本示例仅支持在大型系统上运行。
