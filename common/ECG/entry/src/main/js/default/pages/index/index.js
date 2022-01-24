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
        hundredImg: "/common/A054_110.png",
        tensImg: "/common/A054_110.png",
        onesImg: "/common/A054_110.png",
        tensLeft: "100px",
        onesLeft: "120px",
        chartUnit: "170px",
        hundredDisplay: "none",
        realHrValue: 0,
        moving: false,
        leftNum: 0,
        passTime: 0,
        chartTime: 30,
        chartHeartImg: '/common/A054_078.png',
        isFill: false,
        chartHeartInterval: '',
        electrocardInterval: '',
        heartDataInterval: '',
        maskLeft: 454,
        tipTop: "320px",
        hideFlag: false,
        isBreak: true,
        digMaskLeft: 454,
        times_minute: "",
        ecgData: [
            45,45,45,46,46,46,46,47,47,47,
            47,46,46,46,46,46,46,45,45,45,
            44,44,45,49,73,94,97,80,51,43,
            42,43,43,43,43,43,43,43,43,43,
            44,44,44,44,44,45,45,45,45,46,
            46,47,47,47,48,48,49,50,51,52,
            54,54,55,56,56,55,54,53,52,48,
            47,45,45,44,44,43,43,43,43,43,
            44,44,44,44,45,45,45,46,46,46,
            46,46,46,46,47,47,47,47,47,47
        ],
        heartData: [70,78,80,89,90,85,95,99,101,106,118],
        datasets: [
            {
                strokeColor: '#fc3159',
                data: [50]
            }
        ],
        options: {
            xAxis: { display: false, min: 0, max: 454},
            yAxis: { display: false, min: 0, max: 100},
            series: {
                lineStyle: {
                    width: "5",
                    smooth: true
                },
                headPoint: {
                    shape: 'circle',
                    size: '8px',
                    strokeColor: '#ffffff',
                    fillColor: '#ffffff',
                },
                loop: {
                    margin: 30,
                    gradient: true
                }
            }
        }
    },
    onInit() {
        this.times_minute = this.$t('strings.times_minute');
        this.startChartHeart();
        this.handleMeasureData();
    },
    onHide() {
        console.log('onHide');
    },
    handleMeasureData() {
        this.updateElectrocarddiogram();
        this.updateHeart();
    },
    updateElectrocarddiogram() {
        let minEcgIndex = 0;
        let maxEcgIndex = 99;
        let curEcgIndex = minEcgIndex;
        this.electrocardInterval = setInterval(() => {
            let arrayObj = [];
            for (let i = 0; i < 13; i++) {
                if (curEcgIndex == maxEcgIndex) {
                    curEcgIndex = minEcgIndex;
                } else {
                    arrayObj.push(this.ecgData[curEcgIndex]);
                    curEcgIndex++;
                }
            }
            this.addChartDate(arrayObj);
            this.handleCountDown();
        }, 100);
    },
    updateHeart() {
        this.heartDataInterval = setInterval(() => {
            this.realHrValue = this.heartData[Math.floor(Math.random() * this.heartData.length)];
        }, 1000);
    },
    addChartDate(list) {
        let appendDate = { serial: 0, data: list };
        this.$refs.chart.append(appendDate);
    },
    handleCountDown() {
        let countdownValue = 30;
        this.passTime++;
        if (this.passTime % 10 == 0) {
            countdownValue -= (this.passTime / 10);
            this.setRealHrValue();
            if (countdownValue > 0) {
                if (countdownValue < 10) {
                    this.chartTime = '0' + countdownValue;
                } else {
                    this.chartTime = countdownValue;
                }
            } else {
                this.chartTime = 0;
            }
        }
    },
    setRealHrValue() {
        let hundreds, tens, ones;
        let realHrMin = 0;
        let realHrMax = 255;
        let doubleAvgHr = 2;
        let threeAvgHr = 3;
        let subIndexZero = 0;
        let subIndexOne = 1;
        let subIndexTwo = 2;
        let subIndexEnd = 3;
        if (this.realHrValue == realHrMin || this.realHrValue == realHrMax) {
            this.initRealHrValue();
        } else {
            this.times_minute = this.$t('strings.ecg_times_minute_many_id');
            let number = this.realHrValue.toString();
            if (number.length == doubleAvgHr) {
                this.hundredDisplay = 'none';
                this.tensLeft = '100px';
                this.onesLeft = '120px';
                this.chartUnit = '170px';
                tens = number.substring(subIndexZero, subIndexOne);
                ones = number.substring(subIndexOne, subIndexTwo);
                this.tensImg = '/common/A054_10' + tens + '.png';
                this.onesImg = '/common/A054_10' + ones + '.png';
            } else if (number.length == threeAvgHr) {
                this.hundredDisplay = 'block';
                this.tensLeft = '130px';
                this.onesLeft = '150px';
                this.chartUnit = '170px';
                hundreds = number.substring(subIndexZero, subIndexOne);
                tens = number.substring(subIndexOne, subIndexTwo);
                ones = number.substring(subIndexTwo, subIndexEnd);
                this.hundredImg = '/common/A054_10' + hundreds + '.png';
                this.tensImg = '/common/A054_10' + tens + '.png';
                this.onesImg = '/common/A054_10' + ones + '.png';
            } else {
            }
        }
    },
    initRealHrValue() {
        this.hundredDisplay = 'none';
        this.tensLeft = '100px';
        this.onesLeft = '120px';
        this.chartUnit = '170px';
        this.tensImg = '/common/A054_110.png';
        this.onesImg = '/common/A054_110.png';
    },
    startChartHeart() {
        let chartHeartIndex = 78;
        let chartEndHeartIndex = 97;
        let heartImgIndex = chartHeartIndex;
        this.chartHeartInterval = setInterval(() => {
            if (heartImgIndex == chartEndHeartIndex) {
                heartImgIndex = chartHeartIndex;
            } else {
                this.chartHeartImg = '/common/A054_0' + heartImgIndex + '.png';
                heartImgIndex++;
            }
        }, 50);
    },
    clearTimes() {
        clearInterval(this.chartHeartInterval);
        clearInterval(this.electrocardInterval);
        clearInterval(this.heartDataInterval);
    },
    clearChart() {
        this.chartTime = 30;
        this.datasets = [{ strokeColor: '#fc3159', data: [50]}];
    }
}



