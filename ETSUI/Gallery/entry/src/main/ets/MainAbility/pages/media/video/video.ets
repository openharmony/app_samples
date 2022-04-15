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
@Entry
@Component
struct Template {
  @State rate: number  = 1;
  @State progressStyleString: string = '1';
  @State value: string = "hello world"
  @State color: Color = Color.Black
  @State srcs: string = "/common/video1.mp4";
  @State currentProgressRates: number = 1;  @State autoPlayss: boolean = false;

  @State controlsss: boolean = true;
  myVideoController: VideoController = new VideoController();
  @State startStaus: boolean = true;
  @State muteds: boolean = false
  @State isShow: boolean = false
  @State isLoop: boolean= false;
  @State visible: Visibility= Visibility.None;
  build() {
    Flex({ direction: FlexDirection.Column , alignItems: ItemAlign.Center}) {
      NavigationBar({ title: 'Video' })
      //上部分显示效果
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Video({
          src: this.srcs,
          currentProgressRate: this.currentProgressRates,
          controller: this.myVideoController
        })
          .width('100%')
          .height('100%')
          .loop(this.isLoop)
          .autoPlay(this.autoPlayss)
          .controls(this.controlsss)
          .muted(this.muteds)
          .onStart(() => {
            console.error('onStart');
          })
          .onPause(() => {
            console.error('onPause');
          })
          .onFinish(() => {
            console.error('onFinish');
          })
          .onError(() => {
            console.error('onFinish');
            this.isShow = true
          })
          .onPrepared((e) => {
            console.error('onPrepared is ' + e.duration);
          })
          .onSeeking((e) => {
            console.error('onSeeking is ' + e.time);
          })
          .onSeeked((e) => {
            console.error('onSeekedis ' + e.time);
          })
          .onUpdate((e) => {
            console.error('onUpdateis ' + e.time);
          })
      }
      .width('100%')
      Scroll() {
        Column() {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,  }) {
            Column() {
              Flex ({ justifyContent: FlexAlign.SpaceBetween }) {
                Button("start").onClick(() => {
                  this.myVideoController.start();
                }).width(80).height(40)
                Button("pause").onClick(() => {
                  this.myVideoController.pause();
                }).width(80).height(40)
                Button("stop").onClick(() => {
                  this.myVideoController.stop();
                  this.muteds = false
                  this.autoPlayss = false
                  this.isLoop = false
                }).width(80).height(40)
              }.width("100%").margin({ bottom: 20 })
              Flex({ justifyContent: FlexAlign.SpaceBetween}) {
                Button() {
                  Text('isLoop').fontSize(16).fontColor(Color.White)
                }.width(80).height(40).onClick(() => {
                  this.isLoop = !this.isLoop
                })
                Button("src").width(80).height(40).onClick(() => {
                  if (this.srcs == "http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4") {
                    console.log(this.srcs)
                    this.srcs = '/common/video1.mp4'
                  } else {
                    console.log(this.srcs)
                    this.srcs = "http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4";
                  }
                });
                Button("muted").onClick(() => {
                  this.muteds = !this.muteds
                });
              }.width("100%").margin({ bottom: 20 })
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Button("autoPlays").onClick(() => {
                    this.autoPlayss = !this.autoPlayss
                  }).width(155);
                }
                Row() {
                  Button("setCurrentTime").onClick(() => {
                    this.myVideoController.setCurrentTime(9);
                  }).width(155);
                }
              }.width("100%")
              .margin({ bottom: 8 })
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text('Rate')
                  .fontColor('#182431')
                  .fontSize('16fp')
                  .fontWeight(FontWeight.Medium)
                  .opacity(0.5)
                Column() {
                  Text(`${this.rate}`)
                    .fontColor('#182431')
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }
                .bindMenu([
                  {
                    value: '0.75',
                    action: () => {
                      console.info('handle Menu1 select')
                      this.rate = 0.75
                      this.currentProgressRates = 0.75
                    }
                  },
                  {
                    value: '1',
                    action: () => {
                      console.info('handle Menu2 select')
                      this.rate = 1
                      this.currentProgressRates = 1
                    }
                  },
                  {
                    value: '1.25',
                    action: () => {
                      this.rate = 1.25
                      this.currentProgressRates = 1.25
                    }
                  },
                  {
                    value: '1.75',
                    action: () => {
                      this.rate = 1.75
                      this.currentProgressRates = 1.75
                    }
                  },
                  {
                    value: '2',
                    action: () => {
                      this.rate = 2
                      this.currentProgressRates = 2
                    }
                  }
                ])
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8, bottom: 8 })
            }
          }.width("95%")
        }
        .width('100%')
      }
      .width('100%')
      .height('60%')
      .margin({ top: 20 })
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })
  }
}