# Log

## Introduction

This sample shows how to use log APIs to print log information and save the information to the application installation directory.

## APIs

```
    import logger from '@ohos/log'
    import { LogLevel } from '@ohos/log'
    import { Configure }  from '@ohos/log'
```

## Usage Instruction

1. Configure log printing parameters.

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
  // If types is set to file, logs are saved to the file named by filename. appenders indicates the log tag, and level indicates the lowest log level.
```

2. Initialize a **logger** instance.

```
   logger.setConfigure(configure: Configure)
   // configure indicates the parameter configuration.
```

3. Print log information of the debug level.

```
   logger.debug(value) 
   // value indicates the log content.
```

4. Print log information of the info level.

```
   logger.info(value) 
   // value indicates the log content.
```

5. Print log information of the warn level.

```
   logger.warn(value) 
   // value indicates the log content.
```

6. Print log information of the error level.

```
   logger.error(value) 
   // value indicates the log content.
```

7. Print log information of the fatal level.

```
   logger.fatal(value, bool) 
   // value indicates the log content.
```

## Constraints

1. This sample requires API version 8 or later.

2. The DevEco Studio version used in this sample must be 3.0.0.900 or later.
