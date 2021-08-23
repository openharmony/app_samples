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
#include "common_log.h"
#include "netinet/in.h"
#include "lwip/inet.h"
#include "lwip/netdb.h"
#include "json/jsonutil.h"
#include "network_server.h"
#include "defines.h"

#define     SERVER_PORT     8787
#define     MAX_CONNECT     10

typedef struct {
    int sockfd[MAX_CONNECT];
    int connAmount;
    bool isActive;
    bool serRun;

    NetManagerEventCallback g_call;
}NetServerInfo;

static NetServerInfo g_netServer;

static int NetServerSend(int fd, const char *msg)
{
    const char *eof = "\r\n";
    if (send(fd, msg, strlen(msg), 0) < 0) {
        LOG_E("send failed! errno : %d \n", errno);
        return -1;
    }
    LOG_D("send msg : %s \n", msg);
    send(fd, eof, strlen(eof), 0);

    return 0;
}

static void SendRequest(int sockfd, int code)
{
    json_pobject obj;
    json_pobject json = create_json_object();

    obj = add_number_to_object(json, "code", code);
    if (code == REQUEST_OK) {
        obj = add_string_to_object(json, "errmsg", "");
    } else {
        obj = add_string_to_object(json, "errmsg", "explain params error!");
    }

    char *msg = json_to_string(json);
    NetServerSend(sockfd, msg);
    delete_json_object(json);
}

static bool IsSpecialSocket(const char *msg)
{
    char buf[] = {0xff, 0x55, 0xaa, 0x55, 0x00};
    bool result = true;
    if (msg == NULL || strlen(msg) < strlen(buf)) {
        return false;
    }

    for (int i = 0; i < strlen(buf); i++) {
        if (msg[i] != buf[i]) {
            result = false;
            break;
        }
    }

    return result;
}

static int ReadHandle(int *sockfd, fd_set *fdSet)
{
    char recvbuf[BUF_SHORT_SIZE] = {0};
    int recvbytes;
    int fd = *sockfd;
    int errcode = -1;

    recvbytes = recv(fd, recvbuf, sizeof(recvbuf) - 1, 0);
    if (recvbytes <= 0) {
        LOG_D("socket may quit!\n");
        FD_CLR(fd, fdSet);
        close(fd);
        *sockfd = -1;
        g_netServer.connAmount--;
        return -1;
    }

    if (g_netServer.sockfd[0] == -1 && IsSpecialSocket(recvbuf)) {
        *sockfd = -1;
        g_netServer.sockfd[0] = fd;
        return 0;
    }

    LOG_D("recv msg[%d] : %s \n", recvbytes, recvbuf);
    if (g_netServer.g_call) {
        errcode = g_netServer.g_call(NET_EVENT_RECV_DATA, recvbuf);
    }

    if (errcode == -1) {
        errcode = REQUEST_ERR;
    } else {
        errcode = REQUEST_OK;
    }

    SendRequest(fd, errcode);

    return 0;
}

static void CheckNewSocket(int sockFd, fd_set *fdSet, int *maxFd)
{
    int newfd;
    struct sockaddr_in client_addr;
    socklen_t sin_size = sizeof(client_addr);
    if (FD_ISSET(sockFd, fdSet) == 0) {
        return;
    }

    newfd = accept(sockFd, (struct sockaddr *)&client_addr, &sin_size);
    LOG_D("accept:: sock_fd = %d, newfd = %d\n", sockFd, newfd);
    if (newfd <= 0) {
        LOG_E("accept:\n");
        return;
    }

    g_netServer.connAmount++;

    if (g_netServer.connAmount < MAX_CONNECT) {
        for (int i = 1; i < MAX_CONNECT; i++) {
            if (g_netServer.sockfd[i] == -1) {
                g_netServer.sockfd[i] = newfd;
                break;
            }
        }

        if (newfd > *maxFd) {
            *maxFd = newfd;
        }
    } else {
        LOG_E("max connections arrive, exit\n");
        close(newfd);
    }
}

