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

#ifndef GAME_LOGIC_H
#define GAME_LOGIC_H

#include "ohos_types.h"

typedef enum {
    OBSTACLE_1,
    OBSTACLE_2,
    OBSTACLE_3
}OBSTACLE_ID;

void GameStart(void);

int GameLoop(void);

void DrawGameScreen(void);

void GameOver(void);

void AstronautMove(uint32 flag);

void RefreshGameDifficulty(void);
#endif // GAME_LOGIC_H