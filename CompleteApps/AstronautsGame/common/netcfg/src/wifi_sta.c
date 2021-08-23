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
#include <unistd.h>
#include "lwip/ip_addr.h"
#include "lwip/netifapi.h"
#include "wifi_sta.h"
#include "defines.h"

#define TEST_CONNECT_RETRY_COUNT 5

static WifiEvent g_staEventHandler = {0};
static WifiChangeEvent g_wifiChange = NULL;
static int g_connectRetryCount = 0;

static void WifiConnectionChangedHandler(int state, WifiLinkedInfo *info)
{
    if (state == WIFI_STATE_AVALIABLE) {
        LOG_I("WiFi: Connected.\n");
        g_connectRetryCount = 0;
    } else if (state == WIFI_STATE_NOT_AVALIABLE) {
        LOG_I("WiFi: Disconnected retry = %d, reason = %d\n", g_connectRetryCount, info->disconnectedReason);
        if (g_connectRetryCount < TEST_CONNECT_RETRY_COUNT) {
            g_connectRetryCount++;
            return;
        }
    }
    if (g_wifiChange) {
        g_wifiChange(state);
    }
}

int WifiStaStart(WifiChangeEvent WifiChange)
{
    WifiErrorCode error;

    g_wifiChange = WifiChange;

    if (IsWifiActive() == WIFI_STA_ACTIVE) {
        LOG_E("the wifi has been enabled! \n");
        return 1;
    }

    error = EnableWifi();
    if (error != WIFI_SUCCESS) {
        LOG_E("EnableWifi failed! \n");
        return -1;
    }

    g_staEventHandler.OnWifiConnectionChanged = WifiConnectionChangedHandler;
    error = RegisterWifiEvent(&g_staEventHandler);
    if (error != WIFI_SUCCESS) {
        LOG_E("RegisterWifiEvent fail, error = %d\n", error);
        return -1;
    }

    if (IsWifiActive() == WIFI_STA_NOT_ACTIVE) {
        LOG_E("Wifi station is not actived.\n");
        return -1;
    }

    return 0;
}

int WifiStaConnect(const char *ssid, const char *pwd)
{
    WifiDeviceConfig config = {0};
    int netId = 0;
    WifiErrorCode error;

    if (ssid == NULL) {
        LOG_E("NULL POINT! \n");
        return -1;
    }
    if (strcpy_s(config.ssid, sizeof(config.ssid), ssid) < 0) {
        LOG_E("strcpy_s! \n");
        return -1;
    }

    config.ipType = DHCP;
    if (pwd == NULL || strlen(pwd) == 0) {
        config.securityType = WIFI_SEC_TYPE_OPEN;
    } else {
        config.securityType = WIFI_SEC_TYPE_PSK;
        if (strcpy_s(config.preSharedKey, sizeof(config.preSharedKey), pwd) < 0) {
            LOG_E("strcpy_s! \n");
            return -1;
        }
    }

    error = AddDeviceConfig(&config, &netId);
    if (error != WIFI_SUCCESS) {
        LOG_E("AddDeviceConfig! \n");
        return -1;
    }

    error = ConnectTo(netId);
    if (error != WIFI_SUCCESS) {
        LOG_E("ConnectTo! \n");
        return -1;
    }

    return 0;
}

void WifiStaStop(void)
{
    if (IsWifiActive() == WIFI_STA_NOT_ACTIVE) {
        LOG_E("Wifi station is not actived.\n");
        return;
    }

    DisableWifi();
    UnRegisterWifiEvent(&g_staEventHandler);
}

