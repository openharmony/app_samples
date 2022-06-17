# 日志打印

## 简介

提供日志打印类，并将日志信息保存至应用安装目录下。

## 导入接口

```
    import logger from '@ohos/log'
    import { LogLevel } from '@ohos/log'
    import { Configure }  from '@ohos/log'
```

## 接口说明

1. configure参数设置

```
  Configure = {
    cheese: {
        types: string[],
        filename: string
    }
    defaults: {
        appenders: string,
        level: LogLevel
    }
  } 
  //types为file时将日志输出保存到以filename参数命名的文件中；appenders为日志打印tag；level为打印日志文件的最低等级
```

2. logger类初始化

```
   logger.setConfigure(configure： Configure)
   //configure为配置参数
```

3. debug类型打印日志

```
   logger.debug(value) 
   //value为打印日志内容
```

4. info类型打印日志

```
   logger.info(value) 
   //value为打印日志内容
```

5. warn类型打印日志

```
   logger.warn(value) 
   //value为打印日志内容
```

6. error类型打印日志

```
   logger.error(value) 
   //value为打印日志内容
```

7. fatal类型打印日志

```
   logger.fatal(value, bool) 
   //value为打印日志内容
```

## 兼容性

1.支持 OpenHarmony API version 8 及以上版本。

2.本示例需要使用3.0.0.901及以上的DevEco Studio版本才可编译运行。