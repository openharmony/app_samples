# Intent启动Ability<a name="ZH-CN_TOPIC_0000001127379103"></a>

-   Intent 是对象之间传递信息的载体。例如，当一个 Ability 需要启动另一个 Ability 时，或者一个 AbilitySlice 需要导航到另一个 AbilitySlice 时，可以通过 Intent 指定启动的目标同时携带相关数据。

    本示例通过Ability的全称和Operation的其他属性（不明确指定启动哪个 Ability ，而是设置 Action ，让系统来筛选出合适的 Ability）实现界面跳转以及数据传递。
