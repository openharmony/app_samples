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

#include "button.h"
#include "common_init.h"
#include "oled.h"
#include "common_log.h"
#include "peripheral_hal.h"

#define I2C_IDX_BAUDRATE                  (400000)
#define WIFI_IOT_OLED_I2C_IDX_0           0
#define WIFI_IOT_IO_FUNC_GPIO_13_I2C0_SDA 6
#define WIFI_IOT_IO_FUNC_GPIO_14_I2C0_SCL 6

static void I2cBusInit(void)
{
    IoTGpioInit(HAL_WIFI_IOT_IO_NAME_GPIO_13);
    HalIoSetFunc(HAL_WIFI_IOT_IO_NAME_GPIO_13, WIFI_IOT_IO_FUNC_GPIO_13_I2C0_SDA); // Set up the gpio funcion as i2c

    IoTGpioInit(HAL_WIFI_IOT_IO_NAME_GPIO_14);
    HalIoSetFunc(HAL_WIFI_IOT_IO_NAME_GPIO_14, WIFI_IOT_IO_FUNC_GPIO_14_I2C0_SCL);
    IoTI2cInit(WIFI_IOT_OLED_I2C_IDX_0, I2C_IDX_BAUDRATE); // Rate: 400kbps
    LOG_I("I2C0 bus init success !\n");
}

void DeviceInit(void)
{
    I2cBusInit();
    OledInit();
    LOG_I("Device init success !\n");
}