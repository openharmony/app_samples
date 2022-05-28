/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import fileIo from '@ohos.fileio'
import { Configure } from './Configure'
import { LogLevel } from './LogLevel'
import { LoggerModel } from './LoggerModel'
import featureAbility from '@ohos.ability.featureAbility'

interface ILoggerStrategy {
    debug(message: string): void

    info(message: string): void

    warn(message: string): void

    error(message: string): void

    fatal(message: string): void
}

class ConsoleLoggerStrategy implements ILoggerStrategy {
    private configure?: Configure

    constructor(configure: Configure) {
        this.configure = configure
    }

    public debug(message: string): void {
        console.debug(`[DEBUG] ${this.configure.defaults.appenders}, ${message}`)
    }

    public info(message: string): void {
        console.info(`[INFO] ${this.configure.defaults.appenders}, ${message}`)
    }

    public warn(message: string): void {
        console.warn(`[WARN] ${this.configure.defaults.appenders}, ${message}`)
    }

    public error(message: string): void {
        console.error(`[ERROR] ${this.configure.defaults.appenders}, ${message}`)
    }

    public fatal(message: string): void {
        console.log(`[Log] ${this.configure.defaults.appenders}, ${message}`)
    }
}

class HilogLoggerStrategy implements ILoggerStrategy {
    private configure?: Configure
    private loggerModel?: LoggerModel

    constructor(configure: Configure) {
        this.configure = configure
        this.loggerModel = new LoggerModel(`${configure.defaults.appenders}`)
    }

    public debug(message: string): void {
        this.loggerModel.debug(`[DEBUG] ${this.configure.defaults.appenders} - `, `${message}`)
    }

    public info(message: string): void {
        this.loggerModel.info(`[INFO] ${this.configure.defaults.appenders} - `, `${message}`)
    }

    public warn(message: string): void {
        this.loggerModel.warn(`[WARN] ${this.configure.defaults.appenders} - `, `${message}`)
    }

    public error(message: string): void {
        this.loggerModel.error(`[ERROR] ${this.configure.defaults.appenders} - `, `${message}`)
    }

    public fatal(message: string): void {
        this.loggerModel.fatal(`[FATAL] ${this.configure.defaults.appenders} - `, `${message}`)
    }
}

class FileLoggerStrategy implements ILoggerStrategy {
    private fd: number = 0
    private configure?: Configure

    constructor(configure: Configure) {
        // 初始化文件
        this.configure = configure
        let context = featureAbility.getContext()
        context.getFilesDir().then((e) => {
            let path = e
            let result = `${path}/${configure.cheese.filename}`
            this.fd = fileIo.openSync(result, 0o2 | 0o100, 0o666)
        })
    }

    public debug(message: string): void {
        this.writeFile(`[DEBUG] ${this.configure.defaults.appenders}, ${message}`)
    }

    public info(message: string): void {
        this.writeFile(`[INFO] ${this.configure.defaults.appenders}, ${message}`)
    }

    public warn(message: string): void {
        this.writeFile(`[WARN] ${this.configure.defaults.appenders}, ${message}`)
    }

    public error(message: string): void {
        this.writeFile(`[ERROR] ${this.configure.defaults.appenders}, ${message}`)
    }

    public fatal(message: string): void {
        this.writeFile(`[FATAL] ${this.configure.defaults.appenders}, ${message}`)
    }

    private writeFile(message: string) {
        // 写文件
        fileIo.writeSync(this.fd, `${message}\n`)
    }
}

export class Logger {
    private configure?: Configure
    private loggerModel?: LoggerModel
    private strategies: Map<string, ILoggerStrategy> = new Map()

    public setConfigure(configure: Configure) {
        this.strategies = new Map()
        this.configure = configure
        this.loggerModel = new LoggerModel(`${configure.defaults.appenders}`)
        if (configure.cheese.types.includes('file')) {
            this.strategies.set('file', new FileLoggerStrategy(configure))
        } else if (configure.cheese.types.includes('hilog')) {
            this.strategies.set('hilog', new HilogLoggerStrategy(configure))
        } else {
            this.strategies.set('console', new ConsoleLoggerStrategy(configure))
        }
    }

    public debug(message: string): void {
        let levelCheck = this.loggerModel.isLoggable(message, LogLevel.DEBUG)
        if (levelCheck && this.configure.defaults.level >= LogLevel.DEBUG) {
            this.strategies.forEach((value, key) => {
                this.strategies.get(key).debug(message)
            })
        }
    }

    public info(message: string): void {
        let levelCheck = this.loggerModel.isLoggable(message, LogLevel.DEBUG)
        if (levelCheck && this.configure.defaults.level >= LogLevel.DEBUG) {
            this.strategies.forEach((value, key) => {
                this.strategies.get(key).info(message)
            })
        }
    }

    public warn(message: string): void {
        let levelCheck = this.loggerModel.isLoggable(message, LogLevel.DEBUG)
        if (levelCheck && this.configure.defaults.level >= LogLevel.DEBUG) {
            this.strategies.forEach((value, key) => {
                this.strategies.get(key).warn(message)
            })
        }
    }

    public error(message: string): void {
        let levelCheck = this.loggerModel.isLoggable(message, LogLevel.DEBUG)
        if (levelCheck && this.configure.defaults.level >= LogLevel.DEBUG) {
            this.strategies.forEach((value, key) => {
                this.strategies.get(key).error(message)
            })
        }
    }

    public fatal(message: string): void {
        let levelCheck = this.loggerModel.isLoggable(message, LogLevel.DEBUG)
        if (levelCheck && this.configure.defaults.level >= LogLevel.DEBUG) {
            this.strategies.forEach((value, key) => {
                this.strategies.get(key).fatal(message)
            })
        }
    }
}