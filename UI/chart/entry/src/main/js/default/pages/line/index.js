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
        lineData: [
            {
                strokeColor: '#0081ff',
                fillColor: '#cce5ff',
                data: [
                    {
                        value: 25,
                        description: "25",
                        textLocation: "top",
                        textColor: '#000000'
                    },
                    {
                        value: 15,
                        description: "15",
                        textLocation: "bottom",
                        textColor: '#000000'
                    },
                    {
                        value: 37,
                        description: "37",
                        textLocation: "top",
                        textColor: '#000000'
                    },
                    {
                        value: 48,
                        description: "48",
                        textLocation: "top",
                        textColor: '#000000'
                    },
                    {
                        value: 27,
                        description: "27",
                        textLocation: "bottom",
                        textColor: '#000000'
                    },
                    {
                        value: 83,
                        description: "83",
                        textLocation: "top",
                        textColor: '#000000'
                    },
                    {
                        value: 20,
                        description: "20",
                        textLocation: "bottom",
                        textColor: '#000000'
                    },
                    {
                        value: 66,
                        description: "66",
                        textLocation: "top",
                        textColor: '#000000'
                    },
                    {
                        value: 21,
                        description: "21",
                        textLocation: "bottom",
                        textColor: '#000000'
                    },
                    {
                        value: 99,
                        description: "99",
                        textLocation: "top",
                        textColor: '#000000'
                    },
                ],
                gradient: true,
            }
        ],
        lineOps: {
            xAxis: {
                min: 0,
                max: 10,
                axisTick: 10,
                display: true,
            },
            yAxis: {
                min: 0,
                max: 100,
                axisTick: 20,
                display: true,
            },
            series: {
                lineStyle: {
                    width: "5px",
                    smooth: true,
                },
                headPoint: {
                    shape: "circle",
                    size: 5,
                    strokeWidth: 5,
                    fillColor: '#000000',
                    strokeColor: '#007aff',
                    display: true,
                },
                loop: {
                    margin: 2,
                    gradient: true,
                }
            }
        },
    }
}