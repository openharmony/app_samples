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
import i18n from '@ohos.i18n'
import Intl from '@ohos.intl'
import Logger from './Logger'

const TAG: string = 'IntlUtil'

class IntlUtil {
    fillNum(num: number) {
        return num > 9 ? `${num}` : `0${num}`
    }

    getDateString() {
        let is24Hours = i18n.is24HourClock()
        let hour12 = 'h12'
        if (is24Hours) {
            hour12 = 'h24'
        }
        let currentLocale = new Intl.Locale()
        let locale = i18n.getSystemLocale()
        let options = {
            locale: locale,
            dateStyle: 'medium',
            timeStyle: 'medium',
            hourCycle: hour12,
            timeZone: '',
            numberingSystem: currentLocale.numberingSystem,
            hour12: !is24Hours,
            weekday: 'long',
            era: 'long',
            year: 'medium',
            month: 'medium',
            day: 'medium',
            hour: 'medium',
            minute: 'medium',
            second: 'medium',
            timeZoneName: '',
            dayPeriod: 'narrow',
            localeMatcher: 'best fit',
            formatMatcher: 'best fit'
        }
        let language = i18n.getSystemLanguage()
        let params = [language, locale]
        let dateFormat = new Intl.DateTimeFormat(params, options)
        let date = new Date()
        Logger.info(TAG, `language = ${language}`)
        let formatString = dateFormat.format(date)
        if (language === 'zh-Hans') {
            let format = formatString.split(' ')
            return [format[0], format[1]]
        } else {
            let format = formatString.split(', ')
            return [`${format[0]}, ${format[1]}`, format[2]]
        }
    }

    getTimeZoneString(timeZone: i18n.TimeZone) {
        let offset = timeZone.getRawOffset()
        return `GMT${offset > 0 ? '+' : '-'}${this.getTimeString(offset)}  ${timeZone.getDisplayName(i18n.getSystemLanguage())}`
    }

    getTimeString(duration: number) {
        let time = duration
        if (time < 0) {
            time = 0 - time
        }
        let hour = Math.floor(time / (1000 * 60 * 60))
        let minute = Math.floor(time % (1000 * 60))
        if (hour > 0) {
            return `${this.fillNum(hour)}:${this.fillNum(minute)}`
        }
    }

    getNumberFormatString() {
        let currentLocale = new Intl.Locale()
        let locale = i18n.getSystemLocale()
        let numfmt = new Intl.NumberFormat()
        let options = numfmt.resolvedOptions()
        options.locale = locale
        options.numberingSystem = currentLocale.numberingSystem
        options.currency = 'CNY'
        options.currencySign = 'symbol'
        options.localeMatcher = 'best fit'
        options.style = 'decimal'
        let params = [i18n.getSystemLanguage(), locale]
        let numberFormat = new Intl.NumberFormat(params, options)
        options.style = 'currency'
        let currencyFormat = new Intl.NumberFormat(params, options)
        options.style = 'percent'
        let percentFormat = new Intl.NumberFormat(params, options)
        // 此处返回的只是一个示例，因此1234567，123456，78.9并不具有实际意义
        return [numberFormat.format(1234567), currencyFormat.format(123456), percentFormat.format(78.9)]
    }
}

export default new IntlUtil()