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
#include "errno.h"
#include "cmsis_os2.h"
#include "base64.h"
#include "sys/time.h"
#include "sys/socket.h"
#include "netinet/in.h"
#include "lwip/inet.h"
#include "lwip/netdb.h"

#include "json/jsonutil.h"
#include "ohos_types.h"
#include "common_log.h"
#include "softap.h"
#include "wifi_sta.h"

#include "network_config.h"
#include "network_server.h"
#include "defines.h"

#define SSID_MAX_LEN    32
#define PWD_MAX_LEN     32

#define NET_PORT        8686

#define RETRY_TIMES     5
#define CONNECT_TIMEOUT 20

#define CMD_KEY    "cmd"
#define PAR_KEY     "param"
#define VAL_KEY     "wifiName"
#define PWD_KEY     "wifiPassword"

#define CMD_CONFIG  0x20

typedef struct {
    NET_MODE_TYPE mode;
    NET_STA_TYPE status;
    bool netRun;
    int timeCounts;

    NetManagerEventCallback gEventCall;
} NetManagerInfo;

static NetManagerInfo g_netManager;
const char *g_apName = NULL;

#define SET_NET_EVENT(s, e, d)    ({            \
    if (g_netManager.gEventCall != NULL) {      \
        g_netManager.gEventCall(e, d);          \
    }                                           \
    g_netManager.status = s;                    \
})

static void NetCfgConnectStatus(int s)
{
    if (s == 1 && g_netManager.status != NET_STA_CONNECTTED) {
        SET_NET_EVENT(NET_STA_CONNECTTED, NET_EVENT_CONNECTTED, NULL);
    } else if (s == 0) {
        SET_NET_EVENT(NET_STA_DISTCONNECT, NET_EVENT_DISTCONNECT, NULL);
        g_netManager.mode = NET_MODE_IDLE;
    }
}

#define SHIFT_MASK    0xff
#define SHIFT_8BIT(a)   (((a) >> 8) & (SHIFT_MASK))
#define SHIFT_16BIT(a)  (((a) >> 16) & (SHIFT_MASK))
#define SHIFT_24BIT(a)  (((a) >> 24) & (SHIFT_MASK))

static void GetIpString(uint32_t ip, char *ipAddr, int size)
{
    if (ipAddr == NULL || size <= 0) {
        return;
    }

    if (sprintf_s(ipAddr, size, "%d.%d.%d.%d", ip & SHIFT_MASK, SHIFT_8BIT(ip), SHIFT_16BIT(ip), SHIFT_24BIT(ip)) < 0) {
        LOG_E("GetIpString failed! \n");
    }
    LOG_D("ipAddr : %s \n", ipAddr);
}

int DeviceGetIp(char *buff, int size)
{
    int ret;
    long ip;
    struct netif *netif_node = netif_find("wlan0");
    if (netif_node == NULL) {
        LOG_E("GetLocalWifiIp netif get fail\r\n");
        return -1;
    }

    ip4_addr_t ipAddr;
    ip4_addr_t netMask;
    ip4_addr_t gateWay;

    ret = netifapi_netif_get_addr(netif_node, &ipAddr, &netMask, &gateWay);
    if (ret == 0) {
        ip = ip4_addr_get_u32(&ipAddr);
        GetIpString(ip, buff, size);
        return 0;
    }
    return -1;
}

static void SendLocalIp(int sockfd, int code)
{
    char ip[BUF_SHORT_SIZE] = {0};

    if (code == REQUEST_OK) {
        if (DeviceGetIp(ip, sizeof(ip)) < 0) {
            LOG_E("get local ip failed! \n");
            return;
        }
    }

    json_pobject json = create_json_object();
    json_pobject obj = add_number_to_object(json, "code", code);
    json_pobject obj1, obj2;

    if (code != REQUEST_OK) {
        obj1 = add_string_to_object(json, "errmsg", "connect wifi failed!");
        obj1 = add_object_to_object(json, "result");
    } else {
        obj1 = add_object_to_object(json, "result");
        obj2 = add_number_to_object(obj1, "cmd", CMD_CONFIG);
        obj2 = add_string_to_object(obj1, "ip", (const char *)ip);
    }

    char *msg = json_to_string(json);
    const char *eof = "\r\n";
    LOG_D("send msg : %s \n", msg);
    if (send(sockfd, msg, strlen(msg), 0) < 0) {
        LOG_E("send failed! errno : %d \n", errno);
        return;
    }
    send(sockfd, eof, strlen(eof), 0);

    delete_json_object(json);
}

