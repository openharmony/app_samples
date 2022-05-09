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

import { NavigationBar } from "../../common/components/navigationBar"
import prompt from '@ohos.prompt';

@Entry
@Component
struct GestureLockSample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State canvasWidth: number = 630
  @State canvasHeight: number = 630
  @State circleNum: number = 3
  @State arr: any[] = []
  @State lastPoint: {
    x: number,
    y: number,
    index: number
  }[] = []
  @State restPoint: any[] = []
  @State count: number = 0
  @State touchFlag: boolean = false
  @State textContent: string = '手势密码解锁'
  //以给定坐标点为圆心画出单个圆
  private drawCircle(x, y) {
    this.context.strokeStyle = "#abcdef";
    this.context.lineWidth = 2;
    this.context.beginPath();
    this.context.arc(x, y, 45, 0, 2 * Math.PI, true);
    this.context.closePath();
    this.context.stroke();
  }
  //绘制所有的圆
  private createCircle() {
    this.lastPoint = []
    let n = this.circleNum
    this.arr = []
    this.restPoint = []
    for (let i = 0;i < n; i++) {
      for (let j = 0;j < n; j++) {
        this.count++
        let obj = {
          x: (4 * j + 3) * 45,
          y: (4 * i + 3) * 45,
          index: this.count //给每个圆标记索引
        }
        this.arr.push(obj)
        this.restPoint.push(obj)
      }
    }
    this.count = 0
    //清屏
    this.context.clearRect(0, 0, this.canvasWidth, this.canvasHeight);
    //以给定坐标点为圆心画出所有圆
    for (let i = 0;i < this.arr.length; i++) {
      //循环调用画单个圆的方法
      this.drawCircle(this.arr[i].x, this.arr[i].y);
    }
  }
  //判断输入的密码
  private checkPass(lastPoint) {
    let pwd1 = "1235789", //成功的密码
      pwd2 = "";
    for (let i = 0;i < lastPoint.length; i++) {
      pwd2 += lastPoint[i].index;
    }
    if (pwd1 === pwd2) {
      this.textContent = '图案解锁成功'
      this.drawStatusPoint('green')
    } else {
      this.textContent = '图案绘制不正确'
      this.drawStatusPoint('red')
    }
  }
  //  判断结束后的状态
  private drawStatusPoint(type) {
    for (let i = 0;i < this.lastPoint.length; i++) {
      this.context.strokeStyle = type;
      this.context.beginPath();
      this.context.arc(this.lastPoint[i].x, this.lastPoint[i].y, 45, 0, 2 * Math.PI, true);
      this.context.closePath();
      this.context.stroke();
    }
  }
  //  程序全部结束后重置
  private reset() {
    this.createCircle()
  }
  build() {
    Column() {
      NavigationBar({ title: '触摸事件' })
      Text(this.textContent)
        .fontSize(30)
        .fontWeight(FontWeight.Regular)
        .margin(10)

      Column() {
        Canvas(this.context)
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Orange)
          .onReady(() => {
            this.createCircle()
          })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.lastPoint = []
              for (let i = 0; i < this.arr.length; i++) {
                if (
                Math.abs(event.touches[0].x - this.arr[i].x) < 45 &&
                Math.abs(event.touches[0].y - this.arr[i].y) < 45
                ) {
                  this.touchFlag = true;
                  this.lastPoint.push(this.arr[i]);
                  this.restPoint.splice(i, 1);
                  break;
                }
              }
            }

            if (event.type === TouchType.Move) {
              if (this.touchFlag) {
                //清屏
                this.context.clearRect(0, 0, this.canvasWidth, this.canvasHeight);
                for (let i = 0;i < this.arr.length; i++) {
                  this.drawCircle(this.arr[i].x, this.arr[i].y);
                }
                //画实心圆
                for (let i = 0; i < this.lastPoint.length; i++) {
                  this.context.fillStyle = "#cfe6ff";
                  this.context.beginPath();
                  this.context.arc(
                    this.lastPoint[i].x,
                    this.lastPoint[i].y,
                    45 / 2,
                    0,
                    Math.PI * 2,
                    true
                  );
                  this.context.closePath();
                  this.context.fill();
                }
                //画线
                this.context.beginPath();
                this.context.lineWidth = 3;
                this.context.moveTo(this.lastPoint[0].x, this.lastPoint[0].y); //线条起点
                for (let i = 1; i < this.lastPoint.length; i++) {
                  this.context.lineTo(this.lastPoint[i].x, this.lastPoint[i].y); //线条终点
                }
                this.context.lineTo(event.touches[0].x, event.touches[0].y); //触摸的点
                this.context.stroke();
                this.context.closePath();

                for (let i = 0; i < this.restPoint.length; i++) {
                  if (
                  Math.abs(event.touches[0].x - this.restPoint[i].x) < 45 &&
                  Math.abs(event.touches[0].y - this.restPoint[i].y) < 45
                  ) {
                    this.lastPoint.push(this.restPoint[i]);
                    this.restPoint.splice(i, 1);
                    break;
                  }
                }
              }
            }
            if (event.type === TouchType.Up) {
              if (this.touchFlag) {
                this.checkPass(this.lastPoint)
                this.reset()
              }
            }
          })
      }
      .width(630)
      .height(630)
      .backgroundColor(Color.Orange)
      .margin({ top: 20, left: 50, right: 50 })
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%' })
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