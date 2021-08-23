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
#ifndef __DEFINES_H__
#define __DEFINES_H__

#include <stdio.h>
#include <string.h>

#include <cmsis_os2.h>

#define LOG_E(fmt, arg...)    printf("[ERROR][%s|%d]" fmt, __func__, __LINE__, ##arg)
#define LOG_D(fmt, arg...)    printf("[DEBUG][%s|%d]" fmt, __func__, __LINE__, ##arg)
#define LOG_I(fmt, arg...)    printf("[INFO ][%s|%d]" fmt, __func__, __LINE__, ##arg)

#define REQUEST_OK  200
#define REQUEST_ERR 401

#define BUF_SHORT_SIZE  256
#define AP_NAME     "HmosAP"

#define DELAY_100MS     10          // for function osDelay(), unit 10ms
#define DELAY_200MS     (DELAY_100MS * 2)
#define DELAY_500MS     (DELAY_100MS * 5)
#define DELAY_1000MS    (DELAY_100MS * 10)
#define DELAY_2000MS    (DELAY_100MS * 20)
#define DELAY_5000MS    (DELAY_100MS * 50)

#define USLEEP_100MS    100000      // for function usleep(), unit 1us
#define USLEEP_200MS    (USLEEP_100MS * 2)
#define USLEEP_500MS    (USLEEP_100MS * 5)
#define USLEEP_1000MS   (USLEEP_100MS * 10)
#define USLEEP_2000MS   (USLEEP_100MS * 20)
#define USLEEP_2500MS   (USLEEP_100MS * 25)
#define USLEEP_5000MS   (USLEEP_100MS * 50)

#define ARRAYSIZE(a)    (sizeof((a)) / sizeof((a)[0]))

#endif  /* __DEFINES_H__ */
