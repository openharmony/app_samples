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

#ifndef __NETWORK_CONFIG_H__
#define __NETWORK_CONFIG_H__

#include "network_manager_service.h"

#define NET_TASK_STACK_SIZE (1024*8)
#define NET_TASK_PRIO 31

/**
 * @brief start net config task
 *
 * @param apName -- the name of the device for AP mode
 *        nEventCallback -- The NetEvent callback. event reference {@NET_EVENT_TYPE}
 *
 * @since 1.0
 * @version 1.0
 *
 * @return 0 success, -1 failed
 */
int NetCfgStart(const char *apName, NetManagerEventCallback nEventCallback);

/**
 * @brief stop net config task
 *
 * @since 1.0
 * @version 1.0
 *
 */
void NetCfgStop(void);

/**
 * @brief set net config mode
 * @param mode -- reference {@NET_MODE_TYPE}
 *
 * @since 1.0
 * @version 1.0
 *
 */
void NetCfgSetMode(int mode);

/**
 * @brief start connect the wifi
 * @param ssid -- wifi ssid, pwd -- wifi password
 *
 * @since 1.0
 * @version 1.0
 *
 */
void NetCfgStartConnect(const char *ssid, const char *pwd);

#endif  /* __NETWORK_CONFIG_H__ */