static void SocketListen(int sock_fd)
{
    fd_set fdset;
    int maxsock;
    maxsock = sock_fd;

    while (g_netServer.serRun) {
        int ret;
        struct timeval tv = {2, 0};
        FD_ZERO(&fdset);
        FD_SET(sock_fd, &fdset);
        for (int i = 0; i < MAX_CONNECT; i++) {
            if (g_netServer.sockfd[i] != -1) {
                FD_SET(g_netServer.sockfd[i], &fdset);
            }
        }
        ret = select(maxsock + 1, &fdset, NULL, NULL, &tv);
        if (ret <= 0) {
            continue;
        }
        for (int i = 0; i < MAX_CONNECT; i++) {
            if (g_netServer.sockfd[i] != -1 && FD_ISSET(g_netServer.sockfd[i], &fdset)) {
                LOG_D("g_netServer.sockfd[%d] = %d\n", i, g_netServer.sockfd[i]);
                ReadHandle(&g_netServer.sockfd[i], &fdset);
                continue;
            }
        }

        CheckNewSocket(sock_fd, &fdset, &maxsock);
    }
    for (int i = 0; i < MAX_CONNECT; i++) {
        if (g_netServer.sockfd[i] != -1) {
            close(g_netServer.sockfd[i]);
            g_netServer.sockfd[i] = -1;
        }
    }
}

static void StartServer(void)
{
    struct sockaddr_in serv_addr;
    int sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sockfd < 0) {
        LOG_E("socket failed! \n");
        g_netServer.serRun = false;
        return;
    }

    if (memset_s(&serv_addr, sizeof(serv_addr), 0, sizeof(serv_addr)) < 0) {
        LOG_E("memset_s faield! \n");
        close(sockfd);
        g_netServer.serRun = false;
        return;
    }

    serv_addr.sin_family = AF_INET;                     // 使用IPv4地址
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(SERVER_PORT);                   // 端口
    if (bind(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        LOG_E("bind failed! errno = %d \n", errno);
        g_netServer.serRun = false;
        close(sockfd);
        return;
    }

    if (listen(sockfd, MAX_CONNECT) < 0) {
        LOG_E("listen failed! errno = %d \n", errno);
        g_netServer.serRun = false;
        close(sockfd);
        return;
    }

    SocketListen(sockfd);

    LOG_D("SOCKET SERVER QUIT! \n");

    close(sockfd);
}

static void *NetServerTask(void *param)
{
    while (g_netServer.isActive) {
        if (g_netServer.serRun == false) {
            usleep(USLEEP_100MS);
            continue;
        }

        StartServer();
    }

    return NULL;
}

int NetServerInit(NetManagerEventCallback nEventCallback)
{
    osThreadAttr_t attr;
    attr.name = "NetServerTask";
    attr.attr_bits = 0U;
    attr.cb_mem = NULL;
    attr.cb_size = 0U;
    attr.stack_mem = NULL;
    attr.stack_size = NETSERVER_TASK_STACK_SIZE;
    attr.priority = NETSERVER_TASK_PRIO;

    if (memset_s(&g_netServer, sizeof(g_netServer), 0x00, sizeof(g_netServer)) < 0) {
        LOG_E("memset_s failed! \n");
        return -1;
    }
    for (int i = 0; i < MAX_CONNECT; i++) {
        g_netServer.sockfd[i] = -1;
    }
    g_netServer.isActive = true;
    g_netServer.g_call = nEventCallback;
    if (osThreadNew((osThreadFunc_t)NetServerTask, NULL, &attr) == NULL) {
        LOG_E("Falied to create NetServerTask!\n");
        g_netServer.isActive = false;
        return -1;
    }

    return 0;
}

void NetServerDeinit(void)
{
    g_netServer.serRun = false;
    for (int i = 0; i < MAX_CONNECT; i++) {
        if (g_netServer.sockfd[i] != -1) {
            shutdown(g_netServer.sockfd[i], SHUT_RDWR);
            g_netServer.sockfd[i] = -1;
        }
    }

    osDelay(DELAY_200MS);
    g_netServer.isActive = false;
}

void NetServerStart(void)
{
    g_netServer.serRun = true;
}

void NetServerStop(void)
{
    g_netServer.serRun = false;
    osDelay(DELAY_200MS);
}

bool NetServerIsRun(void)
{
    return g_netServer.serRun;
}

int NetServerSendMsg(const char *msg)
{
    if (g_netServer.serRun == false || g_netServer.sockfd[0] == -1) {
        LOG_E("net server is not run! \n");
        return -1;
    }

    return NetServerSend(g_netServer.sockfd[0], msg);
}
