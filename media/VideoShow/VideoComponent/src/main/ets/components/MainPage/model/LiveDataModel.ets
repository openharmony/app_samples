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

export class CommentDataModel {
  constructor(public name: string | Resource, public comment: string | Resource) {
    this.name = name;
    this.comment = comment
  }
}

export class LiveInfoDataModel {
  constructor(public uri: string | Resource, public name: string | Resource, public peopleNum: string | Resource, public commentList: Array<CommentDataModel>) {
    this.uri = uri;
    this.name = name;
    this.peopleNum = peopleNum;
    this.commentList = commentList
  }
}
