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

import formHost from '@ohos.application.formHost';
import Logger from '../../model/Logger';

@Entry
@Component
struct Index {
  @State formId: number = 0;
  @State bundleName: string = "ohos.samples.FormApplication";
  @State abilityName: string = "FormAbility";
  @State moduleName: string = "entry";
  @State formName: string = "widget";
  @State dimension: FormDimension = FormDimension.Dimension_2_4;
  @State isShow: boolean = true;

  build() {
    Row() {
      Column() {
        Text("eTSFormLauncher")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        if (this.isShow) {
          FormComponent({
            id: this.formId,
            name: this.formName,
            bundle: this.bundleName,
            ability: this.abilityName,
            module: this.moduleName,
            dimension: this.dimension,
            temporary: true
          })
            .allowUpdate(true)
            .visibility(Visibility.Visible)
            .onAcquired((form) => {
              Logger.info(`form info: ${JSON.stringify(form)}`);
              // save form id
              this.formId = form.id;
            })
            .onError((err) => {
              Logger.error(`failed to add form, err: ${JSON.stringify(err)}`);
            })
            .size({ width: 360, height: 180 })
        }

        Button() {
          Text('castTempForm')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('35%')
        .height('5%')
        .onClick(() => {
          formHost.castTempForm(this.formId.toString()).then(() => {
            Logger.log(`castTempForm successfully, formId: ${this.formId.toString()}`);
          });
        })

        Button() {
          Text('updateForm')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('35%')
        .height('5%')
        .onClick(() => {
          formHost.requestForm(this.formId.toString()).then(() => {
            Logger.log(`updateForm successfully, formId: ${this.formId.toString()}`);
          });
        })

        Button() {
          Text('deleteForm')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('35%')
        .height('5%')
        .onClick(() => {
          formHost.deleteForm(this.formId.toString()).then(() => {
            Logger.log(`deleteForm successfully, formId: ${this.formId.toString()}`);
            this.isShow = false;
          });
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}