static int NetCfgConnect(const char *ssid, const char *pwd, bool wait)
{
    int timecnt = 0;
    int retval = 0;
    if (WifiStaStart(NetCfgConnectStatus) < 0) {
        LOG_E("wifista_start \n");
        return -1;
    }

    if (WifiStaConnect((const char *)ssid, (const char *)pwd) < 0) {
        LOG_E("hal_wifi_start_connect \n");
        return -1;
    }

    if (wait) {
        while (g_netManager.status != NET_STA_CONNECTTED) {
            usleep(USLEEP_500MS);
            if (++timecnt > CONNECT_TIMEOUT) {
                retval = -1;
                break;
            }
        }
    }

    return retval;
}

static int ParseWifiInfo(const char *psr, char *ssid, int sl, char *pwd, int pl)
{
    json_handle json;
    json_pobject sub;

    int cmd;
    char *ps = NULL;
    char *pw = NULL;

    json = parse_json(psr);
    if (json == NULL) {
        LOG_E("parse_json\n");
        return -1;
    }

    cmd = get_json_int(json, CMD_KEY);
    if (cmd != CMD_CONFIG) {
        LOG_E("CMD TYPE FAILED! cmd=%d \n", cmd);
        return -1;
    }

    sub = get_json_obj(json, PAR_KEY);
    if (sub == NULL) {
        LOG_E("get param obj failed! \n");
        free_json(json);
        return -1;
    }
    ps = get_json_string(sub, VAL_KEY);
    if (ps == NULL) {
        LOG_E("get ssid failed! \n");
        free_json(json);
        return -1;
    }

    if (strncpy_s(ssid, sl, ps, strlen(ps)) < 0) {
        LOG_E("strncpy_s failed! \n");
        free_json(json);
        return -1;
    }
    pw = get_json_string(sub, PWD_KEY);
    if (pw != NULL) {
        LOG_D("pw=%s\n", pw);
        if (strncpy_s(pwd, pl, pw, strlen(pw)) < 0) {
            LOG_E("strncpy_s failed! \n");
            free_json(json);
            return -1;
        }
    }

    free_json(json);
    return 0;
}

static int NetCfgGetSocketValue(int sockfd)
{
    char recvbuf[BUF_SHORT_SIZE] = {0};
    struct sockaddr_in addr;
    socklen_t len;
    int result = -1;
    char ssid[SSID_MAX_LEN + 1] = {0};
    char pwd[PWD_MAX_LEN + 1] = {0};
    while (1) {
        int readBytes;
        len = sizeof(addr);
        if (g_netManager.mode != NET_MODE_CONFIG) {
            break;
        }
        if (memset_s(recvbuf, BUF_SHORT_SIZE, 0, BUF_SHORT_SIZE) < 0) {
            break;
        }
        readBytes = recvfrom(sockfd, recvbuf, sizeof(recvbuf), 0, (struct sockaddr *)&addr, &len);
        if (readBytes <= 0) {
            LOG_E("socket disconnect! \n");
            break;
        }
        if (ParseWifiInfo((const char*)recvbuf, ssid, sizeof(ssid), pwd, sizeof(pwd)) == 0) {
            result = 0;
            break;
        }
    }
    if (result != -1) {
        int code = REQUEST_OK;
        SET_NET_EVENT(NET_STA_CONNECTTING, NET_EVENT_CONNECTTING, NULL);
        if (NetCfgConnect(ssid, pwd, true) < 0) {
            SET_NET_EVENT(NET_STA_NULL, NET_EVENT_CONN_FAILED, NULL);
            code = REQUEST_ERR;
            WifiStaStop();
            result = -1;
        } else {
            SET_NET_EVENT(NET_STA_CONNECTTED, NET_EVENT_CONNECTTED, NULL);
        }

        usleep(USLEEP_2500MS);    // wait ip ready
        SendLocalIp(sockfd, code);
        usleep(USLEEP_1000MS);
        if (result != -1) {
            NetServerStart();
        }
    }
    if (memset_s(pwd, sizeof(pwd), 0x00, sizeof(pwd)) < 0) {
        return -1;
    }
    return result;
}

