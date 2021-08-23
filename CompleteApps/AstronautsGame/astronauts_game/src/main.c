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
#include "stdio.h"
#include "ohos_init.h"
#include "cmsis_os2.h"

#include "main.h"
#include "button.h"
#include "game_logic.h"
#include "common_init.h"
#include "common_log.h"
#include "oled.h"
#include "music.h"

#include "ohos_types.h"
#include "iot_gpio.h"
#include "iot_watchdog.h"
#include "iot_errno.h"
#include "peripheral_hal.h"

static int g_gameRunningStatus = 0;

void Button_Callback(uint32 event)
{
    LOG_I("[Button] Button_Callback() :  %d\n", event);
    if (event == SSU_S1) {
        AstronautMove(MOVE_LEFT); // press S1, move left
    } else if (event == SSU_S2) {
        AstronautMove(MOVE_RIGHT); // press S2, move right
    } else if (event == SSU_USER) {
        g_gameRunningStatus = 1; // game start
    } else {
        LOG_I("The useless button_callback! \n");
    }
}

void GameTask(void* arg)
{
    (void)arg;
    IoTWatchDogDisable();
    DeviceInit();
    RegButtonIrq(Button_Callback);
    StartBeepMusicTask();

    while (!g_gameRunningStatus) {
        HAL_Delay(DELAY_TIMES_OF_GAME_PENDING); // Waiting game start
    }

    GameStart();
    SetupMusicPlaybackFlag(true);
    while (1) {
        int isCollision = GameLoop();
        RefreshGameDifficulty();

        ssd1306_Fill(Black);
        DrawGameScreen();
        HAL_Delay(DELAY_TIMES_OF_GAME_SCRREN_REFLASH); // Free system resources

        if (isCollision) {
            SetupMusicPlaybackFlag(true);
            GameOver();
            g_gameRunningStatus = 0;

            while (!g_gameRunningStatus) {
                HAL_Delay(DELAY_TIMES_OF_GAME_PENDING);
            }
            GameStart();
            SetupMusicPlaybackFlag(true);
        }
    }
}

void AstronautsAvoidObstaclesGame(void)
{
    osThreadAttr_t attr;

    attr.name = "GameTask";
    attr.attr_bits = 0U;
    attr.cb_mem = NULL;
    attr.cb_size = 0U;
    attr.stack_mem = NULL;
    attr.stack_size = MAIN_TASK_STACK_SIZE;
    attr.priority = osPriorityNormal;

    if (osThreadNew(GameTask, NULL, &attr) == NULL) {
        LOG_E("[Game] Falied to create GameTask!\n");
    }
}

SYS_RUN(AstronautsAvoidObstaclesGame);