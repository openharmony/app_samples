/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the MIT License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://mit-license.org/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import lottie from '@ohos/lottieETS'
import Logger from '../util/Logger'

const TAG: string = 'Lottie'

@Entry
@Component
struct Lottie {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private settings1: RenderingContextSettings = new RenderingContextSettings(true)
  private context1: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings1)
  private scroller: Scroller = new Scroller()
  private animateItem: any = null
  private animateName: string = 'grunt'
  private callbackItem: any = function () {
    Logger.info(TAG, 'grunt loopComplete')
  }
  private triggerCallBack: any = function (item) {
    Logger.info(TAG, `trigger loopComplete, name ${item.name}`)
  }
  @State valueS: AnimationStatus = AnimationStatus.Initial
  @State animationResources: string = '请选择'
  @State imagePath: Resource = $r('app.media.play')
  @State isPlaying: boolean = true
  private controller: TabsController = new TabsController()

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.context)
        .width('540px')
        .height('360px')
        .backgroundColor(Color.Gray)
        .onDisAppear(() => {
          lottie.destroy(this.animateName)
        })
        .margin({ top: 10 })

      Canvas(this.context1)
        .width('540px')
        .height('360px')
        .backgroundColor(Color.Gray)
        .onAppear(() => {
          let ani = lottie.loadAnimation({
            container: this.context1,
            renderer: 'canvas',
            loop: true,
            autoplay: true,
            name: '2016',
            path: 'common/lottie/data.json',
          })
          ani.addEventListener('loopComplete', this.callbackItem)
        })
        .onDisAppear(() => {
          lottie.destroy('2016')
        })
        .margin({ bottom: 10 })
      Scroll(this.scroller) {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.SpaceAround }) {
            Animator('__lottie_ets')
            Text($r('app.string.select'))
              .fontSize('16fp')
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Column() {
              Text(this.animationResources)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'grunt动画',
                action: () => {
                  this.animateItem = lottie.loadAnimation({
                    container: this.context,
                    renderer: 'canvas',
                    loop: true,
                    autoplay: true,
                    name: this.animateName,
                    path: 'common/lottie/grunt.json',
                  })
                  this.animationResources = 'grunt'
                }
              },
              {
                value: '2016动画',
                action: () => {
                  let ani = lottie.loadAnimation({
                    container: this.context1,
                    renderer: 'canvas',
                    loop: true,
                    autoplay: true,
                    name: '2016',
                    path: 'common/lottie/data.json',
                  })
                  this.animationResources = '2016'
                }
              },
            ])
          }
          .backgroundColor('#FFFFFF')
          .padding('3%')
          .borderRadius(24)
          .margin({ bottom: 8 })

          Flex({
            wrap: FlexWrap.Wrap,
            justifyContent: FlexAlign.Start,
            alignContent: FlexAlign.SpaceEvenly,
            alignItems: ItemAlign.Center
          }) {

            Column() {
              Image($r('app.media.suspend'))
                .width(30)
                .height(30)
                .onClick(() => {
                  this.isPlaying = !this.isPlaying
                  lottie.togglePause()
                  if (!this.isPlaying) {
                    this.imagePath = $r('app.media.suspend')
                  } else {
                    this.imagePath = $r('app.media.play')
                  }
                })
              Text($r('app.string.play_pause'))
                .fontSize('13fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .opacity(0.8)
                .margin({ top: 6 })
                .fontFamily('Microsoft YaHei')
            }
            .width('25%')

            Column() {
              Image($r('app.media.stop_playing'))
                .objectFit(ImageFit.Cover)
                .width(30)
                .height(30)
                .onClick(() => {
                  lottie.stop()
                  this.isPlaying = false
                })
              Text($r('app.string.stop'))
                .fontSize('13fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .opacity(0.8)
                .margin({ top: 6 })
                .fontFamily('Microsoft YaHei')
            }
            .width('25%')

            Column() {
              Image($r('app.media.pause'))
                .objectFit(ImageFit.Cover)
                .width(30)
                .height(30)
                .onClick(() => {
                  lottie.pause()
                  this.isPlaying = false
                })
              Text($r('app.string.pause'))
                .fontSize('13fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .opacity(0.8)
                .margin({ top: 6 })
                .fontFamily('Microsoft YaHei')
            }
            .width('25%')

            Column() {
              Image($r('app.media.start'))
                .width(30)
                .height(30)
                .objectFit(ImageFit.Fill)
                .onClick(() => {
                  lottie.play()
                  this.isPlaying = true
                })
              Text($r('app.string.start_play'))
                .fontSize('13fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .opacity(0.8)
                .margin({ top: 6 })
                .fontFamily('Microsoft YaHei')
            }
            .width('25%')

            Column() {
              Image($r('app.media.speed'))
                .width(30)
                .height(30)
                .objectFit(ImageFit.Fill)
                .bindMenu([
                  {
                    value: '×1',
                    action: () => {
                      lottie.setSpeed(1)
                    }
                  },
                  {
                    value: '×2',
                    action: () => {
                      lottie.setSpeed(2)
                    }
                  },
                  {
                    value: '×3',
                    action: () => {
                      lottie.setSpeed(5)
                    }
                  }
                ])
              Text($r('app.string.speed'))
                .fontSize('13fp')
                .fontColor("#182431")
                .fontWeight(FontWeight.Medium)
                .opacity(0.8)
                .margin({ top: 6 })
                .fontFamily('Microsoft YaHei')
            }
            .width('25%')

            Column() {
              Image($r('app.media.forward'))
                .width(30)
                .height(30)
                .objectFit(ImageFit.Fill)
                .bindMenu([
                  {
                    value: '正向',
                    action: () => {
                      lottie.setDirection(1)
                    }
                  },
                  {
                    value: '反向',
                    action: () => {
                      lottie.setDirection(-1)
                    }
                  }
                ])
              Text($r('app.string.play_order'))
                .fontSize('13fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .opacity(0.8)
                .margin({ top: 6 })
                .fontFamily('Microsoft YaHei')
            }
            .width('25%')

            Column() {
              Image($r('app.media.ic_public_delete_filled'))
                .width(30)
                .height(30)
                .colorBlend(Color.White)
                .onClick(() => {
                  lottie.destroy()
                })
              Text($r('app.string.destruction_animation'))
                .fontSize('13fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .opacity(0.8)
                .margin({ top: 6 })
                .fontFamily('Microsoft YaHei')
            }
            .width('25%')
          }
          .height('26%')
          .backgroundColor('#FFFFFF')
          .padding('3%')
          .borderRadius(24)
          .margin({ bottom: 8 })

          Column() {
            Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
              TabContent() {
                Column() {
                  Text($r('app.string.display_effect'))
                    .fontSize('13fp')
                    .margin({ top: 10, bottom: 10 })
                  Flex({
                    wrap: FlexWrap.Wrap,
                    justifyContent: FlexAlign.SpaceEvenly,
                    alignContent: FlexAlign.SpaceAround
                  }) {

                    Column() {
                      Image($r('app.media.start_stop'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          lottie.togglePause(this.animateName)
                        })
                      Text($r('app.string.play_pause'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }.width('33%')

                    Column() {
                      Image($r('app.media.stop_playing'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          lottie.stop(this.animateName)
                        })
                      Text($r('app.string.stop'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }.width('33%')

                    Column() {
                      Image($r('app.media.pause'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          lottie.pause(this.animateName)
                        })
                      Text($r('app.string.pause'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')

                    Column() {
                      Image($r('app.media.start'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          lottie.play(this.animateName)
                        })
                      Text($r('app.string.start_play'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')

                    Column() {
                      Image($r('app.media.speed'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          lottie.setSpeed(2, this.animateName)
                        })
                      Text($r('app.string.double_speed'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')

                    Column() {
                      Image($r('app.media.forward'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          lottie.setDirection(-1, this.animateName)
                        })
                      Text($r('app.string.reverse_playback'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')
                  }
                  .height('65%')
                }
                .width('100%')
                .height('100%')
                .borderRadius(24)
                .backgroundColor('#4D999999')
              }
              .tabBar($r('app.string.play_pause'))

              TabContent() {
                Column() {
                  Text($r('app.string.display_effect_this'))
                    .fontSize('13fp')
                    .margin({ top: 10, bottom: 10 })
                  Flex({
                    wrap: FlexWrap.Wrap,
                    justifyContent: FlexAlign.SpaceEvenly,
                    alignContent: FlexAlign.SpaceAround
                  }) {

                    Column() {
                      Image($r('app.media.start_stop'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.togglePause()
                          }
                        })
                      Text($r('app.string.play_pause'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')

                    Column() {
                      Image($r('app.media.stop_playing'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.stop()
                          }
                        })
                      Text($r('app.string.stop'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')

                    Column() {
                      Image($r('app.media.pause'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.pause()
                          }
                        })
                      Text($r('app.string.pause'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')

                    Column() {
                      Image($r('app.media.start'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.play()
                          }
                        })
                      Text($r('app.string.start_play'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')

                    Column() {
                      Image($r('app.media.speed'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.setSpeed(5)
                          }
                        })
                      Text($r('app.string.five_speed'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')

                    Column() {
                      Image($r('app.media.forward'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.setDirection(-1)
                          }
                        })
                      Text($r('app.string.reverse_playback'))
                        .fontSize('13fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                        .opacity(0.8)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('33%')
                  }
                  .height('65%')
                }
                .borderRadius(24)
                .width('100%')
                .height('100%')
                .backgroundColor('#4D999999')
              }
              .tabBar($r('app.string.play_pause'))

              TabContent() {
                Flex({
                  wrap: FlexWrap.Wrap,
                  justifyContent: FlexAlign.SpaceEvenly,
                  alignContent: FlexAlign.SpaceEvenly,
                  alignItems: ItemAlign.Center
                }) {
                  Column() {
                    Image($r('app.media.loop'))
                      .width(30)
                      .height(30)
                      .onClick(() => {
                        if (this.animateItem !== null) {
                          this.animateItem.setSegment(20, 30)
                        }
                      })
                    Text($r('app.string.fragment_cycle'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                  Column() {
                    Image($r('app.media.loop'))
                      .width(30)
                      .height(30)
                      .onClick(() => {
                        if (this.animateItem !== null) {
                          this.animateItem.playSegments([[5, 15], [20, 30]], true)
                        }
                      })
                    Text($r('app.string.play_segments'))
                      .padding({ left: 5, right: 5 })
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                  Column() {
                    Image($r('app.media.reset'))
                      .width(30)
                      .height(30)
                      .bindMenu([
                        {
                          value: '即时生效播放',
                          action: (() => {
                            if (this.animateItem !== null) {
                              this.animateItem.resetSegments(true)
                            }
                          })
                        },
                        {
                          value: '延迟到下轮循环播放再生效',
                          action: (() => {
                            if (this.animateItem !== null) {
                              this.animateItem.resetSegments(false)
                            }
                          })
                        }
                      ])
                    Text($r('app.string.reset_play'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                  Column() {
                    Image($r('app.media.subframe'))
                      .width(30)
                      .height(30)
                      .onClick(() => {
                        if (this.animateItem !== null) {
                          this.animateItem.setSubframe(false)
                        }
                      })
                    Text($r('app.string.float_integer'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                }
                .borderRadius(24)
                .width('100%')
                .height('100%')
                .backgroundColor('#4D999999')
              }
              .tabBar($r('app.string.cycle'))

              TabContent() {
                Flex({
                  wrap: FlexWrap.Wrap,
                  justifyContent: FlexAlign.SpaceEvenly,
                  alignContent: FlexAlign.SpaceEvenly,
                  alignItems: ItemAlign.Center
                }) {

                  Column() {
                    Image($r('app.media.destination'))
                      .width(30)
                      .height(30)
                      .bindMenu([
                        {
                          value: '250帧时停止',
                          action: (() => {
                            if (this.animateItem !== null) {
                              this.animateItem.goToAndStop(250, true)
                            }
                          })
                        },
                        {
                          value: '5000ms时停止',
                          action: (() => {
                            if (this.animateItem !== null) {
                              this.animateItem.goToAndStop(5000, false)
                            }
                          })
                        }
                      ])
                    Text($r('app.string.animation_stop'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                  Column() {
                    Image($r('app.media.begin'))
                      .width(30)
                      .height(30)
                      .bindMenu([
                        {
                          value: '从250帧开始播放',
                          action: (() => {
                            if (this.animateItem !== null) {
                              this.animateItem.goToAndPlay(250, true);
                            }
                          })
                        },
                        {
                          value: '从12000ms开始播放',
                          action: (() => {
                            if (this.animateItem !== null) {
                              this.animateItem.goToAndPlay(12000, false)
                            }
                          })
                        }
                      ])
                    Text($r('app.string.animation_play'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                  Column() {
                    Image($r('app.media.refresh'))
                      .width(30)
                      .height(30)
                      .onClick(() => {
                        if (this.animateItem !== null) {
                          this.animateItem.resize()
                        }
                      })
                    Text($r('app.string.refresh_animation'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                  Column() {
                    Image($r('app.media.destory'))
                      .width(30)
                      .height(30)
                      .onClick(() => {
                        if (this.animateItem !== null) {
                          this.animateItem.destroy(this.animateName)
                        }
                      })
                    Text($r('app.string.destruction_grunt_animation'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')
                }
                .borderRadius(24)
                .width('100%')
                .height('100%')
                .backgroundColor("#4D999999")
              }
              .tabBar($r('app.string.playback_position'))

              TabContent() {
                Flex({
                  wrap: FlexWrap.Wrap,
                  justifyContent: FlexAlign.SpaceEvenly,
                  alignContent: FlexAlign.SpaceEvenly,
                  alignItems: ItemAlign.Center
                }) {

                  Column() {
                    Image($r('app.media.addevent'))
                      .width(30)
                      .height(30)
                      .onClick(() => {
                        if (this.animateItem !== null) {
                          this.animateItem.addEventListener('loopComplete', this.callbackItem)
                        }
                      })
                    Text($r('app.string.add_listen'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                  Column() {
                    Image($r('app.media.delete'))
                      .width(30)
                      .height(30)
                      .onClick(() => {
                        if (this.animateItem !== null) {
                          this.animateItem.stop()
                        }
                      })
                    Text($r('app.string.delete_listen'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                  Column() {
                    Image($r('app.media.addall'))
                      .width(30)
                      .height(30)
                      .onClick(() => {
                        if (this.animateItem !== null) {
                          this.animateItem.pause()
                        }
                      })
                    Text($r('app.string.triggers_all_callbacks'))
                      .padding({ left: 5, right: 5 })
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')

                  Column() {
                    Image($r('app.media.deleteall'))
                      .width(30)
                      .height(30)
                      .onClick(() => {
                        if (this.animateItem !== null) {
                          this.animateItem.play()
                        }
                      })
                    Text($r('app.string.delete_all_Listen'))
                      .fontSize('13fp')
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                      .opacity(0.8)
                      .margin({ top: 6 })
                      .fontFamily('Microsoft YaHei')
                  }
                  .width('50%')
                }
                .borderRadius(24)
                .width('100%')
                .height('100%')
                .backgroundColor('#4D999999')
              }
              .tabBar($r('app.string.listen'))
            }
            .vertical(true)
            .scrollable(true)
            .barMode(BarMode.Fixed)
            .barWidth(100)
            .barHeight(230)
            .animationDuration(0)
            .onChange((index: number) => {
              Logger.info(TAG, index.toString())
            })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
          }
          .width('100%')
          .height(230)
          .margin({ bottom: 8 })
        }
      }
      .padding({ left: '3%', right: '3%' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}

