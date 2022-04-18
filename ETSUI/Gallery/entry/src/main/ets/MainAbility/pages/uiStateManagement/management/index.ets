/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { NavigationBar } from "../../../common/components/navigationBar"

const WEEKS: String[] = ['一', '二', '三', '四', '五', '六', '日']

function isLeapYear(year: number) {
  return (year % 4 == 0 && year % 100 != 0 || year % 400 == 0)
}

function getTotalDays(year: number, month: number) {
  if (month == 2) {
    return isLeapYear(year) ? 29 : 28;
  } else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
    return 31;
  } else {
    return 30
  }
}

@Entry
@Component
struct ManagementSample {
  @State year: number = (new Date).getFullYear()
  @State month: number = (new Date).getMonth() + 1
  @State day: number = (new Date).getDate()
  @State week: number = (new Date).getDay()
  @State selectMonth: number = (new Date).getMonth() + 1;
  @State selectDay: number = (new Date).getDate();

  build() {
    Column() {
      NavigationBar({ title: '@State&@Link&@Prop' })
      Column() {
        Clock()

        NowDate({ nowYear: this.year, nowMonth: this.selectMonth, nowDay: this.selectDay })

        ShowCalendar({
          currentYear: this.year,
          currentMonth: this.selectMonth,
          currentDay: this.day,
          currentWeek: this.week,
          selectMonth: $selectMonth,
          selectDay: $selectDay,
        })
      }
      .width('95%')
      .height('70%')
      .backgroundColor('#666')
    }.width('100%')
    .padding({ left: '3%', right: '3%', bottom: 10 })
  }
}

@Component
struct Clock {
  @State hour: number = 0
  @State minute: number = 0
  @State second: number = 0
  @State timerId: Number = -1

  private aboutToAppear() {
    this.timerId = setInterval(() => {
      this.hour = (new Date).getHours()
      this.minute = (new Date).getMinutes()
      this.second = (new Date).getSeconds()
    }, 1000)
  }

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Center
      }) {
        Row() {
          Text(`${this.hour < 10 ? '0' + this.hour : this.hour}:`)
            .fontSize(48)
            .fontColor('#fff')
          Text(`${this.minute < 10 ? '0' + this.minute : this.minute}:`)
            .fontSize(48)
            .fontColor('#fff')
          Text(`${this.second < 10 ? '0' + this.second : this.second}`)
            .fontSize(48)
            .fontColor('#fff')
        }
      }
      .margin({ left: 20, top: 20 })
    }
  }
}

@Component
struct NowDate {
  @Prop nowDay: number
  @Prop nowYear: number
  @Prop nowMonth: number

  build() {
    Column() {
      Text(`${this.nowYear}年${this.nowMonth}月${this.nowDay}日`)
        .fontColor('#fff')
        .margin({ top: 20, left: 20 })
        .fontSize(24)
        .fontColor('#87CEFA')
        .alignSelf(ItemAlign.Start)
      Divider()
        .height(1)
        .backgroundColor('#fff')
        .margin({ top: 20, bottom: 10 })
    }
  }
}

@Component
struct ShowCalendar {
  private days: number[] = [...Array(42).keys()]
  @State startIndex: number = 0;
  @State endIndex: number = 0;
  @Prop currentYear: number;
  @Prop currentMonth: number;
  @Prop currentDay: number;
  @Prop currentWeek: number;
  @Link selectMonth: number;
  @Link selectDay: number;

  private calcIndex() {
    let curColumn = (6 + this.currentWeek) % 7;
    let firstColumn = 7 - (this.currentDay - (curColumn + 1)) % 7;
    this.startIndex = firstColumn;
    this.endIndex = firstColumn + getTotalDays(this.currentYear, this.currentMonth);
  }

  private inRange(index: number) {
    return index >= this.startIndex && index < this.endIndex;
  }

  private isSelectDay(index: number) {
    return this.selectMonth == this.currentMonth && this.selectDay == (index - this.startIndex + 1)
  }

  private isCurrentDay(index: number) {
    return ((new Date).getMonth() + 1 == this.currentMonth) && this.currentDay == (index - this.startIndex + 1)
  }

  private selectBorderColor(day: number) {
    return this.isCurrentDay(day) ? '#000' : "#1E90FF"
  }

  aboutToAppear() {
    this.calcIndex()
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text(`${this.currentYear}年${this.currentMonth}月`).fontColor('#fff')
          .fontSize(24)
          .alignSelf(ItemAlign.Start)
          .margin({ left: 20 })

        Row() {
          Image($r('app.media.up')).width(40).height(40)
            .onClick(() => {
              if (this.currentMonth > 1) {
                let prevMonth = this.currentMonth - 1;
                let days = getTotalDays(this.currentYear, prevMonth);
                this.startIndex = 7 - (days - this.startIndex) % 7;
                this.endIndex = this.startIndex + days;
                this.currentMonth = prevMonth;
              }
            })

          Image($r('app.media.down')).width(40).height(40)
            .onClick(() => {
              if (this.currentMonth < 12) {
                let nextMonth = this.currentMonth + 1;
                let days = getTotalDays(this.currentYear, this.currentMonth);
                this.startIndex = (days + this.startIndex - 7) % 7;
                this.endIndex = this.startIndex + getTotalDays(this.currentYear, nextMonth);
                this.currentMonth = nextMonth;
              }
            })
        }.margin({ right: 12 })
      }

      Grid() {
        ForEach(WEEKS, (item: string, index: number) => {
          GridItem() {
            Text(item)
              .fontSize(22)
              .width('100%')
              .height('100%')
              .textAlign(TextAlign.Center)
              .fontColor('#fff')
          }
        }, weekday => weekday)

        ForEach(this.days,
          (day: number) => {
            GridItem() {
              if (this.inRange(day)) {
                Text(`${day - this.startIndex + 1}`)
                  .textAlign(TextAlign.Center)
                  .fontSize(20)
                  .fontColor('#fff')
                  .width('100%')
                  .height('100%')
                  .border({ width: this.isSelectDay(day) ? 2 : 0, color: this.selectBorderColor(day) })
              }
              else {
                Text('')
              }
            }
            .backgroundColor(this.isCurrentDay(day) ? '#1E90FF' : '')
            .padding(2)
            .onClick(() => {
              if (this.inRange(day)) {
                this.selectDay = day - this.startIndex + 1;
                this.selectMonth = this.currentMonth;
              }
            })
            .width('100%')
          },
          day => day)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('90%')
      .height(300)
      .margin({ top: 25 })
    }

  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }
}