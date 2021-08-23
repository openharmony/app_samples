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

#include "peripheral_hal.h"
#include "iot_errno.h"
#include "hi_io.h"
#include "hi_adc.h"
#include "hi_types_base.h"
#include "hi_watchdog.h"
#include "hi_pwm.h"

unsigned int HalIoSetFunc(HalWifiIotIoName id, const char *val)
{
    if (id == HAL_WIFI_IOT_IO_NAME_MAX) {
        return IOT_FAILURE;
    }
    return hi_io_set_func((hi_io_name)id, val);
}

unsigned int HalAdcRead(HalWifiIotAdcChannelIndex channel, unsigned short *data, HalWifiIotAdcEquModelSel equModel,
                        HalWifiIotAdcCurBais curBais, unsigned short rstCnt)
{
    return hi_adc_read((hi_adc_channel_index)channel, (hi_u16*)data, (hi_adc_equ_model_sel)equModel,
                       (hi_adc_cur_bais)curBais, (hi_u16)rstCnt);
}

void HalSetWatchDogEnable(int enable)
{
    if (enable == 0) {
        hi_watchdog_disable();
    } else {
        hi_watchdog_enable();
    }
}

unsigned int HalPwmStart(uint32 id, uint16 duty, uint16 freq)
{
    return hi_pwm_start((hi_pwm_port)id, (hi_u16)duty, (hi_u16)freq);
}