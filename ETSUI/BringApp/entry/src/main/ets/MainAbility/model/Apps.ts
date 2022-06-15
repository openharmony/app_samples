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

export class Apps {
    apps: Array<{
        img: Resource,
        bundleName: string,
        abilityName: string,
        name: Resource
    }> = []

    constructor() {
        this.apps = [
            {
                img: $r('app.media.camera'),
                bundleName: 'com.ohos.camera',
                abilityName: 'MainAbility',
                name: $r('app.string.camera')
            },
            {
                img: $r('app.media.gallery'),
                bundleName: 'com.ohos.photos',
                abilityName: 'com.ohos.photos.MainAbility',
                name: $r('app.string.gallery')
            },
            {
                img: $r('app.media.contact'),
                bundleName: 'com.ohos.contacts',
                abilityName: 'com.ohos.contacts.MainAbility',
                name: $r('app.string.contacts')
            },
            {
                img: $r('app.media.messages'),
                bundleName: 'com.ohos.mms',
                abilityName: 'com.ohos.mms.MainAbility',
                name: $r('app.string.message')
            },
            {
                img: $r('app.media.falshlight'),
                bundleName: 'ohos.samples.flashlight',
                abilityName: 'ohos.samples.flashlight.default',
                name: $r('app.string.flash')
            },
            {
                img: $r('app.media.airquality'),
                bundleName: 'ohos.samples.airquality',
                abilityName: 'ohos.samples.airquality.default',
                name: $r('app.string.air')
            },
            {
                img: $r('app.media.music'),
                bundleName: 'com.ohos.distributedmusicplayer',
                abilityName: 'com.ohos.distributedmusicplayer.MainAbility',
                name: $r('app.string.music')
            },
            {
                img: $r('app.media.clock'),
                bundleName: 'ohos.samples.clock',
                abilityName: 'ohos.samples.clock.default',
                name: $r('app.string.clock')
            }
        ]
    }
}