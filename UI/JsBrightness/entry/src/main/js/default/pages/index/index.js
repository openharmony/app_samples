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

import brightness from '@ohos.brightness';

export default {
    brightness(e) {
        switch (e.value) {
            case 0:
            brightness.setValue(0);
            break;
            case 30:
            brightness.setValue(30);
            break;
            case 60:
            brightness.setValue(60);
            break;
            case 90:
            brightness.setValue(90);
            break;
            case 120:
            brightness.setValue(120);
            break;
            case 150:
            brightness.setValue(150);
            break;
            case 180:
            brightness.setValue(180);
            break;
            case 210:
            brightness.setValue(210);
            break;
            case 240:
            brightness.setValue(240);
            break;
            default:
                break;
        }
    }
}