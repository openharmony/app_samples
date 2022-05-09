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
import { BasicDataSource } from '../common/BasicDataSource';
import router from '@system.router';
import { EMContact, MessageBase, FriendMoment } from './msgBase'

@Entry
@Component
struct FriendsMomentsPage {
  @State itemLength: number = 0;
  private momentData = new FriendMomentsData()
  private id: string
  private imageList = ['/resources/repeat/gr.png', '/resources/repeat/gr.png', '/resources/repeat/gr.png', '/resources/repeat/gr.png']

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Row() {
            Image("/resources/icon/back.png")
              .height(30)
              .width(30)
          }
          .width("10%")
          .onClick(() => {
            router.back()
          })

          Text("聊天社区")
            .fontSize(20)
            .fontColor(Color.White)
          Row() {
            Image("/resources/icon/icon_talk.png")
              .height(30)
              .width(30)
          }
          .width("10%")
        }
        .height(50)
        .width('100%')
        .padding({ left: 10, right: 10 })
        .backgroundColor(Color.Black)

        Column() {
          List() {
            ListItem() {
              Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.End, justifyContent: FlexAlign.Start }) {
                Flex() {
                  Image("/resources/icon/user_ba.png")
                }
                .height('100%')
                .width('100%')

                Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
                  Text("name")
                    .fontSize(20)
                    .fontColor(Color.Black)
                  Image("/resources/image/ge3.png")
                    .height(50)
                    .width(50)
                }
              }
              .height('40%')
            }

            LazyForEach(this.momentData, (msg: FriendMoment) => {
              ListItem() {
                OneMoment({ moment: msg })
              }
            }, (msg: FriendMoment) => msg.id)
          }
          .listDirection(Axis.Vertical)
        }
        .height('100%')
      }
      .height('100%')
      .padding({ bottom: 50 })
    }
    .height('100%')
    .width('100%')
  }

  private aboutToAppear(): void {
    this.makeDataLocal()
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }

  makeDataLocal() {
    for (var i = 0;i < 100; i++) {
      var tdata = new Date()
      var imageStr = '/resources/images/photo' + (i % 50).toString() + '.jpg'
      var mo = new FriendMoment(i.toString(), new EMContact(i.toString(), "朋友" + i.toString(), imageStr), "我是聊天社区消息" + i.toString(), tdata.getMinutes() + ":" + tdata.getSeconds());
      this.momentData.pushData(mo)
    }
  }
}

@Component
struct OneMoment {
  private moment: FriendMoment

  build() {
    Row() {
      Flex() {
        Image(this.moment.user.userImage)
          .autoResize(false)
      }
      .width(50)
      .height(50)

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
        Text(this.moment.user.userName)
          .fontSize(15)
          .fontColor(Color.Black)
        Text(this.moment.text)
          .fontSize(13)
          .fontColor(Color.Black)
        Row({ space: 5 }) {
          MomentsImage({ imageStr: "/resources/images/photo2.jpg" })
          MomentsImage({ imageStr: "/resources/images/photo2.jpg" })
          MomentsImage({ imageStr: "/resources/images/photo2.jpg" })
        }
        .margin({ top: 5, right: 10 })

        Row({ space: 5 }) {
          MomentsImage({ imageStr: "/resources/images/photo2.jpg" })
          MomentsImage({ imageStr: "/resources/images/photo2.jpg" })
          MomentsImage({ imageStr: "/resources/images/photo2.jpg" })
        }
        .margin({ top: 5, right: 10 })

        Row({ space: 5 }) {
          MomentsImage()
          MomentsImage({ imageStr: "/resources/images/photo2.jpg" })
          MomentsImage({ imageStr: "/resources/images/photo2.jpg" })
        }
        .margin({ top: 5, right: 10 })

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
          Text(this.moment.time).fontColor("#e3e3e3").fontSize(12)
          Image("/resources/icon/afr.png").height(15).width(20)
        }
        .margin({ top: 5 })
        .padding({ right: 5 })
      }
      .width('100%')
      .margin({ left: 10 })
    }
    .margin({ left: 10 })
    .padding({ right: 70 })
    .alignItems(VerticalAlign.Top)
  }
}

@Component
struct MomentsImage {
  private imageStr: string = "/resources/images/photo5.jpg";
  @State active: boolean = false;

  build() {
    Stack() {
      Navigator({ target: 'pages/fullImagePage', type: NavigationType.Push }) {
        (Image(this.imageStr)
          .width(70)
          .height(70)
          .sharedTransition('shareImage', { duration: 800, curve: Curve.Linear, delay: 100 })
          .onClick(() => {
            this.active = true
          }))
      }
      .params({ imageStr: this.imageStr })
    }
    .width(70)
    .height(70)
  }
}

class FriendMomentsData extends BasicDataSource {
  momentList: Array<FriendMoment> = []

  public totalCount(): number {
    return this.momentList.length
  }

  public getData(index: number): any {
    return this.momentList[index]
  }

  public addData(index: number, data: FriendMoment): void {
    this.momentList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: FriendMoment): void {
    this.momentList.push(data)
    this.notifyDataAdd(this.momentList.length - 1)
  }
}