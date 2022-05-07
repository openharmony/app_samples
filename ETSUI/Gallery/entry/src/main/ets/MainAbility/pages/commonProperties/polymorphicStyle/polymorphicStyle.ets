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


import router from '@ohos.router';
import {GetColor} from "../../../common/components/getColor"
import {NavigationBar} from "../../../common/components/navigationBar"

async function routePageShoppingCar() {
  let options = {
    url: 'pages/commonProperties/polymorphicStyle/shoppingCar'
  }
  try {
    await router.push(options)
  } catch (err) {
    console.error(`fail callback, code: ${err.code}, msg: ${err.msg}`)
  }
}

@Entry
@Component
struct PolymorphicStyleSample {
  @State isEnable: boolean = true

  @State styleHeight: number = 65
  @State count1: number = 0
  @State count2: number = 0
  @State count3: number = 0
  @State setSliderStep: number = 0.1;
  @State initVal: number = 0.5;
  @State opacityVal: number = 10;
  @State  num1: number = 30
  @State itemList: any[] = [
    {
      imgSrc: '/common/mate40.png',
      detail: '麒麟',
      price: '￥ 6199.00',

      shoppingCar: '/common/ic_shopping_cart+.png',
      stock: 10
    },
    {
      imgSrc: '/common/mate40.png',
      detail: '麒麟',
      price: '￥ 6199.00',

      shoppingCar: '/common/ic_shopping_cart+.png',
      stock: 4
    },
    {
      imgSrc: '/common/mate40.png',
      detail: '麒麟',
      price: '￥ 6199.00',

      shoppingCar: '/common/ic_shopping_cart+.png',
      stock: 0
    },
  ]



  @Styles pressedStyles() {
    .backgroundColor(Color.Yellow)
    .borderRadius(1)
    .borderWidth(1)
    .borderColor("#33000000")
    .height(this.styleHeight)
    .opacity(1)
  }

  @Styles disabledStyles() {
    .backgroundColor("#E5E5E5")
    .borderRadius(10)
    .borderStyle(BorderStyle.Solid)
    .borderWidth(2)
    .borderColor("#2a4c1919")
    .opacity(this.opacityVal/100)
  }

  @Styles normalStyles() {
    .borderColor("#33000000")
    .width(100)
    .height(25)
    .opacity(1)
  }

  @Styles normalStyles1() {
    .borderColor("#33000000")
    .width('300lpx')
    .height('300lpx')
    .opacity(1)
  }

