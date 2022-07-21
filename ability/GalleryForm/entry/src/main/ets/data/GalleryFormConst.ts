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

class GalleryFormConst {
  FORM_PARAM_IDENTITY_KEY: string = 'ohos.extra.param.key.form_identity' // 用于创建卡片ID的标识
  PERMISSIONS: Array<string> = ['ohos.permission.MEDIA_LOCATION', 'ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA']
  permissionState: number = 666 // 权限传递给返回结果的请求码
}

export default new GalleryFormConst()