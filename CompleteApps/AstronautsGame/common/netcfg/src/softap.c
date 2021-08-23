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
#include "wifi_hotspot.h"
#include "wifi_hotspot_config.h"
#include "softap.h"
#include "defines.h"

static void ResetAddr(struct netif *pst_lwip_netif)
{
    ip4_addr_t st_gw;
    ip4_addr_t st_ipaddr;
    ip4_addr_t st_netmask;

    IP4_ADDR(&st_ipaddr, 0, 0, 0, 0);
    IP4_ADDR(&st_gw, 0, 0, 0, 0);
    IP4_ADDR(&st_netmask, 0, 0, 0, 0);

    netifapi_netif_set_addr(pst_lwip_netif, &st_ipaddr, &st_netmask, &st_gw);
}

int SoftApStart(const char *ap_name)
{
    HotspotConfig config = {0};
    ip4_addr_t st_gw;
    ip4_addr_t st_ipaddr;
    ip4_addr_t st_netmask;
    char *apName = ap_name;
    char ifname[BUF_SHORT_SIZE] = {0};
    int retval;

    if (IsHotspotActive() == WIFI_HOTSPOT_ACTIVE) {
        LOG_E("WIFI_HOTSPOT_ACTIVE \n");
        return -1;
    }
    if (apName == NULL) {
        apName = AP_NAME;
    }
    if (strcpy_s(config.ssid, sizeof(config.ssid), apName) != 0) {
        printf("[sample] strcpy ssid fail.\n");
        return -1;
    }
    config.securityType = WIFI_SEC_TYPE_OPEN;
    retval = SetHotspotConfig((const HotspotConfig *)(&config));
    if (retval != WIFI_SUCCESS) {
        LOG_E("SetHotspotConfig \n");
        return -1;
    }

    retval = EnableHotspot();
    if (retval != WIFI_SUCCESS) {
        LOG_E("EnableHotspot failed! \n");
        return -1;
    }
    return 0;
}

void SoftApStop(void)
{
    if (IsHotspotActive() == WIFI_HOTSPOT_NOT_ACTIVE) {
        LOG_E("WIFI_HOTSPOT_NOT_ACTIVE \n");
        return;
    }

    DisableHotspot();
}
