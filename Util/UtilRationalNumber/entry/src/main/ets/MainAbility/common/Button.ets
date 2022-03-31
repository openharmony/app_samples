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

import util from '@ohos.util';

@Component
export struct ButtonComponent {
  private options: Resource [] = [$r('app.string.compare'), $r('app.string.get'), $r('app.string.getDenominator'),
  $r('app.string.isZero'), $r('app.string.isNaN'), $r('app.string.isFinite')]
  private rationalNumber = new util.RationalNumber(1, 2)
  @Link textTitle: string

  compareTo() {
    let rational = new util.RationalNumber(3, 4)
    let result = this.rationalNumber.compareTo(rational)
    console.log('ButtonComponent compareTo =' + result);
    if (result == 0) {
      this.textTitle = '有理数a和有理数b相等'
    }
    if (result == 1) {
      this.textTitle = '有理数a小于有理数b'
    }
    if (result == -1) {
      this.textTitle = '有理数a大于有理数b'
    }
  }

  getValueOf() {
    let valueOf = this.rationalNumber.valueOf();
    console.log('ButtonComponent valueOf' + valueOf);
    this.textTitle = '以整数形式或者浮点数的形式获取有理数a的值是' + valueOf
  }

  getDenominator() {
    let numerator = this.rationalNumber.getNumerator()
    let denominator = this.rationalNumber.getDenominator()
    console.log('ButtonComponent get' + numerator + '----- ' + denominator);
    this.textTitle = '有理数a的分子是:' + numerator + '分母是:' + denominator
  }

  isZero() {
    let isZero = this.rationalNumber.isZero();
    console.log('ButtonComponent isZero' + isZero);
    if (isZero) {
      this.textTitle = '有理数a为0'
    } else {
      this.textTitle = '有理数a不为0'
    }
  }

  isNaN() {
    let isNaN = this.rationalNumber.isNaN();
    console.log('ButtonComponent isNaN' + isNaN);
    if (isNaN) {
      this.textTitle = '有理数a表示非数字值'
    } else {
      this.textTitle = '有理数a不表示非数字值'
    }
  }

  isFinite() {
    let isFinite = this.rationalNumber.isFinite();
    console.log('ButtonComponent isFinite' + isFinite);
    if (isFinite) {
      this.textTitle = '有理数a表示有限值'
    } else {
      this.textTitle = '有理数a表示非有限值'
    }
  }

  build() {
    Column() {
      ForEach(this.options, (item, index) => {
        Button() {
          Text(item)
            .fontSize(25)
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)
            .width('80%')
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .height(50)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          switch (index) {
            case 0:
              this.compareTo()
              break
            case 1:
              this.getValueOf()
              break
            case 2:
              this.getDenominator()
              break
            case 3:
              this.isZero()
              break
            case 4:
              this.isNaN()
              break
            case 5:
              this.isFinite()
              break
            default:
              break
          }
        })
      }, item => JSON.stringify(item))
    }
  }
}
