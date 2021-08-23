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

#ifndef __NETWORK_SERVER_H__
#define __NETWORK_SERVER_H__

#include "network_manager_service.h"

#define NETSERVER_TASK_STACK_SIZE (1024*4)
#define NETSERVER_TASK_PRIO 33


/**
 * @brief start netserver task
 *
 * @param nEventCallback -- The NetEvent callback,
 *                          when the server recv data,
 *                          it will be called with (@NET_EVENT_RECV_DATA)
 * @since 1.0
 * @version 1.0
 *
 * @return 0 success, -1 failed
 */
int NetServerInit(NetManagerEventCallback nEventCallback);

/**
 * @brief stop netserver task
 *
 * @since 1.0
 * @version 1.0
 *
 */
void NetServerDeinit(void);

/**
 * @brief set netserver task resume
 *
 * @since 1.0
 * @version 1.0
 *
 */
void NetServerStart(void);

/**
 * @brief set netserver task suspend
 *
 * @since 1.0
 * @version 1.0
 *
 */
void NetServerStop(void);

/**
 * @brief check the netserver when suspend or not.
 *
 * @since 1.0
 * @version 1.0
 *
 * @return true -- netserver task is activity, false -- netserver is suspend
 */
bool NetServerIsRun(void);

/**
 * @brief send msg to client
 * @param msg -- The message to send
 *
 * @since 1.0
 * @version 1.0
 *
 * @return 0 success, -1 failed
 */
int NetServerSendMsg(const char *msg);

#endif  /* __NETWORK_SERVER_H__ */
