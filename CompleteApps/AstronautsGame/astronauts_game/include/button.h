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

#ifndef  BUTTON_H
#define  BUTTON_H

#include "ohos_types.h"

typedef enum {
    ADC_USR_MIN = 5,
    ADC_USR_MAX = 228,
    ADC_S1_MIN,
    ADC_S1_MAX  = 512,
    ADC_S2_MIN,
    ADC_S2_MAX  = 854
}AdcValue;

typedef enum {
    SSU_NONE,
    SSU_USER,
    SSU_S1,
    SSU_S2
}KeyCode;

typedef void (*KeyEventCallback)(uint32 key);

/**
 * @brief Setting the param of button gpio.
 *
 * @since 1.0
 * @version 1.0
 */
void ButtonInit(void);

/**
 * @brief Register the buttion interrupt.
 *
 * @param eventCall
 * @since 1.0
 * @version 1.0
 */
void RegButtonIrq(KeyEventCallback eventCall);
#endif // BUTTON_H
