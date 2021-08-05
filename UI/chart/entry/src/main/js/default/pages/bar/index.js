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

export default {
    data: {
        barData: [
            {
                fillColor: '#f07826',
                data: [763, 550, 551, 554, 731],
            },
            {
                fillColor: '#cce9ff',
                data: [535, 776, 615, 444, 694],
            },
            {
                fillColor: '#ff88bb',
                data: [673, 500, 574, 483, 702],
            },
        ],
        barOps: {
            xAxis: {
                min: 0,
                max: 20,
                display: true,
                axisTick: 5,
            },
            yAxis: {
                min: 0,
                max: 1000,
                display: true,
                axisTick: 10,
            },
        },
    }
}