  build() {

    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: '多态样式' })
      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {

            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start }) {
              Image(this.itemList[0].imgSrc)
                .width("45%").margin(5).objectFit(ImageFit.Contain)

              Flex({
                direction: FlexDirection.Column,
                alignItems: ItemAlign.Start,
                justifyContent: FlexAlign.SpaceAround
              }) {
                Text('详情：' + this.itemList[0].detail).fontSize(15).align(Alignment.Start)
                  .stateStyles({
                    normal: this.normalStyles,
                  })
                Text('单价：' + this.itemList[0].price).fontSize(15)
                  .stateStyles({
                    pressed: this.pressedStyles,
                  })
                Row() {
                  Column(){
                    Column(){
                      Counter() {
                        Text( this.count1.toString() )
                          .fontSize('10fp')
                          .fontColor('#000000')
                          .fontWeight(FontWeight.Regular)

                      }
                      .onInc(()=>{
                        if(this.itemList[0].stock>this.count1){
                          ++this.count1
                        }
                      })
                      .onDec(()=>{
                        if(this.itemList[0].stock>this.count1 && this.count1 > 0){
                          --this.count1
                        }
                      })
                    }

                    Text( this.itemList[0].stock > this.count1 ? "有货剩余" : "库存不足" )
                      .stateStyles({
                        disabled: this.disabledStyles,
                      })
                      .fontSize(20)

                  }

                  Image(this.itemList[0].shoppingCar)
                    .margin(5)
                    .width('40lpx')
                    .height('40lpx')
                    .margin({ left: '16lpx', top:'-20lpx' })
                    .onClick(() => {
                      routePageShoppingCar()
                    })
                    .stateStyles({
                      pressed: this.pressedStyles,
                    })
                }.margin({ left: -5 })

                Text('库存：' + this.itemList[0].stock).fontSize('16fp')
              }.margin(20).height('250lpx')
            }
            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start }) {
              Image(this.itemList[1].imgSrc)
                .width("45%").margin(5).objectFit(ImageFit.Contain)

              Flex({
                direction: FlexDirection.Column,
                alignItems: ItemAlign.Start,
                justifyContent: FlexAlign.SpaceAround
              }) {
                Text('详情：' + this.itemList[1].detail).fontSize(15).align(Alignment.Start)
                  .stateStyles({
                    normal: this.normalStyles,
                  })
                Text('单价：' + this.itemList[1].price).fontSize(15)
                  .stateStyles({
                    pressed: this.pressedStyles,
                  })
                Row() {
                  Column(){
                    Counter() {
                      Text( this.count2.toString() )
                        .fontSize('10fp')
                        .fontColor('#000000')
                        .fontWeight(FontWeight.Regular)
                    }
                    .onInc(()=>{
                      if(this.itemList[1].stock>this.count2){
                        ++this.count2
                      }
                    })
                    .onDec(()=>{
                      if(this.itemList[1].stock>this.count2 && this.count2 > 0){
                        --this.count2
                      }
                    })
                    Text( this.itemList[1].stock > this.count2 ? "有货剩余" : "库存不足" )
                      .stateStyles({
                        disabled: this.disabledStyles,
                      })
                      .fontSize(20)
                  }
                  Image(this.itemList[1].shoppingCar)
                    .margin(5)
                    .width('40lpx')
                    .height('40lpx')
                    .margin({ left: '16lpx', top:'-20lpx' })
                    .onClick(() => {
                      routePageShoppingCar()
                    })
                    .stateStyles({
                      pressed: this.pressedStyles,
                    })
                }.margin({ left: -5 })

                Text('库存：' + this.itemList[1].stock).fontSize('16fp')
              }.margin(20).height('250lpx')
            }
            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start }) {
              Image(this.itemList[2].imgSrc)
                .width("45%").margin(5).objectFit(ImageFit.Contain)

              Flex({
                direction: FlexDirection.Column,
                alignItems: ItemAlign.Start,
                justifyContent: FlexAlign.SpaceAround
              }) {
                Text('详情：' + this.itemList[2].detail).fontSize(15).align(Alignment.Start)
                  .stateStyles({
                    normal: this.normalStyles,
                  })
                Text('单价：' + this.itemList[2].price).fontSize(15)
                  .stateStyles({
                    pressed: this.pressedStyles,
                  })
                Row() {
                  Column(){
                    Column(){
                      Counter() {
                        Text( this.count3.toString() )
                          .fontSize('10fp')
                          .fontColor('#000000')
                          .fontWeight(FontWeight.Regular)

                      }
                      .onInc(()=>{
                        if(this.itemList[2].stock>this.count3){
                          ++this.count3
                        }
                      })
                      .onDec(()=>{
                        if(this.itemList[2].stock>this.count3 && this.count3>0){
                          --this.count3
                        }
                      })
                    }

                    Text( this.itemList[2].stock > this.count3 ? "有货剩余" : "库存不足" )

                      .stateStyles({
                        disabled: this.disabledStyles,
                      })
                      .fontSize(20)

                  }

                  Image(this.itemList[2].shoppingCar)
                    .margin(5)
                    .width('40lpx')
                    .height('40lpx')
                    .margin({ left: '16lpx', top:'-20lpx' })
                    .onClick(() => {
                      routePageShoppingCar()
                    })
                    .stateStyles({
                      pressed: this.pressedStyles,
                    })
                }.margin({ left: -5 })

                Text('库存：' + this.itemList[2].stock).fontSize('16fp')
              }.margin(15).height('250lpx')
            }
          }
          .width('100%').backgroundColor('#FFFFFF')
        }
        .width('100%')
        .height("70%")
        .margin({bottom:20})

        Scroll() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('opacity')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Slider({
                value: this.opacityVal,
                step: 1,
                min: 0,
                max: 100,
              })
                .width('80%')
                .onChange((value) => {
                  this.opacityVal = value
                  console.log(this.opacityVal.toString())
                })
            }
            .width('100%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .margin({ top: 8, bottom: 8 })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('width')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Column() {
                Counter() {
                  Text(this.styleHeight.toString())
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('10fp')
                }

                .onInc(() => {
                  this.styleHeight++
                })
                .onDec(() => {
                  if(this.styleHeight>40){
                    --this.styleHeight
                  }
                })
                .height(24)
              }
            }
            .width('100%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .margin({ top: 8, bottom: 8 })
          }.width('100%')
        }
        .width('100%')
      }
    }
    .backgroundColor('#F1F3F5')
    .width('100%')
    .padding({ left: '3%', right: '3%', bottom: 10})
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