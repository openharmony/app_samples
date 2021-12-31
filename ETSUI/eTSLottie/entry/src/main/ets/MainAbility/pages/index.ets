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

import lottie from 'lottie-web'
import prompt from '@system.prompt'

@Entry
@Component
struct Index {
  private controller: RenderingContext = new RenderingContext()
  private controller1: RenderingContext = new RenderingContext()
  private scroller: Scroller = new Scroller()
  private animateItem: any = null
  private animateName: string = "grunt"
  private animatePath1: string = "common/lottie/ventilation_1.json"
  private animatePath2: string = "common/lottie/AcSystemCleaning_Open.json"
  private callbackItem: any = function () {
    console.log("EventListener");
  };
  private triggerCallBack: any = function (item) {
    console.log("trigger loopComplete, name:" + item.name);
  };

  private aboutToAppear(): void  {
    console.log('aboutToDisappear');
  }

  private aboutToDisappear(): void {
    console.log('aboutToDisappear');
  }

  private onPageShow(): void {
    console.log('onPageShow');
  }

  private onPageHide(): void {
    console.log('onPageHide');
    lottie.destroy();
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.controller)
        .width(480 + 'px')
        .height(320 + 'px')
        .backgroundColor('#3366FF')
        .onDisAppear(() => {
          lottie.destroy(this.animateName);
        })
      Canvas(this.controller1)
        .width(480 + 'px')
        .height(320 + 'px')
        .backgroundColor('#0099FF')
        .onAppear(() => {
          console.log('canvas onAppear');
          let ani = lottie.loadAnimation({
            container: this.controller1,
            renderer: 'canvas',
            loop: true,
            autoplay: true,
            name: 'clock',
            path: this.animatePath1,
          })
        })
        .onDisAppear(() => {
          lottie.destroy('clock');
        })
      Scroll(this.scroller) {
        Column() {
          Row() {
            Button('load ui-clean')
              .onClick(() => {
                this.animateItem = lottie.loadAnimation({
                  container: this.controller,
                  renderer: 'canvas',
                  loop: true,
                  autoplay: true,
                  name: this.animateName,
                  path: this.animatePath2,
                })
                console.log("start lottie end.");
              })
            Button('load clock')
              .onClick(() => {
                let ani = lottie.loadAnimation({
                  container: this.controller1,
                  renderer: 'canvas',
                  loop: true,
                  autoplay: true,
                  name: 'clock',
                  path: this.animatePath1,
                })
              })
            Button('Debug')
              .onClick(() => {
                if (this.animateItem != null) {
                  prompt.showToast({ message: "grunt animate Item name:" + this.animateItem.name, duration: 5000 });
                  console.log("grunt animate Item name:" + this.animateItem.name);
                  console.log("grunt animate Item isLoaded:" + this.animateItem.isLoaded);
                  console.log("grunt animate Item currentFrame:" + this.animateItem.currentFrame);
                  console.log("grunt animate Item currentRawFrame:" + this.animateItem.currentRawFrame);
                  console.log("grunt animate Item firstFrame:" + this.animateItem.firstFrame);
                  console.log("grunt animate Item totalFrames:" + this.animateItem.totalFrames);
                  console.log("grunt animate Item frameRate:" + this.animateItem.frameRate);
                  console.log("grunt animate Item frameMult:" + this.animateItem.frameMult);
                  console.log("grunt animate Item playSpeed:" + this.animateItem.playSpeed);
                  console.log("grunt animate Item playDirection:" + this.animateItem.playDirection);
                  console.log("grunt animate Item playCount:" + this.animateItem.playCount);
                  console.log("grunt animate Item isPaused:" + this.animateItem.isPaused);
                  console.log("grunt animate Item autoplay:" + this.animateItem.autoplay);
                  console.log("grunt animate Item loop:" + this.animateItem.loop);
                  console.log("grunt animate Item renderer:" + this.animateItem.renderer);
                  console.log("grunt animate Item animationID:" + this.animateItem.animationID);
                  console.log("grunt animate Item timeCompleted:" + this.animateItem.timeCompleted);
                  console.log("grunt animate Item segmentPos:" + this.animateItem.segmentPos);
                  console.log("grunt animate Item isSubframeEnabled:" + this.animateItem.isSubframeEnabled);
                  console.log("grunt animate Item segments:" + this.animateItem.segments);
                  console.log("grunt animate Item getDuration(true):" + this.animateItem.getDuration(true) + 'fr');
                  console.log("grunt animate Item getDuration(false):" + this.animateItem.getDuration(false) + 's');
                  console.log("grunt animate Item getDuration():" + this.animateItem.getDuration() + 's');
                }
              })
          }.border({ width: 1 }).padding(10).width('98%')

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, alignContent: FlexAlign.SpaceAround }) {
            Text('lottie-control-All').fontSize(10).width('90%').fontColor(0xcccccc).margin({ bottom: 10 })
            Button('togglePause')
              .onClick(() => {
                lottie.togglePause();
              })
            Button('stop')
              .onClick(() => {
                lottie.stop();
              })
            Button('pause')
              .onClick(() => {
                lottie.pause();
              })
            Button('play')
              .onClick(() => {
                lottie.play();
              })
            Button('setSpeed')
              .onClick(() => {
                lottie.setSpeed(5);
              })
            Button('direction')
              .onClick(() => {
                lottie.setDirection(-1);
              })
            Button('destroy')
              .onClick(() => {
                if (this.animateItem != null) {
                  lottie.destroy();
                }
              })
          }.border({ width: 1 }).padding(5).width('98%').height(120)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, alignContent: FlexAlign.SpaceAround }) {
            Text(' lottie-ui-clean').fontSize(10).width('90%').fontColor(0xcccccc).margin({ bottom: 10 })
            Button('togglePause')
              .onClick(() => {
                lottie.togglePause(this.animateName);
              })

            Button('stop')
              .onClick(() => {
                lottie.stop(this.animateName);
              })

            Button('pause')
              .onClick(() => {
                lottie.pause(this.animateName);
              })

            Button('play')
              .onClick(() => {
                lottie.play(this.animateName);
              })

            Button('setSpeed')
              .onClick(() => {
                lottie.setSpeed(-5, this.animateName);
              })

            Button('direction')
              .onClick(() => {
                lottie.setDirection(-1, this.animateName);
              })
          }.border({ width: 1 }).padding(5).width('98%').height(120)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, alignContent: FlexAlign.SpaceAround }) {
            Text('AnimationItem-common').fontSize(10).width('90%').fontColor(0xcccccc).margin({ bottom: 10 })
            Button('togglePause')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.togglePause();
                }
              })
            Button('stop')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.stop();
                }
              })

            Button('pause')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.pause();
                }
              })

            Button('play')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.play();
                }
              })

            Button('setSpeed')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.setSpeed(15);
                }
              })

            Button('direction')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.setDirection(-1);
                }
              })


            Button('destroy')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.destroy(this.animateItem)
                }
              })
          }.border({ width: 1 }).padding(5).width('98%').height(120)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, alignContent: FlexAlign.SpaceAround }) {
            Text('AnimationItem-Segments').fontSize(10).width('90%').fontColor(0xcccccc).margin({ bottom: 10 })
            Button('playSegments')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.playSegments([[10, 200]], true);
                }
              })
            Button('resetSegments')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.resetSegments(false);
                }
              })
            Button('setSubframe')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.setSubframe(false);
                }
              })
          }.border({ width: 1 }).padding(5).width('98%').height(120)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, alignContent: FlexAlign.SpaceAround }) {
            Text('AnimationItem-goToPlay/Stop').fontSize(10).width('90%').fontColor(0xcccccc).margin({ bottom: 10 })
            Button('ToStop(250)')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.goToAndStop(250, true);
                }
              })
            Button('ToStop(5000)')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.goToAndStop(5000, false);
                }
              })
            Button('ToPlay(250)')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.goToAndPlay(250, true);
                }
              })

            Button('ToPlay(12000)')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.goToAndPlay(12000, false);
                }
              })
          }.border({ width: 1 }).padding(5).width('98%').height(120)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, alignContent: FlexAlign.SpaceAround }) {
            Text('AnimationItem-resize/destory').fontSize(10).width('90%').fontColor(0xcccccc).margin({ bottom: 10 })
            Button('resize')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.resize();
                }
              })
            Button('AnimationItem-destroy')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.destroy(this.animateName);
                }
              })
            Button('lottie-destroy')
              .onClick(() => {
                if (this.animateItem != null) {
                  lottie.destroy(this.animateName);
                }
              })
          }.border({ width: 1 }).padding(5).width('98%').height(120)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, alignContent: FlexAlign.SpaceAround }) {
            Text('AnimationItem-event').fontSize(10).width('90%').fontColor(0xcccccc).margin({ bottom: 10 })
            Button('addEvent')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.addEventListener('loopComplete', this.callbackItem);
                }
              })
            Button('delEvent')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.removeEventListener('loopComplete', this.callbackItem);
                }
              })
            Button('trigEvent')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.addEventListener('loopComplete', this.triggerCallBack);
                  this.animateItem.triggerEvent('loopComplete', this.animateItem);
                  this.animateItem.removeEventListener('loopComplete', this.triggerCallBack);
                }
              })
            Button('delAllEvent')
              .onClick(() => {
                if (this.animateItem != null) {
                  this.animateItem.addEventListener('loopComplete', this.triggerCallBack);
                  this.animateItem.removeEventListener('loopComplete', this.callbackItem);
                  this.animateItem.removeEventListener('loopComplete');
                }
              })
          }.border({ width: 1 }).padding(10).width('98%').height(120)
        }
      }.margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
  }
}
