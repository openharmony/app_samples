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

#ifndef  __NETWORK_MANAGER_SERVICE_H__
#define  __NETWORK_MANAGER_SERVICE_H__

typedef enum {
    NET_EVENT_NULL,
    NET_EVENT_CONFIG,       // Config wifi
    NET_EVENT_CONFIG_FAIL,  // Config wifi failed
    NET_EVENT_CONFIG_SUCC,  // Config wifi success
    NET_EVENT_CONNECTTING,  // connectting wifi
    NET_EVENT_CONN_FAILED,  // connect wifi failed
    NET_EVENT_CONNECTTED,   // Wifi connected
    NET_EVENT_DISTCONNECT,  // Wifi disconnected
    NET_EVENT_RECV_DATA,    // Recv message from FA

    NET_EVENT_TYPE_NBR
}NET_EVENT_TYPE;

typedef enum {
    NET_MODE_IDLE,      // the idle mode
    NET_MODE_CONFIG,    // the netcfg in the AP mode
    NET_MODE_STA,       // the netcfg int the STA mode

    NET_MODE_NBR
}NET_MODE_TYPE;

typedef enum {
    NET_STA_NULL,
    NET_STA_CONFIG,         // Config wifi
    NET_STA_CONNECTTING,    // connectting wifi
    NET_STA_CONNECTTED,   // Wifi connected
    NET_STA_DISTCONNECT,  // Wifi disconnected

    NET_STA_TYPE_NBR
}NET_STA_TYPE;

/**
 * @brief: the network config service callback
 *
 * @param event reference {@link NET_EVENT_TYPE}
 * @param data The data of the event: NET_EVENT_RECV_DATA or NET_EVENT_SEND_DATA
 * @since 1.0
 * @version 1.0
 */
typedef int (*NetManagerEventCallback)(NET_EVENT_TYPE event, void *data);

/**
 * @brief Register the network config task
 *
 * @param apName -- the name of the device for AP mode
 *        nEventCallback -- The callback of netcfg module
 * @since 1.0
 * @version 1.0
 *
 * @return 0 success, -1 failed
 */
int NetManagerRegister(const char *apName, NetManagerEventCallback nEventCallback);

/**
 * @brief Set the network mode.
 *
 * @param mode : the network module, reference {@NET_MODE_TYPE}
 * @since 1.0
 * @version 1.0
 */
void NetManagerSetNetMode(int mode);

/**
 * @brief Send msg to FA.
 *
 * @param msg : the msg to send
 * @since 1.0
 * @version 1.0
 *
 * @return 0 -- success, others -- failed
 */
int NetManagerSendMsg(const char *msg);

/**
 * @brief UnRegister the network config task
 *
 * @since 1.0
 * @version 1.0
 *
 */
void NetManagerDeinit(void);

#endif  // __NETWORK_MANAGER_SERVICE_H__