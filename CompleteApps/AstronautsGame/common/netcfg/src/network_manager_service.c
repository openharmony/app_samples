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
#include "cmsis_os2.h"
#include "base64.h"
#include "sys/time.h"
#include "sys/socket.h"
#include "errno.h"
#include "netinet/in.h"
#include "lwip/inet.h"
#include "lwip/netdb.h"

#include "json/jsonutil.h"
#include "ohos_types.h"
#include "common_log.h"
#include "network_server.h"
#include "network_config.h"
#include "defines.h"

int NetManagerRegister(const char *apName, NetManagerEventCallback nEventCallback)
{
    if (NetServerInit(nEventCallback) < 0) {
        LOG_E("NetServerInit \n");
        return -1;
    }

    if (NetCfgStart(apName, nEventCallback) < 0) {
        LOG_E("NetCfgStart \n");
        NetServerDeinit();
        return -1;
    }

    return 0;
}

void NetManagerUnRegister(void)
{
    NetServerDeinit();
    NetCfgStop();
}

void NetManagerSetNetMode(int mode)
{
    NetCfgSetMode(mode);
}

int NetManagerSendMsg(const char *msg)
{
    return NetServerSendMsg(msg);
}
