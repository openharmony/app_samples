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

#include <stdio.h>
#include <unistd.h>

#include "cmsis_os2.h"
#include "hi_pwm.h"
#include "common_log.h"

#include "ohos_types.h"
#include "peripheral_hal.h"
#include "iot_gpio.h"
#include "iot_pwm.h"
#include "iot_errno.h"

#define MUSIC_STACK_TASK_SIZE             1024
#define WIFI_IOT_PWM_PORT_PWM0            0
#define WIFI_IOT_IO_FUNC_GPIO_9_PWM0_OUT  5
#define TIMES_OF_MUSICAL_NOTE_INTERVAL    (125*1000)
#define THE_MULTIPLIER_OF_PWM_DUTY        0.5
#define THE_TIMES_OF_RELEASE_CPU_RESOURCE (1000*1000)

static bool music_playback_flag = false;

static const uint16 g_tuneFreqs[] = {
    0,
    38223, // 1046.5  C
    34052, // 1174.7  D
    30338, // 1318.5  E
    28635, // 1396.9  F
    25511, // 1568    G
    22728, // 1760    A
    20249, // 1975.5  B
    19048  // Raise an octave of C
};

static const uint8 g_scoreNotes[] = {
    7, 4, 7, 4,
};

static const uint8 g_scoreDurations[] = {
    2, 2, 2, 2,
};

void PlaybackMusicSample(void)
{
    for (size_t i = 0; i < sizeof(g_scoreNotes) / sizeof(g_scoreNotes[0]); i++) {
        uint32 tune = g_scoreNotes[i];
        uint16 freqDivisor = g_tuneFreqs[tune];
        uint32 tuneInterval = g_scoreDurations[i] * (TIMES_OF_MUSICAL_NOTE_INTERVAL);
        HalPwmStart(WIFI_IOT_PWM_PORT_PWM0, freqDivisor * THE_MULTIPLIER_OF_PWM_DUTY, freqDivisor); // music playback
        usleep(tuneInterval);
        IoTPwmStop(WIFI_IOT_PWM_PORT_PWM0); // Turn off this tone play
    }
}

void SetupMusicPlaybackFlag(bool flag)
{
    music_playback_flag = flag;
}

static void *BeeperMusicTask(const char *arg)
{
    (void)arg;

    LOG_D("BeeperMusicTask start!\r\n");
    hi_pwm_set_clock(PWM_CLK_XTAL); // Set the clock source as crystal clock 40Mhz

    while (1) {
        if (music_playback_flag == true) {
            PlaybackMusicSample();
            music_playback_flag = false;
        }
        usleep(THE_TIMES_OF_RELEASE_CPU_RESOURCE);
    }
    return NULL;
}

void StartBeepMusicTask(void)
{
    osThreadAttr_t attr;
    if (IoTGpioInit(HAL_WIFI_IOT_IO_NAME_GPIO_9) != IOT_SUCCESS) {
        LOG_E("GPIO%d Init Failed !\n", HAL_WIFI_IOT_IO_NAME_GPIO_9);
    }

    if (HalIoSetFunc(HAL_WIFI_IOT_IO_NAME_GPIO_9, WIFI_IOT_IO_FUNC_GPIO_9_PWM0_OUT) != IOT_SUCCESS) {
        LOG_E("GPIO%d Set Func failed !\n", HAL_WIFI_IOT_IO_NAME_GPIO_9);
    }

    if (IoTPwmInit(WIFI_IOT_PWM_PORT_PWM0) != IOT_SUCCESS) {
        LOG_E("PWM%d Init Failed !\n", WIFI_IOT_PWM_PORT_PWM0);
    }

    attr.name = "BeeperMusicTask";
    attr.attr_bits = 0U;
    attr.cb_mem = NULL;
    attr.cb_size = 0U;
    attr.stack_mem = NULL;
    attr.stack_size = MUSIC_STACK_TASK_SIZE;
    attr.priority = osPriorityNormal;

    if (osThreadNew((osThreadFunc_t)BeeperMusicTask, NULL, &attr) == NULL) {
        LOG_E("[LedExample] Falied to create BeeperMusicTask!\n");
    }
}