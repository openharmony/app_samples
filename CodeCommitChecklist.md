## 代码提交规范

1. 所有文件，包括自动生成的编译文件package.json都要格式化；
2. 函数命名，C++大驼峰，TS、JS小驼峰，方法命名注意动宾结构；
3. 变量命名，必须见名知意，ArrayList类型直接按复数表示，不要带list；
4. 函数参数命名，要规范化，见名知意；
5. if语句后必须跟“{”，哪怕只有一行代码；
6. 有break或return的条件，先break或return再走其他的逻辑；
7. 条件判断，当一个分支达成条件时及时返回，不需要再走其他分支；
8. 代码中避免出现魔鬼数字，需补上注释，或者用符合语义的名词常量代替，如下：
```ts
  // One minute has 60 seconds.
  let time = 60

  const ONE_MINUTE = 60
  let time = ONE_MINUTE
```
9. 字符串拼接使用模板字符串；
10. 组件使用，除了宽高属性可以在一行，其他的属性必须换行；
11. TS、JS中统一不带";"符号；
12. 字符串和图片资源等的使用，支持"$r"使用的，全部使用"$r"引用；
13. 新增文件注意开源协议、版权检查；
14. 截图要使用真机效果图；
15. readme中使用“.”，不要用“、”，检查错别字；
16. 异步方法中需要返回方法的返回值，不用声明变量，直接return，如下：
```ts
  return await this.mediaTest.getFileAssets(fetchOp)
```
17. 方法中的参数需要类型声明；
18. import 文件顺序，同类型放一起；
19. string.json中description要写简要描述，zh下要用中文；
20. TS、JS语言缩进为2格，C++语言缩进为4格；
21. 涉及应用截图时，图片不能包含人物、关键信息、网络等有侵权风险的资源；
22. 工程中不要配置签名信息；
23. 规范日志格式，统一用[Sample_包名]开头，如时钟日志，使用[Sample_Clock]；
24. 注释“//”后要加一个空格；如果注释跟在代码后面，则“//”前要加一个空格；
```ts
  // 正确示例
  let a = 10

  let a = 10 // 正确示例
```
25. 代码中避免出现中文字符，要使用资源代替，符合国际化开发标准；


## 工程结构规范

Sample工程，应该区分开UI、业务逻辑、数据模块，工程示例结构如下：

```
main
|---Application // 应用级逻辑
|---MainAbility // 元能力组件
|---feature // 业务功能
|   |---IndexFeature.ts // Index的业务逻辑代码
|---pages // UI页面
|   |---Index.ets // Index的UI界面代码
|---model // 数据
|   |---IndexData.ts // Index数据模型
|---mock // Mock数据
|   |---MockIndexData.ts // IndexData的mock数据
|---net // 网络
|   |---IndexApi.ts // 网络接口
```

## PR提交格式规范

示例如下：

```
IssueNo: #I56EH7:【MR】支持窗口属性设置
Description: set wake up screen.
Sig: SIG_Sample
Feature or Bugfix: Bugfix
Binary Source: No

Signed-off-by: jiangwensai <jiangwensai@huawei.com>
```

1. IssueNo管理issue信息；
2. Description描述修改变更内容；
3. Sig统一使用SIG_Sample；
4. Feature or Bugfix，如果是需求选择Feature，问题选择Bugfix；
5. Signed-off-by，注明开发者账号和邮箱；
	
## ReadMe编写规范

1. 标题：以特性名称命名；
2. 介绍：

	2.1 介绍sample的具体功能;

	2.2 需要介绍本sample的主要实现原理，如使用了什么API、有什么关键性的配置和实现等等；

	2.3 介绍应用的使用说明，具体的操作步骤和用法信息；

3. 效果预览：屏幕截屏或者视频，文件不超过4个；
4. 相关权限：介绍应用的使用权限，附上链接；
5. 依赖： 介绍对其他sample的依赖，附上sample链接；
6. 约束与限制：

	6.1 支持应用运行的操作系统版本和设备，示例如下：

		本示例仅支持标准系统上运行，支持设备：RK3568;

	6.2 API版本、SDK版本（如果依赖Full SDK，附上替换链接），示例如下：

		本示例进支持APIXX版本SDK，版本号：3.X.X.X；（如果涉及Full SDK还需加上：本涉及涉及使用系统接口：XXX，需要手动替换Full SDK才能编译通过，具体操作可参考[替换指南]。）

	6.3 支持的IDE版本，示例如下：

		本示例需要使用DevEco Studio 3.0 Beta3 (Build Version: 3.0.0.901, built on May 30, 2022)版本进行编译；

	6.4 高等级APL特殊签名说明，示例如下：

		本示例涉及[相关权限]为system_basic(或者system_core)级别（相关权限级别可通过[权限定义列表]查看），需要配置高权限签名，可参考[特殊权限配置方法]；

## UI自动化用例编写规范

1. 用例命名规范为：“包名_测试类名_序号”，如“MyApp_Index_001”;
2. 用例的开头和结尾都需要有日志打印，打印必须包括用例名称的关键字，示例：
```ts
  console.info("MyApp_Index_001, begin")
  ...
  console.info("MyApp_Index_001, end")
```
3. 用例中每条断言语句前必须添加日志，打印参数信息；
