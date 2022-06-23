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
import { CandidateSource } from './ListCandidate'
import router from '@ohos.router';
import device from '@system.device';
import mediaquery from '@ohos.mediaquery';
// 输入提示框
@Component
export struct PromptBox {
  @StorageLink("promptText") promptText: string = ""; // 搜索关键字 在各个字母点击事件内调用接口
  @StorageLink('candidateList') @Watch('updateData') candidateList: string[] = [];
  @StorageLink("menuType") menuType: number = 0;
  @StorageLink('activeNo') currentIndex: number = 0;
  @StorageLink('isHardKeyPressed') isHardKeyPressed: boolean = false;
  @State isSun: boolean = false;
  @Link isClickShow: boolean;
  @Link isClickEmo: boolean;
  private keyBgc: string = "#fff"
  private keyFontColor: string = "#000"
  private symbolColor: string = '#fd94c1dd'
  @Link switchScreen: boolean;
  private promptBgc: string = "#bfc"
  private candidateObj: CandidateSource = new CandidateSource();
  private iconSize;

  aboutToAppear() {
    if (globalThis.isPhone) {
      this.iconSize = { width: '36lpx', height: "36lpx", margin: '6lpx' }
    } else {
      this.iconSize = { width: '20lpx', height: "20lpx", margin: '6lpx' }
    }
  }

  updateData() {
    if (this.candidateList.length == 0) {

      console.log('[kikaInput] candidate is nullptr');
      return
    }
    this.candidateObj.notifyDataReload(this.candidateList)
  }

  build() {
    Column() {
      Row() {
        Text(this.promptText)
          .fontSize(`${globalThis.isPhone ? '38lpx' : this.switchScreen ? '18lpx' : '16lpx'}`)
          .padding({ left: `${this.switchScreen ? '10lpx' : '6lpx'}` })
      }
      .visibility(this.promptText == '' ? Visibility.None : Visibility.Visible)

      Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Row() {
          if ((this.menuType === 0 || this.isHardKeyPressed) && this.candidateList.length > 0) {
            // 取消设置界面
            List({ space: 20 }) {
              LazyForEach(this.candidateObj, (item) => {
                ListItem() {
                  Text(item.value)
                    .borderRadius('10lpx')
                    .height("100%")
                    .fontSize(`${globalThis.isPhone ? '40lpx' : this.switchScreen ? '18lpx' : '16lpx'}`)
                    .padding({
                      left: `${this.switchScreen ? '4lpx' : '5lpx'}`,
                      right: `${this.switchScreen ? '4lpx' : '5lpx'}`
                    })
                    .fontColor(this.currentIndex === item.index ? (this.isSun ? "#000" : this.keyFontColor) : "#1e6875")
                    .backgroundColor(this.currentIndex === item.index ? (this.isSun ? this.promptBgc : this.keyBgc) : "")
                    .onClick(() => {
                      let current = item.index
                      console.log('[Chinese input demo] current index is' + current);
                      globalThis.chineseEngine.choiceTouched(item.index);
                    })
                    .onTouch((event: TouchEvent) => {
                      AppStorage.Set("activeNo", item.index);
                    })
                }
              })
            }.listDirection(Axis.Horizontal)
          } else {
            Flex({
              justifyContent: FlexAlign.SpaceBetween,
              direction: FlexDirection.Row,
              alignItems: ItemAlign.Center
            }) {
              // 小键盘
              Row({ space: 15 }) {
                Image($rawfile('key.png'))
                  .objectFit((ImageFit.Cover))
                  .objectFit((ImageFit.Cover))
                  .backgroundColor("#fff")
                  .margin(this.iconSize.margin)
                  .width(this.iconSize.width)
                  .height(this.iconSize.height)
                  .onClick(() => {
                    this.isClickShow = !this.isClickShow
                  })
                Divider().vertical(true).color("#ffaea8a8").strokeWidth(1).height(20)
              }

              Row({ space: 15 }) {
                Image($rawfile('emo.png'))
                  .objectFit((ImageFit.Cover))
                  .objectFit((ImageFit.Cover))
                  .backgroundColor("#fff")
                  .margin(this.iconSize.margin)
                  .width(this.iconSize.width)
                  .height(this.iconSize.height)
                  .visibility(this.isClickShow ? Visibility.None : Visibility.Visible)
                  .onClick(() => {
                    this.isClickEmo = !this.isClickEmo
                  })

                Divider().vertical(true).color("#ffaea8a8").strokeWidth(1).height(20)
                // 下拉箭头
                Image($rawfile('down.png'))
                  .objectFit((ImageFit.Cover))
                  .objectFit((ImageFit.Cover))
                  .backgroundColor("#fff")
                  .margin(this.iconSize.margin)
                  .width(this.iconSize.width)
                  .height(this.iconSize.height)
                  .onClick(() => {
                    AppStorage.Set('promptText', '')
                    AppStorage.Set('hidden', true)
                    AppStorage.Set('hiddenPopup', true);
                    globalThis.keyboardController.hideKeyboard();
                  })
              }
            }.opacity(0.8).padding({ left: 20, right: 20 })
          }
        }
      }
      .width("100%")
      .height(`${globalThis.isPhone ? '80px' : this.switchScreen ? '105.28px' : '144.384px'}`)
      .padding(`${this.switchScreen ? '1%' : "0.5%"}`)
      .backgroundColor("#fff")
      .shadow({ radius: 20, color: "#eee", offsetX: 0, offsetY: 0 })
      .clip(new Rect({ width: '100%', height: "100%", radius: [[20, 20], [20, 20], [20, 20], [20, 20]] }))
    }.alignItems(HorizontalAlign.Start)
  }
}