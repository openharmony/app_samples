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
import router from '@system.router';

let panelMargin: object = { left: "-5%", top: "10%" }

@Entry
@Component
struct KeyBoard {
  @State list: Array<object> = [
    { Text: "文字设置", img: $r("app.media.icon") },
    { Text: "键盘设置", img: $r("app.media.icon") }
  ]
  // 键盘设置
  @State show_key: boolean = false;
  @State list_key: Array<Object> = ['震动', '气泡'];
  @StorageLink("isPrediction") isPrediction: boolean = true
  @StorageLink("isVibrate") isVibrate: boolean = false;
  @StorageLink("isBubble") isBubble: boolean = false;

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Image($r("app.media.icon")).width(22).height(28).onClick(() => {
          router.push({
            uri: 'page/service/index'
          })
        })
        Text("设置").fontSize(20).margin({ left: "2%" }).height(30).width(200)
        Image($r("app.media.icon")).width(25).height(28)
      }.margin({ bottom: 20 })

      List() {
        ListItem() {
          Row() {
            Text("联想").fontSize(20).width("80%")
            Toggle({ type: ToggleType.Switch, isOn: this.isPrediction }).onChange(isOn => {
              AppStorage.Set<boolean>("isPrediction", isOn);
            })
          }
        }

        ForEach(this.list.map((item, index) => {
          return { i: index, data: item }
        }), item => {
          ListItem() {
            Row() {
              Text(item.data.text).fontSize(20).width("60%")
              Image(item.data.img)
                .objectFit(ImageFit.Contain)
                .width("40%")
                .onClick((e) => {
                  if (item.i == 0) {
                    router.push({
                      uri: "pages/service/TextPage"
                    })
                  }
                  if (item.i == 1) {
                    this.show_key = !this.show_key
                  }
                })
            }.width("100%").height(30).margin({ top: 12, left: 15 })
          }
        }, item => item.data.text)
      }
      // 键盘设置
      Panel(this.show_key) {
        Column() {
          Text("键盘效果选择").fontSize(20).margin(panelMargin)
          List() {
            ForEach(this.list_key.map((data, index) => {
              return { index: index, text: data }
            }), item => {
              ListItem() {
                Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                  Text(item.text).fontSize(16)
                  Toggle({ type: ToggleType.Checkbox, isOn: item.text == "震动" ? this.isVibrate : this.isBubble })
                    .size({ width: 20, height: 20 })
                    .selectedColor(0xed6f21)
                    .margin({ right: "25lpx" })
                    .onChange((isOn: boolean) => {
                      console.log("[kikaInput click item is" + JSON.stringify(item) + ", isOn" + isOn);
                      if (item.index == 0) {
                        console.log("[kikaInput] set vibrate");
                        AppStorage.Set("isVibrate", isOn);
                      } else if (item.index == 1) {
                        AppStorage.Set("isBubble", isOn);
                      }
                    })
                }.margin({ left: 20 }).width("100%")
              }
            })
          }

          Text("取消").fontSize(15).fontColor("#4169E1").onClick(() => {
            this.show_key = false;
          })
        }
      }
      .type(PanelType.Foldable)
      .mode(PanelMode.Half)
      .dragBar(true)
      .halfHeight(480)
      .position({ x: "-2%", y: 0 })
    }.width("90%").margin({ top: 20, left: 20 })
  }
}