static int NetCfgSocket(void)
{
    int sockfd;
    struct sockaddr_in servaddr;

    if ((sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0) {
        LOG_E("socket error! \n");
        return -1;
    }

    memset_s(&servaddr, sizeof(servaddr), 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(NET_PORT);
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);

    LOG_D("监听%d端口\n", NET_PORT);
    if (bind(sockfd, (struct sockaddr *)&servaddr, sizeof(servaddr)) < 0) {
        LOG_E("bind socket! \n");
        close(sockfd);
        return -1;
    }

    if (listen(sockfd, 1) < 0) {
        LOG_E("listen failed! errno = %d \n", errno);
        close(sockfd);
        return -1;
    }

    while (g_netManager.mode == NET_MODE_CONFIG) {
        int newfd, retval;
        struct sockaddr_in client_addr;
        socklen_t length = sizeof(client_addr);
        newfd = accept(sockfd, (struct sockaddr *)&client_addr, &length);
        LOG_D("new socket connect!\n");
        retval = NetCfgGetSocketValue(newfd);
        close(newfd);

        if (retval == 0) {
            LOG_D("config network success! \n");
            g_netManager.mode = NET_MODE_STA;
        }
    }

    close(sockfd);

    return 0;
}

static void NetCfgStartConfig(void)
{
    SET_NET_EVENT(NET_STA_CONFIG, NET_EVENT_CONFIG, NULL);
    WifiStaStop();
    if (SoftApStart(g_apName) < 0) {
        LOG_E("start softap failed! \n");
        SET_NET_EVENT(NET_STA_NULL, NET_EVENT_CONFIG_FAIL, NULL);
        return;
    }

    if (NetCfgSocket() < 0) {
        SET_NET_EVENT(NET_STA_NULL, NET_EVENT_CONFIG_FAIL, NULL);
        return;
    }

    SoftApStop();
}

static void *NetCfgTask(void *arg)
{
    (void)arg;
    int netCfgMode = NET_STA_NULL;
    while (g_netManager.netRun) {
        if (netCfgMode == g_netManager.mode && netCfgMode != NET_MODE_STA) {
            usleep(USLEEP_1000MS);
            continue;
        }
        if (netCfgMode != g_netManager.mode) {
            netCfgMode = g_netManager.mode;
        }
        switch (netCfgMode) {
            case NET_MODE_CONFIG:
                NetCfgStartConfig();
                break;
            default:
                break;
        }
        usleep(USLEEP_1000MS);
    }

    return NULL;
}

int NetCfgStart(const char *apName, NetManagerEventCallback nEventCallback)
{
    osThreadAttr_t attr;

    if (memset_s(&g_netManager, sizeof(g_netManager), 0x00, sizeof(g_netManager)) < 0) {
        LOG_E("memset_s g_netManager \n");
        return -1;
    }

    g_netManager.gEventCall = nEventCallback;
    g_netManager.netRun = true;
    g_netManager.mode = NET_STA_CONFIG;
    g_apName = apName;
    attr.name = "NetManagerTask";
    attr.attr_bits = 0U;
    attr.cb_mem = NULL;
    attr.cb_size = 0U;
    attr.stack_mem = NULL;
    attr.stack_size = NET_TASK_STACK_SIZE;
    attr.priority = NET_TASK_PRIO;

    if (osThreadNew((osThreadFunc_t)NetCfgTask, NULL, &attr) == NULL) {
        LOG_E("Falied to create NetManagerTask!\n");
        return -1;
    }

    return 0;
}

void NetCfgStop(void)
{
    g_netManager.netRun = false;
}

void NetCfgSetMode(int mode)
{
    g_netManager.mode = mode;
}

void NetCfgStartConnect(const char *ssid, const char *pwd)
{
    NetCfgConnect(ssid, pwd, false);
}
