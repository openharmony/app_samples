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

@Observed
export class FirstNavInfo {
  public title: string = '组件化和生命周期';
  public isClicked: boolean = false;
  public uri: string = "";
  public secondIndex: number= 0;

  constructor(title: string, uri: string, secondIndex: number) {
    this.title = title;
    this.uri = uri;
    this.isClicked = false;
    this.secondIndex = secondIndex;
  }
}