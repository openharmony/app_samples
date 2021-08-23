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

#ifndef MAIN_H
#define MAIN_H

#define OLED_MODE    0
#define SIZE         8
#define X_Level_L      0x00
#define X_Level_H      0x10
#define MAX_COLUMN   128
#define MAX_ROW      64
#define BRIGHTNESS   0xFF
#define X_WIDTH      128
#define Y_WIDTH      64
#define OLED_CMD     0    // 写命令
#define OLED_DATA    1    // 写数据

#define DELAY_TIMES_OF_GAME_PENDING        300
#define DELAY_TIMES_OF_GAME_SCRREN_REFLASH 100
#define MAIN_TASK_STACK_SIZE (1024*10)
#define MOVE_LEFT    0
#define MOVE_RIGHT   1

#endif // MAIN_H