# **分布式搜索**

##### 简介

​    本sample使用Java语言开发，通过搜索本地的图片，音频及视频文件，并加入到分布式文件系统中，实现文件快速共享。用户可以通过输入关键字搜索到分布式文件系统中的所有文件。

##### 使用说明

1. 搜索
	输入框输入关键字，可以通过输入框后面的搜索按钮进行搜索，也可以通过选择类型进行对应类别的搜索。
2. 结果显示
	搜索完后，数据将以列表的形式显示在显示区域。
	点击每行可以查看到文件的具体路径。
	如果没有搜索到文件，则显示无搜索结果的界面。
3. 分布式设备查看
	点击主界面右下角的设备按钮，可以查看到当前已经加入到分布式系统的设备情况。

##### 约束与限制

1. 编译约束
   已实名认证的开发者联盟账号 ，具体[参考](https://developer.huawei.com/consumer/cn/ )
   开发工具：DevEcoStudio下载地址 [HUAWEI DevEco Studio - HarmonyOS应用开发官网](https://developer.harmonyos.com/cn/develop/deveco-studio#download) 

   •安装DevEco Studio 

   设置DevEco Studio开发环境，DevEco Studio开发环境需要连接到网络，以确保该正常使用。
   可以根据以下两种情况配置开发环境：
           1).如果您可以直接访问Internet，则只需下载HarmonyOS SDK 
           2).如果网络无法直接访问Internet，则可以通过代理服务器进行访问 • 生成密钥并申请证书 

   具体环境搭建请[参考：](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/installation_process-0000001071425528) 
   更多资料请登录HarmonyOS应用开发[官网:](https://developer.harmonyos.com/cn/)
   
2. 使用限制
   •该应用必须要有两部或以上同一组网内的手机
   •多手机必须登录同一用户
   •暂时只支持外部SD卡中的图片，音频以及视频文件的搜索

