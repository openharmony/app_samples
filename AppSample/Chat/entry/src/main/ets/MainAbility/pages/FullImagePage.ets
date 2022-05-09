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
// @ts-nocheck
import router from '@system.router';

@Entry
@Component
struct FullImagePage {
  @State imageStrId: string = router.getParams().imageStrId
  //第一个手指的横坐标开始
  @State picStar1x: number = 0
  //第一个手指的横坐标结束
  @State picEnd1x: number = 0
  //第一个手指移动过程中的横坐标位置
  @State picAddStar1x: number = 0
  //第一个手指的纵坐标开始
  @State picStar1y: number = 0
  //第一个手指的纵坐标结束
  @State picEnd1y: number = 0
  //第一个手指移动过程中的纵坐标位置
  @State picAddStar1y: number = 0
  //第二个手指的横坐标开始
  @State picStar2x: number = 0
  //第二个手指的横坐标结束
  @State picEnd2x: number = 0
  //第二个手指移动过程中的横坐标位置
  @State picAddStar2x: number = 0
  //第二个手指的纵坐标开始
  @State picStar2y: number = 0
  //第二个手指的纵坐标结束
  @State picEnd2y: number = 0
  //第二个手指移动过程中的纵坐标位置
  @State picAddStar2y: number = 0
  //两个手指之间的距离变化
  @State picChange: number = 0
  //开始时两个手指之间的距离
  @State now1: number = 0
  //移动中两个手指之间的距离
  @State now2: number = 0
  //图片缩放后，一个手指时的起始横坐标位置
  @State point1: number = 0
  //图片缩放后，一个手指移动时的横坐标位置
  @State point2: number = 0
  //图片缩放后，一个手指时的起始纵坐标位置
  @State point4: number = 0
  //图片缩放后，一个手指移动时的纵坐标位置
  @State point5: number = 0
  //图片的左边距
  @State marginLeft: number = 0
  //图片的上边距
  @State marginTop: number = 0
  //图片移动的左距离
  @State numLeft: number = 0
  //图片移动的上距离
  @State numTop: number = 0
  //将手指抬起时的变化记录赋值
  @State size: number = 0

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Image(`/resources/images/photo${this.imageStrId.toString()}.jpg`)
        //此处330为初始图片大小
        .width(330 + this.picChange)
        .sharedTransition('shareImage')
        .objectFit(ImageFit.Contain)
        .margin({ left: this.marginLeft, top: this.marginTop })
        .onTouch((event: TouchEvent) => {
          //判断是否是双指
          if (event.touches.length === 2) {
            this.marginLeft = 0
            if (event.type === TouchType.Down) {
              //取双指的坐标位置
              this.picStar1x = event.touches[0].x
              this.picStar1y = event.touches[0].y
              this.picStar2x = event.touches[1].x
              this.picStar2y = event.touches[1].y
            } else if (event.type === TouchType.Move) {
              //双指移动时的位置
              this.picAddStar1x = event.touches[0].x
              this.picAddStar1y = event.touches[0].y
              this.picAddStar2x = event.touches[1].x
              this.picAddStar2y = event.touches[1].y
              //勾股定理算出开始和移动时的双指距离
              this.now1 = Math.sqrt((this.picStar2x - this.picStar1x) * (this.picStar2x - this.picStar1x) + (this.picStar2y - this.picStar1y) * (this.picStar2y - this.picStar1y))
              this.now2 = Math.sqrt((this.picAddStar2x - this.picAddStar1x) * (this.picAddStar2x - this.picAddStar1x) + (this.picAddStar2y - this.picAddStar1y) * (this.picAddStar2y - this.picAddStar1y))
            } else if (event.type === TouchType.Up) {
              //将手指抬起时的变化记录赋值
              this.size = this.picChange
            }
            //双指变化的距离
            this.picChange = (this.now2 - this.now1) + this.size
            if (this.picChange < -150) {
              this.picChange = -150
            } else if (this.picChange > 200) {
              this.picChange = 200
            }
            //一个手指
          } else if (event.touches.length === 1) {
            if (event.type === TouchType.Down) {
              //获取手指的横坐标
              this.point1 = event.touches[0].x
              //获取手指的纵坐标
              this.point4 = event.touches[0].y
            } else if (event.type === TouchType.Move) {
              this.point2 = event.touches[0].x
              this.point5 = event.touches[0].y
              //只有图片放大才可以移动
              if (this.picChange != 0) {
                //变化值不为0
                if (this.numLeft != 0) {
                  this.marginLeft = this.numLeft + (this.point2 - this.point1)
                  this.marginTop = this.numTop + (this.point5 - this.point4)
                  //左边距
                  if (this.marginLeft > 200) {
                    this.marginLeft = 200
                  } else if (this.marginLeft < -100) {
                    this.marginLeft = -100
                  }
                  //上边距
                  if (this.marginTop > 200) {
                    this.marginTop = 200
                  } else if (this.marginTop < -200) {
                    this.marginTop = -200
                  }
                  //变化值为0
                } else {
                  this.marginLeft = (this.point2 - this.point1)
                  this.marginTop = (this.point5 - this.point4)
                  //左边距
                  if (this.marginLeft > 200) {
                    this.marginLeft = 200
                  } else if (this.marginLeft < -100) {
                    this.marginLeft = -100
                  }
                  //上边距
                  if (this.marginTop > 200) {
                    this.marginTop = 200
                  } else if (this.marginTop < -200) {
                    this.marginTop = -200
                  }
                }
              }
            } else if (event.type === TouchType.Up) {
              //记录值
              this.numLeft = this.marginLeft
              this.numTop = this.marginTop
            }
          }
        })
    }
    .onClick(() => {
      router.back()
    })
    .width('100%')
    .height('100%')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}