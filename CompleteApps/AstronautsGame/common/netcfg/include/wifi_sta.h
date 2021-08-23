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

#ifndef __WIFI_STA_H__
#define __WIFI_STA_H__

#include "wifi_device.h"

/**
 * @brief wifi state change callback.
 * @param state -- wifi state, 0 -- wifi not connect, 1 -- wifi connectted
 *
 * @since 1.0
 * @version 1.0
 *
 */
typedef void (*WifiChangeEvent)(int state);

/**
 * @brief start sta mode.
 * @param WifiChange--wifi state changed callback
 *
 * @since 1.0
 * @version 1.0
 *
 * @return 0 success, -1 failed
 */
int WifiStaStart(WifiChangeEvent WifiChange);

/**
 * @brief start connect wifi.
 * @param ssid -- wifi ssid, pwd -- wifi password
 *
 * @since 1.0
 * @version 1.0
 *
 * @return 0 success, -1 failed
 */
int WifiStaConnect(const char *ssid, const char *pwd);

/**
 * @brief stop sta mode.
 *
 * @since 1.0
 * @version 1.0
 *
 */
void WifiStaStop(void);

#endif  /* __WIFI_STA_H__ */
