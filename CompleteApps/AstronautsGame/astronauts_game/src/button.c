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

#include "cmsis_os2.h"
#include "button.h"
#include "common_log.h"
#include "peripheral_hal.h"

#define BUTTON_TASK_STAK_SIZE  (1024*4)
#define BUTTON_TASK_PRIORITY   24
#define DELAY_200_MS 20

static KeyEventCallback g_buttonCallback = NULL;
void ButtonTask(void* arg)
{
    unsigned short data = 0;
    int ret = SSU_NONE;

    while (1) {
        if (HalAdcRead(HAL_WIFI_IOT_ADC_CHANNEL_2, &data, HAL_WIFI_IOT_ADC_EQU_MODEL_4, HAL_WIFI_IOT_ADC_CUR_BAIS_DEFAULT, 0) == 0) {
            if ((ADC_USR_MIN <= data) && (data <= ADC_USR_MAX))  ret = SSU_USER;
            if ((ADC_S1_MIN <= data) && (data <= ADC_S1_MAX))  ret = SSU_S1;
            if ((ADC_S2_MIN <= data) && (data <= ADC_S2_MAX))  ret = SSU_S2;
        }
        if (ret != SSU_NONE) {
            g_buttonCallback(ret);
            ret = SSU_NONE;
        }
        osDelay(DELAY_200_MS);
    }
    return ret;
}

void RegButtonIrq(KeyEventCallback buttonCallback)
{
    g_buttonCallback =  buttonCallback;
    osThreadAttr_t attr = {0};
    attr.name = (char*)"buttontask";
    attr.attr_bits = 0U;
    attr.cb_mem = NULL;
    attr.cb_size = 0U;
    attr.stack_mem = NULL;
    attr.stack_size = BUTTON_TASK_STAK_SIZE;
    attr.priority = BUTTON_TASK_PRIORITY;
    if (osThreadNew((osThreadFunc_t)ButtonTask, NULL, &attr) == NULL) {
        LOG_E("Failed to create ControlSysTask !\n");
    }
    return 0;
}