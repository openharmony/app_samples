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

@Component
export struct FlipClock{

  @State timeOne : Array<number> = []
  @State timeTwo : Array<number> = []
  @State timeThree : Array<number> = []
  @State timeFour : Array<number> = []
  @State angleOne : Array<number> = [0,0,0,0,0,0]
  @State angleTwo : Array<number> = [-90,-90,-90,-90,-90,-90]

  aboutToAppear(){
    const arr=this.changeTime()
    this.timeOne=[...arr]
    this.timeTwo=[...arr]
    this.timeThree=[...arr]
    this.timeFour=[...arr]
    setInterval(()=>{
      const time=new Date()
      if(this.timeOne[5]!=time.getSeconds()%10){
        const arr=this.changeTime()
        for(let i=0;i<6;i++){
          if(arr[i]!=this.timeFour[i]){
            this.timeFour[i]=arr[i]
            this.animationOne(i)
            setTimeout(()=>{
              this.timeTwo[i]=arr[i]
              setTimeout(()=>{
                this.timeThree[i]=arr[i]
                setTimeout(()=>{
                  this.timeOne[i]=arr[i]
                },180)
              },180)
            },90)
          }
        }
      }
    },10)
  }

  //修改时间
  changeTime(){
    const time=new Date()
    const hour=time.getHours()
    const hourOne=Math.floor(hour/10)
    const hourTwo=hour%10
    const minutesOne=Math.floor(time.getMinutes()/10)
    const minutesTwo=time.getMinutes()%10
    const secondsOne=Math.floor(time.getSeconds()/10)
    const secondsTwo=time.getSeconds()%10
    return [hourOne,hourTwo,minutesOne,minutesTwo,secondsOne,secondsTwo]
  }

  animationOne(i){
    animateTo({
      duration:370,
      delay:0,
      iterations:1,
      onFinish:()=>{
        this.animationTwo(i)
        this.angleOne[i]=0
      }
    },()=>this.angleOne[i]=90)
  }

  animationTwo(i){
    animateTo({
      duration:370,
      delay:0,
      iterations:1,
      onFinish:()=>{
        this.angleTwo[i]=-90
      }
    },()=>this.angleTwo[i]=0)
  }

  @Builder box(num){
    Column(){
      Divider()
        .zIndex(5)
        .strokeWidth(2)
        .color('#ffffff')
        .position({x:0,y:'50%'})
      Text(this.timeOne[num].toString())
        .zIndex(1)
        .height(108)
        .width('100%')
        .borderRadius(8)
        .fontWeight(700)
        .padding({top:0})
        .fontSize('90vp')
        .position({x:0,y:0})
        .fontColor('#ffffff')
        .fontFamily('Monospace')
        .backgroundColor('#000000')
        .textAlign(TextAlign.Center)

      Text(this.timeTwo[num].toString())
        .zIndex(2)
        .height(64)
        .width('100%')
        .fontWeight(700)
        .borderRadius(8)
        .padding({top:3})
        .fontSize('90vp')
        .position({x:0,y:0})
        .fontColor('#ffffff')
        .fontFamily('Monospace')
        .backgroundColor('#000000')
        .textAlign(TextAlign.Center)

      Text(this.timeThree[num].toString())
        .zIndex(4)
        .height(64)
        .width('100%')
        .fontWeight(700)
        .borderRadius(8)
        .padding({top:3})
        .fontSize('90vp')
        .position({x:0,y:0})
        .fontColor('#ffffff')
        .fontFamily('Monospace')
        .textAlign(TextAlign.Center)
        .backgroundColor('#000000')
        .rotate({
          x:1,
          y:0,
          z:0,
          centerX:'50%',
          centerY:'100%',
          angle:this.angleOne[num]
        })

      Text(this.timeFour[num].toString())
        .zIndex(3)
        .height(108)
        .width('100%')
        .fontWeight(700)
        .borderRadius(8)
        .padding({top:0})
        .fontSize('90vp')
        .position({x:0,y:0})
        .fontColor('#ffffff')
        .fontFamily('Monospace')
        .backgroundColor('#000000')
        .textAlign(TextAlign.Center)
        .rotate({
          x:1,
          y:0,
          z:0,
          centerX:'50%',
          centerY:'50%',
          angle:this.angleTwo[num]
        })
    }
    .height(108)
    .width('40%')
  }
  build() {
    Flex({alignItems:ItemAlign.Center,justifyContent:FlexAlign.Center}){
      Flex({alignItems:ItemAlign.Center,justifyContent:FlexAlign.Center}){
        Row({space:2}){
          this.box(0)
          this.box(1)
        }
      }
      .width('33%')
      .height('15%')
      Image($r('app.media.dot'))
        .width(20)
        .height(50)
      Flex({alignItems:ItemAlign.Center,justifyContent:FlexAlign.Center}){
        Row({space:2}){
          this.box(2)
          this.box(3)
        }
      }
      .width('33%')
      .height('15%')
      Image($r('app.media.dot'))
        .width(20)
        .height(50)
      Flex({alignItems:ItemAlign.Center,justifyContent:FlexAlign.Center}){
        Row({space:2}){
          this.box(4)
          this.box(5)
        }
      }
      .width('33%')
      .height('15%')
    }
    .width('100%')
    .height('100%')
  }
}