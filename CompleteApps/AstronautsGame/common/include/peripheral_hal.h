/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

#ifndef  PERIPHERAL_HAL_H
#define  PERIPHERAL_HAL_H

#include "ohos_types.h"

/* gpio start */
typedef enum {
    /** GPIO hardware pin 0 */
    HAL_WIFI_IOT_IO_NAME_GPIO_0,
    /** GPIO hardware pin 1 */
    HAL_WIFI_IOT_IO_NAME_GPIO_1,
    /** GPIO hardware pin 2 */
    HAL_WIFI_IOT_IO_NAME_GPIO_2,
    /** GPIO hardware pin 3 */
    HAL_WIFI_IOT_IO_NAME_GPIO_3,
    /** GPIO hardware pin 4 */
    HAL_WIFI_IOT_IO_NAME_GPIO_4,
    /** GPIO hardware pin 5 */
    HAL_WIFI_IOT_IO_NAME_GPIO_5,
    /** GPIO hardware pin 6 */
    HAL_WIFI_IOT_IO_NAME_GPIO_6,
    /** GPIO hardware pin 7 */
    HAL_WIFI_IOT_IO_NAME_GPIO_7,
    /** GPIO hardware pin 8 */
    HAL_WIFI_IOT_IO_NAME_GPIO_8,
    /** GPIO hardware pin 9 */
    HAL_WIFI_IOT_IO_NAME_GPIO_9,
    /** GPIO hardware pin 10 */
    HAL_WIFI_IOT_IO_NAME_GPIO_10,
    /** GPIO hardware pin 11 */
    HAL_WIFI_IOT_IO_NAME_GPIO_11,
    /** GPIO hardware pin 12 */
    HAL_WIFI_IOT_IO_NAME_GPIO_12,
    /** GPIO hardware pin 13 */
    HAL_WIFI_IOT_IO_NAME_GPIO_13,
    /** GPIO hardware pin 14 */
    HAL_WIFI_IOT_IO_NAME_GPIO_14,
    /** Maximum value */
    HAL_WIFI_IOT_IO_NAME_MAX,
} HalWifiIotIoName;

/**
 * @brief set IO function.
 *
 * @param id -- IO number, reference {@ HalWifiIotIoName}.
 * @param val -- the io function value which defined in {@ hi_io.h}.
 *
 * @return Returns {@link WIFI_IOT_SUCCESS} if the operation is successful;
 *         returns an error code defined in {@link wifiiot_errno.h} otherwise.
 * @since 1.0
 * @version 1.0
 */
unsigned int HalIoSetFunc(HalWifiIotIoName id, const char *val);
/* gpio end */


/* adc  start */

/**
 * @brief Enumerates ADC channel indexes.
 *
 */
typedef enum {
    /** Channel 0 */
    HAL_WIFI_IOT_ADC_CHANNEL_0,
    /** Channel 1 */
    HAL_WIFI_IOT_ADC_CHANNEL_1,
    /** Channel 2 */
    HAL_WIFI_IOT_ADC_CHANNEL_2,
    /** Channel 3 */
    HAL_WIFI_IOT_ADC_CHANNEL_3,
    /** Channel 4 */
    HAL_WIFI_IOT_ADC_CHANNEL_4,
    /** Channel 5 */
    HAL_WIFI_IOT_ADC_CHANNEL_5,
    /** Channel 6 */
    HAL_WIFI_IOT_ADC_CHANNEL_6,
    /** Channel 7 */
    HAL_WIFI_IOT_ADC_CHANNEL_7,
    /** Button value */
    HAL_WIFI_IOT_ADC_CHANNEL_BUTT,
} HalWifiIotAdcChannelIndex;

/**
 * @brief Enumerates analog power control modes.
 */
typedef enum {
    /** Automatic control */
    HAL_WIFI_IOT_ADC_CUR_BAIS_DEFAULT,
    /** Automatic control */
    HAL_WIFI_IOT_ADC_CUR_BAIS_AUTO,
    /** Manual control (AVDD = 1.8 V) */
    HAL_WIFI_IOT_ADC_CUR_BAIS_1P8V,
    /** Manual control (AVDD = 3.3 V) */
    HAL_WIFI_IOT_ADC_CUR_BAIS_3P3V,
    /** Button value */
    HAL_WIFI_IOT_ADC_CUR_BAIS_BUTT,
} HalWifiIotAdcCurBais;

/**
 * @brief Enumerates equation models.
 */
typedef enum {
    /** One-equation model */
    HAL_WIFI_IOT_ADC_EQU_MODEL_1,
    /** Two-equation model */
    HAL_WIFI_IOT_ADC_EQU_MODEL_2,
    /** Four-equation model */
    HAL_WIFI_IOT_ADC_EQU_MODEL_4,
    /** Eight-equation model */
    HAL_WIFI_IOT_ADC_EQU_MODEL_8,
    /** Button value */
    HAL_WIFI_IOT_ADC_EQU_MODEL_BUTT,
} HalWifiIotAdcEquModelSel;

/**
 * @brief Reads a piece of sampled data from a specified ADC channel based on the input parameters.
 *
 *
 *
 * @param channel Indicates the ADC channel index.
 * @param data Indicates the pointer to the address for storing the read data.
 * @param equModel Indicates the equation model.
 * @param curBais Indicates the analog power control mode.
 * @param rstCnt Indicates the count of the time from reset to conversion start.
 *               One count is equal to 334 ns. The value must range from 0 to 0xFF0.
 * @return Returns {@link WIFI_IOT_SUCCESS} if the operation is successful;
 *         returns an error code defined in {@link wifiiot_errno.h} otherwise.
 * @since 1.0
 * @version 1.0
 */
unsigned int HalAdcRead(HalWifiIotAdcChannelIndex channel, unsigned short *data, HalWifiIotAdcEquModelSel equModel,
                        HalWifiIotAdcCurBais curBais, unsigned short rstCnt);
/** adc  end  ****/

/**
 * @brief set WatchDog enable or disable.
 *
 * @param enable -- 1 enable, 0 disable.
 *
 * @since 1.0
 * @version 1.0
 */
void HalSetWatchDogEnable(int enable);

/**
 * @brief start the pwm.
 *
 * @param id Port id of PWM
 * @param duty The usefull cycles of PWM
 * @param freq The total cycles of PWM
 *
 * @return Returns {@link WIFI_IOT_SUCCESS} if the operation is successful;
 *         returns an error code defined in {@link wifiiot_errno.h} otherwise.
 * @since 1.0
 * @version 1.0
 */
unsigned int HalPwmStart(uint32 id, uint16 duty, uint16 freq);

#endif // PERIPHERAL_HAL_H