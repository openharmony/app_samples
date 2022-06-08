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

import mediaQuery from '@ohos.mediaquery'
import http from '@ohos.net.http'
import preferences from '@ohos.data.preferences'
import dateTimeUtil from '../Common/DateTimeUtil'
import BaseModel  from '../Model/BaseModel'
import logger from '../Common/Logger'
import { AirQualityModel } from '../Model/AirQualityModel'
import { TitleBar } from '../Common/TitleBar'
import { HistoryShow } from '../Common/HistoryShow'
import { HttpRequestOptions } from '../Model/HttpRequestOptions'
import { ImageShow } from '../Common/ImageShow'
import { ElementIndicators } from '../Common/ElementIndicators'
import { AirQuality } from '../Model/AirQuality'

const TAG: string = 'Index'
const locationShenZhen: string = '101280601'
const locationDongGuan: string = '101281601'

@Entry
@Component
struct Index {
  private httpRequest: http.HttpRequest = undefined
  private preference: preferences.Preferences = undefined
  private airQualitysHistoryShenZhen: Array<AirQualityModel> = []
  private airQualitysHistoryDongGuan: Array<AirQualityModel> = []
  private airQualityModelShenZhen: AirQualityModel = new AirQualityModel()
  private airQualityModelDongGuan: AirQualityModel = new AirQualityModel()
  private swiperController: SwiperController = new SwiperController()
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  @State isLand: boolean = false
  @State qualitys: Array<BaseModel> = [
    {
      city: '深圳',
      category: '良',
      aqi: '0',
      airQualityModel: {
        co: { name: 'CO', data: 0 },
        so2: { name: 'SO2', data: 0 },
        pm10: { name: 'PM10', data: 0 },
        pm2p5: { name: 'PM2.5', data: 0 },
        no2: { name: 'NO2', data: 0 },
        date: '00月00日_00:00'
      }
    },
    {
      city: '东莞',
      category: '差',
      aqi: '0',
      airQualityModel: {
        co: { name: 'CO', data: 0 },
        so2: { name: 'SO2', data: 0 },
        pm10: { name: 'PM10', data: 0 },
        pm2p5: { name: 'PM2.5', data: 0 },
        no2: { name: 'NO2', data: 0 },
        date: "00月00日_00:00"
      }
    }
  ]
  onLand = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
  }

  async request(uri: string, op: Object) {
    this.httpRequest = http.createHttp()
    try {
      let result = await this.httpRequest.request(uri, op)
      return result
    } catch (error) {
      this.httpRequest.destroy()
      return error
    }
  }

  async saveData() {
    logger.info(TAG, `enter saveData`)
    this.preference = await preferences.getPreferences(globalThis.abilityContext, 'airquality')
    logger.info(TAG, `this.preference = ${this.preference}`)
    let [existShenZhen,existDongGuan] = await Promise.all([this.preference.has('shenzhen'), this.preference.has('dongguan')])
    logger.info(TAG, `whether exist ShenZhen = ${JSON.stringify(existShenZhen)}`)
    logger.info(TAG, `whether exist DongGuan = ${JSON.stringify(existDongGuan)}`)

    if (existDongGuan && existShenZhen) {
      let shenZhenResult = <string> await this.preference.get('shenzhen', 'default')
      logger.info(TAG, `[Exist] shenZhenResult = ${JSON.stringify(shenZhenResult)}`)

      let dongGuanResult = <string> await this.preference.get('dongguan', 'default')
      logger.info(TAG, `[Exist] dongGuanResult = ${JSON.stringify(dongGuanResult)}`)

      this.airQualitysHistoryShenZhen = JSON.parse(shenZhenResult)
      logger.info(TAG, `[Exist] this.airQualitysHistoryShenZhen = ${JSON.stringify(this.airQualitysHistoryShenZhen)}`)

      this.airQualitysHistoryDongGuan = JSON.parse(dongGuanResult)
      logger.info(TAG, `[Exist] this.airQualitysHistoryDongGuan = ${JSON.stringify(this.airQualitysHistoryDongGuan)}`)

      if (this.airQualitysHistoryShenZhen.length === 7 || this.airQualitysHistoryDongGuan.length === 7) {
        this.airQualitysHistoryShenZhen = new Array
        this.airQualitysHistoryDongGuan = new Array
        this.airQualitysHistoryDongGuan.push(this.airQualityModelDongGuan)
        await this.preference.put('dongguan', JSON.stringify(this.airQualitysHistoryDongGuan))
        logger.info(TAG, `[=7] this.airQualitysHistoryDongGuan = ${JSON.stringify(this.airQualitysHistoryDongGuan)}`)
        this.airQualitysHistoryShenZhen.push(this.airQualityModelShenZhen)
        await this.preference.put('shenzhen', JSON.stringify(this.airQualitysHistoryShenZhen))
        logger.info(TAG, `[=7] this.airQualitysHistoryShenZhen = ${JSON.stringify(this.airQualitysHistoryShenZhen)}`)
        await this.preference.flush()
      } else {
        this.airQualitysHistoryDongGuan.push(this.airQualityModelDongGuan)
        await this.preference.put('dongguan', JSON.stringify(this.airQualitysHistoryDongGuan))
        logger.info(TAG, `[<7] this.airQualitysHistoryDongGuan = ${JSON.stringify(this.airQualitysHistoryDongGuan)}`)
        this.airQualitysHistoryShenZhen.push(this.airQualityModelShenZhen)
        await this.preference.put('shenzhen', JSON.stringify(this.airQualitysHistoryShenZhen))
        logger.info(TAG, `[<7] this.airQualitysHistoryShenZhen = ${JSON.stringify(this.airQualitysHistoryShenZhen)}`)
        await this.preference.flush()
      }
    } else {
      this.airQualitysHistoryDongGuan.push(this.airQualityModelDongGuan)
      this.airQualitysHistoryShenZhen.push(this.airQualityModelShenZhen)
      await this.preference.put('shenzhen', JSON.stringify(this.airQualitysHistoryShenZhen))
      logger.info(TAG, `[notExist] put shenzhen`)
      await this.preference.put('dongguan', JSON.stringify(this.airQualitysHistoryDongGuan))
      logger.info(TAG, `[notExist] put dongguan`)
      await this.preference.flush()
    }
  }

  constructorAirQualityModel = (baseModel: BaseModel, response: http.HttpResponse) => {
    logger.info(TAG, `enter constructorAirQualityModel`)
    let airQualityModel = new AirQualityModel()
    baseModel.aqi = JSON.parse(response.result.toString()).now.aqi
    airQualityModel.co = new AirQuality('CO', JSON.parse(response.result.toString()).now.co)
    airQualityModel.so2 = new AirQuality('SO2', JSON.parse(response.result.toString()).now.so2)
    airQualityModel.pm10 = new AirQuality('PM10', JSON.parse(response.result.toString()).now.pm10)
    airQualityModel.pm2p5 = new AirQuality('PM2.5', JSON.parse(response.result.toString()).now.pm2p5)
    airQualityModel.no2 = new AirQuality('NO2', JSON.parse(response.result.toString()).now.no2)
    airQualityModel.date = dateTimeUtil.getDate() + '_' + dateTimeUtil.getTime()
    logger.info(TAG, `airQualityModel = ${JSON.stringify(airQualityModel)}`)
    baseModel.airQualityModel = airQualityModel
    if (baseModel.city === '深圳') {
      this.qualitys[0] = baseModel
      this.airQualityModelShenZhen = airQualityModel
      logger.info(TAG, `this.airQualityModelShenZhen = ${JSON.stringify(this.airQualityModelShenZhen)}`)
    }
    if (baseModel.city === '东莞') {
      this.qualitys[1] = baseModel
      this.airQualityModelDongGuan = airQualityModel
      logger.info(TAG, `this.airQualityModelDongGuan = ${JSON.stringify(this.airQualityModelDongGuan)}`)
    }
    logger.info(TAG, `constructorAirQualityModel qualitys = ${JSON.stringify(this.qualitys)}`)
  }

  constructorSZResponse(responseShenZhen: http.HttpResponse) {
    logger.info(TAG, `enter constructorSZResponse`)
    let baseModelShenZhen = new BaseModel()
    baseModelShenZhen.city = '深圳'
    baseModelShenZhen.category = '良'
    this.constructorAirQualityModel(baseModelShenZhen, responseShenZhen)

  }

  constructorDGResponse(responseDongGuan: http.HttpResponse) {
    logger.info(TAG, `enter constructorDGResponse`)
    let baseModelDongGuan = new BaseModel()
    baseModelDongGuan.city = '东莞'
    baseModelDongGuan.category = '差'
    this.constructorAirQualityModel(baseModelDongGuan, responseDongGuan)
  }

  async aboutToAppear() {
    this.listener.on('change', this.onLand)
    logger.info(TAG, 'enter aboutToAppear')
    let uri = 'https://devapi.qweather.com/v7/air/now'
    let shenzhenRequestOptions = new HttpRequestOptions()
    shenzhenRequestOptions.setExtraData(locationShenZhen)
    let dongguanRequestOptions = new HttpRequestOptions()
    dongguanRequestOptions.setExtraData(locationDongGuan)
    let [responseShenZhen,responseDongGuan] = await Promise.all([this.request(uri, shenzhenRequestOptions), this.request(uri, dongguanRequestOptions)])
    logger.info(TAG, `responseShenZhen = ${JSON.stringify(responseShenZhen.result)}`)
    this.constructorSZResponse(responseShenZhen)
    logger.info(TAG, `responseDongGuan = ${JSON.stringify(responseDongGuan.result)}`)
    this.constructorDGResponse(responseDongGuan)

    this.saveData()
  }

  handlerClickButton = () => {
    globalThis.abilityContext.terminateSelf()
  }

  onPageHide() {
    this.preference = undefined
    this.qualitys = undefined
    this.airQualityModelShenZhen = undefined
    this.airQualitysHistoryShenZhen = undefined
    this.airQualityModelDongGuan = undefined
    this.airQualitysHistoryDongGuan = undefined
  }

  build() {
    Column() {
      TitleBar({ handlerClickButton: this.handlerClickButton })
      Swiper(this.swiperController) {
        ForEach(this.qualitys, (item, index) => {
          Column() {
            if (this.isLand) {
              Row() {
                Column() {
                  ImageShow({ quality: item, cityIndex: index })
                }
                .width('50%')

                Column() {
                  ElementIndicators({ airQualityModel: item.airQualityModel })
                }
                .width('50%')
              }
            } else {
              ImageShow({ quality: item, cityIndex: index })
              ElementIndicators({ airQualityModel: item.airQualityModel })
            }
            HistoryShow({ city: item.city })
          }
        }, item => item.city)
      }
      .height('92%')
    }
  }
}